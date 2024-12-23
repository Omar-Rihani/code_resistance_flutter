import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResistorCalculatorPage extends StatefulWidget {
  @override
  _ResistorCalculatorPageState createState() => _ResistorCalculatorPageState();
}

class _ResistorCalculatorPageState extends State<ResistorCalculatorPage> {
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
    'White',
    'Gold',   // Added Gold
    'Silver'  // Added Silver
  ];

  final List<String> firstBandColors = [
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
    'Gold': Color(0x6FFFD700),   // Multiplier color
    'Silver': Color(0xFFC0C0C0), // Multiplier color
  };

  final List<int> resistorColorValues = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]; // No multipliers here

  final List<double> multiplierValues = [1, 10, 100, 1e3, 1e4, 1e5, 1e6, 0.1, 0.01]; // Multipliers for Gold and Silver

  String? colorBand1 = 'Brown';
  String? colorBand2 = 'Black';
  String? colorBand3 = 'Red';
  String? colorBand4 = 'Red';
  String calculatedResistance = '';

  void computeResistance() {
    if (colorBand1 != null && colorBand2 != null && colorBand3 != null && colorBand4 != null)
    {
      int value1 = resistorColorValues[firstBandColors.indexOf(colorBand1!)]+1;
      int value2 = resistorColorValues[resistorColors.indexOf(colorBand2!)];

      int value3 = resistorColorValues[resistorColors.indexOf(colorBand3!)];
      int multiplierIndex = resistorColors.indexOf(colorBand4!);

      num baseValue = (value1 * 100 + value2 * 10 + value3);
      num multiplier;
      if (multiplierIndex < 10) {
        multiplier = multiplierValues[multiplierIndex];
      } else if (multiplierIndex == 10) { // Gold
        multiplier = 0.1;
      } else if (multiplierIndex == 11) { // Silver
        multiplier = 0.01;
      } else {
        multiplier = 1; // Default multiplier in case of error
      }

      num resistance = baseValue * multiplier;
      int tolerance = 5; // Band 5 is always Gold, which means 5% tolerance

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
        calculatedResistance = 'Resistance: ${resistance.toStringAsFixed(2)} $unit ± $tolerance%';
      });
    }
  }

  Widget createColorDropdown(String? selectedBand, ValueChanged<String?> onChanged, bool isMultiplier, bool isFirstBand) {
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
        items: (isFirstBand ? firstBandColors : resistorColors)
            .where((color) => isMultiplier || color != 'Gold' && color != 'Silver') // Exclude Gold and Silver if not multiplier
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(), // Ensure unique items
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
                  painter: ResistorIllustrator(
                    band1Color: colorBand1 != null ? resistorColorMap[colorBand1!]! : Colors.transparent,
                    band2Color: colorBand2 != null ? resistorColorMap[colorBand2!]! : Colors.transparent,
                    band3Color: colorBand3 != null ? resistorColorMap[colorBand3!]! : Colors.transparent,
                    band4Color: colorBand4 != null ? resistorColorMap[colorBand4!]! : Colors.transparent,
                    band5Color: resistorColorMap['Gold']!, // Band 5 is always Gold, force unwrap
                  ),
                ),
              ),
              SizedBox(height: 20),
              createColorDropdown(colorBand1, (String? newValue) {
                setState(() {
                  colorBand1 = newValue;
                  computeResistance();
                });
              }, false, true),
              createColorDropdown(colorBand2, (String? newValue) {
                setState(() {
                  colorBand2 = newValue;
                  computeResistance();
                });
              }, false, false),
              createColorDropdown(colorBand3, (String? newValue) {
                setState(() {
                  colorBand3 = newValue;
                  computeResistance();
                });
              }, false, false),
              createColorDropdown(colorBand4, (String? newValue) {
                setState(() {
                  colorBand4 = newValue;
                  computeResistance();
                });
              }, true, false), // Band 4 is the multiplier
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: computeResistance,
                child: Text('Calculate Resistance'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              Text(
                calculatedResistance,
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResistorIllustrator extends CustomPainter {
  final Color? band1Color;
  final Color? band2Color;
  final Color? band3Color;
  final Color? band4Color;
  final Color band5Color; // No nullable type here

  ResistorIllustrator({
    this.band1Color,
    this.band2Color,
    this.band3Color,
    this.band4Color,
    required this.band5Color
  });

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
    paint.color = band5Color;
    final Rect band5 = Rect.fromLTWH(230, 40, 10, 20);
    canvas.drawRect(band5, paint);

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
