import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Assets {
  static late final Sprite button;
  static late final Sprite buttonPause;

  static late final String background;
  static late final String background1;
  static late final String background2;
  static late final String background3;
  static late final String background4;
  static late final String background5;
  static late final String background6;

  static late final Sprite heroFall;
  static late final Sprite heroJump;

  static late final Sprite cloudHappyEnemy;
  static late final Sprite cloudAngryEnemy;
  static late final SpriteAnimation hearthEnemy;
  static late final SpriteAnimation jetpackFire;
  static late final SpriteAnimation lightning;

  static late final Sprite coin;
  static late final Sprite gun;
  static late final Sprite bullet;
  static late final Sprite spring;
  static late final Sprite bubbleSmall;
  static late final Sprite jetpackSmall;
  static late final Sprite bubble;
  static late final Sprite jetpack;
  static late final SpriteAnimation frozenComponent;
  static late final SpriteAnimation burstComponent;

  static late final Sprite platformBeige;
  static late final Sprite platformBeigeLight;
  static late final Sprite platformBeigeBroken;
  static late final Sprite platformBeigeLeft;
  static late final Sprite platformBeigeRight;
  static late final Sprite platformBlue;
  static late final Sprite platformBlueLight;
  static late final Sprite platformBlueBroken;
  static late final Sprite platformBlueLeft;
  static late final Sprite platformBlueRight;
  static late final Sprite platformGray;
  static late final Sprite platformGrayLight;
  static late final Sprite platformGrayBroken;
  static late final Sprite platformGrayLeft;
  static late final Sprite platformGrayRight;
  static late final Sprite platformGreen;
  static late final Sprite platformGreenLight;
  static late final Sprite platformGreenBroken;
  static late final Sprite platformGreenLeft;
  static late final Sprite platformGreenRight;
  static late final Sprite platformMulticolor;
  static late final Sprite platformMulticolorLight;
  static late final Sprite platformMulticolorBroken;
  static late final Sprite platformMulticolorLeft;
  static late final Sprite platformMulticolorRight;
  static late final Sprite platformPink;
  static late final Sprite platformPinkLight;
  static late final Sprite platformPinkBroken;
  static late final Sprite platformPinkLeft;
  static late final Sprite platformPinkRight;

  static late final Sprite platform1;
  static late final Sprite platform2;
  static late final Sprite platform3;

  static late final SpriteAnimation loveA;
  static late final Sprite love;
  static late final Sprite empathy;
  static late final Sprite solidarity;
  static late final Sprite respect;
  static late final Sprite equality;

  static late final Sprite hate;
  static late final Sprite envy;
  static late final Sprite indifference;
  static late final Sprite violence;
  static late final Sprite injustice;

  static late final Sprite hateStatic;
  static late final Sprite injusticeStatic;

  static late final Sprite rocket1;
  static late final Sprite rocket2;
  static late final Sprite rocket3;
  static late final Sprite rocket4;

  static Future<void> load() async {
    button = await _loadSprite('ui/button.png');
    buttonPause = await _loadSprite('ui/buttonPause.png');

    //background
    background = 'background/background.png';
    background1 = 'background/06_Background_Solid.png';
    background2 = 'background/05_Background_Small_Stars.png';
    background3 = 'background/04_Background_Big_Stars.png';
    background4 = 'background/03_Background_Block_Shapes.png';
    background5 = 'background/02_Background_Orbs.png';
    background6 = 'background/01_Background_Squiggles.png';

    heroFall = await _loadSprite('dashJump.png');
    heroJump = await _loadSprite('dashFall.png');

    cloudHappyEnemy = await _loadSprite('HappyCloud.png');
    cloudAngryEnemy = await _loadSprite('AngryCloud.png');
    final enemy1 = await _loadSprite('HearthEnemy1.png');
    final enemy2 = await _loadSprite('HearthEnemy2.png');
    final lightning1 = await _loadItem('Lightning1');
    final lightning2 = await _loadItem('Lightning2');

    hearthEnemy = SpriteAnimation.spriteList([
      enemy1,
      enemy2,
    ], stepTime: 0.2, loop: true);

    lightning = SpriteAnimation.spriteList([
      lightning1,
      lightning2,
    ], stepTime: 0.15, loop: true);

    final love2 = await _loadItem('Love2');
    final love3 = await _loadItem('Love3');
    final love7 = await _loadItem('Love7');
    final love8 = await _loadItem('Love8');
    final love9 = await _loadItem('Love9');

    loveA = SpriteAnimation.spriteList([love2, love3, love7, love8, love9],
        stepTime: 0.35, loop: true);
    //values

    final frozen1 = await _loadItem('Frozen1');
    final frozen2 = await _loadItem('Frozen2');
    final frozen3 = await _loadItem('Frozen3');
    final frozen4 = await _loadItem('Frozen4');
    final frozen5 = await _loadItem('Frozen5');
    final frozen6 = await _loadItem('Frozen6');
    final frozen7 = await _loadItem('Frozen7');
    final frozen8 = await _loadItem('Frozen7');

    //FrozenAnimation
    frozenComponent = SpriteAnimation.spriteList([frozen1, frozen2, frozen3, frozen4, frozen5, frozen6,frozen7, frozen8],
      stepTime: 0.375
    );

    final burst1 = await _loadItem('Burst1');
    final burst2 = await _loadItem('Burst2');
    final burst3 = await _loadItem('Burst3');
    final burst4 = await _loadItem('Burst4');

    burstComponent = SpriteAnimation.spriteList([burst1, burst2,burst3,burst4],stepTime: 0.75);

    love = await _loadSprite('items/love.png');
    empathy = await _loadSprite('items/empathy.png');
    solidarity = await _loadSprite('items/solidarity.png');
    respect = await _loadSprite('items/respect.png');
    equality = await _loadSprite('items/equality.png');

    //anti-values
    hate = await _loadSprite('items/hate.png');
    envy = await _loadSprite('items/envy.png');
    indifference = await _loadSprite('items/indifference.png');
    violence = await _loadSprite('items/violence.png');
    injustice = await _loadSprite('items/injustice.png');

    //anti-values-static
    hateStatic = await _loadSprite('items/hate1.png');
    injusticeStatic = await _loadSprite('items/injustice1.png');

    coin = await _loadItem('Coin');
    gun = await _loadItem('Pistol');
    bullet = await _loadItem('Heart');
    spring = await _loadItem('Spring');
    bubbleSmall = await _loadItem('Bubble_Small');
    jetpackSmall = await _loadItem('Jetpack_Small');
    bubble = await _loadItem('Bubble_Big');
    jetpack = await _loadItem('Jetpack_Big');

    final jetpack1 = await _loadItem('JetFire1');
    final jetpack2 = await _loadItem('JetFire2');

    jetpackFire = SpriteAnimation.spriteList([
      jetpack1,
      jetpack2,
    ], stepTime: 0.15, loop: true);

    final rocket1 = await _loadItem('rocket_1');
    final rocket2 = await _loadItem('rocket_2');
    final rocket3 = await _loadItem('rocket_3');
    final rocket4 = await _loadItem('rocket_4');

    platform1 = await _loadPlatform('platform1');
    platform2 = await _loadPlatform('platform2');
    platform3 = await _loadPlatform('platform3');

    platformBeige = await _loadPlatform('LandPiece_DarkBeige');
    platformBeigeLight = await _loadPlatform('LandPiece_LightBeige');
    platformBeigeBroken = await _loadPlatform('BrokenLandPiece_Beige');
    platformBeigeLeft = await _loadPlatform('HalfLandPiece_Left_Beige');
    platformBeigeRight = await _loadPlatform('HalfLandPiece_Right_Beige');

    platformBlue = await _loadPlatform('LandPiece_DarkBlue');
    platformBlueLight = await _loadPlatform('LandPiece_LightBlue');
    platformBlueBroken = await _loadPlatform('BrokenLandPiece_Blue');
    platformBlueLeft = await _loadPlatform('HalfLandPiece_Left_Blue');
    platformBlueRight = await _loadPlatform('HalfLandPiece_Right_Blue');

    platformGray = await _loadPlatform('LandPiece_DarkGray');
    platformGrayLight = await _loadPlatform('LandPiece_LightGray');
    platformGrayBroken = await _loadPlatform('BrokenLandPiece_Gray');
    platformGrayLeft = await _loadPlatform('HalfLandPiece_Left_Gray');
    platformGrayRight = await _loadPlatform('HalfLandPiece_Right_Gray');

    platformGreen = await _loadPlatform('LandPiece_DarkGreen');
    platformGreenLight = await _loadPlatform('LandPiece_LightGreen');
    platformGreenBroken = await _loadPlatform('BrokenLandPiece_Green');
    platformGreenLeft = await _loadPlatform('HalfLandPiece_Left_Green');
    platformGreenRight = await _loadPlatform('HalfLandPiece_Right_Green');

    platformMulticolor = await _loadPlatform('LandPiece_DarkMulticolored');
    platformMulticolorLight =
        await _loadPlatform('LandPiece_LightMulticolored');
    platformMulticolorBroken =
        await _loadPlatform('BrokenLandPiece_Multicolored');
    platformMulticolorLeft =
        await _loadPlatform('HalfLandPiece_Left_Multicolored');
    platformMulticolorRight =
        await _loadPlatform('HalfLandPiece_Right_Multicolored');

    platformPink = await _loadPlatform('LandPiece_DarkPink');
    platformPinkLight = await _loadPlatform('LandPiece_LightPink');
    platformPinkBroken = await _loadPlatform('BrokenLandPiece_Pink');
    platformPinkLeft = await _loadPlatform('HalfLandPiece_Left_Pink');
    platformPinkRight = await _loadPlatform('HalfLandPiece_Right_Pink');
  }

  static Future<Sprite> _loadPlatform(String name) {
    return _loadSprite('platforms/$name.png');
  }

  static Future<Sprite> _loadItemSVG(String name) async {
    return _loadSprite('items/$name.svg');
  }

  static Future<Sprite> _loadItem(String name) {
    return _loadSprite('items/$name.png');
  }

  static Future<Sprite> _loadSprite(String name) async {
    return Sprite(await Flame.images.load(name));
  }
}
