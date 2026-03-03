import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

int shotsFired = 0;
const int maxShots = 3;

enum RevolverAction { idle, fire, reload }

class RevolverAnimator extends StatefulWidget {
  const RevolverAnimator({super.key});

  @override
  State<RevolverAnimator> createState() => _RevolverAnimatorState();
}

class _RevolverAnimatorState extends State<RevolverAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ui.Image? _image;

  // Audio
  final AudioPlayer firePlayer = AudioPlayer();
  final AudioPlayer reloadPlayer = AudioPlayer();
  final AudioPlayer emptyPlayer = AudioPlayer();

  RevolverAction _action = RevolverAction.idle;

  // Sprite info
  final int frameWidth = 32;
  final int frameHeight = 32;

  int frameCount = 1;
  int currentFrame = 0;

  double triggerRotation = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this)
      ..addListener(() {
        if (!mounted) return;

        setState(() {
          currentFrame =
              (_controller.value * frameCount).floor().clamp(0, frameCount - 1);

          // Trigger recoil 
          if (_action == RevolverAction.fire) {
            triggerRotation = -0.15 * (1 - _controller.value);
          }
        });
      })
      ..addStatusListener((status) {
        if (!mounted) return;

        if (status == AnimationStatus.completed) {
          setState(() {
            _action = RevolverAction.idle;
            currentFrame = 0;
            triggerRotation = 0;
          });
        }
      });

    // Base idle frame
    _loadSprite('assets/sprites/revolver_trigger.png', 4);
  }

  // Load sprite safely
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

  // FIRE
  Future<void> fire() async {
    if (_action != RevolverAction.idle) return;

    if (shotsFired >= maxShots) {
      emptyPlayer.play(AssetSource('sounds/empty.mp3'));
      await reload();
      return;
    }

    shotsFired++;
    firePlayer.play(AssetSource('sounds/revolver.mp3'));

    await _loadSprite('assets/sprites/revolver_trigger.png', 4);

    if (!mounted) return;

    setState(() {
      _action = RevolverAction.fire;
      _controller.duration = const Duration(milliseconds: 250);
    });

    _controller.forward(from: 0);
  }

  // RELOAD
  Future<void> reload() async {
    if (_action != RevolverAction.idle) return;

    reloadPlayer.play(AssetSource('sounds/bulletchamber.mp3'));
    shotsFired = 0;

    await _loadSprite('assets/sprites/revolver_reload.png', 30);

    if (!mounted) return;

    setState(() {
      _action = RevolverAction.reload;
      _controller.duration = const Duration(milliseconds: 1900);
    });

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    firePlayer.dispose();
    reloadPlayer.dispose();
    emptyPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) return const SizedBox();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pivot 
        Transform(
          alignment: Alignment.centerRight,
          transform: Matrix4.identity()..rotateZ(triggerRotation),
          child: CustomPaint(
            size: const Size(256, 256),
            painter: _SpritePainter(
              image: _image!,
              frame: currentFrame,
              frameWidth: frameWidth,
              frameHeight: frameHeight,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fire,
              child: const Text('Fire'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: reload,
              child: const Text('Reload'),
            ),
          ],
        ),
      ],
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
