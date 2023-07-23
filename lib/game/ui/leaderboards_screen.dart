import 'package:flutter/material.dart';
import 'package:jueguito2/game/high_scores.dart';
import 'package:jueguito2/game/navigation/routes.dart';
import 'package:jueguito2/game/ui/widgets/my_text.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = MediaQuery.of(context).size.height * .075;
    return Material(
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
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
                Positioned(
                  bottom: 0,
                  child: Image.asset('assets/inicio/bot.png'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          // icon: Image.asset('assets/images/ui/buttonBack.png'),
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.push(Routes.main),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    const MyText(
                      'Best Scores',
                      fontSize: 42,
                    ),
                    SizedBox(height: spacing),
                    MyText(
                      '${HighScores.highScores[0]}',
                      fontSize: 30,
                    ),
                    SizedBox(height: spacing),
                    MyText(
                      '${HighScores.highScores[1]}',
                      fontSize: 30,
                    ),
                    SizedBox(height: spacing),
                    MyText(
                      '${HighScores.highScores[2]}',
                      fontSize: 30,
                    ),
                    SizedBox(height: spacing),
                    MyText(
                      '${HighScores.highScores[3]}',
                      fontSize: 30,
                    ),
                    SizedBox(height: spacing),
                    MyText(
                      '${HighScores.highScores[4]}',
                      fontSize: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
