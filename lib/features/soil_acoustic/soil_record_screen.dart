import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:kisan_mitra/l10n/app_localizations.dart';

import '../farmer/advisory/data/models/weather_model.dart';

import 'audio_processing_service.dart';
import 'audio_record_service.dart';
import 'advisory_integration_service.dart';
import 'soil_ai_service.dart';
import 'soil_result_screen.dart';

/// Screen 1: Smart Soil Analyzer — Recording Screen.
///
/// Shows instruction, animated mic button, real-time waveform, and countdown
/// timer. On completion navigates to the result screen.
class SoilRecordScreen extends StatefulWidget {
  const SoilRecordScreen({super.key});

  @override
  State<SoilRecordScreen> createState() => _SoilRecordScreenState();
}

enum _RecordState { idle, recording, processing, error }

class _SoilRecordScreenState extends State<SoilRecordScreen>
    with TickerProviderStateMixin {
  final AudioRecordService _recordService = AudioRecordService();
  final AudioProcessingService _processingService = AudioProcessingService();
  final SoilAiService _aiService = SoilAiService();
  final AdvisoryIntegrationService _integrationService =
      AdvisoryIntegrationService();

  _RecordState _state = _RecordState.idle;
  String? _errorMessage;

  // Recording state
  int _elapsedSeconds = 0;
  Timer? _timer;
  final List<double> _amplitudes = [];
  StreamSubscription<double>? _ampSubscription;

  // Waveform animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  late AnimationController _waveController;

  // Pre-fetching state (Zero-latency optimization)
  Future<WeatherData>? _weatherFuture;
  geo.Position? _position;

  Future<WeatherData> _preFetchData() async {
    try {
      final pos = await _integrationService.getCurrentPosition();
      _position = pos;
      if (pos != null) {
        return await _integrationService.getWeatherData(
          latitude: pos.latitude,
          longitude: pos.longitude,
        );
      }
    } catch (_) {}
    return _integrationService.getWeatherData();
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampSubscription?.cancel();
    _pulseController.dispose();
    _waveController.dispose();
    _recordService.dispose();
    super.dispose();
  }

  // ─── Actions ──────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    try {
      // Background parallel fetch: Get location & weather WHILE user is recording!
      // This completely masks the 2-5 second network latency.
      _position = null;
      _weatherFuture = _preFetchData();

      final stream = await _recordService.startRecording();
      setState(() {
        _state = _RecordState.recording;
        _elapsedSeconds = 0;
        _amplitudes.clear();
        _errorMessage = null;
      });

      _pulseController.repeat(reverse: true);

      // Timer
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() => _elapsedSeconds++);
        if (_elapsedSeconds >= AudioRecordService.maxDurationSec) {
          _stopRecording();
        }
      });

      // Amplitude stream
      _ampSubscription = stream.listen((amp) {
        setState(() {
          _amplitudes.add(amp);
          if (_amplitudes.length > 60) {
            _amplitudes.removeAt(0);
          }
        });
      });
    } on PermissionDeniedException {
      setState(() {
        _state = _RecordState.error;
        _errorMessage = 'permissionDenied';
      });
    } catch (e) {
      setState(() {
        _state = _RecordState.error;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    _ampSubscription?.cancel();
    _pulseController.stop();
    _pulseController.reset();

    if (_elapsedSeconds < AudioRecordService.minDurationSec) {
      setState(() {
        _state = _RecordState.error;
        _errorMessage = 'tooShort';
      });
      await _recordService.cancelRecording();
      return;
    }

    if (!_recordService.isSignalValid(_amplitudes)) {
      setState(() {
        _state = _RecordState.error;
        _errorMessage = 'noSignal';
      });
      await _recordService.cancelRecording();
      return;
    }

    setState(() => _state = _RecordState.processing);

    try {
      // 1. Stop recorder & get file path
      final filePath = await _recordService.stopRecording();

      // 2. Process audio (GPS/Weather is already pre-fetching!)
      final features = await _processingService.processAudioFile(filePath);

      // 3. Await pre-fetched weather (nearly instant since it started 5s ago)
      final weather = await (_weatherFuture ?? _preFetchData());

      // 4. Rule-based soil analysis (synchronous — instant)
      final soilResult = _aiService.analyzeAcousticFeatures(
        features,
        latitude: _position?.latitude,
        longitude: _position?.longitude,
      );

      // 5. Generate advisory (weather + AI) — pass weather to skip re-fetch
      final locale = Localizations.localeOf(context);
      final advisory = await _integrationService.generateFullAdvisory(
        soilResult: soilResult,
        preFetchedWeather: weather,
        languageCode: locale.languageCode,
      );

      // 5. Fire-and-forget cleanup (don't block navigation)
      _recordService.deleteRecording();

      // 6. Navigate to results
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SoilResultScreen(result: soilResult, advisory: advisory),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _state = _RecordState.error;
          _errorMessage = e.toString();
        });
      }
      _recordService.deleteRecording();
    }
  }

  void _retry() {
    setState(() {
      _state = _RecordState.idle;
      _errorMessage = null;
      _amplitudes.clear();
      _elapsedSeconds = 0;
    });
  }

  // ─── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.smartSoilAnalyzer,
          style: const TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildInstructionCard(l10n),
                    const SizedBox(height: 32),
                    _buildMicButton(l10n),
                    const SizedBox(height: 24),
                    if (_state == _RecordState.recording)
                      _buildWaveformVisualizer(),
                    if (_state == _RecordState.recording) _buildTimer(),
                    if (_state == _RecordState.processing)
                      _buildProcessingIndicator(l10n),
                    if (_state == _RecordState.error) _buildErrorCard(l10n),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE8F5E9),
            const Color(0xFFC8E6C9).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              color: Color(0xFF2E7D32),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.soilRecordInstruction,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _stepChip('1', l10n.soilStepInsert),
              const SizedBox(width: 8),
              _stepChip('2', l10n.soilStepTap),
              const SizedBox(width: 8),
              _stepChip('3', l10n.soilStepRecord),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stepChip(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF2E7D32)),
          ),
        ],
      ),
    );
  }

  Widget _buildMicButton(AppLocalizations l10n) {
    final isRecording = _state == _RecordState.recording;
    final isProcessing = _state == _RecordState.processing;

    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, child) {
            final scale = isRecording ? _pulseAnim.value : 1.0;
            return Transform.scale(scale: scale, child: child);
          },
          child: GestureDetector(
            onTap: isProcessing
                ? null
                : isRecording
                ? _stopRecording
                : _startRecording,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isRecording
                      ? [const Color(0xFFE53935), const Color(0xFFC62828)]
                      : [const Color(0xFF43A047), const Color(0xFF2E7D32)],
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isRecording
                                ? const Color(0xFFE53935)
                                : const Color(0xFF2E7D32))
                            .withOpacity(0.3),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isRecording
              ? l10n.soilTapToStop
              : isProcessing
              ? l10n.soilProcessing
              : l10n.soilTapToRecord,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isRecording ? const Color(0xFFE53935) : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildWaveformVisualizer() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomPaint(
        size: const Size(double.infinity, 80),
        painter: _WaveformPainter(
          amplitudes: _amplitudes,
          color: const Color(0xFF2E7D32),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    final remaining = AudioRecordService.maxDurationSec - _elapsedSeconds;
    final progress = _elapsedSeconds / AudioRecordService.maxDurationSec;

    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.75
                      ? const Color(0xFFE53935)
                      : const Color(0xFF2E7D32),
                ),
              ),
              Center(
                child: Text(
                  '${remaining}s',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _elapsedSeconds < AudioRecordService.minDurationSec
              ? AppLocalizations.of(context).soilKeepRecording
              : AppLocalizations.of(context).soilCanStopNow,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildProcessingIndicator(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.soilAnalyzing,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.soilAnalyzingSubtext,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(AppLocalizations l10n) {
    String message;
    IconData icon;

    switch (_errorMessage) {
      case 'permissionDenied':
        message = l10n.soilErrorMicPermission;
        icon = Icons.mic_off;
        break;
      case 'tooShort':
        message = l10n.soilErrorTooShort;
        icon = Icons.timer_off;
        break;
      case 'noSignal':
        message = l10n.soilErrorNoSignal;
        icon = Icons.graphic_eq;
        break;
      default:
        message = l10n.soilErrorGeneral;
        icon = Icons.error_outline;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: const Color(0xFFE65100)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFE65100),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _retry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.tryAgain),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the live waveform visualization.
class _WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final Color color;

  _WaveformPainter({required this.amplitudes, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final barWidth = size.width / max(amplitudes.length, 1);

    for (int i = 0; i < amplitudes.length; i++) {
      // Convert dBFS (-160..0) to a visual height (0..1)
      final normalized = ((amplitudes[i] + 60) / 60).clamp(0.0, 1.0);
      final barHeight = normalized * (size.height * 0.8);

      final x = i * barWidth + barWidth / 2;

      paint.color = color.withOpacity(0.4 + normalized * 0.6);

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter old) => true;
}
