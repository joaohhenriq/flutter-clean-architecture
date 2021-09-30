import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/pages/main_screen.dart';
import 'package:get/get.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Number Trivia',
      home: MainScreen(),
    );
  }
}
