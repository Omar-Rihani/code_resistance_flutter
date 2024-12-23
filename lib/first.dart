 import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResistorCalculatorScreen extends StatefulWidget {
  @override
  _ResistorCalculatorScreenState createState() => _ResistorCalculatorScreenState();
}

class _ResistorCalculatorScreenState extends State<ResistorCalculatorScreen> {
  final List<String> bandColors = [
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
  final List<String> bandColors1 = [
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
  final List<String> multiplierColors = [
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
    'Gold': Color(0x6FFFD700), // Gold color for tolerance
    'Silver': Color(0xFFC0C0C0),
  };

  final List<int> colorValues = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  String? band1 = 'Brown';
  String? band2 = 'Brown';
  String? multiplier = 'Red'; // Use default for multiplier
  String resistanceValue = '';

  void calculateResistance() {
    if (band1 != null && band2 != null && multiplier != null) {
      int value1 = colorValues[bandColors.indexOf(band1!)];
      int value2 = colorValues[bandColors.indexOf(band2!)];
      int multiplierIndex = multiplierColors.indexOf(multiplier!);
      int multiplierValue;
      if (multiplierIndex < 10) {
        multiplierValue = colorValues[multiplierIndex];
      } else if (multiplier == 'Gold') {
        multiplierValue = -1; // 0.1
      } else if (multiplier == 'Silver') {
        multiplierValue = -2; // 0.01
      } else {
        multiplierValue = colorValues[multiplierIndex];
      }

      num resistance;
      if (multiplierValue >= 0) {
        resistance = (value1 * 10 + value2) * pow(10, multiplierValue);
      } else {
        resistance = (value1 * 10 + value2) * pow(10, multiplierValue); // Apply the decimal multiplier
      }

      // Calculate the resistance value and unit
      String unit;
      if (resistance >= 1e6) {
        resistance /= 1e6;
        unit = 'MΩ';
      } else if (resistance >= 1e3) {
        resistance /= 1e3;
        unit = 'kΩ';
      } else {
        unit = 'Ω';
      }

      setState(() {
        resistanceValue = 'Resistance: ${resistance.toStringAsFixed(2)} $unit ± 5%';
      });
    }
  }

  Widget buildColorDropdown(String? selectedBand, List<String> colorList, ValueChanged<String?> onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        hint: Text('Select band'),
        value: selectedBand,
        onChanged: onChanged,
        underline: SizedBox(),
        isExpanded: true,
        items: colorList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Resistor Calculator',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Center(
                child: CustomPaint(
                  size: Size(300, 100),
                  painter: ResistorPainter(
                    band1Color: band1 != null ? colorMap[band1!] : Colors.transparent,
                    band2Color: band2 != null ? colorMap[band2!] : Colors.transparent,
                    band3Color: multiplier != null ? colorMap[multiplier!] : Colors.transparent,
                    band4Color: colorMap['Gold'], // Tolerance band
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildColorDropdown(band1, bandColors1, (String? newValue) {
                setState(() {
                  band1 = newValue;
                  calculateResistance();
                });
              }),
              buildColorDropdown(band2, bandColors, (String? newValue) {
                setState(() {
                  band2 = newValue;
                  calculateResistance();
                });
              }),
              buildColorDropdown(multiplier, multiplierColors, (String? newValue) {
                setState(() {
                  multiplier = newValue;
                  calculateResistance();
                });
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateResistance,
                child: Text('Calculate Resistance'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              Text(
                resistanceValue,
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResistorPainter extends CustomPainter {
  final Color? band1Color;
  final Color? band2Color;
  final Color? band3Color;
  final Color? band4Color;

  ResistorPainter({this.band1Color, this.band2Color, this.band3Color, this.band4Color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    paint.color = Colors.brown.shade300;
    final Rect resistorBody = Rect.fromLTWH(50, 40, 200, 20);
    canvas.drawRect(resistorBody, paint);

    if (band1Color != null) {
      paint.color = band1Color!;
      final Rect band1 = Rect.fromLTWH(70, 40, 10, 20);
      canvas.drawRect(band1, paint);
    }
    if (band2Color != null) {
      paint.color = band2Color!;
      final Rect band2 = Rect.fromLTWH(110, 40, 10, 20);
      canvas.drawRect(band2, paint);
    }
    if (band3Color != null) {
      paint.color = band3Color!;
      final Rect band3 = Rect.fromLTWH(150, 40, 10, 20);
      canvas.drawRect(band3, paint);
    }
    if (band4Color != null) {
      paint.color = band4Color!;
      final Rect band4 = Rect.fromLTWH(190, 40, 10, 20);
      canvas.drawRect(band4, paint);
    }

    paint.color = Colors.grey;
    final double wireWidth = 4.0;
    canvas.drawRect(Rect.fromLTWH(0, 48, 50, wireWidth), paint);
    canvas.drawRect(Rect.fromLTWH(250, 48, 50, wireWidth), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}