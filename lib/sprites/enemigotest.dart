import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class EnemyAnimator extends StatefulWidget {
  
  const EnemyAnimator({super.key});
  

  @override
  State<EnemyAnimator> createState() => _EnemyAnimatorState();
}

class _EnemyAnimatorState extends State<EnemyAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ui.Image? _image;

  final AudioPlayer damagePlayer = AudioPlayer();

  // Sprite 
  final int frameWidth = 32;
  final int frameHeight = 32;
  final int frameCount = 20;

  int currentFrame = 0;

  // Damage 
  bool isDamaged = false;

  // Counter 
  int damageCounter = 3;
  int _nextResetBase = 3;

  // Base filt
  ColorFilter? baseFilter;

  // Rango de cambio de colores
  final List<ColorFilter> availableFilters = [
    const ColorFilter.mode(Colors.blue, BlendMode.modulate),
    const ColorFilter.mode(Colors.green, BlendMode.modulate),
    const ColorFilter.mode(Colors.purple, BlendMode.modulate),
    const ColorFilter.mode(Colors.yellow, BlendMode.modulate),
    const ColorFilter.mode(Colors.cyan, BlendMode.modulate),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )
      ..addListener(() {
        if (!mounted || isDamaged) return;

        setState(() {
          currentFrame =
              (_controller.value * frameCount).floor().clamp(0, frameCount - 1);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && !isDamaged) {
          _controller.forward(from: 0); // 🔁 loop
        }
      });

    _loadSprite();
  }

  // Load spritesheet
  Future<void> _loadSprite() async {
    final data = await rootBundle.load('assets/sprites/enemigo1.png');
    final codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();

    if (!mounted) return;

    setState(() {
      _image = frame.image;
      currentFrame = 0;
    });

    _controller.forward(from: 0);
  }

  // AAAAAAAAAAAAA
  Future<void> damage() async {
    if (isDamaged) return;

    await damagePlayer.play(
      AssetSource('sounds/damage1.mp3'),
    );

    _controller.stop();

    setState(() {
      isDamaged = true;
      damageCounter--;
    });

    // Reset logic + new random filter
    if (damageCounter <= 0) {
      _nextResetBase = (_nextResetBase + 2).clamp(0, 9);
      damageCounter = _nextResetBase;

      baseFilter =
          availableFilters[Random().nextInt(availableFilters.length)];
    }

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      isDamaged = false;
    });

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    damagePlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) return const SizedBox();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColorFiltered(
          colorFilter: isDamaged
              ? const ColorFilter.mode(
                  Colors.red,
                  BlendMode.modulate,
                )
              : baseFilter ??
                  const ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.dst,
                  ),
          child: CustomPaint(
            size: const Size(256, 256),
            painter: _EnemyPainter(
              image: _image!,
              frame: currentFrame,
              frameWidth: frameWidth,
              frameHeight: frameHeight,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Counter: $damageCounter',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: damage,
          child: const Text('Damage'),
        ),
      ],
    );
  }
}

class _EnemyPainter extends CustomPainter {
  final ui.Image image;
  final int frame;
  final int frameWidth;
  final int frameHeight;

  _EnemyPainter({
    required this.image,
    required this.frame,
    required this.frameWidth,
    required this.frameHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final src = Rect.fromLTWH(
      frame * frameWidth.toDouble(),
      0,
      frameWidth.toDouble(),
      frameHeight.toDouble(),
    );

    final dst = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(
      image,
      src,
      dst,
      Paint()..filterQuality = FilterQuality.none,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}