import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jueguito2/login/kid/provider/firestore_kid.dart';

/// !!Step1: prepare the data to plot.

// ignore: must_be_immutable
class FlBarChartExample extends StatefulWidget {
  String? idKid;
  String? id;
  String? nameKid;
  FlBarChartExample(this.id, this.idKid, this.nameKid, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FlBarChartExampleState createState() => _FlBarChartExampleState();
}

class _FlBarChartExampleState extends State<FlBarChartExample> {
  @override
  Widget build(BuildContext context) {
    /// !!Step2: convert data into barGroups.

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameKid!),
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       deleteKid(widget.idKid).then((value) => Navigator.pop(context));
        //     },
        //     icon: const Icon(Icons.delete),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          const Text('Valores'),
          FutureBuilder(
              future: getKid(widget.idKid!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  Map valores = snapshot.data?['valores'] ??
                      {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0};
                  Map antivalores = snapshot.data?['antivalores'] ??
                      {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0};
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
                    Widget text =
                        Transform.rotate(angle: 0.5, child: const Text(''));
                    switch (value.toInt()) {
                      case 0:
                        text = Transform.rotate(
                            angle: 0.5, child: const Text('amor'));
                        break;
                      case 1:
                        text = Transform.rotate(
                            angle: 0.5, child: const Text('amistad'));
                        break;
                      case 2:
                        text = Transform.rotate(
                            angle: 0.5, child: const Text('cariño'));
                        break;
                      case 3:
                        text = Transform.rotate(
                            angle: 0.5, child: const Text('fuerza'));
                        break;
                      case 4:
                        text = Transform.rotate(
                            angle: 0.5, child: const Text('valentia'));
                        break;
                      case 5:
                        text = Transform.rotate(
                            angle: 0.5, child: const Text('honestidad'));
                        break;
                      default:
                        const Text('');
                    }
                    return SideTitleWidget(
                        axisSide: meta.axisSide, child: text);
                  }

                  DateTime birthdate = snapshot.data?['birtday'].toDate();
                  int edad = DateTime.now().year - birthdate.year;
                  if (DateTime.now().month < birthdate.month ||
                      (DateTime.now().month == birthdate.month &&
                          DateTime.now().day < birthdate.day)) {
                    edad--;
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 400,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 20),
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
                            Text(snapshot.data!['description']),
                            const SizedBox(height: 40),
                            const Text(
                              'informacion:',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text('Nombre: ${snapshot.data!['name']}'),
                            Text('genero: ${snapshot.data!['gender']}'),
                            Text('Edad: $edad'),
                            Text('I.E: ${snapshot.data!['ie']}'),
                            // Transform.rotate(
                            //     angle: 0.5, child: const Text('amor')),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text('No tienes eventos creados'));
                }
              }),
        ],
      ),
    );
  }
}

// /// !!Step1: prepare the data to plot.
// final _data1 = <double, double>{1: 9, 2: 12, 3: 10, 4: 20, 5: 14, 6: 18};
// final _data2 = <double, double>{1: 8, 2: 15, 3: 17, 4: 11, 5: 13, 6: 20};

// class FlBarChartExample extends StatefulWidget {
//   const FlBarChartExample({super.key});

//   @override
//   _FlBarChartExampleState createState() => _FlBarChartExampleState();
// }

// class _FlBarChartExampleState extends State<FlBarChartExample> {
//   bool _showBorder = true;
//   bool _showGrid = false;

//   @override
//   Widget build(BuildContext context) {
//     /// !!Step2: convert data into barGroups.
//     final barGroups = <BarChartGroupData>[
//       for (final entry in _data1.entries)
//         BarChartGroupData(
//           x: entry.key.toInt(),
//           barRods: [
//             BarChartRodData(toY: entry.value, color: Colors.blue),
//             BarChartRodData(toY: _data2[entry.key]!, color: Colors.red),
//           ],
//         ),
//     ];

//     /// !!Step3: prepare barChartData
//     final barChartData = BarChartData(
//       maxY: 25,
//       // ! The data to show
//       barGroups: barGroups,
//       barTouchData: BarTouchData(
//         enabled: true,
//         touchTooltipData: BarTouchTooltipData(
//           tooltipBgColor: Colors.blueGrey,
//         ),
//       ),
//       // ! Borders:
//       borderData: FlBorderData(show: _showBorder),
//       // ! Grid behavior:
//       gridData: FlGridData(show: _showGrid),
//       // ! Title and ticks in the axis
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           axisNameWidget: Text('Month'),
//           sideTitles: SideTitles(
//             showTitles: true,
//             // ! Decides how to show bottom titles,
//             // here we convert double to month names
//             getTitlesWidget: (double val, _) =>
//                 Text(DateFormat.MMM().format(DateTime(2020, val.toInt()))),
//           ),
//         ),
//         leftTitles: AxisTitles(
//           axisNameWidget: Text('Sales'),
//           sideTitles: SideTitles(
//             showTitles: true,
//             // ! Decides how to show left titles,
//             // here we skip some values by returning ''.
//             getTitlesWidget: (double val, _) {
//               if (val.toInt() % 5 != 0) return Text('');
//               return Text('${val.toInt()}');
//             },
//           ),
//         ),
//       ),
//     );
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8),
//         child: BarChart(barChartData),
//       ),
//       bottomNavigationBar: _buildControlWidgets(),
//     );
//   }

//   Widget _buildControlWidgets() {
//     return Container(
//       height: 200,
//       color: Colors.grey[200],
//       child: ListView(
//         children: [
//           SwitchListTile(
//             title: const Text('ShowBorder'),
//             onChanged: (bool val) => setState(() => this._showBorder = val),
//             value: this._showBorder,
//           ),
//           SwitchListTile(
//             title: const Text('ShowGrid'),
//             onChanged: (bool val) => setState(() => this._showGrid = val),
//             value: this._showGrid,
//           ),
//         ],
//       ),
//     );
//   }
// }
