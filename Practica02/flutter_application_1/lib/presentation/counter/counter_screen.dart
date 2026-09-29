import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int clickCounter = 0;

  Color _getCounterColor() {
    if (clickCounter > 0) {
      return Colors.green;
    }
    if (clickCounter < 0) {
      return Colors.red;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF192A46),
        foregroundColor: const Color(0xFFFFF4D6),
        title: const Text(
          'Counter Screen',
          style: TextStyle(fontFamily: 'PokemonFireRed', fontSize: 22),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFCB05),
        foregroundColor: const Color(0xFF101A2C),
        onPressed: () {
          setState(() {
            clickCounter++;
          });
        },
        child: const Icon(Icons.plus_one),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$clickCounter',
              style: TextStyle(
                fontSize: 160,
                fontWeight: FontWeight.w100,
                fontFamily: 'PokemonFireRed',
                color: _getCounterColor(),
              ),
            ),
            const Text(
              'Clicks',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'PokemonFireRed',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
