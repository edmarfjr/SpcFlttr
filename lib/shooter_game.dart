import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:myapp/inimigos.dart';
import 'package:myapp/player.dart';

class ShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  int score = 0;
  late Player player;
  int lives = 3;
  bool isGameOver = false;
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );
    add(parallax);

    player = Player();

    resetGame();

    add(
      SpawnComponent(
        factory: (index) {
          return Enemy();
        },
        period: 1,
        area: Rectangle.fromLTWH(0, 0, size.x, -Enemy.enemySize),
      ),
    );
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
    // Calcula o ângulo do vetor de movimento
    final delta = info.delta.global;
    player.targetAngle = -delta.angleToSigned(Vector2(0, -1));
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) return;

    score += 1 * dt.toInt();
    if (isGameOver) {
      resetGame();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 24,
        color: Colors.white,
      ),
    );
    textPaint.render(canvas, 'Score: $score', Vector2(10, 10));
    textPaint.render(canvas, 'Lives: $lives', Vector2(size.x - 100, 10));
    if (isGameOver) {
      textPaint.render(
        canvas,
        'Game Over! Tap to restart.',
        Vector2(size.x / 2 - 150, size.y / 2),
      );
    }
  }

  void resetGame() {
    score = 0;
    lives = 3;
    isGameOver = false;
    player.position = size / 2;
    children.whereType<Enemy>().forEach(remove);
    children.whereType<PositionComponent>().forEach(remove);

    add(player);
    resumeEngine();
  }
}
