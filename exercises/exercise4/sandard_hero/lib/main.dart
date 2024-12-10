import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    this.onTap,
    required this.width,
  });

  final String photo;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class BasicHeroAnimation extends StatefulWidget {
  const BasicHeroAnimation({super.key});

  @override
  State<BasicHeroAnimation> createState() => _BasicHeroAnimationState();
}

class _BasicHeroAnimationState extends State<BasicHeroAnimation> {
  double _animationSpeed = 2.0;

  @override
  Widget build(BuildContext context) {
    timeDilation = _animationSpeed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Hero Animation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Adjust Animation Speed',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _animationSpeed,
            min: 1.0,
            max: 5.0,
            divisions: 4,
            label: '${_animationSpeed.toStringAsFixed(1)}x',
            onChanged: (value) {
              setState(() {
                _animationSpeed = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: PhotoHero(
              photo: 'images/puppy.jpg',
              width: 300,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Puppy Page'),
                      ),
                      body: Container(
                        color: Colors.lightBlueAccent,
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PhotoHero(
                              photo: 'images/puppy.jpg',
                              width: 100,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Back to Main Page'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ));
              },
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
      home: BasicHeroAnimation(),
    ),
  );
}
