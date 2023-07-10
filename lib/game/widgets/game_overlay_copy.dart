/*
// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/widgets/heart_display.dart';
import 'package:jueguito2/game/widgets/life_display.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../doodle_dash.dart';
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
            top: 30,
            left: 30,
            child: ScoreDisplay(title: 'Score', game: widget.game),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: LifeDisplay(game: widget.game)),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: ElevatedButton(
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
              },
            ),
          ),
          if (isMobile)
            Positioned(
              bottom: MediaQuery.of(context).size.height / 4,
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
                          color: Colors.transparent,
                          elevation: 3.0,
                          shadowColor: Theme.of(context).colorScheme.background,
                          child: const Icon(Icons.arrow_left, size: 64),
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
                              elevation: 3.0,
                              shadowColor:
                                  Theme.of(context).colorScheme.background,
                              child: const Icon(
                                Icons.favorite,
                                size: 64,
                                color: Colors.red,
                              ),
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
                          color: Colors.transparent,
                          elevation: 3.0,
                          shadowColor: Theme.of(context).colorScheme.background,
                          child: const Icon(Icons.arrow_right, size: 64),
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

* */

// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/widgets/heart_display.dart';
import 'package:jueguito2/game/widgets/life_display.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../doodle_dash.dart';
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
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  double _gyroscopeValue = 0.0;
  double _gyroscopeThreshold = 0.5;

  double dx = 100, dy = 100;

  bool isPaused = false;
  final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValue = event.y;
      });
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  void _handleGyroscopeEvent() {
    if (_gyroscopeValue < -_gyroscopeThreshold) {
      widget.game.hero.moveLeft();
    } else if (_gyroscopeValue > _gyroscopeThreshold) {
      widget.game.hero.moveRight();
    } else {
      widget.game.hero.resetDirection();
    }
    print(_gyroscopeValue);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 30,
            child: ScoreDisplay(game: widget.game),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: LifeDisplay(game: widget.game)),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: ElevatedButton(
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
              },
            ),
          ),
          if (isMobile)
            Positioned(
                bottom: MediaQuery.of(context).size.height / 4,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<GyroscopeEvent>(
                    stream: SensorsPlatform.instance.gyroscopeEvents,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      _gyroscopeValue = snapshot.data!.y;
                      _handleGyroscopeEvent();

                      return Row(
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
                                color: Colors.transparent,
                                elevation: 3.0,
                                shadowColor:
                                    Theme.of(context).colorScheme.background,
                                child: const Icon(Icons.arrow_left, size: 64),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 60, bottom: 0, left: 10),
                            child: GestureDetector(
                              onTapDown: (details) {
                                widget.game.hero.fireBullet();
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    elevation: 3.0,
                                    shadowColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    child: const Icon(
                                      Icons.favorite,
                                      size: 64,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Positioned(
                                      child: HeartDisplay(game: widget.game)),
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
                                color: Colors.transparent,
                                elevation: 3.0,
                                shadowColor:
                                    Theme.of(context).colorScheme.background,
                                child: const Icon(Icons.arrow_right, size: 64),
                              ),
                            ),
                          ),
                          // Resto del código de los botones (si quieres mantenerlos)...

                          // Puedes eliminar los botones si prefieres solo el control por giroscopio
                          // y ajustar el diseño según tus necesidades.
                        ],
                      );
                      if (snapshot.hasData) {
                        dx = dx + (snapshot.data!.y * 30);
                        dy = dy + (snapshot.data!.x * 30);
                      }
                      return Transform.translate(
                          offset: Offset(dx, dy),
                          child: const CircleAvatar(
                            radius: 20,
                          ));
                    },
/*
                    stream: gyroscopeEvents,
                    builder: (context, snapshot) {

                    },*/
                  ),
                )),
        ],
      ),
    );
  }
}


