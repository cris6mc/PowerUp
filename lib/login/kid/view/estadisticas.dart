import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FlBarChartExample extends StatefulWidget {
  int index;
  Map? kid;
  String? nameKid;
  FlBarChartExample(this.index, this.kid, this.nameKid, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FlBarChartExampleState createState() => _FlBarChartExampleState();
}

class _FlBarChartExampleState extends State<FlBarChartExample> {
  @override
  Widget build(BuildContext context) {
    Map valores = widget.kid?['valores'] ??
        {
          'empatia': 0,
          'igualdad': 0,
          'amor': 0,
          'respeto': 0,
          'solidaridad': 0
        };
    Map antivalores =
        widget.kid?['antivalores'] ?? {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0};

    List valoreskeysList = valores.values.toList();
    List antivaloreskeysList = antivalores.values.toList();

    final barGroups = <BarChartGroupData>[
      for (int i = 0; i < 5; i++) ...[
        BarChartGroupData(
          x: i * 2,
          barRods: [
            BarChartRodData(
              toY: valoreskeysList[i]!.toDouble(),
              color: Colors.blue,
              width: 15,
            ),
          ],
        ),
        BarChartGroupData(
          x: i * 2 + 1,
          barRods: [
            BarChartRodData(
              toY: antivaloreskeysList[i]!.toDouble(),
              color: Colors.red,
              width: 15,
            ),
          ],
        ),
      ]
    ];

    Widget rotText(String text) {
      return Transform.rotate(
          angle: -(55 * pi / 180),
          child: Text(
            text,
            style: const TextStyle(fontSize: 10),
          ));
    }

    Widget getBottomTitles(double value, TitleMeta meta) {
      Widget text = rotText('');
      switch (value.toInt()) {
        case 0:
          text = rotText('empatia');
          break;
        case 1:
          text = rotText('envidia');
          break;
        case 2:
          text = rotText('igualdad');
          break;
        case 3:
          text = rotText('odio');
          break;
        case 4:
          text = rotText('amor');
          break;
        case 5:
          text = rotText('indiferencia');
          break;
        case 6:
          text = rotText('respeto');
          break;
        case 7:
          text = rotText('injusticia');
          break;
        case 8:
          text = rotText('solidaridad');
          break;
        case 9:
          text = rotText('violencia');
          break;
        default:
          const Text('');
      }
      return SideTitleWidget(axisSide: meta.axisSide, child: text);
    }

    DateTime birthdate = widget.kid?['birtday'].toDate();
    int edad = DateTime.now().year - birthdate.year;
    if (DateTime.now().month < birthdate.month ||
        (DateTime.now().month == birthdate.month &&
            DateTime.now().day < birthdate.day)) {
      edad--;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameKid!),
      ),
      body: Column(
        children: [
          const Row(
            children: [
              Text('Valores', style: TextStyle(color: Colors.blue)),
              Icon(
                Icons.circle,
                color: Colors.blue,
              )
            ],
          ),
          const Row(
            children: [
              Text('Antivalores', style: TextStyle(color: Colors.red)),
              Icon(
                Icons.circle,
                color: Colors.red,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 400,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                child: BarChart(
                  BarChartData(
                    maxY: 10,
                    minY: 0,
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: getBottomTitles,
                      )),
                    ),
                    barGroups: barGroups,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'observaciones:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.kid!['description']),
                    const SizedBox(height: 40),
                    const Text(
                      'informacion:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('Nombre: ${widget.kid!['name']}'),
                    Text('genero: ${widget.kid!['gender']}'),
                    Text('Edad: $edad'),
                    Text('I.E: ${widget.kid!['ie']}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
