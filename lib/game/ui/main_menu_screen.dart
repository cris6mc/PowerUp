import 'package:flutter/material.dart';
import 'package:jueguito2/game/high_scores.dart';
import 'package:jueguito2/game/navigation/routes.dart';
import 'package:jueguito2/game/ui/widgets/my_button.dart';
import 'package:jueguito2/game/ui/widgets/my_text.dart';

import '../../login/login/view/login_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: LayoutBuilder(builder: (context, constrains) {
                return Stack(
                  children: [
                    Positioned(
                      bottom: constrains.maxHeight * .25,
                      child: Image.asset(
                        'assets/images/heroJump.png',
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .60,
                      child: Image.asset(
                        'assets/images/platforms/LandPiece_DarkMulticolored.png',
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .05,
                      left: constrains.maxWidth * .2,
                      child: Image.asset(
                        'assets/images/platforms/BrokenLandPiece_Beige.png',
                        scale: 1.25,
                      ),
                    ),
                    Positioned(
                      bottom: constrains.maxHeight * .3,
                      right: 0,
                      child: Image.asset(
                        'assets/images/platforms/LandPiece_DarkBlue.png',
                        scale: 1.5,
                      ),
                    ),
                    Positioned(
                      top: constrains.maxHeight * .3,
                      right: 0,
                      child: Image.asset(
                        'assets/images/HappyCloud.png',
                        scale: 1.75,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        MyButton('login', onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyScreen()));
                        }),
                        Image.asset('assets/images/title.png'),
                        MyText(
                          'Best Score: ${HighScores.highScores[0]}',
                          fontSize: 26,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyButton(
                                'Play',
                                onPressed: () =>
                                    context.pushAndRemoveUntil(Routes.game),
                              ),
                              const SizedBox(height: 40),
                              MyButton(
                                'Rate',
                                onPressed: () {},
                              ),
                              const SizedBox(height: 40),
                              MyButton(
                                'Leaderboard',
                                onPressed: () =>
                                    context.push(Routes.leaderboard),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
