import 'package:flutter/material.dart';
import '../sprites/revolver_animator.dart';
import '../sprites/submachine_animator.dart';
import '../sprites/enemigotest.dart';
import '../sprites/forms.dart';
import '../sprites/fades.dart';
import '../sprites/dog.dart';
import '../sprites/parallax.dart';
import '../sprites/chat_ui.dart';
import '../sprites/chatbotkomunicate.dart';
import '../sprites/aicuisine.dart';
import '../sprites/turnbasedcombat.dart';
// ejemplo

class SpriteCarousel extends StatefulWidget {
  const SpriteCarousel({super.key});

  @override
  State<SpriteCarousel> createState() => _SpriteCarouselState();
}

class _SpriteCarouselState extends State<SpriteCarousel> {
  final PageController _controller = PageController();
  int currentIndex = 0;

final List<Widget> pages = [    //<------------Aqui se añaden las ventanas de la carpeta /lib/sprites individualmente
  const AICuisine(),
  //const RevolverAnimator(),  
  //const SubmachineAnimator(),
  //EnemyAnimator(), // ← NO const
  UniversityChatbot(),

  MyApp(),
  MyApp2(),
  ScheduleApp(),
  MyApp4(),
  RevolverAnimator(),
  SubmachineAnimator(),
  ChatBotPage(),
  TurnCombatScreen(),
  EnemyAnimator(),

];

  void nextPage() {
    final next = (currentIndex + 1) % pages.length;

    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );

    setState(() => currentIndex = next);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(), // swipe solo por botón
            children: pages,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: nextPage,
          child: const Text('Next'),
        ),
      ],
    );
  }
}