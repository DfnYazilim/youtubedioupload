import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:youtubedioupload/providers/upload_provider.dart';

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCardView= true;
    double _elevation = 4;
    final pp = Provider.of<UploadProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("ProviderScreen"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const FlutterLogo(),
                ElevatedButton(
                    onPressed: () {
                      pp.uploadFn().then((value) => null);
                    },
                    child: const Text("Upload")),
                if (pp.sent != null && pp.total != null)
                   Consumer<UploadProvider>(builder: (BuildContext context, value, Widget? child) {
                     return Column(
                       children: [
                         Text(
                             "Uploading : ${pp.getFileSizeString(bytes: pp.sent!)}/${pp.getFileSizeString(bytes: pp.total!)}"),
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
                                             pp.percentageTxt??"-",
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
                                       value: (pp.percentage ?? 0).toDouble(),
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
                                       value: (pp.percentage ?? 0).toDouble(),
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
                                       widget: Text('${pp.percentageTxt??0}%',
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
                     );
                         },),

              ],
            ),
          ),
        ],
      ),
    );
  }
}