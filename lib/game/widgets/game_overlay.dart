// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/widgets/heart_display.dart';
import 'package:jueguito2/game/widgets/life_display.dart';
import 'package:jueguito2/game/widgets/value_display.dart';

import '../navigation/routes.dart';
import 'widgets.dart';

class GameOverlay extends StatefulWidget {
  final MyGame game;

  const GameOverlay({
    super.key,
    required this.game,
  });

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  bool isPaused = false;
  final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                ScoreDisplay(game: widget.game),
                const SizedBox(width: 10),
                Container(
                  height: 15,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: LifeDisplay(game: widget.game),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  child: isPaused
                      ? const Icon(
                          Icons.play_arrow,
                          size: 48,
                        )
                      : const Icon(
                          Icons.pause,
                          size: 48,
                        ),
                  onPressed: () {
                    widget.game.togglePauseState();
                    setState(
                      () {
                        isPaused = !isPaused;
                      },
                    );
                    if (isPaused) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Juego en Pausa'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.pushAndRemoveUntil(Routes.main);
                                    },
                                    child: const Text('Volver al menu'),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        widget.game.togglePauseState();
                                        setState(
                                          () {
                                            isPaused = !isPaused;
                                          },
                                        );
                                      },
                                      child: const Text('Continuar jugando'))
                                ],
                              ));
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 100, left: 30),
            child: ListView.builder(
              itemCount: ValuesType.values.length,
              itemBuilder: (BuildContext context, int index) {
                ValuesType valueType = ValuesType.values[index];
                return ValueDisplay(
                  type: valueType,
                  game: widget.game,
                );
              },
            ),
          ),
          if (isMobile)
            Positioned(
              bottom: MediaQuery.of(context).size.height / 6,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: GestureDetector(
                        onTapDown: (details) {
                          widget.game.hero.moveLeft();
                        },
                        onTapUp: (details) {
                          widget.game.hero.resetDirection();
                        },
                        child: Material(
                          color: Colors.white24,
                          shape: const CircleBorder(),
                          elevation: 3.0,
                          shadowColor: Theme.of(context).colorScheme.background,
                          child: const Icon(Icons.arrow_left, size: 120),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 60, bottom: 0, left: 10),
                      child: GestureDetector(
                        onTapDown: (details) {
                          widget.game.hero.fireBullet();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              elevation: 3.0,
                              shadowColor:
                                  Theme.of(context).colorScheme.background,
                              child: Image.asset(
                                  'assets/images/items/Love1.png',
                                  width: 64),
                            ),
                            Positioned(child: HeartDisplay(game: widget.game)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: GestureDetector(
                        onTapDown: (details) {
                          widget.game.hero.moveRight();
                        },
                        onTapUp: (details) {
                          widget.game.hero.resetDirection();
                        },
                        child: Material(
                          color: Colors.white24,
                          shape: const CircleBorder(),
                          elevation: 3.0,
                          shadowColor: Theme.of(context).colorScheme.background,
                          child: const Icon(
                            Icons.arrow_right,
                            size: 120,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
