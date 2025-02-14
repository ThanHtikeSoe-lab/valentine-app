import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ValentineScreen(),
    );
  }
}

class ValentineScreen extends StatefulWidget {
  @override
  _ValentineScreenState createState() => _ValentineScreenState();
}

class _ValentineScreenState extends State<ValentineScreen> {
  bool _showNoButton = true;
  double _noButtonTop = 400;
  double _noButtonLeft = 150;
  final Random _random = Random();
  int _pressCount = 0;
  bool _backgroundChanged = false;

  void _moveNoButton() {
    setState(() {
      double moveAmount = (_pressCount + 1) * 50.0;
      _noButtonTop =
          (_noButtonTop + _random.nextDouble() * moveAmount - moveAmount / 2)
              .clamp(50.0, MediaQuery.of(context).size.height - 100);
      _noButtonLeft =
          (_noButtonLeft + _random.nextDouble() * moveAmount - moveAmount / 2)
              .clamp(50.0, MediaQuery.of(context).size.width - 100);
      _pressCount++;
    });
  }

  void _onYesClicked() {
    setState(() {
      _backgroundChanged = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThankYouPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: _backgroundChanged
              ? DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.cover,
                )
              : null,
          gradient: _backgroundChanged
              ? null
              : LinearGradient(
                  colors: [Colors.pink, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                'NeoTharix',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Pacifico',
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Will you be mine, today and always?',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    onPressed: _onYesClicked,
                    child: Text(
                      'YES',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  if (_pressCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Boo! Try again! 👻',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_showNoButton)
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                top: _noButtonTop,
                left: _noButtonLeft,
                child: GestureDetector(
                  onTap: _moveNoButton,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      elevation: 10,
                    ),
                    onPressed: _moveNoButton,
                    child: Text(
                      'NO',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ThankYouPage extends StatefulWidget {
  @override
  _ThankYouPageState createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<FallingObject> fallingObjects = [];
  double screenWidth = 400;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..addListener(() {
            setState(() {
              for (var obj in fallingObjects) {
                obj.fall();
              }
            });
          })
          ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    fallingObjects = List.generate(30, (_) => FallingObject(screenWidth));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.redAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Happy Valentine\'s Day! ❤️',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Pacifico',
                  ),
                ),
                SizedBox(height: 30),
                Image.asset(
                  'assets/heart.png',
                  height: 150,
                ),
                SizedBox(height: 30),
                Text(
                  'Thank you, my love! 💕',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          for (var obj in fallingObjects)
            Positioned(
              top: obj.y,
              left: obj.x,
              child: obj.isHeart
                  ? Icon(Icons.favorite, color: Colors.red, size: obj.size)
                  : Image.asset(
                      'assets/rosepetal.png',
                      height: obj.size,
                      width: obj.size,
                    ),
            ),
        ],
      ),
    );
  }
}

class FallingObject {
  double x;
  double y;
  double speed;
  double size;
  bool isHeart;

  FallingObject(double screenWidth)
      : x = Random().nextDouble() * screenWidth,
        y = Random().nextDouble() * -500,
        speed = Random().nextDouble() * 3 + 2,
        size = Random().nextDouble() * 30 + 20,
        isHeart = Random().nextBool();

  void fall() {
    y += speed;
    if (y > 800) {
      y = Random().nextDouble() * -100;
      x = Random().nextDouble() * 400;
    }
  }
}
