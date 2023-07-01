// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:jueguito2/game/my_game.dart';

class LifeDisplay extends StatelessWidget {
  const LifeDisplay({super.key, required this.game, this.isLight = false});

  final MyGame game;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      // valueListenable: (game as DoodleDash).gameManager.score,
      valueListenable: game.objects ,
      builder: (context, value, child) {
        return FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: game.objects.value / 5,
          // Porcentaje de vida actual del jugador
          child: Container(
            decoration: BoxDecoration(
              color: game.objects.value / 5.0 < 0.6 ? Colors.red : Colors.green ,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      },
    );
  }
}
