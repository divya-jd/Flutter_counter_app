import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow(); // Set up the window for desktop apps
  runApp(
    // Provide the model to all widgets within the app using ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => AgeCounter(), // Initialize the AgeCounter model
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  // Configure the window settings if not on the web and running on desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Counter'); // Set the window title
    setWindowMinSize(const Size(windowWidth, windowHeight)); // Set minimum window size
    setWindowMaxSize(const Size(windowWidth, windowHeight)); // Set maximum window size
    getCurrentScreen().then((screen) {
      // Center the window on the screen
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class AgeCounter with ChangeNotifier {
  int age = 0; // Initial age value

  // Method to increment the age
  void increment() {
    age += 1;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Method to decrement the age
  void decrement() {
    if (age > 0) { // Prevent negative age
      age -= 1; // Subtract from the age value
      notifyListeners(); // Notify listeners to rebuild UI
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.green, // Change the primary color to green
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Age Counter'), // Update the title
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.tealAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 10,
            shadowColor: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'I am this many years old:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Consumer<AgeCounter>(
                    builder: (context, ageCounter, child) => Text(
                      '${ageCounter.age}', // Display the age value
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Space between age and buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Decrement button
                      ElevatedButton(
                        onPressed: () {
                          context.read<AgeCounter>().decrement(); // Call decrement method
                        },
                        child: const Icon(Icons.remove, size: 30), // Icon for decrement
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent, // Use backgroundColor instead of primary
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                      ),
                      // Increment button
                      ElevatedButton(
                        onPressed: () {
                          context.read<AgeCounter>().increment(); // Call increment method
                        },
                        child: const Icon(Icons.add, size: 30), // Icon for increment
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent, // Use backgroundColor instead of primary
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
