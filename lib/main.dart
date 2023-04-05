import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list/consts.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/data/src/hive_task_source.dart';

import 'data/data.dart';
import 'screens/home/home.dart';

void main() async {
  // final Repository<TaskEntity> repository = Repository(HiveTaskDataSource(Hive.box(taskBoxName)));

  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: primaryVariantColor,
    ),
  );
  runApp(
    ChangeNotifierProvider<Repository<TaskEntity>>(
      create: (BuildContext context) => Repository<TaskEntity>(
        HiveTaskDataSource(
          Hive.box(taskBoxName),
        ),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: secondaryTextColor),
          border: InputBorder.none,
          iconColor: secondaryTextColor,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          primaryContainer: primaryVariantColor,
          background: Color(0xffF3F5F8),
          onSurface: primaryTextColor,
          onPrimary: Colors.white,
          onBackground: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
