import "dart:math" show sqrt;

import "../datatypes/config_planedetection.dart";
import "../models/ar_anchor.dart";
import "../models/ar_hittest_result.dart";
import "../utils/json_converters.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:vector_math/vector_math_64.dart";

// Type definitions to enforce a consistent use of the API
typedef ARHitResultHandler = void Function(List<ARHitTestResult> hits);

/// Manages the session configuration, parameters and events of an [ARView]
class ARSessionManager {
  /// Platform channel used for communication from and to [ARSessionManager]
  late MethodChannel _channel;

  /// Debugging status flag. If true, all platform calls are printed. Defaults to false.
  final bool debug;

  /// Context of the [ARView] widget that this manager is attributed to
  final BuildContext buildContext;

  /// Determines the types of planes ARCore and ARKit should show
  final PlaneDetectionConfig planeDetectionConfig;

  /// Receives hit results from user taps with tracked planes or feature points
  late ARHitResultHandler onPlaneOrPointTap;

  ARSessionManager(int id, this.buildContext, this.planeDetectionConfig,
      {this.debug = false}) {
    _channel = MethodChannel("arsession_$id");
    _channel.setMethodCallHandler(_platformCallHandler);
    if (debug) {
      print("ARSessionManager initialized");
    }
  }

  /// Returns the camera pose in Matrix4 format with respect to the world coordinate system of the [ARView]
  Future<Matrix4?> getCameraPose() async {
    try {
      final List? serializedCameraPose =
          await _channel.invokeMethod<List<dynamic>>("getCameraPose", <, >{});
      return const MatrixConverter().fromJson(serializedCameraPose!);
    } catch (e) {
      print("Error caught: $e");
      return null;
    }
  }

  /// Returns the given anchor pose in Matrix4 format with respect to the world coordinate system of the [ARView]
  Future<Matrix4?> getPose(ARAnchor anchor) async {
    try {
      if (anchor.name.isEmpty) {
        throw Exception("Anchor can not be resolved. Anchor name is empty.");
      }
      final List? serializedCameraPose =
          await _channel.invokeMethod<List<dynamic>>("getAnchorPose", <String, String>{
        "anchorId": anchor.name,
      });
      return const MatrixConverter().fromJson(serializedCameraPose!);
    } catch (e) {
      print("Error caught: $e");
      return null;
    }
  }

  /// Returns the distance in meters between @anchor1 and @anchor2.
  Future<double?> getDistanceBetweenAnchors(
      ARAnchor anchor1, ARAnchor anchor2) async {
    final Matrix4? anchor1Pose = await getPose(anchor1);
    final Matrix4? anchor2Pose = await getPose(anchor2);
    final Vector3? anchor1Translation = anchor1Pose?.getTranslation();
    final Vector3? anchor2Translation = anchor2Pose?.getTranslation();
    if (anchor1Translation != null && anchor2Translation != null) {
      return getDistanceBetweenVectors(anchor1Translation, anchor2Translation);
    } else {
      return null;
    }
  }

  /// Returns the distance in meters between @anchor and device's camera.
  Future<double?> getDistanceFromAnchor(ARAnchor anchor) async {
    final Matrix4? cameraPose = await getCameraPose();
    final Matrix4? anchorPose = await getPose(anchor);
    final Vector3? cameraTranslation = cameraPose?.getTranslation();
    final Vector3? anchorTranslation = anchorPose?.getTranslation();
    if (anchorTranslation != null && cameraTranslation != null) {
      return getDistanceBetweenVectors(anchorTranslation, cameraTranslation);
    } else {
      return null;
    }
  }

  /// Returns the distance in meters between @vector1 and @vector2.
  double getDistanceBetweenVectors(Vector3 vector1, Vector3 vector2) {
    final num dx = vector1.x - vector2.x;
    final num dy = vector1.y - vector2.y;
    final num dz = vector1.z - vector2.z;
    final double distance = sqrt(dx * dx + dy * dy + dz * dz);
    return distance;
  }

  Future<void> _platformCallHandler(MethodCall call) {
    if (debug) {
      print("_platformCallHandler call ${call.method} ${call.arguments}");
    }
    try {
      switch (call.method) {
        case "onError":
          onError(call.arguments[0]);
          print(call.arguments);
                  break;
        case "onPlaneOrPointTap":
          final List rawHitTestResults = call.arguments as List<dynamic>;
          final List<Map<String, dynamic>> serializedHitTestResults = rawHitTestResults
              .map(
                  (hitTestResult) => Map<String, dynamic>.from(hitTestResult))
              .toList();
          final List<ARHitTestResult> hitTestResults = serializedHitTestResults.map((Map<String, dynamic> e) {
            return ARHitTestResult.fromJson(e);
          }).toList();
          onPlaneOrPointTap(hitTestResults);
                  break;
        case "dispose":
          _channel.invokeMethod<void>("dispose");
          break;
        default:
          if (debug) {
            print("Unimplemented method ${call.method} ");
          }
      }
    } catch (e) {
      print("Error caught: $e");
    }
    return Future.value();
  }

  /// Function to initialize the platform-specific AR view. Can be used to initially set or update session settings.
  /// [customPlaneTexturePath] refers to flutter assets from the app that is calling this function, NOT to assets within this plugin. Make sure
  /// the assets are correctly registered in the pubspec.yaml of the parent app (e.g. the ./example app in this plugin's repo)
  onInitialize({
    bool showAnimatedGuide = true,
    bool showFeaturePoints = false,
    bool showPlanes = true,
    String? customPlaneTexturePath,
    bool showWorldOrigin = false,
    bool handleTaps = true,
    bool handlePans = false, // nodes are not draggable by default
    bool handleRotation = false, // nodes can not be rotated by default
  }) {
    _channel.invokeMethod<void>("init", <String, Object?>{
      "showAnimatedGuide": showAnimatedGuide,
      "showFeaturePoints": showFeaturePoints,
      "planeDetectionConfig": planeDetectionConfig.index,
      "showPlanes": showPlanes,
      "customPlaneTexturePath": customPlaneTexturePath,
      "showWorldOrigin": showWorldOrigin,
      "handleTaps": handleTaps,
      "handlePans": handlePans,
      "handleRotation": handleRotation,
    });
  }

  /// Displays the [errorMessage] in a snackbar of the parent widget
  onError(String errorMessage) {
    ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
        content: Text(errorMessage),
        action: SnackBarAction(
            label: "HIDE",
            onPressed:
                ScaffoldMessenger.of(buildContext).hideCurrentSnackBar)));
  }

  /// Dispose the AR view on the platforms to pause the scenes and disconnect the platform handlers.
  /// You should call this before removing the AR view to prevent out of memory erros
  dispose() async {
    try {
      await _channel.invokeMethod<void>("dispose");
    } catch (e) {
      print(e);
    }
  }

  /// Returns a future ImageProvider that contains a screenshot of the current AR Scene
  Future<ImageProvider> snapshot() async {
    final Uint8List? result = await _channel.invokeMethod<Uint8List>("snapshot");
    return MemoryImage(result!);
  }
}