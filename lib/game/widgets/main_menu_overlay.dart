// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:jueguito2/game/navigation/routes.dart';
import 'package:jueguito2/main.dart';
import 'package:provider/provider.dart';

import '../../login/kid/view/list_kids.dart';
import '../../login/login/view/login_screen.dart';
import '../ui/leaderboards_screen.dart';

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
      return Container(
        // color: Theme.of(context).colorScheme.background,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/inicio/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Image.asset('assets/inicio/burbles.png'),
            Positioned(
              top: 0,
              child: Image.asset('assets/inicio/top.png'),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset('assets/inicio/bot.png'),
            ),
            Positioned(
              top: 55,
              right: 0,
              left: 0,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      'assets/inicio/logo.png',
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          const HorizontalSpace(),
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
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          saveValues = false;
                          final myCharacter =
                              Provider.of<MyProvider>(context, listen: false);
                          myCharacter.updateValue(character);
                          context.pushAndRemoveUntil(Routes.game);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/inicio/bg-icon.png',
                              height: 150,
                              width: 150,
                            ),
                            Image.asset(
                              'assets/inicio/icon-play.png',
                              height: 80,
                              width: 80,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyScreen()));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/inicio/bg-icon2.png',
                                height: 150,
                                width: 150,
                              ),
                              Image.asset(
                                'assets/inicio/icon-home.png',
                                height: 80,
                                width: 80,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LeaderboardScreen()));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/inicio/bg-icon2.png',
                                height: 150,
                                width: 150,
                              ),
                              Image.asset(
                                'assets/inicio/icon-stadistic.png',
                                height: 80,
                                width: 80,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const WhiteSpace(height: 50),
                  ],
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
  const CharacterButton({
    Key? key,
    required this.character,
    this.selected = false,
    required this.onSelectChar,
    required this.characterWidth,
  }) : super(key: key);

  final Character character;
  final bool selected;
  final void Function() onSelectChar;
  final double characterWidth;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: selected
          ? ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(31, 64, 195, 255),
              ),
            )
          : null,
      onPressed: onSelectChar,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              width: characterWidth,
              height: characterWidth,
              child: Image.asset(
                'assets/images/game/${character.name}_center.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              (character.name.length > 4
                  ? character.name.substring(0, 4)
                  : character.name),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
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

class HorizontalSpace extends StatelessWidget {
  const HorizontalSpace({super.key, this.width = 10});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}
