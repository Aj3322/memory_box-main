import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackharvard21/Controller/Binding.dart';
import 'package:hackharvard21/Screens/Locations/LocationScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/Routines/medicines/MedicineScreen.dart';
import 'Screens/Routines/notes/AudioHome.dart';
import 'Screens/Routines/notes/NotesScreen.dart';
import 'Screens/Routines/notes/TextHome.dart';
import 'Screens/Routines/notes/VideoHome.dart';
import 'Screens/Routines/tasks/TasksScreen.dart';
import 'Screens/YouScreen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(95, 65, 165, 1),
        // accentColor: Color.fromRGBO(95, 65, 165, 1),
      ),
      initialBinding: HomeBinding(),
      home: MainPage(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/location': (context) => LocationsPage(),
        '/notes': (context) => NotesPage(),
        '/textNotes': (context) => TextNotesPage(),
        '/videoNotes': (context) => VideoNotesPage(),
        '/audioNotes': (context) => AudioNotesPage(),
        '/you': (context) => YouPage(),
        '/daily': (context) => DailyTasksPage(),
        '/medicine': (context) => MdicinePage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
