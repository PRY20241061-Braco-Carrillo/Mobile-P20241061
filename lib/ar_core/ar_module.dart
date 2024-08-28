import 'dart:io';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'ar.types.dart';

class ARScreen extends StatefulWidget {
  final String urlGLB;
  final NutritionalInformationAR nutritionalInformation;

  const ARScreen({
    Key? key,
    required this.urlGLB,
    required this.nutritionalInformation,
  }) : super(key: key);

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARNode? webObjectNode;
  HttpClient? httpClient;
  vector_math.Vector3 objectScale =
      vector_math.Vector3(0.5, 0.5, 0.5); // Initial scale

  @override
  void dispose() {
    super.dispose();
    arSessionManager?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Module'),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Wrap(
                  spacing: 8.0, // Espacio horizontal entre botones
                  runSpacing: 4.0, // Espacio vertical entre botones
                  alignment: WrapAlignment.center,
                  children: [
                    _buildInfoButton(
                        "Calories", widget.nutritionalInformation.calories),
                    _buildInfoButton(
                        "Proteins", widget.nutritionalInformation.proteins),
                    _buildInfoButton(
                        "Total Fat", widget.nutritionalInformation.totalFat),
                    _buildInfoButton("Carbohydrates",
                        widget.nutritionalInformation.carbohydrates),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () => _updateObjectScale(0.1),
                      ),
                    ),
                    SizedBox(width: 16), // Espacio entre los botones
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.remove, color: Colors.white),
                        onPressed: () => _updateObjectScale(-0.1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoButton(String label, double value) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        '$label: $value',
        textAlign: TextAlign.center,
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: true,
          handleTaps: false,
        );
    this.arObjectManager!.onInitialize();

    httpClient = HttpClient();
    _loadWebObject(widget.urlGLB);
  }

  Future<void> _loadWebObject(String url) async {
    var file = await _downloadFile(url, "LocalDuck.glb");
    if (file != null) {
      Matrix4? cameraPose = await arSessionManager!.getCameraPose();
      if (cameraPose != null) {
        vector_math.Vector3 cameraPosition = cameraPose.getTranslation();
        var newNode = ARNode(
          type: NodeType.webGLB,
          uri: file.path,
          scale: objectScale,
          position: vector_math.Vector3(
            cameraPosition.x,
            cameraPosition.y -
                0.5, // slightly below camera to ensure visibility
            cameraPosition.z - 1.0, // 1 meter in front of camera
          ),
        );
        bool? didAddWebNode = await arObjectManager!.addNode(newNode);
        webObjectNode = (didAddWebNode!) ? newNode : null;
      }
    }
  }

  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient!.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    print("Downloading finished, path: " + '$dir/$filename');
    return file;
  }

  void _updateObjectScale(double scaleChange) {
    if (webObjectNode != null) {
      setState(() {
        objectScale += vector_math.Vector3.all(scaleChange);
        arObjectManager!.removeNode(webObjectNode!);
        var newNode = ARNode(
          type: NodeType.webGLB,
          uri: webObjectNode!.uri,
          scale: objectScale,
          position: webObjectNode!.position,
        );
        arObjectManager!.addNode(newNode);
        webObjectNode = newNode;
      });
    }
  }
}
