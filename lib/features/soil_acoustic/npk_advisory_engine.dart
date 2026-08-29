

// --- Enums ---

enum CompactionLevel { low, optimal, severelyCompacted }
enum SoilTexture { sandy, loamy, heavyClay }
enum NPKStatus { low, medium, high }
enum GrowthStage { basal, vegetative, flowering, fruiting }

// --- Data Models ---

class AcousticFeatures {
  final double peakFrequency; // Hz
  final double dampingRate; // decay constant / Q-factor (s⁻¹)
  final double harmonicRatio; // high/low energy ratio

  AcousticFeatures({
    required this.peakFrequency,
    required this.dampingRate,
    required this.harmonicRatio,
  });
}

class SoilPhysicalProfile {
  final CompactionLevel compactionLevel;
  final SoilTexture soilTexture;
  final double estimatedMoisturePct;

  SoilPhysicalProfile({
    required this.compactionLevel,
    required this.soilTexture,
    required this.estimatedMoisturePct,
  });
}

class RegionalPrior {
  final String district;
  final NPKStatus baselineN;
  final NPKStatus baselineP;
  final NPKStatus baselineK;
  final SoilTexture typicalSoilType;

  RegionalPrior({
    required this.district,
    required this.baselineN,
    required this.baselineP,
    required this.baselineK,
    required this.typicalSoilType,
  });
}

class CropAdvisoryRequest {
  final String crop;
  final GrowthStage growthStage;
  final List<AcousticFeatures> acousticStrikes;
  final RegionalPrior regionalPrior;
  final String previousCrop;
  final double previousYield;

  CropAdvisoryRequest({
    required this.crop,
    required this.growthStage,
    required this.acousticStrikes,
    required this.regionalPrior,
    required this.previousCrop,
    required this.previousYield,
  });
}

class FertilizerAdvisoryResult {
  final NPKStatus finalN;
  final NPKStatus finalP;
  final NPKStatus finalK;
  final double nScore;
  final double pScore;
  final double kScore;
  final String recommendedFertilizer;
  final double dosageKgPerAcre;
  final String applicationMethod;
  final String? bioavailabilityWarning;
  final SoilPhysicalProfile inferredProfile;

  FertilizerAdvisoryResult({
    required this.finalN,
    required this.finalP,
    required this.finalK,
    required this.nScore,
    required this.pScore,
    required this.kScore,
    required this.recommendedFertilizer,
    required this.dosageKgPerAcre,
    required this.applicationMethod,
    this.bioavailabilityWarning,
    required this.inferredProfile,
  });
}

// --- Engine ---

class NPKAdvisoryEngine {
  /// Applies a 3-tap median filter to discard outliers.
  double _applyMedianFilter(List<double> values) {
    if (values.isEmpty) return 0.0;
    List<double> sorted = List.from(values)..sort();
    int mid = sorted.length ~/ 2;
    if (sorted.length % 2 != 0) {
      return sorted[mid];
    } else {
      return (sorted[mid - 1] + sorted[mid]) / 2.0;
    }
  }

  /// Processes multiple acoustic strikes through a median filter.
  AcousticFeatures _filterStrikes(List<AcousticFeatures> strikes) {
    if (strikes.isEmpty) {
      throw ArgumentError("Acoustic strikes list cannot be empty");
    }
    
    // 3-tap median filter behavior on the most recent strikes
    List<AcousticFeatures> targetStrikes = strikes.length > 3 
        ? strikes.sublist(strikes.length - 3) 
        : strikes;

    double medFreq = _applyMedianFilter(targetStrikes.map((s) => s.peakFrequency).toList());
    double medDamp = _applyMedianFilter(targetStrikes.map((s) => s.dampingRate).toList());
    double medHarm = _applyMedianFilter(targetStrikes.map((s) => s.harmonicRatio).toList());

    return AcousticFeatures(
      peakFrequency: medFreq,
      dampingRate: medDamp,
      harmonicRatio: medHarm,
    );
  }

  /// Inverts acoustic features to a physical soil profile based on physical heuristics.
  SoilPhysicalProfile invertPhysicalState(AcousticFeatures features) {
    CompactionLevel compaction;
    SoilTexture texture;
    
    // High frequency (>750 Hz) + fast damping (>15 s⁻¹) → High compaction / Heavy clay.
    if (features.peakFrequency > 750.0 && features.dampingRate > 15.0) {
      compaction = CompactionLevel.severelyCompacted;
      texture = SoilTexture.heavyClay;
    } 
    // Low frequency (<450 Hz) → Sandy / Loose soil.
    else if (features.peakFrequency < 450.0) {
      compaction = CompactionLevel.low;
      texture = SoilTexture.sandy;
    } 
    // Moderate frequency (450–750 Hz) + balanced damping → Loamy / Optimal compaction.
    else {
      compaction = CompactionLevel.optimal;
      texture = SoilTexture.loamy;
    }

    // Estimate moisture % using an acoustic heuristic:
    // Moisture is roughly inversely proportional to Peak Frequency, proportional to Damping.
    double estMoisture = 30.0 - (features.peakFrequency / 100.0) + (features.dampingRate * 0.5);
    estMoisture = estMoisture.clamp(5.0, 40.0);

    return SoilPhysicalProfile(
      compactionLevel: compaction,
      soilTexture: texture,
      estimatedMoisturePct: estMoisture,
    );
  }

