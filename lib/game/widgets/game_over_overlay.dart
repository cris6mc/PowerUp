import 'package:flutter/material.dart';
import 'package:jueguito2/game/high_scores.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/navigation/routes.dart';
import 'package:jueguito2/game/widgets/text_display.dart';
import 'widgets.dart';

// Overlay that pops up when the game ends
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.game});

  final MyGame game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Container(
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
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/game_over_kid.png'),
                      const Text(
                        "Recuerda escoger los valores. No te rindas y vuelve a intentarlo. \n¡Tú puedes hacerlo!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const WhiteSpace(height: 20),
                      const Text('Game Over',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          )),
                      const WhiteSpace(height: 10),
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
                        child: const Text('Volver a jugar'),
                      ),
                      const SizedBox(
                        height: 25,
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
                        child: const Text('Menú'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
