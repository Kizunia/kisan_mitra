import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'soil_model.dart';

/// Service for processing recorded audio files and extracting acoustic features.
///
/// Implements a lightweight Cooley-Tukey FFT in pure Dart and uses it to
/// compute frequency-domain features from WAV PCM audio data.
class AudioProcessingService {
  /// Sample rate we expect from the recorder (44100 Hz).
  static const int _sampleRate = 44100;

  /// Process a WAV file and extract acoustic features.
  ///
  /// Runs heavy computation via [compute] to avoid blocking the UI thread.
  Future<AcousticFeatures> processAudioFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileSystemException('Audio file not found', filePath);
    }

    final bytes = await file.readAsBytes();
    return compute(_processBytes, bytes);
  }

  /// Top-level function for isolate-compatible processing.
  static AcousticFeatures _processBytes(Uint8List bytes) {
    // ── Parse WAV header ──────────────────────────────────────────────
    // Standard WAV: 44-byte header, 16-bit PCM, mono
    if (bytes.length < 44) {
      throw FormatException('File too small to be a valid WAV');
    }

    // Verify RIFF header
    final riff = String.fromCharCodes(bytes.sublist(0, 4));
    if (riff != 'RIFF') {
      throw FormatException('Not a valid WAV file (missing RIFF header)');
    }

    // Read format info
    final numChannels = bytes.buffer.asByteData().getInt16(22, Endian.little);
    final sampleRate = bytes.buffer.asByteData().getInt32(24, Endian.little);
    final bitsPerSample = bytes.buffer.asByteData().getInt16(34, Endian.little);

    // Find 'data' chunk
    int dataOffset = 12;
    int dataSize = 0;
    while (dataOffset < bytes.length - 8) {
      final chunkId = String.fromCharCodes(
        bytes.sublist(dataOffset, dataOffset + 4),
      );
      final chunkSize = bytes.buffer.asByteData().getInt32(
        dataOffset + 4,
        Endian.little,
      );
      if (chunkId == 'data') {
        dataOffset += 8;
        dataSize = chunkSize;
        break;
      }
      dataOffset += 8 + chunkSize;
    }

    if (dataSize == 0) {
      throw FormatException('No data chunk found in WAV file');
    }

    // ── Extract PCM samples ──────────────────────────────────────────
    final bytesPerSample = bitsPerSample ~/ 8;
    final totalSamples = dataSize ~/ (bytesPerSample * numChannels);
    final samples = Float64List(totalSamples);

    final byteData = bytes.buffer.asByteData();
    for (int i = 0; i < totalSamples; i++) {
      final offset = dataOffset + i * bytesPerSample * numChannels;
      if (offset + bytesPerSample > bytes.length) break;

      int rawSample;
      if (bitsPerSample == 16) {
        rawSample = byteData.getInt16(offset, Endian.little);
        samples[i] = rawSample / 32768.0; // Normalize to [-1.0, 1.0]
      } else if (bitsPerSample == 8) {
        rawSample = bytes[offset] - 128;
        samples[i] = rawSample / 128.0;
      } else {
        // 24- or 32-bit: read as 16-bit for simplicity
        rawSample = byteData.getInt16(offset, Endian.little);
        samples[i] = rawSample / 32768.0;
      }
    }

    final duration = totalSamples / sampleRate.toDouble();

    // ── Time-domain features ─────────────────────────────────────────
    double sumAmplitude = 0;
    double sumSquared = 0;
    for (final s in samples) {
      sumAmplitude += s.abs();
      sumSquared += s * s;
    }
    final averageAmplitude = samples.isNotEmpty
        ? sumAmplitude / samples.length
        : 0.0;
    final energy = sumSquared;

    // Variance
    final mean = samples.isNotEmpty
        ? samples.reduce((a, b) => a + b) / samples.length
        : 0.0;
    double varianceSum = 0;
    for (final s in samples) {
      varianceSum += (s - mean) * (s - mean);
    }
    final signalVariance = samples.isNotEmpty
        ? varianceSum / samples.length
        : 0.0;

    // ── FFT ──────────────────────────────────────────────────────────
    // Use a window of the first N samples where N is a power of 2
    final fftSize = _nextPowerOf2(min(samples.length, 8192));
    final windowedSamples = Float64List(fftSize);
    for (int i = 0; i < fftSize && i < samples.length; i++) {
      // Apply Hanning window to reduce spectral leakage
      final window = 0.5 * (1 - cos(2 * pi * i / (fftSize - 1)));
      windowedSamples[i] = samples[i] * window;
    }

    final fftResult = _fft(windowedSamples);
    final magnitudes = Float64List(fftSize ~/ 2);
    double maxMag = 0;
    int maxIdx = 0;
    double magSum = 0;

    for (int i = 1; i < fftSize ~/ 2; i++) {
      final re = fftResult[i * 2];
      final im = fftResult[i * 2 + 1];
      magnitudes[i] = sqrt(re * re + im * im);
      magSum += magnitudes[i];

      if (magnitudes[i] > maxMag) {
        maxMag = magnitudes[i];
        maxIdx = i;
      }
    }

    final freqResolution = sampleRate / fftSize;
    final peakFrequency = maxIdx * freqResolution;

    // Spectral centroid: weighted average of frequencies by magnitude
    double weightedSum = 0;
    for (int i = 1; i < fftSize ~/ 2; i++) {
      weightedSum += magnitudes[i] * (i * freqResolution);
    }
    final spectralCentroid = magSum > 0 ? weightedSum / magSum : 0.0;

    // Resonance score: how sharp the peak is vs. the average
    final avgMag = magnitudes.length > 1
        ? magSum / (magnitudes.length - 1)
        : 1.0;
    final resonanceScore = avgMag > 0 ? maxMag / avgMag : 0.0;

    return AcousticFeatures(
      peakFrequency: peakFrequency,
      spectralCentroid: spectralCentroid,
      energy: energy,
      signalVariance: signalVariance,
      resonanceScore: resonanceScore,
      duration: duration,
      averageAmplitude: averageAmplitude,
    );
  }

  /// Cooley-Tukey radix-2 FFT.
  ///
  /// Input: real-valued samples of length N (must be power of 2).
  /// Output: interleaved [re0, im0, re1, im1, ...] of length 2*N.
  static Float64List _fft(Float64List input) {
    final n = input.length;
    // Interleaved complex: [re, im, re, im, ...]
    final data = Float64List(n * 2);
    for (int i = 0; i < n; i++) {
      data[i * 2] = input[i]; // real
      data[i * 2 + 1] = 0; // imaginary
    }

    // Bit-reversal permutation
    int j = 0;
    for (int i = 0; i < n; i++) {
      if (i < j) {
        // Swap real
        final tmpR = data[i * 2];
        data[i * 2] = data[j * 2];
        data[j * 2] = tmpR;
        // Swap imag
        final tmpI = data[i * 2 + 1];
        data[i * 2 + 1] = data[j * 2 + 1];
        data[j * 2 + 1] = tmpI;
      }
      int m = n >> 1;
      while (m >= 1 && j >= m) {
        j -= m;
        m >>= 1;
      }
      j += m;
    }

    // Butterfly operations
    for (int step = 2; step <= n; step <<= 1) {
      final halfStep = step >> 1;
      final angle = -2.0 * pi / step;
      final wR = cos(angle);
      final wI = sin(angle);

      for (int group = 0; group < n; group += step) {
        double curR = 1.0;
        double curI = 0.0;

        for (int pair = 0; pair < halfStep; pair++) {
          final evenIdx = (group + pair) * 2;
          final oddIdx = (group + pair + halfStep) * 2;

          final tR = curR * data[oddIdx] - curI * data[oddIdx + 1];
          final tI = curR * data[oddIdx + 1] + curI * data[oddIdx];

          data[oddIdx] = data[evenIdx] - tR;
          data[oddIdx + 1] = data[evenIdx + 1] - tI;
          data[evenIdx] += tR;
          data[evenIdx + 1] += tI;

          // Advance twiddle factor
          final nextR = curR * wR - curI * wI;
          final nextI = curR * wI + curI * wR;
          curR = nextR;
          curI = nextI;
        }
      }
    }

    return data;
  }

  /// Returns the smallest power of 2 >= [n].
  static int _nextPowerOf2(int n) {
    int v = 1;
    while (v < n) {
      v <<= 1;
    }
    return v;
  }
}
