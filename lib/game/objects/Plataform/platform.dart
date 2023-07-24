import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/objects/anti_values_static.dart';

enum PlatformType {
  platform1,
  platform2,
  platform3,
}

extension PlatformTypeExtension on PlatformType {
  Sprite get sprite {
    switch (this) {
      case PlatformType.platform1:
        return Assets.platform1;
      case PlatformType.platform2:
        return Assets.platform2;
      case PlatformType.platform3:
        return Assets.platform3;
    }
  }
}

class Platform2 extends BodyComponent<MyGame> {
  static Vector2 size = Vector2(1.2, .5);
  final Vector2 _position;
  bool destroy = false;

  final PlatformType type;

  double probability = random.nextDouble();

  Platform2({
    required double x,
    required double y,
  })  : _position = Vector2(x, y),
        type = PlatformType.values
            .elementAt(random.nextInt(PlatformType.values.length));

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

    add(
      SpriteComponent(
        sprite: type.sprite,
        size: size,
        anchor: Anchor.center,
      ),
    );
    if (gameRef.score.value <= 50) {
      if (probability < 0.0) {
        gameRef.add(AntiValuesStatic(x: _position.x, y: _position.y - 0.3));
      }
    } else if (gameRef.score.value > 50 || gameRef.score.value <= 90) {
      if (probability < 0.2) {
        gameRef.add(AntiValuesStatic(
          x: _position.x,
          y: _position.y - 0.3,
        ));
      }
    } else if (gameRef.score.value > 90 || gameRef.score.value <= 300) {
      if (probability < 0.3) {
        gameRef.add(AntiValuesStatic(
          x: _position.x,
          y: _position.y - 0.3,
        ));
      }
    } else if (gameRef.score.value > 300 && gameRef.score.value <= 500) {
      if (probability < 0.4) {
        gameRef.add(AntiValuesStatic(
          x: _position.x,
          y: _position.y - 0.3,
        ));
      } else if (gameRef.score.value > 500) {
        if (probability < 0.6) {
          gameRef.add(AntiValuesStatic(
            x: _position.x,
            y: _position.y - 0.3,
          ));
        }
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

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
      type: BodyType.static,
    );

    final shape = PolygonShape()..setAsBoxXY(.58, .23);
    final fixtureDef = FixtureDef(shape);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
