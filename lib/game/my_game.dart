import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/high_scores.dart';
import 'package:jueguito2/game/objects/anti_values.dart';
import 'package:jueguito2/game/objects/bullet.dart';
import 'package:jueguito2/game/objects/cloud_enemy.dart';
import 'package:jueguito2/game/objects/coin.dart';
import 'package:jueguito2/game/objects/floor.dart';
import 'package:jueguito2/game/objects/hearth_enemy.dart';
import 'package:jueguito2/game/objects/hero.dart';
import 'package:jueguito2/game/objects/platform.dart';
import 'package:jueguito2/game/objects/platform_pieces.dart';
import 'package:jueguito2/game/objects/power_up.dart';
import 'package:jueguito2/game/objects/values.dart';
import 'package:jueguito2/main.dart';

final screenSize = Vector2(428, 926);
final worldSize = Vector2(4.28, 9.26);

final random = Random();

enum GameState {
  running,
  gameOver,
}

class MyGame extends Forge2DGame
    with HasKeyboardHandlerComponents, TapDetector {
  late final MyHero hero;

  // int score = 0;
  ValueNotifier<int> score = ValueNotifier(0);

  // int bullets = 0;
  ValueNotifier<int> bullets = ValueNotifier(0);
  ValueNotifier<double> objects = ValueNotifier(5);
  double generatedWorldHeight = 6.7;

  var state = GameState.running;

  // Object counter
  ValueNotifier<int> coins = ValueNotifier(0);
  ValueNotifier<int> bubbles = ValueNotifier(0);
  ValueNotifier<int> fires = ValueNotifier(0);
  ValueNotifier<int> lightnings = ValueNotifier(0);

  // Scale the screenSize by 100 and set the gravity of 15
  MyGame({required this.character})
      : super(zoom: 100, gravity: Vector2(0, 9.8));

  Character character;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(screenSize);

    final background = await loadParallaxComponent(
      [
        ParallaxImageData(Assets.background1),
        ParallaxImageData(Assets.background2),
        ParallaxImageData(Assets.background3),
        ParallaxImageData(Assets.background5),
        ParallaxImageData(Assets.background4),
        ParallaxImageData(Assets.background6),
      ],
      fill: LayerFill.width,
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(0, -5),
      velocityMultiplierDelta: Vector2(0, 1.2),
    );

    add(background);

    // add(GameUI());

    add(Floor());
    hero = MyHero(character: character);

    overlays.add('GameOverlay');
    // generateNextSectionOfWorld();

    await add(hero);

    final worldBounds =
        Rect.fromLTRB(0, -double.infinity, worldSize.x, worldSize.y);
    camera.followBodyComponent(hero, worldBounds: worldBounds);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state == GameState.running) {
      if (generatedWorldHeight > hero.body.position.y - worldSize.y / 2) {
        generateNextSectionOfWorld();
      }
      final heroY = (hero.body.position.y - worldSize.y) * -1;

      if (score.value < heroY) {
        score.value = heroY.toInt();
      }

      if (score.value - 7 > heroY) {
        hero.hit();
      }

      if ((score.value - worldSize.y) > heroY || hero.state == HeroState.dead) {
        state = GameState.gameOver;
        HighScores.saveNewScore(score.value);
        overlays.add('GameOverMenu');
      }
    }
  }

  bool isOutOfScreen(Vector2 position) {
    final heroY = (hero.body.position.y - worldSize.y) * -1;
    final otherY = (position.y - worldSize.y) * -1;

    return otherY < heroY - worldSize.y / 2;

    // final heroPosY = (hero.body.position.y - worldSize.y).abs();
    // final otherPosY = (position.y - worldSize.y).abs();
    // return otherPosY < heroPosY - worldSize.y / 2;
  }

  void generateNextSectionOfWorld() {
    for (int i = 0; i < 10; i++) {
      if (score.value < 100) {
        add(Platform(
          x: worldSize.x * random.nextDouble(),
          y: generatedWorldHeight,
        ));
        add(Platform(
          x: worldSize.x * random.nextDouble(),
          y: generatedWorldHeight,
        ));
        if (random.nextDouble() < .1) {
          add(AntiValues(
            x: worldSize.x * random.nextDouble(),
            y: generatedWorldHeight - 1.5,
          ));
        } else if (random.nextDouble() < .4) {
          add(Values(
              x: worldSize.x * random.nextDouble(),
              y: generatedWorldHeight - 1.5));
        }
        if (random.nextDouble() < .2) {
          add(PowerUp(
            x: worldSize.x * random.nextDouble(),
            y: generatedWorldHeight - 1.5,
          ));
          if (random.nextDouble() < .2) {
            addCoins();
          }
        }
      } else {
        add(Platform(
          x: worldSize.x * random.nextDouble(),
          y: generatedWorldHeight,
        ));
        if (random.nextDouble() < .2) {
          add(AntiValues(
            x: worldSize.x * random.nextDouble(),
            y: generatedWorldHeight - 1.5,
          ));
        }else if (random.nextDouble() < .4) {
          add(Values(
              x: worldSize.x * random.nextDouble(),
              y: generatedWorldHeight - 1.5));
        }
        if (random.nextDouble() < .3) {
          add(PowerUp(
            x: worldSize.x * random.nextDouble(),
            y: generatedWorldHeight - 1.5,
          ));
          if (random.nextDouble() < .2) {
            addCoins();
          }
        }
      }
      generatedWorldHeight -= 2.7;
    }
  }

  void addBrokenPlatformPieces(Platform platform) {
    final x = platform.body.position.x;
    final y = platform.body.position.y;

    final leftSide = PlatformPieces(
      x: x - (PlatformPieces.size.x / 2),
      y: y,
      isLeftSide: true,
      type: platform.type,
    );

    final rightSide = PlatformPieces(
      x: x + (PlatformPieces.size.x / 2),
      y: y,
      isLeftSide: false,
      type: platform.type,
    );

    add(leftSide);
    add(rightSide);
  }

  void addCoins() {
    final rows = random.nextInt(15) + 1;
    final cols = random.nextInt(5) + 1;

    final x = (worldSize.x - (Coin.size.x * cols)) * random.nextDouble() +
        Coin.size.x / 2;

    add(Coin(
      x: x + (random.nextInt(5) + 1 * Coin.size.x),
      y: generatedWorldHeight + (random.nextInt(15) + 1 * Coin.size.y) - 2,
    ));
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    hero.fireBullet();
  }

  void addBullets() {
    bullets.value -= 3;
    if (bullets.value < 0) bullets.value = 0;
    if (bullets.value == 0) return;
    final x = hero.body.position.x;
    final y = hero.body.position.y;

    add(Bullet(x: x, y: y, accelX: -1.5));
    add(Bullet(x: x, y: y, accelX: 0));
    add(Bullet(x: x, y: y, accelX: 1.5));
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
  }

  void startGame() {
    // initializeGameStart();
    // gameManager.state = GameState.playing;
    // overlays.remove('mainMenuOverlay');
  }
}
