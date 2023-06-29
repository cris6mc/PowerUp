// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:jueguito2/game/high_scores.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/navigation/routes.dart';
import 'package:jueguito2/game/widgets/text_display.dart';
import '../doodle_dash.dart';
import 'widgets.dart';

// Overlay that pops up when the game ends
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.game});

  final MyGame game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Game Over',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(),
              ),
              const WhiteSpace(height: 50),
              TitleDisplay(
                title: 'Score',
                value: game.score.value.toString(),
                isLight: true,
              ),
              TitleDisplay(
                title: 'Best Score',
                value: HighScores.highScores[0].toString(),
                isLight: true,
              ),
              const WhiteSpace(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushAndRemoveUntil(Routes.game);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(200, 75),
                  ),
                  textStyle: MaterialStateProperty.all(
                      Theme.of(context).textTheme.titleLarge),
                ),
                child: const Text('Try Again'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushAndRemoveUntil(Routes.main);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(200, 75),
                  ),
                  textStyle: MaterialStateProperty.all(
                      Theme.of(context).textTheme.titleLarge),
                ),
                child: const Text('Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
