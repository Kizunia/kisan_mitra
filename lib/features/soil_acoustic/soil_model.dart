/// Data models for the Smart Soil Analyzer (Acoustic Soil Analysis) feature.

/// Moisture level estimated from acoustic analysis.
enum MoistureLevel {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case MoistureLevel.low:
        return 'Low';
      case MoistureLevel.medium:
        return 'Medium';
      case MoistureLevel.high:
        return 'High';
    }
  }
}

/// Soil density estimated from acoustic analysis.
enum DensityLevel {
  loose,
  medium,
  compact;

  String get label {
    switch (this) {
      case DensityLevel.loose:
        return 'Loose';
      case DensityLevel.medium:
        return 'Medium';
      case DensityLevel.compact:
        return 'Compact';
    }
  }
}

/// Features extracted from the recorded audio signal.
class AcousticFeatures {
  /// Dominant frequency in Hz from FFT analysis.
  final double peakFrequency;

  /// Spectral centroid — weighted average frequency (Hz).
  final double spectralCentroid;

  /// Total signal energy (sum of squared amplitudes).
  final double energy;

  /// Variance of the signal amplitude.
  final double signalVariance;

  /// Resonance score: ratio of peak FFT magnitude to average magnitude.
  final double resonanceScore;

  /// Duration of the recorded audio in seconds.
  final double duration;

  /// Average amplitude of the signal.
  final double averageAmplitude;

  const AcousticFeatures({
    required this.peakFrequency,
    required this.spectralCentroid,
    required this.energy,
    required this.signalVariance,
    required this.resonanceScore,
    required this.duration,
    required this.averageAmplitude,
  });

  Map<String, dynamic> toJson() => {
    'peakFrequency': peakFrequency,
    'spectralCentroid': spectralCentroid,
    'energy': energy,
    'signalVariance': signalVariance,
    'resonanceScore': resonanceScore,
    'duration': duration,
    'averageAmplitude': averageAmplitude,
  };

  factory AcousticFeatures.fromJson(Map<String, dynamic> json) {
    return AcousticFeatures(
      peakFrequency: (json['peakFrequency'] ?? 0.0).toDouble(),
      spectralCentroid: (json['spectralCentroid'] ?? 0.0).toDouble(),
      energy: (json['energy'] ?? 0.0).toDouble(),
      signalVariance: (json['signalVariance'] ?? 0.0).toDouble(),
      resonanceScore: (json['resonanceScore'] ?? 0.0).toDouble(),
      duration: (json['duration'] ?? 0.0).toDouble(),
      averageAmplitude: (json['averageAmplitude'] ?? 0.0).toDouble(),
    );
  }
}

/// Result of AI / rule-based soil analysis from acoustic features.
class SoilAnalysisResult {
  final MoistureLevel moistureLevel;
  final DensityLevel densityLevel;

  /// Compaction score from 0 (very loose) to 100 (extremely compacted).
  final double compactionScore;

  /// Confidence in the analysis from 0 to 100.
  final double confidenceScore;

  /// The acoustic features used for this analysis.
  final AcousticFeatures features;

  /// Timestamp of the analysis.
  final DateTime timestamp;

  /// GPS latitude at time of analysis.
  final double? latitude;

  /// GPS longitude at time of analysis.
  final double? longitude;

  const SoilAnalysisResult({
    required this.moistureLevel,
    required this.densityLevel,
    required this.compactionScore,
    required this.confidenceScore,
    required this.features,
    required this.timestamp,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'moistureLevel': moistureLevel.name,
    'densityLevel': densityLevel.name,
    'compactionScore': compactionScore,
    'confidenceScore': confidenceScore,
    'features': features.toJson(),
    'timestamp': timestamp.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
  };

  factory SoilAnalysisResult.fromJson(Map<String, dynamic> json) {
    return SoilAnalysisResult(
      moistureLevel: MoistureLevel.values.firstWhere(
        (e) => e.name == json['moistureLevel'],
        orElse: () => MoistureLevel.medium,
      ),
      densityLevel: DensityLevel.values.firstWhere(
        (e) => e.name == json['densityLevel'],
        orElse: () => DensityLevel.medium,
      ),
      compactionScore: (json['compactionScore'] ?? 50.0).toDouble(),
      confidenceScore: (json['confidenceScore'] ?? 0.0).toDouble(),
      features: AcousticFeatures.fromJson(json['features'] ?? {}),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}

/// Combined advisory output: fertilizer plan + irrigation + warnings.
class SoilAdvisory {
  /// List of fertilizer recommendations.
  final List<String> fertilizerPlan;

  /// Irrigation advice text.
  final String irrigationAdvice;

  /// Warning messages (e.g., soil too dry, rain expected).
  final List<String> warnings;

  /// Weather context summary used in generating this advisory.
  final String weatherContext;

  /// The crop this advisory is targeted for (if selected).
  final String? cropName;

  /// Growth stage of the crop.
  final String? growthStage;

  const SoilAdvisory({
    required this.fertilizerPlan,
    required this.irrigationAdvice,
    required this.warnings,
    required this.weatherContext,
    this.cropName,
    this.growthStage,
  });

  Map<String, dynamic> toJson() => {
    'fertilizerPlan': fertilizerPlan,
    'irrigationAdvice': irrigationAdvice,
    'warnings': warnings,
    'weatherContext': weatherContext,
    'cropName': cropName,
    'growthStage': growthStage,
  };

  factory SoilAdvisory.fromJson(Map<String, dynamic> json) {
    return SoilAdvisory(
      fertilizerPlan: List<String>.from(json['fertilizerPlan'] ?? []),
      irrigationAdvice: json['irrigationAdvice'] ?? '',
      warnings: List<String>.from(json['warnings'] ?? []),
      weatherContext: json['weatherContext'] ?? '',
      cropName: json['cropName'],
      growthStage: json['growthStage'],
    );
  }
}
