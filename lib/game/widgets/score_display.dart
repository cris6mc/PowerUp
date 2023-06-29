// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:jueguito2/game/my_game.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key, required this.game, required this.title, this.isLight = false});

  final MyGame game;
  final bool isLight;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      // valueListenable: (game as DoodleDash).gameManager.score,
      valueListenable: game.score,
      builder: (context, value, child) {
        return Text(
          '$title: $value',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
