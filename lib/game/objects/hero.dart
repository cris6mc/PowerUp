import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/objects/Plataform/platform.dart';
import 'package:jueguito2/game/objects/anti_values.dart';
import 'package:jueguito2/game/objects/coin.dart';
import 'package:jueguito2/game/objects/floor.dart';
import 'package:jueguito2/game/objects/hearth_enemy.dart';
import 'package:jueguito2/game/objects/jetpack_group.dart';
import 'package:jueguito2/game/objects/lightning.dart';
import 'package:jueguito2/game/objects/platform.dart';
import 'package:jueguito2/game/objects/power_up.dart';
import 'package:jueguito2/game/objects/values.dart';
import 'package:jueguito2/game/utils.dart';
import 'package:jueguito2/main.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'values.dart';

enum HeroState {
  jump,
  fall,
  dead,
  left,
  right,
  center,
  rocket,
}
enum State { jump, fall }


const _durationJetpack = 3.0;

class MyHero extends BodyComponent<MyGame>
    with ContactCallbacks, KeyboardHandler {
  MyHero({
    required this.character,
  });

  static final size = Vector2(.75, .80);

  var state = HeroState.center;

  var stateHero = State.fall;

  late final SpriteComponent fallComponent;
  late final SpriteComponent jumpComponent;
  late final SpriteComponent rightComponent;
  late final SpriteComponent leftComponent;
  late final SpriteComponent centerComponent;
  late final SpriteComponent rocketComponent;

  final jetpackComponent = JetpackGroup();
  final bubbleShieldComponent = SpriteComponent(
    sprite: Assets.bubble,
    size: Vector2(1, 1),
    anchor: Anchor.center,
    priority: 2,
  );

  late Component currentComponent;

  double accelerationX = 0;

  bool hasJetpack = false;
  bool hasBubbleShield = false;

  double durationJetpack = 0;

  StreamSubscription? accelerometerSubscription;

  int _hAxisInput = 0;
  final int movingLeftInput = -1;
  final int movingRightInput = 1;

  Character character;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;

    if (isMobile || isWeb) {
      accelerometerSubscription = accelerometerEvents.listen((event) {
        accelerationX = (event.x * -1).clamp(-1, 1);
      });
    }

    fallComponent = SpriteComponent(
      sprite: Sprite(await Flame.images.load('${character.name}_center.png')),
      size: size,
      anchor: Anchor.center,
    );

    jumpComponent = SpriteComponent(
      sprite:
          Sprite(await Flame.images.load('game/${character.name}_center.png')),
      size: size,
      anchor: Anchor.center,
    );

    rightComponent = SpriteComponent(
      sprite:
          Sprite(await Flame.images.load('game/${character.name}_right.png')),
      size: size,
      anchor: Anchor.center,
    );

    leftComponent = SpriteComponent(
      sprite:
          Sprite(await Flame.images.load('game/${character.name}_left.png')),
      size: size,
      anchor: Anchor.center,
    );
    centerComponent = SpriteComponent(
      sprite:
          Sprite(await Flame.images.load('game/${character.name}_center.png')),
      size: size,
      anchor: Anchor.center,
    );
    rocketComponent = SpriteComponent(
      sprite: Sprite(await Flame.images.load('game/rocket_4.png')),
      size: size,
      anchor: Anchor.center,
    );

    currentComponent = centerComponent;
    add(currentComponent);
  }

  void jump() {
    if (stateHero == State.jump || state == HeroState.dead) return;
    final velocity = body.linearVelocity;
    body.linearVelocity = Vector2(velocity.x, -7.5);

    //state = HeroState.jump;
    stateHero = State.jump;
  }

  void hit() {
    if (hasJetpack) return;
    if (state == HeroState.dead) return;

    if (hasBubbleShield) {
      hasBubbleShield = false;
      remove(bubbleShieldComponent);
      return;
    }
    if (gameRef.objects.value <= 0) {
      state = HeroState.dead;
      body.applyAngularImpulse(2);
      return;
    }
    gameRef.objects.value--;

    //state = HeroState.dead;
    //body.setFixedRotation(false);
    //body.applyAngularImpulse(2);
  }

  void takeJetpack() {
    if (state == HeroState.dead) return;
    hasJetpack = true;
    gameRef.lightnings.value++;
  }

  void takeBubbleShield() {
    if (state == HeroState.dead) return;
    if (!hasBubbleShield) add(bubbleShieldComponent);
    hasBubbleShield = true;
    gameRef.bubbles.value++;
  }

  //acumular coins
  void takeCoin() {
    if (state == HeroState.dead) return;
    gameRef.coins.value++;
    final velocity = body.linearVelocity;
    body.linearVelocity = Vector2(velocity.x, -8.5);
  }

  // atacar
  void takeBullet() {
    if (state == HeroState.dead) return;
    gameRef.bullets.value += 4;
  }

  void fireBullet() {
    if (state == HeroState.dead) return;
    gameRef.addBullets();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final velocity = body.linearVelocity;
    final position = body.position;

    if (velocity.y > 0.1 && state != HeroState.dead) {
      stateHero = State.fall;
    }

    if (hasJetpack) {
      durationJetpack += dt;
      if (durationJetpack >= _durationJetpack) {
        hasJetpack = false;
        state = HeroState.center;
        //remove(jetpackComponent);
      }
      velocity.y = -7.5;
    }

    velocity.x = accelerationX * 5;
    body.linearVelocity = velocity;

    if (position.x > worldSize.x) {
      position.x = 0;
      body.setTransform(position, 0);
    } else if (position.x < 0) {
      position.x = worldSize.x;
      body.setTransform(position, 0);
    }

    if (state == HeroState.jump) {
      _setComponent(jumpComponent);
    } else if (state == HeroState.fall) {
      _setComponent(fallComponent);
    } else if (state == HeroState.dead) {
      _setComponent(fallComponent);
    } else if (state == HeroState.center) {
      _setComponent(centerComponent);
    } else if (state == HeroState.right) {
      _setComponent(rightComponent);
    } else if (state == HeroState.left) {
      _setComponent(leftComponent);
    } else if (state == HeroState.rocket) {
      _setComponent(rocketComponent);
    }
  }

  void _setComponent(PositionComponent component) {
    if (accelerationX > 0) {
      if (!component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    } else {
      if (component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    }

    if (component == currentComponent) return;
    remove(currentComponent);
    currentComponent = component;
    add(component);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(worldSize.x / 2, worldSize.y - 1),
      type: BodyType.dynamic,
    );

    final shape = PolygonShape()..setAsBoxXY(.27, .30);

    final fixtureDef = FixtureDef(shape)
      ..density = 10
      ..friction = 0
      ..restitution = 0;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setFixedRotation(true);
  }

  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    if (other is Platform) {
      final heroY = body.position.y - size.y / 2;
      final platformY = other.body.position.y + Platform.size.y / 2;

      if (heroY < platformY) {
        contact.setEnabled(false);
      }
    }
    if (other is Platform2) {
      final heroY = body.position.y - size.y / 2;
      final platformY = other.body.position.y + Platform.size.y / 2;

      if (heroY < platformY) {
        contact.setEnabled(false);
      }
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is HearthEnemy) {
      other.destroy = true;
      {
        /*
        if (hasBubbleShield) {
        other.destroy = true
        }
        */
      }
      hit();
    }
    if (other is AntiValues) {
      other.destroy = true;
      hit();
    }

    if (other is Values) {
      other.destroy = true;
      final ValuesType type = other.type;
      gameRef.updateValue(type);

    }

    if (other is Lightning) {
      hit();
    }
    if (other is Floor) jump();

    if (other is PowerUp) {
      if (other.type == PowerUpType.jetpack) {
        state = HeroState.rocket;
        takeJetpack();
      }
      if (other.type == PowerUpType.bubble) {
        takeBubbleShield();
      }
      if (other.type == PowerUpType.gun) {
        takeBullet();
      }
      other.take();
    }

    if (other is Coin) {
      if (!other.isTaken) {
        takeCoin();
        other.take();
      }
    }

    if (other is Platform) {
      if (stateHero == State.fall && other.type.isBroken) {
        other.destroy = true;
      }
      jump();
    }

    if (other is Platform2) {
      jump();
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      accelerationX = 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      accelerationX = -1;
    } else {
      accelerationX = 0;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyR)) {
      fireBullet();
    }

    return false;
  }

  void moveLeft() {
    if (state != HeroState.rocket) state = HeroState.left;

    accelerationX = -1;
  }

  void moveRight() {
    if (state != HeroState.rocket) state = HeroState.right;
    accelerationX = 1;
  }

  void resetDirection() {
    accelerationX = 0;
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}
