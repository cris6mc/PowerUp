import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../login/cubit/my_user_cubit.dart';
import '../provider/firestore_kid.dart';

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
    Map valores =
        widget.kid?['valores'] ?? {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0};
    Map antivalores =
        widget.kid?['antivalores'] ?? {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0};
    final barGroups = <BarChartGroupData>[
      for (final entry in valores.entries)
        BarChartGroupData(
          x: int.parse(entry.key),
          barRods: [
            BarChartRodData(
              toY: entry.value.toDouble(),
              color: Colors.blue,
              width: 15,
            ),
            BarChartRodData(
              toY: antivalores[entry.key]!.toDouble(),
              color: Colors.red,
              width: 15,
            ),
          ],
        ),
    ];

    Widget getBottomTitles(double value, TitleMeta meta) {
      Widget text = Transform.rotate(angle: 0.5, child: const Text(''));
      switch (value.toInt()) {
        case 0:
          text = Transform.rotate(angle: 0.5, child: const Text('amor'));
          break;
        case 1:
          text = Transform.rotate(angle: 0.5, child: const Text('amistad'));
          break;
        case 2:
          text = Transform.rotate(angle: 0.5, child: const Text('cariño'));
          break;
        case 3:
          text = Transform.rotate(angle: 0.5, child: const Text('fuerza'));
          break;
        case 4:
          text = Transform.rotate(angle: 0.5, child: const Text('valentia'));
          break;
        case 5:
          text = Transform.rotate(angle: 0.5, child: const Text('honestidad'));
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
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Eliminar del registro'),
                        content: const Text(
                            '¿Estas seguro que deseas eliminar al niño del registro?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              deleteKid(widget.index).then((value) {
                                Navigator.pop(context);
                                context.read<MyUserCubit>().getMyUser();
                              });
                            },
                            child: const Text('Si'),
                          ),
                        ],
                      ));
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        children: [
          const Text('Valores'),
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
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(widget.kid!['description']),
                    const SizedBox(height: 40),
                    const Text(
                      'informacion:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
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
