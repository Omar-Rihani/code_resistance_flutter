import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class ColorCodeScreen extends StatefulWidget {
  @override
  _ColorCodeScreenState createState() => _ColorCodeScreenState();
}

class _ColorCodeScreenState extends State<ColorCodeScreen> {
  final List<String> colors = [
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

  final List<String> multipliers = [
    'Black',
    'Brown',
    'Red',
    'Orange',
    'Yellow',
    'Green',
    'Blue',
    'Violet',
    'Gray',
    'White',
    'Gold',
    'Silver'
  ];

  final Map<String, Color> colorMap = {
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
    'Gold': Color(0x6FFFD700),
    'Silver': Color(0xFFC0C0C0),
  };

  TextEditingController resistanceController = TextEditingController();
  String band1 = 'Brown';
  String band2 = 'Black';
  String band3 = 'Black';
  String band4 = 'Gold';

  void calculateBands() {
    if (resistanceController.text.isNotEmpty) {
      int resistance = int.parse(resistanceController.text);
      int significantDigits = resistance;
      int multiplierIndex = 0;

      while (significantDigits >= 100) {
        significantDigits ~/= 10;
        multiplierIndex++;
      }
      int value1 = significantDigits ~/ 10;
      int value2 = significantDigits % 10;

      setState(() {
        band1 = colors[value1];
        band2 = colors[value2];
        band3 = multipliers[multiplierIndex < multipliers.length - 2 ? multiplierIndex : multipliers.length - 2]; // Exclude Gold and Silver for band3
        band4 = multiplierIndex == multipliers.length - 1 ? 'Gold' : (multiplierIndex == multipliers.length - 2 ? 'Silver' : 'Gold'); // Default tolerance
      });
    }
  }

  Widget buildBandColorBox(String color) {
    return Container(
      width: 30,
      height: 30,
      color: colorMap[color],
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
                onPressed: calculateBands,
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
                  buildBandColorBox(band1),
                  buildBandColorBox(band2),
                  buildBandColorBox(band3),
                  buildBandColorBox(band4),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Band 1: $band1\nBand 2: $band2\nMultiplier: $band3\nTolerance: $band4',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
