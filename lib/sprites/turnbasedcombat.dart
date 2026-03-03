import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../sprites/revolver_animator.dart';
import '../sprites/enemigotest.dart';

enum CombatAction { attack, block }

class TurnCombatScreen extends StatefulWidget {
  const TurnCombatScreen({super.key});

  @override
  State<TurnCombatScreen> createState() => _TurnCombatScreenState();
}

class _TurnCombatScreenState extends State<TurnCombatScreen> {
  int revolverHP = 3;
  int enemyHP = 3;

  CombatAction? revolverAction;
  CombatAction? enemyAction;

  bool turnLocked = false;
  String statusText = '';

  final Random _rng = Random();

  // FULL RESET
  void resetGame() {
    setState(() {
      revolverHP = 3;
      enemyHP = 3;
      revolverAction = null;
      enemyAction = null;
      statusText = '';
      turnLocked = false;
    });
  }

  // Player selects action
  void revolverSelect(CombatAction action) {
    if (turnLocked || statusText.isNotEmpty) return;

    setState(() {
      turnLocked = true;
      revolverAction = action;
      enemyAction =
          _rng.nextBool() ? CombatAction.attack : CombatAction.block;
    });

    // small delay → feels turn-based
    Future.delayed(const Duration(milliseconds: 400), resolveTurn);
  }

  // Resolve combat
  void resolveTurn() {
    setState(() {
      if (revolverAction == CombatAction.attack &&
          enemyAction == CombatAction.attack) {
        revolverHP--;
        enemyHP--;
      } else if (revolverAction == CombatAction.attack &&
          enemyAction == CombatAction.block) {
        enemyHP--;
      } else if (revolverAction == CombatAction.block &&
          enemyAction == CombatAction.attack) {
        // revolver blocks → no damage
      }
    });

    checkStates();
  }

  // Check win / lose
  void checkStates() {
    if (revolverHP <= 0) {
      setState(() {
        statusText = 'YOU LOSE';
      });

      Future.delayed(const Duration(seconds: 2), resetGame);
      return;
    }

    if (enemyHP <= 0) {
      setState(() {
        revolverHP += 1;
        enemyHP += 2;
        statusText = '';
      });
    }

    // unlock next turn
    setState(() {
      revolverAction = null;
      enemyAction = null;
      turnLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (statusText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              statusText,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Revolver
            Column(
              children: [
                Text('HP: $revolverHP'),
                Text(revolverAction?.name ?? ''),
                const SizedBox(height: 8),
                const RevolverAnimator(),
              ],
            ),

            // Enemy
            Column(
              children: [
                Text('HP: $enemyHP'),
                Text(enemyAction?.name ?? ''),
                const SizedBox(height: 8),
                const EnemyAnimator(),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: turnLocked
                  ? null
                  : () => revolverSelect(CombatAction.attack),
              child: const Text('Attack'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: turnLocked
                  ? null
                  : () => revolverSelect(CombatAction.block),
              child: const Text('Block'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: resetGame,
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}