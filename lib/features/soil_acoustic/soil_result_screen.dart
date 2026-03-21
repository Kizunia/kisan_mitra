import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kisan_mitra/l10n/app_localizations.dart';

import 'soil_model.dart';
import 'soil_record_screen.dart';

/// Screen 2: Smart Soil Analyzer — Results Screen.
///
/// Displays soil analysis results (moisture, density, compaction gauge,
/// confidence), weather context, fertilizer recommendations, irrigation
/// advice, and warnings.
class SoilResultScreen extends StatelessWidget {
  final SoilAnalysisResult result;
  final SoilAdvisory advisory;

  const SoilResultScreen({
    super.key,
    required this.result,
    required this.advisory,
  });

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
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text(
          l10n.soilResultsTitle,
          style: const TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Soil Analysis Cards ──────────────────────────────
              _buildSoilAnalysisSection(context, l10n),
              const SizedBox(height: 20),

              // ── Compaction Gauge ─────────────────────────────────
              _buildCompactionGauge(context, l10n),
              const SizedBox(height: 20),

              // ── Weather Context ──────────────────────────────────
              if (advisory.weatherContext.isNotEmpty) _buildWeatherCard(l10n),
              if (advisory.weatherContext.isNotEmpty)
                const SizedBox(height: 20),

              // ── Warnings ────────────────────────────────────────
              if (advisory.warnings.isNotEmpty) _buildWarningsSection(l10n),
              if (advisory.warnings.isNotEmpty) const SizedBox(height: 20),

              // ── Fertilizer Recommendations ──────────────────────
              if (advisory.fertilizerPlan.isNotEmpty)
                _buildFertilizerSection(l10n),
              if (advisory.fertilizerPlan.isNotEmpty)
                const SizedBox(height: 20),

              // ── Irrigation Advice ───────────────────────────────
              if (advisory.irrigationAdvice.isNotEmpty)
                _buildIrrigationCard(l10n),
              const SizedBox(height: 24),

              // ── Actions ─────────────────────────────────────────
              _buildActions(context, l10n),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Soil Analysis Cards
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildSoilAnalysisSection(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n.soilAnalysisResults, Icons.analytics),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMoistureCard(l10n)),
            const SizedBox(width: 12),
            Expanded(child: _buildDensityCard(l10n)),
          ],
        ),
        const SizedBox(height: 12),
        _buildConfidenceBar(l10n),
      ],
    );
  }

  Widget _buildMoistureCard(AppLocalizations l10n) {
    final color = switch (result.moistureLevel) {
      MoistureLevel.low => const Color(0xFFFF9800),
      MoistureLevel.medium => const Color(0xFF2196F3),
      MoistureLevel.high => const Color(0xFF1565C0),
    };

    final icon = switch (result.moistureLevel) {
      MoistureLevel.low => Icons.water_drop_outlined,
      MoistureLevel.medium => Icons.water_drop,
      MoistureLevel.high => Icons.opacity,
    };

    final label = switch (result.moistureLevel) {
      MoistureLevel.low => l10n.soilMoistureLow,
      MoistureLevel.medium => l10n.soilMoistureMedium,
      MoistureLevel.high => l10n.soilMoistureHigh,
    };

    return _infoCard(
      icon: icon,
      iconColor: color,
      title: l10n.soilMoistureLabel,
      value: label,
      valueColor: color,
    );
  }

  Widget _buildDensityCard(AppLocalizations l10n) {
    final color = switch (result.densityLevel) {
      DensityLevel.loose => const Color(0xFF8BC34A),
      DensityLevel.medium => const Color(0xFFFFC107),
      DensityLevel.compact => const Color(0xFFF44336),
    };

    final icon = switch (result.densityLevel) {
      DensityLevel.loose => Icons.grain,
      DensityLevel.medium => Icons.layers,
      DensityLevel.compact => Icons.compress,
    };

    final label = switch (result.densityLevel) {
      DensityLevel.loose => l10n.soilDensityLoose,
      DensityLevel.medium => l10n.soilDensityMedium,
      DensityLevel.compact => l10n.soilDensityCompact,
    };

    return _infoCard(
      icon: icon,
      iconColor: color,
      title: l10n.soilDensityLabel,
      value: label,
      valueColor: color,
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBar(AppLocalizations l10n) {
    final pct = result.confidenceScore;
    final color = pct > 70
        ? const Color(0xFF2E7D32)
        : pct > 40
        ? const Color(0xFFFFC107)
        : const Color(0xFFE53935);

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Icon(Icons.verified, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.soilConfidenceLabel,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${pct.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Compaction Gauge
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildCompactionGauge(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.soilCompactionLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getCompactionColor(result.compactionScore).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getCompactionStatusText(result.compactionScore, l10n),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getCompactionColor(result.compactionScore),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 220,
            height: 220,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: result.compactionScore / 100),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, animValue, child) {
                return CustomPaint(
                  painter: _PremiumGaugePainter(value: animValue),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          (animValue * 100).toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF212121),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '/ 100',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(l10n.soilDensityLoose, const Color(0xFF4CAF50)),
              _buildLegendItem(l10n.soilDensityMedium, const Color(0xFFFFC107)),
              _buildLegendItem(l10n.soilDensityCompact, const Color(0xFFE53935)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCompactionColor(double score) {
    if (score < 40) return const Color(0xFF4CAF50);
    if (score < 70) return const Color(0xFFFFC107);
    return const Color(0xFFE53935);
  }

  String _getCompactionStatusText(double score, AppLocalizations l10n) {
    if (score < 40) return l10n.soilDensityLoose;
    if (score < 70) return l10n.soilDensityMedium;
    return l10n.soilDensityCompact;
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Weather Card
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildWeatherCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF42A5F5).withOpacity(0.08),
            const Color(0xFF1E88E5).withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF42A5F5).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud, color: Color(0xFF1565C0), size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.soilWeatherContext,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  advisory.weatherContext,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Warnings
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildWarningsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n.soilWarnings, Icons.warning_amber_rounded),
        const SizedBox(height: 8),
        ...advisory.warnings.map(
          (w) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF9800).withOpacity(0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFE65100),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    w,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFE65100),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Fertilizer Recommendations
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildFertilizerSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n.soilFertilizerPlan, Icons.eco),
        const SizedBox(height: 8),
        ...advisory.fertilizerPlan.asMap().entries.map(
          (e) => _fertilizerCard(e.key + 1, e.value),
        ),
      ],
    );
  }

  Widget _fertilizerCard(int index, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Irrigation Advice
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildIrrigationCard(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n.soilIrrigationAdvice, Icons.water),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF42A5F5).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF42A5F5).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Color(0xFF1565C0),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  advisory.irrigationAdvice,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Actions
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildActions(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            icon: const Icon(Icons.home_rounded),
            label: Text(l10n.backToHome),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2E7D32),
              side: const BorderSide(color: Color(0xFF2E7D32)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SoilRecordScreen()),
              );
            },
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l10n.soilAnalyzeAgain),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Helpers
  // ═══════════════════════════════════════════════════════════════════

  Widget _sectionTitle(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
      ],
    );
  }
}

