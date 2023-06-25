// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_local_variable, avoid_single_cascade_in_expression_statements, unused_element

import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  MobileScannerController _cameraController = MobileScannerController();
  PermissionStatus? _cameraPermission;
  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  void _checkCameraPermission() async {
    try {
      await Permission.camera.request();
    } catch (e) {
      print(e);
    }
    var permission = await Permission.camera.status;
    setState(() {
      _cameraPermission = permission;
    });
  }

  get _cameraHasAccess {
    return (_cameraPermission == PermissionStatus.granted ||
        _cameraPermission == PermissionStatus.limited);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Positioned.fill(
            child: _cameraPermission == null
                ? Container()
                : _cameraHasAccess
                    ? MobileScanner(
                        controller: _cameraController,
                        onDetect: (barcode) {
                          Navigator.of(context).pop(barcode.raw);
                        },
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 170,
                              width: 230,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.clear_fill,
                                    color: CupertinoColors.white,
                                    size: 80,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Insufficient permissions to open camera.',
                                    style:
                                        TextStyle(color: CupertinoColors.white),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: !_cameraController.hasTorch
                      ? null
                      : () {
                          _cameraController.toggleTorch();
                        },
                  child: Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: CupertinoColors.systemGrey.withOpacity(0.3)),
                    child: ValueListenableBuilder(
                        valueListenable: _cameraController.torchState,
                        builder: (_, torchState, __) => Icon(
                              !_cameraController.hasTorch
                                  ? CupertinoIcons.lightbulb_slash
                                  : torchState == TorchState.on
                                      ? CupertinoIcons.lightbulb_fill
                                      : CupertinoIcons.lightbulb,
                              color: !_cameraController.hasTorch
                                  ? CupertinoColors.systemGrey
                                  : CupertinoColors.white,
                            )),
                  ),
                ),
                GestureDetector(
                  onTap: !_cameraHasAccess
                      ? null
                      : () {
                          _cameraController.switchCamera();
                        },
                  child: Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: CupertinoColors.systemGrey.withOpacity(0.3)),
                    child: Icon(
                      CupertinoIcons.camera_rotate,
                      color: _cameraHasAccess
                          ? CupertinoColors.white
                          : CupertinoColors.systemGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 80,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: CupertinoColors.systemGrey.withOpacity(0.3)),
                child: Icon(
                  CupertinoIcons.clear,
                  color: CupertinoColors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
