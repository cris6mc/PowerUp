import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../navigation/routes.dart';

class WinnerOverlay extends StatefulWidget {
  @override
  _WinnerOverlayState createState() => _WinnerOverlayState();
}

class _WinnerOverlayState extends State<WinnerOverlay> {
  final controller = ConfettiController();

  @override
  void initState() {
    super.initState();
    controller.play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Center(
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 9 / 19.5,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ConfettiWidget(
                  confettiController: controller,
                  blastDirectionality: BlastDirectionality.explosive,
                  // don't specify a direction, blast randomly
                  shouldLoop: true,
                  // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],
                  // customize the number of particles
                  numberOfParticles: 100,
                  // define a custom shape/path.
                ),
              ),
            ),
            Column(
              // añadir ventana de ganador
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/trophy.gif',
                  width: MediaQuery.of(context).size.width,
                ),
                Center(
                  child: Text(
                    '¡Ganaste!',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                        'Tenemos un video que podria gustarte. \n¿Te gustaria verlo?'),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VideoScreen(),
                          ),
                        );
                      },
                      // cambiar color de boton
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.yellow,
                      ),
                      child: const Text('Ver video sobre el bullyng'),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushAndRemoveUntil(Routes.main);
                    },
                    child: const Text('Volver al menú'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'mYrZvNW3DDw',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No al bullyng'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            const SizedBox(height: 20),
            // texto de agradecimiento y recomendacion
            const Text(
              'Gracias por jugar, recuerda que el bullyng es un problema que afecta a muchos niños y niñas, no seas parte del problema, se parte de la solución.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/image_splash.png'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