  /// Main advisory generation logic
  FertilizerAdvisoryResult generateAdvisory(CropAdvisoryRequest request) {
    if (request.acousticStrikes.isEmpty) {
      throw ArgumentError("At least one acoustic strike is required for inference.");
    }

    final filteredFeatures = _filterStrikes(request.acousticStrikes);
    final profile = invertPhysicalState(filteredFeatures);

    // Dynamic NPK Score Calculation from Sound Frequency & Acoustic Features
    // 1. Nitrogen (N) Proxy: Loose soil leaches N. Higher frequency -> harder soil -> higher N retention.
    double nScore = (filteredFeatures.peakFrequency / 10.0) + (filteredFeatures.dampingRate * 2.0);
    
    // 2. Phosphorus (P) Proxy: High compaction/clay locks P. Optimal at moderate frequency.
    double pScore = 100.0 - ((filteredFeatures.peakFrequency - 500).abs() / 15.0);
    
    // 3. Potassium (K) Proxy: Highly dependent on moisture.
    double kScore = profile.estimatedMoisturePct * 2.5;

    // Add acoustic harmonic variance for precision simulation
    nScore += filteredFeatures.harmonicRatio * 5.0;
    pScore += filteredFeatures.harmonicRatio * 3.0;
    kScore -= filteredFeatures.harmonicRatio * 2.0;

    // Clamp scores
    nScore = nScore.clamp(0.0, 100.0);
    pScore = pScore.clamp(0.0, 100.0);
    kScore = kScore.clamp(0.0, 100.0);

    // Map to discrete statuses
    NPKStatus finalN = nScore < 40 ? NPKStatus.low : (nScore > 75 ? NPKStatus.high : NPKStatus.medium);
    NPKStatus finalP = pScore < 40 ? NPKStatus.low : (pScore > 75 ? NPKStatus.high : NPKStatus.medium);
    NPKStatus finalK = kScore < 40 ? NPKStatus.low : (kScore > 75 ? NPKStatus.high : NPKStatus.medium);

    // Bioavailability checks
    bool requiresFoliarP = (profile.compactionLevel == CompactionLevel.severelyCompacted || profile.soilTexture == SoilTexture.heavyClay);
    bool kImmobileFlag = profile.estimatedMoisturePct < 18.0;

    String? bioWarning;
    if (profile.estimatedMoisturePct < 15.0) {
      bioWarning = "Soil is too dry. Delay top-dressing until irrigation/rainfall.";
    } else if (kImmobileFlag) {
      bioWarning = "Potassium is immobile in dry soil. Ensure adequate irrigation.";
    }

    // Fertilizer Recommendation Output
    String recommendedFert = "Standard NPK Blend";
    String appMethod = "Broadcasting";
    double dosage = 50.0; // Default

    if (request.growthStage == GrowthStage.basal && finalP == NPKStatus.low) {
      recommendedFert = "DAP / SSP";
      appMethod = requiresFoliarP ? "Foliar Spray (if possible) or Deep Placement" : "Basal Application";
      dosage = 50.0;
    } else if (request.growthStage == GrowthStage.vegetative && finalN == NPKStatus.low) {
      recommendedFert = "Urea";
      appMethod = "Split Top-Dressing";
      dosage = 45.0;
    } else if ((request.growthStage == GrowthStage.flowering || request.growthStage == GrowthStage.fruiting) && 
               (finalK == NPKStatus.low || finalK == NPKStatus.medium)) {
      recommendedFert = "MKP (0:52:34) or SOP (0:0:50)";
      appMethod = "Foliar Spray / Fertigation";
      dosage = 10.0;
    }

    // Alkaline soil / Micronutrient flag
    if (request.regionalPrior.district.toLowerCase().contains("alkaline")) {
      recommendedFert += " + Zinc Sulphate";
    }

    return FertilizerAdvisoryResult(
      finalN: finalN,
      finalP: finalP,
      finalK: finalK,
      nScore: nScore,
      pScore: pScore,
      kScore: kScore,
      recommendedFertilizer: recommendedFert,
      dosageKgPerAcre: dosage,
      applicationMethod: appMethod,
      bioavailabilityWarning: bioWarning,
      inferredProfile: profile,
    );
  }
}
