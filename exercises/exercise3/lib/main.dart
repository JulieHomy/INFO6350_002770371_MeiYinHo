import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const SingleChildScrollView(
            child: Column(
              children: [
                ImageSection(
                  imageUrl:
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                ),
                TitleSection(
                  name: 'Oeschinen Lake Campground',
                  location: 'Kandersteg, Switzerland',
                ),
                ButtonSection(),
                TextSection(
                  description:
                  'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
                      'Bernese Alps. Situated 1,578 meters above sea level, it '
                      'is one of the larger Alpine Lakes. A gondola ride from '
                      'Kandersteg, followed by a half-hour walk through pastures '
                      'and pine forest, leads you to the lake, which warms to 20 '
                      'degrees Celsius in the summer. Activities enjoyed here '
                      'include rowing, and riding the summer toboggan run.',
                ),
              ],
            )),
      ),
    );
  }
}

class TitleSection extends StatefulWidget {
  const TitleSection({
    super.key,
    required this.name,
    required this.location,
  });

  final String name;
  final String location;

  @override
  _TitleSectionState createState() => _TitleSectionState();
}

class _TitleSectionState extends State<TitleSection> {
  int starCount = 41;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  widget.location,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.star,
              color: Colors.red[500],
            ),
            onPressed: () {
              setState(() {
                starCount++;
              });
            },
          ),
          Text('$starCount'),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, this.image, this.imageUrl});

  final String? image;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? Image.network(
      imageUrl!,
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    )
        : Image.asset(
      image ?? 'images/default.jpg',
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonWithText(
            color: color,
            icon: Icons.call,
            label: 'CALL',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Call button pressed')),
            ),
          ),
          ButtonWithText(
            color: color,
            icon: Icons.near_me,
            label: 'ROUTE',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Route button pressed')),
            ),
          ),
          ButtonWithText(
            color: color,
            icon: Icons.share,
            label: 'SHARE',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share button pressed')),
            ),
          ),
        ],
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  const TextSection({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        description,
        softWrap: true,
      ),
    );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
