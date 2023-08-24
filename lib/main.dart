import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(name: "BoxApp",
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
            const Text("OPEN THE BOX", 
            style: TextStyle(
      color: Color.fromARGB(255, 19, 165, 104), //background color of button,
      fontWeight: FontWeight.w100,
      fontStyle: FontStyle.italic,
      fontFamily: 'Open Sans',
      fontSize: 40),),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 19, 165, 104), //background color of button,
                  side: const BorderSide(width:3, color:Color.fromARGB(255, 137, 229, 197)), //border width and color
                  elevation: 3, //elevation of button
                  shape: RoundedRectangleBorder( //to set border radius to button
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.all(20) //content padding inside button
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
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 19, 165, 104), //background color of button
                  side: const BorderSide(width:3, color:Color.fromARGB(255, 137, 229, 197)), //border width and color
                  elevation: 3, //elevation of button
                  shape: RoundedRectangleBorder( //to set border radius to button
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.all(20) //content padding inside button
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
               style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent, //background color of button
                  side: const BorderSide(width:3, color:Color.fromARGB(255, 137, 229, 197)), //border width and color
                  elevation: 3, //elevation of button
                  shape: RoundedRectangleBorder( //to set border radius to button
                      borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.all(20) //content padding inside button
                ),
              onPressed: () async {
                try {
                  status = await ReadStatus("LED_STATUS");
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
        await Firebase.initializeApp();
    final databaseRef = FirebaseDatabase.instance.ref();

    // Create a child node in the database.
    final childRef = databaseRef.child('LED_STATUS');

    // Set the value of the child node.
    await childRef.set(value);
    return "SUCCESS";
  }
  
  Future<String> ReadStatus(String s) async {
    // Create a reference to the Firebase Realtime Database.
         await Firebase.initializeApp();
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
