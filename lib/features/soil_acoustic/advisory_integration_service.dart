import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../farmer/advisory/data/models/weather_model.dart';
import '../farmer/advisory/data/services/weather_service.dart';
import 'soil_ai_service.dart';
import 'soil_model.dart';

/// Bridges soil acoustic analysis with weather data, location, and the
/// existing advisory infrastructure.
///
/// Orchestrates the full analysis pipeline:
/// 1. Fetch GPS location
/// 2. Fetch weather data
/// 3. Run AI advisory generation
/// 4. Cache results locally
/// 5. Store results in Firebase
class AdvisoryIntegrationService {
  final WeatherService _weatherService = WeatherService();
  final SoilAiService _soilAiService = SoilAiService();

  // ─── Location ────────────────────────────────────────────────────────

  /// Get current GPS position. Returns null if permission denied or unavailable.
  Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('AdvisoryIntegrationService: Location error: $e');
      return null;
    }
  }

  // ─── Weather ─────────────────────────────────────────────────────────

  /// Fetch weather data for the given coordinates or current position.
  Future<WeatherData> getWeatherData({
    double? latitude,
    double? longitude,
  }) async {
    try {
      double lat = latitude ?? 20.5937; // Default: India center
      double lon = longitude ?? 78.9629;

      if (latitude == null || longitude == null) {
        final pos = await getCurrentPosition();
        if (pos != null) {
          lat = pos.latitude;
          lon = pos.longitude;
        }
      }

      return await _weatherService.fetchWeather(lat, lon);
    } catch (e) {
      debugPrint('AdvisoryIntegrationService: Weather fetch error: $e');
      return WeatherData.initial();
    }
  }

  // ─── Full Pipeline ───────────────────────────────────────────────────

  /// Run the complete advisory pipeline:
  /// soil analysis → weather → Gemini advisory → cache → Firebase.
  Future<SoilAdvisory> generateFullAdvisory({
    required SoilAnalysisResult soilResult,
    WeatherData? preFetchedWeather,
    String? cropName,
    String? growthStage,
    String languageCode = 'en',
  }) async {
    // 1. Use pre-fetched weather or fetch it
    final weather =
        preFetchedWeather ??
        await getWeatherData(
          latitude: soilResult.latitude,
          longitude: soilResult.longitude,
        );

    // 2. Generate advisory via AI
    final advisory = await _soilAiService.generateAdvisory(
      soilResult: soilResult,
      cropName: cropName,
      growthStage: growthStage,
      temperature: weather.temperature,
      humidity: weather.humidity,
      rainProbability: weather.rainProbability,
      weatherCondition: weather.condition,
      languageCode: languageCode,
    );

    // 3. Cache locally (fire-and-forget)
    _cacheResult(soilResult, advisory);

    // 4. Store in Firebase (fire-and-forget)
    _storeInFirebase(soilResult, advisory).catchError((e) {
      debugPrint('AdvisoryIntegrationService: Firebase store error: $e');
    });

    return advisory;
  }

  // ─── Caching ─────────────────────────────────────────────────────────

  static const String _cacheKey = 'last_soil_analysis';
  static const String _advisoryCacheKey = 'last_soil_advisory';

  /// Cache the last result in SharedPreferences.
  Future<void> _cacheResult(
    SoilAnalysisResult result,
    SoilAdvisory advisory,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(result.toJson()));
      await prefs.setString(_advisoryCacheKey, jsonEncode(advisory.toJson()));
    } catch (e) {
      debugPrint('AdvisoryIntegrationService: Cache error: $e');
    }
  }

  /// Get the last cached soil analysis result, if available.
  Future<SoilAnalysisResult?> getCachedResult() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_cacheKey);
      if (json != null) {
        return SoilAnalysisResult.fromJson(jsonDecode(json));
      }
    } catch (e) {
      debugPrint('AdvisoryIntegrationService: Cache read error: $e');
    }
    return null;
  }

  /// Get the last cached advisory, if available.
  Future<SoilAdvisory?> getCachedAdvisory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_advisoryCacheKey);
      if (json != null) {
        return SoilAdvisory.fromJson(jsonDecode(json));
      }
    } catch (e) {
      debugPrint('AdvisoryIntegrationService: Advisory cache read error: $e');
    }
    return null;
  }

  // ─── Firebase Storage ────────────────────────────────────────────────

  /// Store analysis result in Firestore under the current user's history.
  Future<void> _storeInFirebase(
    SoilAnalysisResult result,
    SoilAdvisory advisory,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docData = {
      ...result.toJson(),
      'advisory': advisory.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('soil_analyses')
        .add(docData);
  }

  /// Get analysis history for the current user from Firebase.
  Future<List<SoilAnalysisResult>> getAnalysisHistory({int limit = 10}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('soil_analyses')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        return SoilAnalysisResult.fromJson(doc.data());
      }).toList();
    } catch (e) {
      debugPrint('AdvisoryIntegrationService: History fetch error: $e');
      return [];
    }
  }
}
