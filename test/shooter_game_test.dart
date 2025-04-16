import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/inimigos.dart';
import 'package:myapp/shooter_game.dart';
import 'package:flame_test/flame_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ShooterGame Tests', () {
    testWithGame<ShooterGame>('Game initializes correctly', () => ShooterGame(), (game) async {
      expect(game.score, 0);
      expect(game.lives, 3);
    });

    testWithGame<ShooterGame>(
        'Score increases when enemy is destroyed',
        () => ShooterGame(),
        (game) async {
          game.score = 0; // Ensure initial score is 0.
          final enemy = Enemy(); // Create a dummy enemy.
          await game.add(enemy);
          enemy.destroy(); // Simulate enemy destruction.
          expect(game.score, 10);
        });

    testWithGame<ShooterGame>(
        'Lives decrease when player is hit',
        () => ShooterGame(),
        (game) async {
          game.lives = 3; // Ensure initial lives is 3.
          await game.add(game.player); // Add the player to the game.
          game.player.playerHit(); // Simulate player being hit.
          expect(game.lives, 2);
        });

    testWithGame<ShooterGame>('Game resets when lives reach zero', () => ShooterGame(),
        (game) async {
      game.score = 100; // Set a non-zero initial score
      game.lives = 1; // Set lives to 1 to trigger game over on next hit
      await game.ensureAdd(game.player); // Ensure player is added
   //  print('Score before playerHit: ${game.score}');
      game.player.playerHit(); // Simulate player losing the last life
     // print('Score after playerHit: ${game.score}');
      expect(game.score, 0); // Expect score to be reset to 0
      expect(game.lives, 3); // Expect lives to be reset to 3
    }); // There should be more than 0 Inimigo after reset
  });
}