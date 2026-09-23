import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/feature/charts/widgets/chart_header.dart';

class GetDashScatterChart extends StatefulWidget {
  const GetDashScatterChart({super.key});

  @override
  State<StatefulWidget> createState() => _GetDashScatterChartState();
}

class _GetDashScatterChartState extends State {
  int touchedIndex = -1;

  Color greyColor = Colors.grey;

  List<int> selectedSpots = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChartHeader(title: "scatter_chart".tr),
        Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 1,
            child: ScatterChart(
              ScatterChartData(
                scatterSpots: [
                  ScatterSpot(
                    4,
                    4,
                    dotPainter: FlDotCirclePainter(
                      color: selectedSpots.contains(0)
                          ? Colors.green
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  ScatterSpot(
                    2,
                    5,
                    dotPainter: FlDotCirclePainter(
                      color: selectedSpots.contains(1)
                          ? Colors.yellow
                          : Colors.red.withValues(alpha: 0.5),
                      radius: 12,
                    ),
                  ),
                  ScatterSpot(
                    4,
                    5,
                    dotPainter: FlDotCirclePainter(
                      color: selectedSpots.contains(2)
                          ? Colors.pink
                          : Colors.blue.withValues(alpha: 0.5),
                      radius: 8,
                    ),
                  ),
                  ScatterSpot(
                    8,
                    6,
                    dotPainter: FlDotCirclePainter(
                      color: selectedSpots.contains(3)
                          ? Colors.orange
                          : Colors.green.withValues(alpha: 0.5),
                      radius: 20,
                    ),
                  ),
                  ScatterSpot(
                    5,
                    7,
                    dotPainter: FlDotCirclePainter(
                      color: selectedSpots.contains(4)
                          ? Colors.purple
                          : Colors.blue.withValues(alpha: 0.5),
                      radius: 14,
                    ),
                  ),
                  ScatterSpot(
                    7,
                    2,
                    dotPainter: FlDotCirclePainter(
                      color: selectedSpots.contains(5)
                          ? Colors.blue
                          : Colors.orange.withValues(alpha: 0.5),
                      radius: 18,
                    ),
                  ),
                  ScatterSpot(
                    3,
                    2,
                    dotPainter: FlDotCirclePainter(
                      color: selectedSpots.contains(6)
                          ? Colors.red
                          : Colors.green.withValues(alpha: 0.5),
                      radius: 36,
                    ),
                  ),
                  ScatterSpot(
                    2,
                    8,
                    dotPainter: FlDotCirclePainter(
                      color: selectedSpots.contains(7)
                          ? Colors.cyan
                          : Colors.red.withValues(alpha: 0.5),
                      radius: 22,
                    ),
                  ),
                ],
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 10,
                borderData: FlBorderData(
                  show: false,
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  checkToShowHorizontalLine: (value) => true,
                  getDrawingHorizontalLine: (value) =>  const FlLine(
                    color: Colors.orange,
                  ),
                  drawVerticalLine: true,
                  checkToShowVerticalLine: (value) => true,
                  getDrawingVerticalLine: (value) =>  const FlLine(
                    color: Colors.orange,
                  ),
                ),
                titlesData: const FlTitlesData(
                  show: false,
                ),
                showingTooltipIndicators: selectedSpots,
                scatterTouchData: ScatterTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  mouseCursorResolver:
                      (FlTouchEvent touchEvent, ScatterTouchResponse? response) {
                    return response == null || response.touchedSpot == null
                        ? MouseCursor.defer
                        : SystemMouseCursors.click;
                  },
                  touchTooltipData: ScatterTouchTooltipData(
                    getTooltipColor: (ScatterSpot spot) => Colors.black,
                    getTooltipItems: (ScatterSpot touchedBarSpot) {
                      return ScatterTooltipItem(
                        'X: ',
                        textStyle: TextStyle(
                          height: 1.2,
                          color: Colors.grey[100],
                          fontStyle: FontStyle.italic,
                        ),
                        bottomMargin: 10,
                        children: [
                          TextSpan(
                            text: '${touchedBarSpot.x.toInt()} \n',
                            style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Y: ',
                            style: TextStyle(
                              height: 1.2,
                              color: Colors.grey[100],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextSpan(
                            text: touchedBarSpot.y.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, ScatterTouchResponse? touchResponse) {
                    if (touchResponse == null || touchResponse.touchedSpot == null) {
                      return;
                    }
                    if (event is FlTapUpEvent) {
                      final sectionIndex = touchResponse.touchedSpot!.spotIndex;
                      setState(() {
                        if (selectedSpots.contains(sectionIndex)) {
                          selectedSpots.remove(sectionIndex);
                        } else {
                          selectedSpots.add(sectionIndex);
                        }
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}