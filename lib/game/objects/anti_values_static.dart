import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/my_game.dart';

enum AntiValuesTypeStatic { hate, injustice }

extension AntiValuesStaticTypeExtension on AntiValuesTypeStatic {
  Sprite get sprite {
    switch (this) {
      case AntiValuesTypeStatic.hate:
        return Assets.hateStatic;
      case AntiValuesTypeStatic.injustice:
        return Assets.injusticeStatic;
    }
  }
}

class AntiValuesStatic extends BodyComponent<MyGame> {
  static Vector2 size = Vector2(.6, .6);

  Vector2 _position;
  bool destroy = false;
  final AntiValuesTypeStatic type;

  final speed = 1.0 + (2.0 * random.nextDouble());

  AntiValuesStatic({
    required double x,
    required double y,
  })  : _position = Vector2(x, y),
        type = AntiValuesTypeStatic.values
            .elementAt(random.nextInt(AntiValuesTypeStatic.values.length));

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

    if (_position.x > worldSize.x) {
      body.linearVelocity = Vector2(-speed, 0);
    } else if (_position.x < 0) {
      body.linearVelocity = Vector2(speed, 0);
    }

    bool isOutOfScreen = gameRef.isOutOfScreen(body.position);

    if (destroy || isOutOfScreen) {
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

    final shape = PolygonShape()..setAsBoxXY(.3, .2);
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..linearVelocity = Vector2(0, 0);
  }
}
