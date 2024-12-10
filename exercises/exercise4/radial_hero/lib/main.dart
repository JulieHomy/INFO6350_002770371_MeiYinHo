import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class Photo extends StatelessWidget {
  const Photo({super.key, required this.photo, this.onTap});

  final String photo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      child: InkWell(
        onTap: onTap,
        child: Image.asset(
          photo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class RadialExpansion extends StatelessWidget {
  const RadialExpansion({
    super.key,
    required this.maxRadius,
    this.child,
  }) : clipRectSize = 2.0 * (maxRadius / math.sqrt2);

  final double maxRadius;
  final double clipRectSize;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: child,
          ),
        ),
      ),
    );
  }
}

class RadialExpansionDemo extends StatefulWidget {
  const RadialExpansionDemo({super.key});

  @override
  _RadialExpansionDemoState createState() => _RadialExpansionDemoState();
}

class _RadialExpansionDemoState extends State<RadialExpansionDemo> {
  static double kMinRadius = 32.0;
  static double kMaxRadius = 128.0;
  static Interval opacityCurve =
  const Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  double _animationSpeed = 5.0;

  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  static Widget _buildPage(
      BuildContext context, String imageName, String description) {
    return Scaffold(
      appBar: AppBar(
        title: Text(description),
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Center(
          child: Card(
            elevation: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: kMaxRadius * 2.0,
                  height: kMaxRadius * 2.0,
                  child: Hero(
                    createRectTween: _createRectTween,
                    tag: imageName,
                    child: RadialExpansion(
                      maxRadius: kMaxRadius,
                      child: Photo(
                        photo: imageName,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero(
      BuildContext context, String imageName, String description) {
    return SizedBox(
      width: kMinRadius * 2.0,
      height: kMinRadius * 2.0,
      child: Hero(
        createRectTween: _createRectTween,
        tag: imageName,
        child: RadialExpansion(
          maxRadius: kMaxRadius,
          child: Photo(
            photo: imageName,
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder<void>(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: opacityCurve.transform(animation.value),
                          child: _buildPage(context, imageName, description),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = _animationSpeed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Radial Transition Demo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Adjust Animation Speed',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _animationSpeed,
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  label: _animationSpeed.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _animationSpeed = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              alignment: FractionalOffset.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildHero(context, 'images/chair-alpha.png', 'Chair'),
                  _buildHero(context, 'images/binoculars-alpha.png', 'Binoculars'),
                  _buildHero(context, 'images/beachball-alpha.png', 'Beach ball'),
                  _buildHero(context, 'images/sunset-alpha.png', 'Sunset'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: RadialExpansionDemo(),
    ),
  );
}
