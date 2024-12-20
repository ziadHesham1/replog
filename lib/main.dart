import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Provider class to manage the value of x and its stream
class XProvider {
  int _x = 0;
  final StreamController<int> _controller = StreamController<int>();

  // Expose the stream so other classes can listen to it
  Stream<int> get xStream => _controller.stream;

  // Method to increment x and add the new value to the stream
  void incrementX() {
    _x++;
    _controller.sink.add(_x); // Push the updated value to the stream
  }

  // Clean up the stream controller
  void dispose() {
    _controller.close();
  }
}

class MyApp extends StatelessWidget {
  final XProvider xProvider = XProvider(); // Initialize the XProvider

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(xProvider: xProvider),
    );
  }
}

// Home screen with buttons to navigate to the increment and listener screens
class HomeScreen extends StatelessWidget {
  final XProvider xProvider;

  const HomeScreen({Key? key, required this.xProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncrementScreen(xProvider: xProvider),
                  ),
                );
              },
              child: Text('Go to Increment Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListenerScreen(xProvider: xProvider),
                  ),
                );
              },
              child: Text('Go to Listener Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen with a button to increment x
class IncrementScreen extends StatelessWidget {
  final XProvider xProvider;

  const IncrementScreen({Key? key, required this.xProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Increment Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            xProvider.incrementX(); // Increment x when button is pressed
          },
          child: Text('Increment X'),
        ),
      ),
    );
  }
}

// Screen to listen and display the value of x
class ListenerScreen extends StatelessWidget {
  final XProvider xProvider;

  const ListenerScreen({Key? key, required this.xProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listener Screen')),
      body: Center(
        child: StreamBuilder<int>(
          stream: xProvider.xStream,
          initialData: 0,
          builder: (context, snapshot) {
            return Text(
              'Current value of X: ${snapshot.data}',
              style: TextStyle(fontSize: 24),
            );
          },
        ),
      ),
    );
  }
}