/// Custom premium gauge painter for compaction score visualization.
class _PremiumGaugePainter extends CustomPainter {
  final double value; // 0.0 to 1.0

  _PremiumGaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 16;
    const startAngle = 2.4; // ~137 degrees arc start
    const sweepFull = 4.62; // ~265 degrees arc total

    // Premium Background arc (track)
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFF5F5F5);

    final trackRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(trackRect, startAngle, sweepFull, false, bgPaint);

    // Subtle inner shadow / track depth
    final innerTrackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..color = Colors.black.withOpacity(0.02);
    canvas.drawArc(trackRect, startAngle, sweepFull, false, innerTrackPaint);

    if (value > 0) {
      final valueAngle = sweepFull * value;
      
      // Sweep gradient for the value
      final gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepFull,
        colors: const [
          Color(0xFF4CAF50), // Green for loose
          Color(0xFFFFC107), // Yellow for good
          Color(0xFFFF9800), // Orange for compact
          Color(0xFFE53935), // Red for very compact
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(trackRect);

      // Glow effect below the actual arc
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
        ..shader = gradient;
        
      canvas.drawArc(trackRect, startAngle, valueAngle, false, glowPaint);

      final valuePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..shader = gradient;

      canvas.drawArc(trackRect, startAngle, valueAngle, false, valuePaint);

      // Draw needle / indicator dot
      final needleAngle = startAngle + valueAngle;
      final needleX = center.dx + radius * cos(needleAngle);
      final needleY = center.dy + radius * sin(needleAngle);
      
      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
        
      final shadowDotPaint = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        
      canvas.drawCircle(Offset(needleX, needleY + 2), 10, shadowDotPaint);
      canvas.drawCircle(Offset(needleX, needleY), 10, dotPaint);

      final innerDotPaint = Paint()
        ..color = _getColorForValue(value)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(needleX, needleY), 4, innerDotPaint);
    }

    // Draw little tick marks along the inner arc
    final tickPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i <= 10; i++) {
      final tickAngle = startAngle + (sweepFull * (i / 10));
      final innerRadius = radius - 26;
      final outerRadius = radius - 18;
      
      canvas.drawLine(
        Offset(center.dx + innerRadius * cos(tickAngle), center.dy + innerRadius * sin(tickAngle)),
        Offset(center.dx + outerRadius * cos(tickAngle), center.dy + outerRadius * sin(tickAngle)),
        tickPaint,
      );
    }
  }

  Color _getColorForValue(double val) {
    if (val < 0.4) return const Color(0xFF4CAF50);
    if (val < 0.7) return const Color(0xFFFFC107);
    if (val < 0.9) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  @override
  bool shouldRepaint(covariant _PremiumGaugePainter old) => old.value != value;
}
