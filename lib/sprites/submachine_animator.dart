import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

enum SubmachineAction { idle, fire, reload }

class SubmachineAnimator extends StatefulWidget {
  const SubmachineAnimator({super.key});

  @override
  State<SubmachineAnimator> createState() => _SubmachineAnimatorState();
}

class _SubmachineAnimatorState extends State<SubmachineAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ui.Image? _image;

  // Audio
  final AudioPlayer firePlayer = AudioPlayer();
  final AudioPlayer reloadPlayer = AudioPlayer();

  SubmachineAction _action = SubmachineAction.idle;

  // Sprite info
  final int frameWidth = 32;
  final int frameHeight = 32;

  int frameCount = 1;
  int currentFrame = 0;

  bool holdingFire = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this)
      ..addListener(() {
        if (!mounted) return;

        setState(() {
          currentFrame =
              (_controller.value * frameCount).floor().clamp(0, frameCount - 1);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed &&
            _action == SubmachineAction.fire &&
            !holdingFire) {
          _resetToIdle();
        }
      });

    _loadSprite('assets/sprites/submachine_trigger.png', 4);
  }

  // Load sprite
  Future<void> _loadSprite(String path, int frames) async {
    final data = await rootBundle.load(path);
    final codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();

    if (!mounted) return;

    setState(() {
      _image = frame.image;
      frameCount = frames;
      currentFrame = 0;
    });
  }

  // Tap fire (single)
  Future<void> fireOnce() async {
    if (_action != SubmachineAction.idle) return;

    firePlayer.play(
      AssetSource('sounds/revolver.mp3'),
      volume: 1,
    );

    await _loadSprite('assets/sprites/submachine_trigger.png', 4);

    setState(() {
      _action = SubmachineAction.fire;
      _controller.duration = const Duration(milliseconds: 120);
    });

    _controller.forward(from: 0);
  }

  // Hold fire (loop)
  Future<void> startAutoFire() async {
    if (_action == SubmachineAction.reload) return;

    holdingFire = true;

    await _loadSprite('assets/sprites/submachine_trigger.png', 4);

    firePlayer.setReleaseMode(ReleaseMode.loop);
    firePlayer.play(AssetSource('sounds/revolver.mp3'));

    setState(() {
      _action = SubmachineAction.fire;
      _controller.duration = const Duration(milliseconds: 80);
    });

    _controller.repeat();
  }

  void stopAutoFire() {
    holdingFire = false;
    firePlayer.stop();
    _controller.stop();
    _resetToIdle();
  }

  // Reload
  Future<void> reload() async {
    if (_action != SubmachineAction.idle) return;

    reloadPlayer.play(AssetSource('sounds/bulletchamber.mp3'));

    await _loadSprite('assets/sprites/submachine_reload.png', 16);

    setState(() {
      _action = SubmachineAction.reload;
      _controller.duration = const Duration(milliseconds: 900);
    });

    _controller.forward(from: 0);
  }

  void _resetToIdle() {
    setState(() {
      _action = SubmachineAction.idle;
      currentFrame = 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    firePlayer.dispose();
    reloadPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) return const SizedBox();

    return SizedBox.expand(
  child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(256, 256),
          painter: _SpritePainter(
            image: _image!,
            frame: currentFrame,
            frameWidth: frameWidth,
            frameHeight: frameHeight,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: fireOnce,
              onLongPressStart: (_) => startAutoFire(),
              onLongPressEnd: (_) => stopAutoFire(),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Fire'),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: reload,
              child: const Text('Reload'),
            ),
          ],
        ),
      ],
    ),
  ),
);
  }
}

class _SpritePainter extends CustomPainter {
  final ui.Image image;
  final int frame;
  final int frameWidth;
  final int frameHeight;

  _SpritePainter({
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