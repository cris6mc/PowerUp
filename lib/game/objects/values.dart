import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/my_game.dart';

enum ValuesType { love, empathy, solidarity, respect, equality }

extension ValuesTypeExtension on ValuesType {
  Sprite get sprite {
    switch (this) {
      case ValuesType.love:
        return Assets.love;
      case ValuesType.empathy:
        return Assets.empathy;
      case ValuesType.solidarity:
        return Assets.solidarity;
      case ValuesType.respect:
        return Assets.respect;
      case ValuesType.equality:
        return Assets.equality;
    }
  }
}

class Values extends BodyComponent<MyGame> {
  static Vector2 size = Vector2(.6, .6);

  Vector2 _position;
  bool destroy = false;
  final ValuesType type;

  Values({
    required double x,
    required double y,
  }) : _position = Vector2(x, y),
        type = ValuesType.values
            .elementAt(random.nextInt(ValuesType.values.length));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;

    add(
      SpriteComponent(
        sprite: type.sprite,
        size: size,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    _position = body.position;

    bool isOutOfScreen = gameRef.isOutOfScreen(body.position);

    if (isOutOfScreen) {
      world.destroyBody(body);
      gameRef.remove(this);
    }
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: _position,
      type: BodyType.kinematic,
    );

    final shape = PolygonShape()..setAsBoxXY(.14, .5);
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..linearVelocity = Vector2(0, 1.5);
  }
}
