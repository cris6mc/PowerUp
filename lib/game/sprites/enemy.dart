import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/doodle_dash.dart';
import 'package:jueguito2/game/my_game.dart';

class Enemy<T> extends SpriteGroupComponent<T> with HasGameRef<DoodleDash>, CollisionCallbacks {
  final hitbox = RectangleHitbox();
  bool isMoving = false;

  double direction = 1;
  final Vector2 _velocity = Vector2.zero();
  double speed = 35;

  Enemy({
    super.position,
  }) : super(
    size: Vector2.all(100),
    priority: 2,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(hitbox);

    final int rand = Random().nextInt(100);
    if (rand > 80) isMoving = true;
  }
  void _move(double dt) {
    if (!isMoving) return;

    final double gameWidth = gameRef.size.x;

    if (position.x <= 0) {
      direction = 1;
    } else if (position.x >= gameWidth - size.x) {
      direction = -1;
    }

    _velocity.x = direction * speed;

    position += _velocity * dt;
  }

  @override
  void update(double dt) {
    _move(dt);
    super.update(dt);
  }
}

enum LightEnemyState {
  only
}
class LightEnemy extends Enemy<LightEnemyState>{
  LightEnemy({super.position});
  final Map<String, Vector2> spriteOptions = {
    'Lightning1': Vector2(28, 102),
    'JetFire1': Vector2(36, 58),
  };

  @override
  Future<void> onLoad() async {
    var randSpriteIndex = Random().nextInt(spriteOptions.length);
    String randSprite = spriteOptions.keys.elementAt(randSpriteIndex);

    sprites = {
      LightEnemyState.only: await gameRef.loadSprite('items/$randSprite.png')
    };

    current = LightEnemyState.only;

    size = spriteOptions[randSprite]!;
    await super.onLoad();
  }
}