import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  void readData() {
    databaseReference
        .child('https://footwear-abf3c-default-rtdb.firebaseio.com/LED_STATUS')
        .get()
        .then((DataSnapshot snapshot) {
      // DataSnapshot contains the data from the database
      print('Value: ${snapshot.value}');
    }).catchError((error) {
      // Handle the error if any
      print('Error: $error');
    });
  }

  void writeData() {
    databaseReference
        .child('https://footwear-abf3c-default-rtdb.firebaseio.com/LED_STATUS')
        .set('ON')
        .then((_) {
      print('Data written successfully.');
    }).catchError((error) {
      // #Handle the error if any
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Click On OPEN to Get Your Assets',
            ),
            ElevatedButton(
              onPressed: writeData,
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 12, 83, 14), // Background color
                onPrimary: Colors.white, // Foreground color (text color)
              ),
              child: Text("OPEN"),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: readData,
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 5, 46, 135), // Background color
                onPrimary: Colors.white, // Foreground color (text color)
              ),
              child: Text("READ STATUS"),
            ),
          ],
        ),
      ),
    );
  }
}
