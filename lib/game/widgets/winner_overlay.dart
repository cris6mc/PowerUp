import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../navigation/routes.dart';

class WinnerOverlay extends StatefulWidget {
  const WinnerOverlay({super.key});

  @override
  WinnerOverlayState createState() => WinnerOverlayState();
}

class WinnerOverlayState extends State<WinnerOverlay> {
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
                  'assets/images/trophy.png',
                  width: MediaQuery.of(context).size.width,
                ),
                const Center(
                  child: Text(
                    '¡Ganaste!',
                    style: TextStyle(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 75),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Tenemos un video que podria gustarte. \n¿Te gustaria verlo?',
                      style: TextStyle(color: Colors.amber, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
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
                      child: const Text(
                        'Ver video sobre el bullyng',
                        style: TextStyle(fontSize: 20),
                      ),
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
                const SizedBox(
                  height: 8,
                )
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
      initialVideoId: 'tIn4m5Tb8KA',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        showLiveFullscreenButton: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No al bullying'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            const SizedBox(height: 30),
            // texto de agradecimiento y recomendacion
            const Padding(
              padding: EdgeInsets.all(8.0),
              child:  Text(
                'Gracias por jugar, recuerda que el bullying es un problema que afecta a muchos niños y niñas, no seas parte del problema, se parte de la solución.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontFamily: 'DaveysDoodleface',
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
