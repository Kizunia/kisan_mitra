import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'soil_model.dart';

/// AI-based soil analysis engine.
///
/// **Tier 1 (offline)**: Rule-based mapping from acoustic features to soil
/// characteristics (moisture, density, compaction).
///
/// **Tier 2 (online)**: Sends soil analysis + weather + crop data to Gemini AI
/// to generate natural-language fertilizer and irrigation recommendations.
class SoilAiService {
  // ═══════════════════════════════════════════════════════════════════════
  //  TIER 1 — Rule-based acoustic → soil mapping
  // ═══════════════════════════════════════════════════════════════════════

  /// Analyze acoustic features and return a soil analysis result.
  ///
  /// This runs entirely offline and produces moisture, density, and
  /// compaction estimates with a confidence score.
  SoilAnalysisResult analyzeAcousticFeatures(
    AcousticFeatures features, {
    double? latitude,
    double? longitude,
  }) {
    // ── Moisture estimation ──────────────────────────────────────────
    // Low frequency + high energy + high variance → wet/moist soil
    // High frequency + low energy → dry soil
    final moistureScore = _calculateMoistureScore(features);
    final moistureLevel = _scoreToBucket<MoistureLevel>(moistureScore, [
      MoistureLevel.low,
      MoistureLevel.medium,
      MoistureLevel.high,
    ]);

    // ── Density estimation ───────────────────────────────────────────
    // High spectral centroid + sharp resonance → compact, dense soil
    // Low centroid + diffuse spectrum → loose soil
    final densityScore = _calculateDensityScore(features);
    final densityLevel = _scoreToBucket<DensityLevel>(densityScore, [
      DensityLevel.loose,
      DensityLevel.medium,
      DensityLevel.compact,
    ]);

    // ── Compaction score (0–100) ─────────────────────────────────────
    final compactionScore = _calculateCompactionScore(features);

    // ── Confidence ───────────────────────────────────────────────────
    final confidenceScore = _calculateConfidence(features);

    return SoilAnalysisResult(
      moistureLevel: moistureLevel,
      densityLevel: densityLevel,
      compactionScore: compactionScore.clamp(0, 100),
      confidenceScore: confidenceScore.clamp(0, 100),
      features: features,
      timestamp: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Score 0–1 where 0 = very dry, 1 = very wet.
  double _calculateMoistureScore(AcousticFeatures f) {
    // Lower peak frequency → more likely moist (sound dampened)
    final freqFactor = 1.0 - (f.peakFrequency / 2000.0).clamp(0.0, 1.0);

    // Higher energy relative to duration → moist soil absorbs less
    // (inverted: high energy in wet soil from dull thuds)
    final energyPerSec = f.duration > 0 ? f.energy / f.duration : 0.0;
    final energyFactor = (energyPerSec / 500.0).clamp(0.0, 1.0);

    // Higher variance → irregular signal → possibly wet
    final varianceFactor = (f.signalVariance * 100).clamp(0.0, 1.0);

    // Weighted combination
    return (freqFactor * 0.45 + energyFactor * 0.30 + varianceFactor * 0.25)
        .clamp(0.0, 1.0);
  }

  /// Score 0–1 where 0 = very loose, 1 = very compact.
  double _calculateDensityScore(AcousticFeatures f) {
    // Higher spectral centroid → denser (higher-frequency reflections)
    final centroidFactor = (f.spectralCentroid / 1500.0).clamp(0.0, 1.0);

    // Higher resonance → clearer reflections → denser material
    final resonanceFactor = (f.resonanceScore / 15.0).clamp(0.0, 1.0);

    // Higher peak frequency → harder surface → denser
    final freqFactor = (f.peakFrequency / 1500.0).clamp(0.0, 1.0);

    return (centroidFactor * 0.35 + resonanceFactor * 0.35 + freqFactor * 0.30)
        .clamp(0.0, 1.0);
  }

  /// Compaction score 0–100.
  double _calculateCompactionScore(AcousticFeatures f) {
    // Combine density-like factors with resonance and amplitude
    final baseDensity = _calculateDensityScore(f);

    // Make the compaction score highly sensitive to frequency changes.
    // Loose soil gives a low dull thud (~100-200Hz), compacted gives a sharp high thud (~600-800Hz).
    final freqSensitivity = ((f.peakFrequency - 100) / 700.0).clamp(0.0, 1.0);
    final centroidSensitivity = ((f.spectralCentroid - 200) / 800.0).clamp(0.0, 1.0);

    final highFreqDominance = (freqSensitivity * 0.6 + centroidSensitivity * 0.4);

    // Amplitude is often damped in loose soil, sharp in compact soil
    final amplitudeFactor = (f.averageAmplitude * 5.0).clamp(0.0, 1.0);

    // Heavily weight the score towards frequency sensitivity so the gauge moves dynamically
    double finalScore = (baseDensity * 0.2 + highFreqDominance * 0.6 + amplitudeFactor * 0.2) * 100.0;

    return finalScore.clamp(0, 100);
  }

  /// Confidence 0–100 based on signal quality metrics.
  double _calculateConfidence(AcousticFeatures f) {
    double score = 50.0; // Base confidence

    // Good duration (5–10 sec) boosts confidence
    if (f.duration >= 5 && f.duration <= 10) {
      score += 15.0;
    } else if (f.duration >= 3) {
      score += 8.0;
    }

    // Detectable peak frequency
    if (f.peakFrequency > 50 && f.peakFrequency < 3000) {
      score += 15.0;
    }

    // Reasonable energy level
    if (f.energy > 0.1) {
      score += 10.0;
    }

    // Good resonance (clear signal)
    if (f.resonanceScore > 3.0) {
      score += 10.0;
    }

    return score.clamp(0, 100);
  }

  /// Map a 0–1 score into one of the provided buckets.
  T _scoreToBucket<T>(double score, List<T> buckets) {
    if (buckets.length == 3) {
      if (score < 0.33) return buckets[0];
      if (score < 0.66) return buckets[1];
      return buckets[2];
    }
    final idx = (score * (buckets.length - 1)).round();
    return buckets[idx.clamp(0, buckets.length - 1)];
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  TIER 2 — Gemini AI natural-language advisory
  // ═══════════════════════════════════════════════════════════════════════

  /// Generate fertilizer and irrigation recommendations using Gemini AI.
  ///
  /// Falls back to rule-based defaults if offline or API unavailable.
  Future<SoilAdvisory> generateAdvisory({
    required SoilAnalysisResult soilResult,
    String? cropName,
    String? growthStage,
    double? temperature,
    double? humidity,
    double? rainProbability,
    String? weatherCondition,
    String languageCode = 'en',
  }) async {
    // Check connectivity
    final hasConnection = await _checkConnectivity();
    if (!hasConnection) {
      return _getRuleBasedAdvisory(
        soilResult,
        cropName: cropName,
        temperature: temperature,
        humidity: humidity,
        rainProbability: rainProbability,
      );
    }

    // Safety check for dotenv initialization
    if (!dotenv.isInitialized) {
      try {
        await dotenv.load(fileName: '.env');
      } catch (_) {}
    }

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      return _getRuleBasedAdvisory(
        soilResult,
        cropName: cropName,
        temperature: temperature,
        humidity: humidity,
        rainProbability: rainProbability,
      );
    }

    try {
      final languageName = switch (languageCode) {
        'hi' => 'Hindi',
        'mr' => 'Marathi',
        _ => 'English',
      };

      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.6,
          maxOutputTokens: 400,
        ),
      );

      final prompt =
          '''You are an expert agricultural soil scientist and advisor.

Based on the following acoustic soil analysis data, generate practical farming advice.

SOIL ANALYSIS:
- Moisture Level: ${soilResult.moistureLevel.label}
- Soil Density: ${soilResult.densityLevel.label}
- Compaction Score: ${soilResult.compactionScore.toStringAsFixed(1)}/100
- Confidence: ${soilResult.confidenceScore.toStringAsFixed(1)}%

${cropName != null ? 'CROP: $cropName' : 'CROP: General (no specific crop selected)'}
${growthStage != null ? 'GROWTH STAGE: $growthStage' : ''}

WEATHER:
- Temperature: ${temperature?.toStringAsFixed(1) ?? 'Unknown'}°C
- Humidity: ${humidity?.toStringAsFixed(1) ?? 'Unknown'}%
- Rain Probability: ${((rainProbability ?? 0) * 100).toStringAsFixed(0)}%
- Condition: ${weatherCondition ?? 'Unknown'}

RESPOND IN VALID JSON ONLY. NO MARKDOWN. NO CODE BLOCKS.
Language: $languageName. Write all text content in $languageName.

Schema:
{
  "fertilizerPlan": ["recommendation 1", "recommendation 2", ...],
  "irrigationAdvice": "detailed irrigation advice string",
  "warnings": ["warning 1", ...] 
}

Rules:
- fertilizerPlan: 3-5 specific, actionable fertilizer recommendations with quantities
- irrigationAdvice: specific irrigation advice considering soil moisture + weather
- warnings: any critical warnings (soil too dry/wet, extreme weather, etc.)
- If confidence is low, include a warning about re-testing
''';

      final response = await model
          .generateContent([Content.text(prompt)])
          .timeout(const Duration(seconds: 12));

      final content = response.text;
      if (content != null && content.isNotEmpty) {
        try {
          // Clean potential markdown wrapping
          String cleanJson = content.trim();
          if (cleanJson.startsWith('```')) {
            cleanJson = cleanJson
                .replaceFirst(RegExp(r'^```\w*\n?'), '')
                .replaceFirst(RegExp(r'\n?```$'), '');
          }

          final parsed = jsonDecode(cleanJson) as Map<String, dynamic>;

          final weatherCtx = weatherCondition != null
              ? '${temperature?.toStringAsFixed(0)}°C, ${humidity?.toStringAsFixed(0)}% humidity, $weatherCondition'
              : 'Weather data unavailable';

          return SoilAdvisory(
            fertilizerPlan: List<String>.from(parsed['fertilizerPlan'] ?? []),
            irrigationAdvice: parsed['irrigationAdvice']?.toString() ?? '',
            warnings: List<String>.from(parsed['warnings'] ?? []),
            weatherContext: weatherCtx,
            cropName: cropName,
            growthStage: growthStage,
          );
        } catch (e) {
          debugPrint('SoilAiService: Failed to parse Gemini response: $e');
        }
      }
    } catch (e) {
      debugPrint('SoilAiService: Gemini API error: $e');
    }

    // Fallback
    return _getRuleBasedAdvisory(
      soilResult,
      cropName: cropName,
      temperature: temperature,
      humidity: humidity,
      rainProbability: rainProbability,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  //  Rule-based fallback advisory
  // ═══════════════════════════════════════════════════════════════════════

  SoilAdvisory _getRuleBasedAdvisory(
    SoilAnalysisResult result, {
    String? cropName,
    double? temperature,
    double? humidity,
    double? rainProbability,
  }) {
    final fertilizers = _buildFertilizerPlan(result, rainProbability: rainProbability);
    final warnings = <String>[];

    // Moisture-driven warnings
    switch (result.moistureLevel) {
      case MoistureLevel.low:
        warnings.add('Soil moisture is LOW. Irrigate before applying fertilizer.');
        break;
      case MoistureLevel.medium:
        break;
      case MoistureLevel.high:
        warnings.add(
          'Soil moisture is HIGH. Avoid fertilizer application during waterlogging.',
        );
        break;
    }

    if (result.densityLevel == DensityLevel.compact) {
      warnings.add(
        'Soil density is COMPACT. Prefer band placement and light incorporation of fertilizers.',
      );
    }

    // Compaction-based warning
    if (result.compactionScore > 70) {
      warnings.add('Soil is highly compacted. Consider deep plowing before sowing.');
    }

    // Irrigation advice
    String irrigation;
    switch (result.moistureLevel) {
      case MoistureLevel.low:
        irrigation =
            'Immediate irrigation recommended. Apply 50-60 mm water via drip or flood irrigation. Schedule daily irrigation until soil moisture normalizes.';
        break;
      case MoistureLevel.medium:
        irrigation =
            'Soil moisture is adequate. Continue normal irrigation schedule (every 3-5 days). Monitor evapotranspiration.';
        break;
      case MoistureLevel.high:
        irrigation =
            'Reduce irrigation immediately. Ensure field drainage is clear. Resume irrigation only when top 10 cm of soil dries out.';
        break;
    }

    // Weather-based adjustments
    if (rainProbability != null && rainProbability > 0.5) {
      warnings.add(
        'Rain expected (${(rainProbability * 100).toStringAsFixed(0)}% probability). Delay fertilizer application to prevent nutrient leaching.',
      );
      irrigation += ' Rain is forecast — skip next scheduled irrigation.';
    }

    if (temperature != null && temperature > 38) {
      warnings.add(
        'High temperature detected (${temperature.toStringAsFixed(0)}°C). Apply fertilizer in early morning or evening to avoid scorching.',
      );
    }

    final weatherCtx = temperature != null
        ? '${temperature.toStringAsFixed(0)}°C, ${humidity?.toStringAsFixed(0) ?? '--'}% humidity'
        : 'Weather data unavailable';

    return SoilAdvisory(
      fertilizerPlan: fertilizers,
      irrigationAdvice: irrigation,
      warnings: warnings,
      weatherContext: weatherCtx,
      cropName: cropName,
    );
  }

  List<String> _buildFertilizerPlan(
    SoilAnalysisResult result, {
    double? rainProbability,
  }) {
    final fertilizers = <String>[];

    // Primary nutrition based on moisture state
    switch (result.moistureLevel) {
      case MoistureLevel.low:
        fertilizers.add(
          'Apply Urea (46-0-0) at 45-50 kg/acre after first irrigation for drought recovery.',
        );
        fertilizers.add(
          'Use DAP (18-46-0) at 20-25 kg/acre near root zone to support early root growth in dry soil.',
        );
        break;
      case MoistureLevel.medium:
        fertilizers.add(
          'Apply NPK (19-19-19) at 35-40 kg/acre for balanced nutrition in current moisture conditions.',
        );
        fertilizers.add(
          'Top-dress with Urea at 25-30 kg/acre in 2 split doses for steady nitrogen supply.',
        );
        break;
      case MoistureLevel.high:
        fertilizers.add(
          'Use SSP (0-16-0) at 25-30 kg/acre and limit nitrogen until excess moisture drains.',
        );
        fertilizers.add(
          'Apply MOP (0-0-60) at 18-20 kg/acre to improve stem strength under wet conditions.',
        );
        break;
    }

    // Secondary adjustments based on density state
    switch (result.densityLevel) {
      case DensityLevel.loose:
        fertilizers.add(
          'For loose soil, use 10-15% lower dose per application and split into smaller intervals to reduce nutrient loss.',
        );
        break;
      case DensityLevel.medium:
        fertilizers.add(
          'Add Zinc Sulphate at 8-10 kg/acre once per season to support balanced nutrient uptake in medium-density soil.',
        );
        break;
      case DensityLevel.compact:
        fertilizers.add(
          'Apply Gypsum at 150-200 kg/acre and place fertilizers in shallow bands to improve nutrient movement in compact soil.',
        );
        break;
    }

    if (result.compactionScore > 70 && result.densityLevel != DensityLevel.compact) {
      fertilizers.add('Apply Gypsum at 100-150 kg/acre to reduce compaction effects.');
    }

    final vermicompostDose = switch (result.densityLevel) {
      DensityLevel.loose => '350-400',
      DensityLevel.medium => '450-550',
      DensityLevel.compact => '600-700',
    };
    fertilizers.add(
      'Supplement with Vermicompost at $vermicompostDose kg/acre for long-term soil health.',
    );

    if (rainProbability != null && rainProbability > 0.5) {
      fertilizers.add('If possible rain is high, postpone top-dressing by 24-48 hours to reduce leaching.');
    }

    return fertilizers;
  }

  Future<bool> _checkConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.isNotEmpty &&
          results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }
}
