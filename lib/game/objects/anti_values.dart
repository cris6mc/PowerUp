import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/my_game.dart';

enum AntiValuesType { hate, envy, indifference, violence, injustice }


extension AntiValuesTypeExtension on AntiValuesType {
  Sprite get sprite {
    switch (this) {
      case AntiValuesType.hate:
        return Assets.hate;
      case AntiValuesType.envy:
        return Assets.envy;
      case AntiValuesType.indifference:
        return Assets.indifference;
      case AntiValuesType.violence:
        return Assets.violence;
      case AntiValuesType.injustice:
        return Assets.injustice;
    }
  }
}

class AntiValues extends BodyComponent<MyGame> {
  static Vector2 size = Vector2(.6, .6);

  Vector2 _position;
  bool destroy = false;
  final AntiValuesType type;

  AntiValues({
    required double x,
    required double y,
  })  : _position = Vector2(x, y),
        type = AntiValuesType.values
            .elementAt(random.nextInt(AntiValuesType.values.length));

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

    final shape = PolygonShape()..setAsBoxXY(.14, .5);
    final fixtureDef = FixtureDef(shape)..isSensor = true;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..linearVelocity = Vector2(0, 1.5);
  }
}
