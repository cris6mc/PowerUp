import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/utils.dart';

final textPaint = TextPaint(
  style: const TextStyle(
    color: Colors.white,
    fontSize: 35,
    fontWeight: FontWeight.w800,
    fontFamily: 'DaveysDoodleface',
  ),
);

class GameUI extends PositionComponent with HasGameRef<MyGame> {
  // Keep track of the number of bodies in the world.
  final totalBodies =
      TextComponent(position: Vector2(5, 895), textRenderer: textPaint);

  final totalObjects = TextComponent(textRenderer: textPaint);

  final totalScore = TextComponent(textRenderer: textPaint);

  final totalCoins = TextComponent(textRenderer: textPaint);

  final totalBullets = TextComponent(textRenderer: textPaint);

  final coin = SpriteComponent(sprite: Assets.coin, size: Vector2.all(25));
  final gun = SpriteComponent(sprite: Assets.gun, size: Vector2.all(35));

  // Keep track of the frames per second
  final fps =
      FpsTextComponent(position: Vector2(5, 870), textRenderer: textPaint);

  late final JoystickComponent joystick;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    positionType = PositionType.viewport;
    position.y = isIOS ? 25 : 0;
    priority = 3;

    final btPause = SpriteButtonComponent(
        button: Assets.buttonPause,
        size: Vector2(50, 50),
        position: Vector2(390, 40),
        onPressed: () {
          findGame()?.overlays.add('PauseMenu');
          findGame()?.paused = true;
        })
      ..positionType = PositionType.viewport;

    add(btPause);
    add(coin);
    add(gun);
    add(fps);
    add(totalBodies);
    add(totalScore);
    add(totalCoins);
    add(totalBullets);
    add(totalObjects);
  }

  @override
  void update(double dt) {
    super.update(dt);

    totalBodies.text = 'Bodies: ${gameRef.world.bodies.length}';
    totalScore.text = 'Score ${gameRef.score.value}';
    totalCoins.text = 'x${gameRef.coins}';
    totalBullets.text = 'x${gameRef.bullets}';
    totalObjects.text = 'xa${gameRef.objects}';

    final posX = screenSize.x - totalCoins.size.x;
    totalCoins.position
      ..x = posX - 5
      ..y = 5;

    totalObjects.position
      ..x = 5
      ..y = 70;

    coin.position
      ..x = posX - 35
      ..y = 12;

    gun.position
      ..x = 5
      ..y = 12;
    totalBullets.position
      ..x = 40
      ..y = 8;

    totalScore.position
      ..x = screenSize.x / 2 - totalScore.size.x / 2
      ..y = 5;
  }
}
