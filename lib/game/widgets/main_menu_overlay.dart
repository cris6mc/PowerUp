// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:jueguito2/game/managers/level_manager.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/navigation/routes.dart';
import 'package:jueguito2/main.dart';
import 'package:provider/provider.dart';

import '../../login/login/view/login_screen.dart';

// Overlay that appears for the main menu
class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay({super.key});

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  Character character = Character.dash;

  @override
  Widget build(BuildContext context) {
    //DoodleDash game = widget.game as DoodleDash;

    return LayoutBuilder(builder: (context, constraints) {
      final characterWidth = constraints.maxWidth / 8;

      final TextStyle titleStyle = (constraints.maxWidth > 830)
          ? Theme.of(context).textTheme.displayLarge!
          : Theme.of(context).textTheme.displaySmall!;

      // 760 is the smallest height the browser can have until the
      // layout is too large to fit.
      final bool screenHeightIsSmall = constraints.maxHeight < 760;
      LevelManager levelManager = LevelManager();
      return Material(
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const WhiteSpace(height: 50),
            ElevatedButton(
              onPressed: () {
                context.pushAndRemoveUntil(Routes.game);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyScreen()));
              },
              child: const Text('login'),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Bullybuster',
                        style: titleStyle.copyWith(
                          height: .8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const WhiteSpace(height: 50),
                      Align(
                        alignment: Alignment.center,
                        child: Text('Selecciona tu personaje:',
                            style: Theme.of(context).textTheme.headlineSmall!),
                      ),
                      if (!screenHeightIsSmall) const WhiteSpace(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CharacterButton(
                            character: Character.dash,
                            selected: character == Character.dash,
                            onSelectChar: () {
                              setState(() {
                                character = Character.dash;
                              });
                            },
                            characterWidth: characterWidth,
                          ),
                          CharacterButton(
                            character: Character.sparky,
                            selected: character == Character.sparky,
                            onSelectChar: () {
                              setState(() {
                                character = Character.sparky;
                              });
                            },
                            characterWidth: characterWidth,
                          ),
                        ],
                      ),
                      if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Dificultad:',
                              style: Theme.of(context).textTheme.bodyLarge!),
                          LevelPicker(
                            level:levelManager.selectedLevel.toDouble(),
                            label: levelManager.selectedLevel.toString(),
                            onChanged: ((value) {
                              setState(() {
                                levelManager.selectLevel(value.toInt());
                              });
                            }),
                          ),
                        ],
                      ),
                      if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final myCharacter = Provider.of<MyProvider>(context, listen: false);
                            myCharacter.updateValue(character);
                            context.pushAndRemoveUntil(Routes.game);
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              const Size(100, 50),
                            ),
                            textStyle: MaterialStateProperty.all(
                                Theme.of(context).textTheme.titleMedium),
                          ),
                          child: const Text('JUGAR'),
                        ),
                      ),
                      const WhiteSpace(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            context.pushAndRemoveUntil(Routes.leaderboard);
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              const Size(100, 50),
                            ),
                            textStyle: MaterialStateProperty.all(
                                Theme.of(context).textTheme.titleMedium),
                          ),
                          child: const Text('LEADERBOARD'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class LevelPicker extends StatelessWidget {
  const LevelPicker({
    super.key,
    required this.level,
    required this.label,
    required this.onChanged,
  });

  final double level;
  final String label;
  final void Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Slider(
      value: level,
      max: 5,
      min: 1,
      divisions: 4,
      label: label,
      onChanged: onChanged,
    ));
  }
}

class CharacterButton extends StatelessWidget {
  const CharacterButton(
      {super.key,
      required this.character,
      this.selected = false,
      required this.onSelectChar,
      required this.characterWidth});

  final Character character;
  final bool selected;
  final void Function() onSelectChar;
  final double characterWidth;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: (selected)
          ? ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(31, 64, 195, 255)))
          : null,
      onPressed: onSelectChar,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/game/${character.name}_center.png',
              height: characterWidth,
              width: characterWidth,
            ),
            const WhiteSpace(height: 18),
            Text(
              character.name,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteSpace extends StatelessWidget {
  const WhiteSpace({super.key, this.height = 100});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
