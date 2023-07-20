import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/high_scores.dart';
import 'package:jueguito2/game/objects/Plataform/platform.dart';
import 'package:jueguito2/game/objects/Values/love.dart';
import 'package:jueguito2/game/objects/anti_values.dart';
import 'package:jueguito2/game/objects/anti_values_static.dart';
import 'package:jueguito2/game/objects/bullet.dart';
import 'package:jueguito2/game/objects/coin.dart';
import 'package:jueguito2/game/objects/floor.dart';
import 'package:jueguito2/game/objects/hero.dart';
import 'package:jueguito2/game/objects/platform.dart';
import 'package:jueguito2/game/objects/platform_pieces.dart';
import 'package:jueguito2/game/objects/values.dart';
import 'package:jueguito2/login/kid/provider/firestore_kid.dart';
import 'package:jueguito2/main.dart';

import '../login/kid/view/list_kids.dart';

final screenSize = Vector2(428, 926);
final worldSize = Vector2(4.28, 9.26);

final random = Random();

enum GameState { running, gameOver, winner }

enum ValuesType { empathy, solidarity, respect, equality, love }

enum AntiValuesType { hate, envy, indifference, violence, injustice }

class MyGame extends Forge2DGame
    with HasKeyboardHandlerComponents, TapDetector {
  late final MyHero hero;

  late final background;
  // late final background2;

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

  ValueNotifier<Map<ValuesType, int>> valuesNotifier = ValueNotifier({
    ValuesType.love: 0,
    ValuesType.empathy: 0,
    ValuesType.solidarity: 0,
    ValuesType.respect: 0,
    ValuesType.equality: 0,
  });

  ValueNotifier<Map<AntiValuesType, int>> antiValuesNotifier = ValueNotifier({
    AntiValuesType.hate: 0,
    AntiValuesType.envy: 0,
    AntiValuesType.indifference: 0,
    AntiValuesType.violence: 0,
    AntiValuesType.injustice: 0,
  });

  // Scale the screenSize by 100 and set the gravity of 15
  MyGame({required this.character})
      : super(zoom: 100, gravity: Vector2(0, 9.8));

  Character character;

  // Hero is mega
  bool mega = false;

  double velocity = -7;

  void updateValue(ValuesType type) {
    final Map<ValuesType, int> currentValues = Map.from(valuesNotifier.value);
    currentValues[type] = (currentValues[type] ?? 0) + 1;
    valuesNotifier.value = currentValues;
  }

  void updateAntiValue(AntiValuesType type) {
    final Map<AntiValuesType, int> currentAntiValues =
        Map.from(antiValuesNotifier.value);
    currentAntiValues[type] = (currentAntiValues[type] ?? 0) + 1;
    antiValuesNotifier.value = currentAntiValues;
  }

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(screenSize);

    background = await loadParallaxComponent(
      [
        ParallaxImageData(Assets.background)
      ],
      fill: LayerFill.width,
      baseVelocity: Vector2(0, velocity),
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
    // if (score.value > 40) {
    //   background = background2;
    // }
    if (state == GameState.running) {
      final heroY = (hero.body.position.y - worldSize.y) * -1;
      if (!mega) {
        if (generatedWorldHeight > hero.body.position.y - worldSize.y / 2) {
          generateNextSectionOfWorld();
        }
        if (score.value < heroY) {
          score.value = heroY.toInt();
        }
      }

      if (score.value - 7 > heroY) {
        hero.hit();
      }

      if ((score.value - worldSize.y) > heroY || hero.state == HeroState.dead) {
        state = GameState.gameOver;
        //funcion de envio de contador de valores
        if (saveValues == true) {
          updateKidValores(indexKid!, valuesNotifier.value,
              antiValuesNotifier.value, score.value);
        }

        HighScores.saveNewScore(score.value);
        overlays.add('GameOverMenu');
      }
      if (mega) {
        //overlays.add('WinnerOverlay');
        overlays.remove('GameOverlay');
        hero.onRemove();
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
        if (random.nextDouble() < .5) {
          add(AntiValues(
            x: worldSize.x * random.nextDouble(),
            y: generatedWorldHeight - 1.5,
          ));
        } else if (random.nextDouble() < .6) {
          add(Values(
              x: worldSize.x * random.nextDouble(),
              y: generatedWorldHeight - 1.5));
        }
      } else if (score.value >= 100 && score.value < 200) {
        add(Platform(
          x: worldSize.x * random.nextDouble(),
          y: generatedWorldHeight,
        ));
        if (random.nextDouble() < .5) {
          add(AntiValues(
            x: worldSize.x * random.nextDouble(),
            y: generatedWorldHeight - 1.5,
          ));
        } else if (random.nextDouble() < .6) {
          add(Values(
              x: worldSize.x * random.nextDouble(),
              y: generatedWorldHeight - 1.5));
        }
      } else if (score.value >= 100 && score.value < 300) {
        add(Platform2(
          x: worldSize.x * random.nextDouble(),
          y: generatedWorldHeight,
        ));
        if (random.nextDouble() < .5) {
          add(AntiValues(
            x: worldSize.x * random.nextDouble(),
            y: generatedWorldHeight - 1.5,
          ));
        } else if (random.nextDouble() < .6) {
          add(Values(
              x: worldSize.x * random.nextDouble(),
              y: generatedWorldHeight - 1.5));
        }
      } else {
        add(Platform2(
          x: worldSize.x * random.nextDouble(),
          y: generatedWorldHeight,
        ));
        if (random.nextDouble() < .2) {
          add(AntiValues(
            x: worldSize.x * random.nextDouble(),
            y: generatedWorldHeight - 1.5,
          ));
        } else if (random.nextDouble() < .4) {
          add(Values(
              x: worldSize.x * random.nextDouble(),
              y: generatedWorldHeight - 1.5));
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
