import 'package:flutter/material.dart';
import 'package:jueguito2/game/my_game.dart';

class ValueDisplay extends StatelessWidget {
  const ValueDisplay(
      {Key? key, required this.game, required this.type, this.isLight = false})
      : super(key: key);

  final MyGame game;
  final bool isLight;
  final ValuesType type;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<ValuesType, int>>(
      valueListenable: game.valuesNotifier,
      builder: (context, values, child) {
        final int value = values[type] ?? 0;
        final String path = type.name.toLowerCase();
        return Row(
          children: [
            Image.asset(
              'images/items/$path.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
                width: 10),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
