import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/features/soil_acoustic/soil_ai_service.dart';
import 'package:kisan_mitra/features/soil_acoustic/soil_model.dart';

void main() {
  group('SoilAiService fertilizer rules', () {
    final service = SoilAiService();

    SoilAnalysisResult makeResult({
      required MoistureLevel moisture,
      required DensityLevel density,
      double compaction = 55,
    }) {
      return SoilAnalysisResult(
        moistureLevel: moisture,
        densityLevel: density,
        compactionScore: compaction,
        confidenceScore: 80,
        timestamp: DateTime.now(),
        features: const AcousticFeatures(
          peakFrequency: 600,
          spectralCentroid: 700,
          energy: 0.8,
          signalVariance: 0.2,
          resonanceScore: 4,
          duration: 6,
          averageAmplitude: 0.3,
        ),
      );
    }

    test('adds loose-soil strategy when density is loose', () async {
      final advisory = await service.generateAdvisory(
        soilResult: makeResult(
          moisture: MoistureLevel.medium,
          density: DensityLevel.loose,
        ),
      );

      expect(
        advisory.fertilizerPlan.any((r) => r.contains('loose soil')),
        isTrue,
      );
    });

    test('adds medium-density micronutrient recommendation', () async {
      final advisory = await service.generateAdvisory(
        soilResult: makeResult(
          moisture: MoistureLevel.medium,
          density: DensityLevel.medium,
        ),
      );

      expect(
        advisory.fertilizerPlan.any((r) => r.contains('Zinc Sulphate')),
        isTrue,
      );
    });

    test('adds compact-soil gypsum recommendation and warning', () async {
      final advisory = await service.generateAdvisory(
        soilResult: makeResult(
          moisture: MoistureLevel.low,
          density: DensityLevel.compact,
          compaction: 78,
        ),
      );

      expect(
        advisory.fertilizerPlan.any((r) => r.contains('150-200 kg/acre')),
        isTrue,
      );
      expect(
        advisory.warnings.any((w) => w.contains('COMPACT')),
        isTrue,
      );
    });
  });
}

