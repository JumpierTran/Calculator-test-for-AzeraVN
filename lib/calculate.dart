// ignore_for_file: avoid_print, unused_element, unnecessary_string_interpolations
import 'package:calculation/btn_calculate.dart';
import 'package:calculation/history.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

String input = "";
String output = "";
String result = '';
List<String> calculationsHistory = [];

// ignore: must_be_immutable
class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  bool calculationPerformed = false;
  @override
  void initState() {
    super.initState();
    _loadCalculationsHistory();
  }

  void _saveCalculationsHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('calculate', calculationsHistory);
    });
    print('$calculationsHistory');
  }

  void _loadCalculationsHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      calculationsHistory = prefs.getStringList('calculate') ?? [];
    });
    print('$calculationsHistory');
  }

  _performCalculation() {
    double calcResult = double.parse(calculate(output));
    setState(() {
      result = calcResult.toString();
      calculationsHistory.add('$input = $calcResult');
      _saveCalculationsHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate test'),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryCalculate(),
                ),
              ),
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    input.isEmpty ? '0' : input,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    output,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: BtnCalculate.btnValues
                  .map(
                    (value) => SizedBox(
                      width: screenSize.width / 5,
                      height: screenSize.height / 8,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white38,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnPressed(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getBtnColor(value) {
    return [BtnCalculate.btnClear].contains(value)
        ? Colors.blueGrey
        : [
            BtnCalculate.btnCalculate,
            BtnCalculate.btnDot,
            BtnCalculate.btnOpen,
            BtnCalculate.btnClose,
            BtnCalculate.btnPer,
          ].contains(value)
            ? Colors.orange
            : Colors.white;
  }

  void onBtnPressed(String value) {
    if (calculationPerformed) {
      input = value;
      output = '';
      calculationPerformed = false;
    } else if (value == BtnCalculate.btnCalculate) {
      final result = calculate(output);
      output = result;
      calculationPerformed = true;
      _performCalculation();
    }
    if (value == BtnCalculate.btnClear) {
      input = '0';
      output = '';
      calculationPerformed = false;
    } else if (canAppend(input, value)) {
      if (input == '0') {
        input = value;
      } else {
        input += value;
      }
    }
    setState(() {});
  }
}

bool canAppend(String currentInput, String nextValue) {
  if (nextValue == BtnCalculate.btnCalculate ||
      nextValue == BtnCalculate.btnClear ||
      nextValue == BtnCalculate.btnSubtract ||
      nextValue == BtnCalculate.btnPer) {
    return true;
  } else if (currentInput.isEmpty) {
    return !(nextValue == BtnCalculate.btnCalculate ||
        nextValue == BtnCalculate.btnClear);
  }
  final lastChar = currentInput[currentInput.length - 1];
  if (isOperator(lastChar) && isOperator(nextValue)) {
    return false;
  } else if (lastChar == BtnCalculate.btnDot &&
      nextValue == BtnCalculate.btnDot) {
    return false;
  }
  return true;
}

bool isOperator(String value) {
  return value == BtnCalculate.btnSubtract ||
      value == BtnCalculate.btnAdd ||
      value == BtnCalculate.btnMulti ||
      value == BtnCalculate.btnDivide ||
      value == BtnCalculate.btnPer;
}

String calculate(String output) {
  try {
    String modifiedInput = input.replaceAll(BtnCalculate.btnMulti, '*');
    modifiedInput = modifiedInput.replaceAll(BtnCalculate.btnDivide, '/');
    modifiedInput = modifiedInput.replaceAll(BtnCalculate.btnPer, '/100');
    if (modifiedInput.startsWith(BtnCalculate.btnSubtract)) {
      modifiedInput += BtnCalculate.btnZero;
    }
    if (modifiedInput.endsWith(BtnCalculate.btnPer)) {
      modifiedInput += BtnCalculate.btnZero;
    }
    final parser = Parser();
    final context = ContextModel();
    final expression = parser.parse(modifiedInput);
    final result = expression.evaluate(EvaluationType.REAL, context);
    return result.toString();
  } catch (e) {
    return 'Error';
  }
}

void removeData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('calculate');
}
