import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Dio dio = Dio();
  int? _sent;
  int? _total;
bool isCardView= true;
double _elevation = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MainScreen"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const FlutterLogo(),
                ElevatedButton(
                    onPressed: () {
                      uploadFn().then((value) => null);
                    },
                    child: const Text("Upload")),
                if (_sent != null && _total != null)
                  Text(
                      "Uploading : ${getFileSizeString(bytes: _sent!)}/${getFileSizeString(bytes: _total!)}"),
                if (_sent != null && _total != null)
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                          showLabels: false,
                          showTicks: false,
                          startAngle: 270,
                          endAngle: 270,
                          radiusFactor: 0.8,
                          axisLineStyle: const AxisLineStyle(
                              thicknessUnit: GaugeSizeUnit.factor,
                              thickness: 0.15),
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                angle: 180,
                                widget: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      (_sent!/_total! * 100).toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontFamily: 'Times',
                                          fontSize: true ? 18 : 22,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    const Text(
                                      ' / 100',
                                      style: TextStyle(
                                          fontFamily: 'Times',
                                          fontSize: true ? 18 : 22,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                )),
                          ],
                          pointers:  <GaugePointer>[
                            RangePointer(
//todo value
                                value: _sent!/_total! * 100,
                                cornerStyle: CornerStyle.bothCurve,
                                enableAnimation: true,
                                animationDuration: 1200,
                                sizeUnit: GaugeSizeUnit.factor,
                                gradient: const SweepGradient(colors: <Color>[
                                  Color(0xFF6A6EF6),
                                  Color(0xFFDB82F5)
                                ], stops: <double>[
                                  0.25,
                                  0.75
                                ]),
                                color: const Color(0xFF00A8B5),
                                width: 0.15),
                          ]),
                    ],
                  ),
                if (_sent != null && _total != null)
                  SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                          startAngle: 180,
                          endAngle: 360,
                          radiusFactor: 0.9,
                          canScaleToFit: true,
                          interval: 10,
                          showLabels: false,
                          showAxisLine: false,
                          pointers: <GaugePointer>[
                            MarkerPointer(
                                value: _sent!/_total! * 100,
                                elevation: _elevation,
                                markerWidth: 25,
                                markerHeight: 25,
                                color: const Color(0xFFF67280),
                                markerType: MarkerType.circle,
                                markerOffset: -7)
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                angle: 175,
                                positionFactor: 0.8,
                                widget: Text('Min',
                                    style: TextStyle(
                                        fontSize: isCardView ? 12 : 16,
                                        fontWeight: FontWeight.bold))),
                            GaugeAnnotation(
                                angle: 270,
                                positionFactor: 0.1,
                                widget: Text('${(_sent!/_total! * 100).toStringAsFixed(2)}%',
                                    style: TextStyle(
                                        fontSize: isCardView ? 12 : 16,
                                        fontWeight: FontWeight.bold))),
                            GaugeAnnotation(
                                angle: 5,
                                positionFactor: 0.8,
                                widget: Text('Max',
                                    style: TextStyle(
                                        fontSize: isCardView ? 12 : 16,
                                        fontWeight: FontWeight.bold)))
                          ],
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0,
                              endValue: 100,
                              sizeUnit: GaugeSizeUnit.factor,
                              gradient: const SweepGradient(
                                  colors: <Color>[Color(0xFFAB64F5), Color(0xFF62DBF6)],
                                  stops: <double>[0.25, 0.75]),
                              startWidth: 0.4,
                              endWidth: 0.4,
                              color: const Color(0xFF00A8B5),
                            )
                          ],
                          showTicks: false),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> uploadFn() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    (result?.files ?? []).forEach((element) {
      print(element.name);
      print(element.path);
    });
    if ((result?.files ?? []).isEmpty) return;
    var ff = await MultipartFile.fromFile(result!.files.first.path!,
        filename: result!.files.first.name!);
    var formData = await FormData.fromMap({'photo': ff});
    final response = await dio.post(
      'http://localhost:5560/upload',
      data: formData,
      onSendProgress: (int sent, int total) {
        print('$sent $total');
        _sent = sent;
        _total = total;
        setState(() {});
      },
    );
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
}
