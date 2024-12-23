import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class ResistorColorCodePage extends StatefulWidget {
  @override
  _ResistorColorCodePageState createState() => _ResistorColorCodePageState();
}

class _ResistorColorCodePageState extends State<ResistorColorCodePage> {
  final List<String> resistorColors = [
    'Black',
    'Brown',
    'Red',
    'Orange',
    'Yellow',
    'Green',
    'Blue',
    'Violet',
    'Gray',
    'White'
  ];

  final Map<String, Color> resistorColorMap = {
    'Black': Colors.black,
    'Brown': Colors.brown,
    'Red': Colors.red,
    'Orange': Colors.orange,
    'Yellow': Colors.yellow,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Violet': Colors.purple,
    'Gray': Colors.grey,
    'White': Colors.white,
    'Gold': Color(0x6FFFD700), // Gold color for tolerance
  };

  TextEditingController resistanceController = TextEditingController();
  String colorBand1 = 'Brown';
  String colorBand2 = 'Black';
  String colorBand3 = 'Black';
  String colorBand4 = 'Black';
  String colorBand5 = 'Gold'; // Set to Gold for 5% tolerance

  void computeBands() {
    if (resistanceController.text.isNotEmpty) {
      int resistance = int.parse(resistanceController.text);
      int value1, value2, value3;
      int multiplierIndex;
      // Determine the significant digits and multiplier index
      if (resistance >= 1000000000) {
        value1 = resistance ~/ 1000000000;
        value2 = (resistance ~/ 100000000) % 10;
        value3 = (resistance ~/ 10000000) % 10;
        multiplierIndex = (log(resistance / (value1 * 1000000000)) / log(10)).toInt();
      } else if (resistance >= 100000000) {
        value1 = resistance ~/ 100000000;
        value2 = (resistance ~/ 10000000) % 10;
        value3 = (resistance ~/ 1000000) % 10;
        multiplierIndex = (log(resistance / (value1 * 100000000 + value2 * 10000000 + value3 * 1000000)) / log(10)).toInt();
      } else if (resistance >= 10000000) {
        value1 = resistance ~/ 10000000;
        value2 = (resistance ~/ 1000000) % 10;
        value3 = (resistance ~/ 100000) % 10;
        multiplierIndex = (log(resistance / (value1 * 10000000 + value2 * 1000000 + value3 * 100000)) / log(10)).toInt();
      } else if (resistance >= 1000000) {
        value1 = resistance ~/ 1000000;
        value2 = (resistance ~/ 100000) % 10;
        value3 = (resistance ~/ 10000) % 10;
        multiplierIndex = (log(resistance / (value1 * 1000000 + value2 * 100000 + value3 * 10000)) / log(10)).toInt();
      } else if (resistance >= 100000) {
        value1 = resistance ~/ 100000;
        value2 = (resistance ~/ 10000) % 10;
        value3 = (resistance ~/ 1000) % 10;
        multiplierIndex = (log(resistance / (value1 * 100000 + value2 * 10000 + value3 * 1000)) / log(10)).toInt();

      } else if (resistance >= 10000) {
        value1 = resistance ~/ 10000;
        value2 = (resistance ~/ 1000) % 10;
        value3 = (resistance ~/ 100) % 10;
        multiplierIndex = (log(resistance / (value1 * 10000 + value2 * 1000 + value3 * 100)) / log(10)).toInt();
      } else if (resistance >= 1000) {
        value1 = resistance ~/ 1000;
        value2 = (resistance ~/ 100) % 10;
        value3 = (resistance ~/ 10) % 10;
        multiplierIndex = (log(resistance / (value1 * 1000 + value2 * 100 + value3 * 10)) / log(10)).toInt();
      } else {
        value1 = resistance ~/ 100;
        value2 = (resistance ~/ 10) % 10;
        value3 = resistance % 10;
        multiplierIndex = (log(resistance / (value1 * 100 + value2 * 10 + value3)) / log(10)).toInt();
      }

      // List of standard multipliers
      List<int> multipliers = [1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000];
      // Find the closest multiplier
      int closestMultiplier = multipliers.firstWhere((m) => m >= resistance / 100, orElse: () => 1);
      multiplierIndex = multipliers.indexOf(closestMultiplier)-1;

      // Ensure multiplier index is within bounds
      if (multiplierIndex < 0) multiplierIndex = 0;
      if (multiplierIndex >= resistorColors.length) multiplierIndex = resistorColors.length - 1;

      setState(() {
        colorBand1 = resistorColors[value1];
        colorBand2 = resistorColors[value2];
        colorBand3 = resistorColors[value3];
        colorBand4 = resistorColors[multiplierIndex];
        colorBand5 = 'Gold'; // Tolerance band
      });

      print('Resistance: $resistance');
      print('Value1: $value1');
      print('Value2: $value2');
      print('Value3: $value3');
      print('Multiplier Index: $multiplierIndex');
      print('Color Band 4: ${resistorColors[multiplierIndex]}');
    }
  }

  Widget buildColorBox(String color) {
    return Container(
      width: 30,
      height: 30,
      color: resistorColorMap[color],
      margin: EdgeInsets.symmetric(horizontal: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Color Code Calculator',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: resistanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Resistance Value (Ω)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: computeBands,
                child: Text('Calculate Color Bands'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildColorBox(colorBand1),
                  buildColorBox(colorBand2),
                  buildColorBox(colorBand3),
                  buildColorBox(colorBand4),
                  buildColorBox(colorBand5),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Band 1: $colorBand1\nBand 2: $colorBand2\nBand 3: $colorBand3\nMultiplier: $colorBand4\nTolerance: $colorBand5',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
