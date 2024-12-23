import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FourDigitResistanceCalculatorScreen extends StatefulWidget {
  @override
  _FourDigitResistanceCalculatorScreenState createState() => _FourDigitResistanceCalculatorScreenState();
}

class _FourDigitResistanceCalculatorScreenState extends State<FourDigitResistanceCalculatorScreen> {
  final TextEditingController _inputController = TextEditingController();
  String calculatedResistance = '';

  void calculateResistance(String inputValue) {
    if (inputValue.length == 4) {
      int significantFigures = int.parse(inputValue.substring(0, 3));
      int exponent = int.parse(inputValue.substring(3, 4));
      num resistanceResult = significantFigures * pow(10, exponent);
      String unit;
      if (resistanceResult >= 1e6) {
        resistanceResult /= 1e6;
        unit = 'MΩ';
      } else if (resistanceResult >= 1e3) {
        resistanceResult /= 1e3;
        unit = 'kΩ';
      } else {
        unit = 'Ω';
      }

      setState(() {
        calculatedResistance = 'Resistance: ${resistanceResult.toStringAsFixed(2)} $unit';
      });
    } else {
      setState(() {
        calculatedResistance = 'Invalid input. Please enter a 4-digit number.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Resistance Calculator CMD',
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
              TextField(
                controller: _inputController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter a 4-digit number_CMD',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  calculateResistance(_inputController.text);
                },
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
