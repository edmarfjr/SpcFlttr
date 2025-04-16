import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:myapp/fx.dart';
import 'package:myapp/projeteis.dart';
import 'package:myapp/shooter_game.dart';

class Enemy extends SpriteComponent
    with HasGameRef<ShooterGame>, CollisionCallbacks {
  Enemy({
    super.position,
  }) : super(
          size: Vector2.all(enemySize),
          anchor: Anchor.center,
        );

  static const enemySize = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('mete.png');
    /*  animation = await game.loadSpriteAnimation(
      'mete.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(14),
      ),
    );
    */
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 250;

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  void destroy() {
    removeFromParent();
    game.add(Explosion(position: position));
    game.score += 10;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet) {
      destroy();
      other.removeFromParent();
    }
  }
}
