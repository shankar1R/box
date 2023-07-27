import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Asset Box Handler'),
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
  String value = "";
 String status="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("OPEN TO GET YOUR BELONGINGS"),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                textStyle:
                    MaterialStateProperty.all(const TextStyle(color: Colors.white)),
              ),
              onPressed: () async {
                try {
                  value = await WriteOPEN("ON");
                  print("Value $value");
                } catch (e) {
                  print("e: $e");
                }
              },
              child: const Text("OPEN"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                textStyle:
                    MaterialStateProperty.all(const TextStyle(color: Colors.white)),
              ),
              onPressed: () async {
                try {
                  value = await WriteOPEN("OFF");
                  print("Value $value");
                } catch (e) {
                  print("e: $e");
                }
              },
              child: const Text("CLOSE"),
            ),
            const SizedBox(height: 20,),
            
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 60, 158, 228)),
                textStyle:
                    MaterialStateProperty.all(const TextStyle(color: Colors.white)),
              ),
              onPressed: () async {
                try {
                  status = await ReadStatus("STATUS");
                  print("Value $status");
                } catch (e) {
                  print("e: $e");
                }
              },
              child: const Text("READ STATUS"),
            ),
            Text("STATUS: $status")
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<String> WriteOPEN(String value) async {
    // Create a reference to the Firebase Realtime Database.
    final databaseRef = FirebaseDatabase.instance.ref();

    // Create a child node in the database.
    final childRef = databaseRef.child('STATUS');

    // Set the value of the child node.
    await childRef.set(value);
    return "SUCCESS";
  }
  
  Future<String> ReadStatus(String s) async {
    // Create a reference to the Firebase Realtime Database.
    final databaseRef = FirebaseDatabase.instance.ref();

    // Read the data once.
    DatabaseEvent event = await databaseRef.child(s).once();
    setState(() {
      status = event.snapshot.value.toString();
    });

    // Print the data of the snapshot.
    print(event.snapshot.value); //

    return status;
  }
}
