import 'dart:math';

import 'package:flutter/material.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// Root widget of the Color Tap App.
class MyApp extends StatelessWidget {
  /// Creates a new MyApp widget.
  const MyApp({super.key});

  /// Builds the MaterialApp for the application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     // This is the theme of your application.
    //     //
    //     // TRY THIS: Try running your application with "flutter run". You'll see
    //     // the application has a purple toolbar. Then, without quitting the app,
    //     // try changing the seedColor in the colorScheme below to Colors.green
    //     // and then invoke "hot reload" (save your changes or press the "hot
    //     // reload" button in a Flutter-supported IDE, or press "r" if you used
    //     // the command line to start the app).
    //     //
    //     // Notice that the counter didn't reset back to zero; the application
    //     // state is not lost during the reload. To reset the state, use hot
    //     // restart instead.
    //     //
    //     // This works for code too, not just values: Most code changes can be
    //     // tested with just a hot reload.
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //   ),
    //   home: const MyHomePage(title: 'Flutter Demo Home Page'),
    // );

    return MaterialApp(
      title: 'Color Tap App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ColorTapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Stateful widget for the main color-tapping screen.
class ColorTapScreen extends StatefulWidget {
  /// Creates a new ColorTapScreen widget.
  const ColorTapScreen({super.key});

  /// Creates the state for this widget.
  @override
  ColorTapScreenState createState() => ColorTapScreenState();
}

/// State for the ColorTapScreen widget.
class ColorTapScreenState extends State<ColorTapScreen>
    with TickerProviderStateMixin {
  /// The current background color of the screen.
  Color backgroundColor = Colors.green;

  /// The number of times the screen has been tapped.
  int tapCount = 0;

  /// The hexadecimal representation of the current color.
  String colorHex = '#FFFFFF';

  late AnimationController _animationController;
  late AnimationController _textAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textScaleAnimation;
  final Random _random = Random();
  
  /// Initializes the state, setting up animation controllers.
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ),);
    
    _textScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.bounceOut,
    ),);
  }

  /// Disposes of resources, including animation controllers.
  @override
  void dispose() {
    _animationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  /// Generates a random color using RGB values.
  Color generateRandomColor() {
    // Generate RGB values (0-255 each) for 16,777,216 possible colors
    final int red = _random.nextInt(256);
    final int green = _random.nextInt(256);
    final int blue = _random.nextInt(256);
    
    return Color.fromARGB(255, red, green, blue);
  }

  /// Converts a Color to its hexadecimal string representation (RRGGBB).
  String colorToHex(Color color) {
    // Use toARGB32() as replacement for deprecated color.value
    final int argb = color.toARGB32();
    // Break long line for readability
    final String hexPart = argb
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2)
        .toUpperCase();
    return '#$hexPart';
  }

  /// Returns a contrasting text color (black or white) 
  /// based on background luminance.
  Color getContrastingTextColor(Color backgroundColor) {
    // Use built-in computeLuminance() for accurate WCAG relative luminance
    final double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Handles screen taps to change color and update state.
  void onScreenTap() {
    setState(() {
      backgroundColor = generateRandomColor();
      colorHex = colorToHex(backgroundColor);
      tapCount++;
    });
    
    // Trigger animations
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    _textAnimationController.forward().then((_) {
      _textAnimationController.reverse();
    });
  }

  /// Builds the UI for the color tap screen.
  @override
  Widget build(BuildContext context) {
    final Color textColor = getContrastingTextColor(backgroundColor);
    
    // Compute RGB integers to shorten display line
    final int redInt = (backgroundColor.r * 255.0).round();
    final int greenInt = (backgroundColor.g * 255.0).round();
    final int blueInt = (backgroundColor.b * 255.0).round();
    
    return Scaffold(
      body: GestureDetector(
        onTap: onScreenTap,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: double.infinity,
                height: double.infinity,
                color: backgroundColor,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main text
                      AnimatedBuilder(
                        animation: _textAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _textScaleAnimation.value,
                            child: Text(
                              'Hello there',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                    color: textColor.withValues(
                                      alpha: textColor.a * 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Tap instruction
                      Text(
                        'Tap anywhere to change color',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor.withValues(
                            alpha: textColor.a * 0.8,
                          ),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Color info card
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: textColor.withValues(
                            alpha: textColor.a * 0.1,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: textColor.withValues(
                              alpha: textColor.a * 0.3,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Color Code:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor.withValues(
                                      alpha: textColor.a * 0.8,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  colorHex,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'RGB:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor.withValues(
                                      alpha: textColor.a * 0.8,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '($redInt, $greenInt, $blueInt)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Tap counter
                      Container(
                        padding: 
                        const EdgeInsets.symmetric(horizontal: 20, 
                        vertical: 10,),
                        decoration: BoxDecoration(color: textColor.withValues(
                            alpha: textColor.a * 0.1,),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Taps: $tapCount',
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Example home page widget (commented out in MyApp).
class MyHomePage extends StatefulWidget {
  /// Creates a new MyHomePage widget.
  const MyHomePage({required this.title});

  /// The title of the home page.
  final String title;

  /// Creates the state for this widget.
  @override
  MyHomePageState createState() => MyHomePageState();
}

/// State for the MyHomePage widget.
class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  /// Increments the counter.
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  /// Builds the UI for the home page.
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
