import 'package:mycampus/homepage.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedLogo(),
            const SizedBox(height: 20),
            AnimatedText(),
          ],
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatefulWidget {
  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Image.asset('images/nietlogo.png', width: 100, height: 100),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedText extends StatefulWidget {
  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with TickerProviderStateMixin {
  final String text = 'campusNIET';
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _animations = [];
  final List<Animation<double>> _rotations = [];

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.indigo,
    Colors.lime,
    Colors.teal,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < text.length; i++) {
      AnimationController controller = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
      );
      _controllers.add(controller);

      double dx = 0.0, dy = 0.0;
      switch (i % 4) {
        case 0:
          dx = -22.0; // from left
          break;
        case 1:
          dx = 22.0; // from right
          break;
        case 2:
          dy = -22.0; // from top
          break;
        case 3:
          dy = 22.0; // from bottom
          break;
      }

      _animations.add(Tween<Offset>(
        begin: Offset(dx, dy),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      )));

      _rotations.add(Tween<double>(
        begin: -math.pi,
        end: 0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      )));
    }

    _startAnimations();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        _controllers[i].forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: text.split('').asMap().entries.map((entry) {
        int index = entry.key;
        String char = entry.value;
        return SlideTransition(
          position: _animations[index],
          child: RotationTransition(
            turns: _rotations[index],
            child: Text(
              char,
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: colors[index % colors.length], // Assign different color
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
