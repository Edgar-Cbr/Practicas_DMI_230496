import 'package:flutter/material.dart';
import 'presentation/counter/counter_functions_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF101A2C);
    const primaryColor = Color(0xFFFFCB05);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          surface: Color(0xFF192A46),
        ),
        fontFamily: 'PokemonFireRed',
      ),
      home: const CounterFunctionsScreen(), 
    );
  }
}
