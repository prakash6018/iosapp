import 'package:flutter/material.dart';
import 'buttons.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userInput = '';
  var answer = '';
  var currentOperator = '';
  bool showUserInput = true;
  bool newInput = true;
  double previousAnswer = 0.0;

  final List<String> buttons = [
    'AC',
    '+/-',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'C',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(60),
                    alignment: Alignment.center,
                    child: Text(
                      showUserInput ? userInput : answer,
                      style: TextStyle(
                        fontSize: showUserInput ? 38 : 40,
                        color: Colors.white,
                        fontWeight:
                            showUserInput ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput = '';
                          answer = '';
                          currentOperator = '';
                          showUserInput = true;
                          newInput = true;
                          previousAnswer = 0.0; // Reset the previous answer
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  } else if (index == 1) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          if (userInput.isNotEmpty &&
                              !userInput.startsWith('-')) {
                            userInput = '-' + userInput;
                          } else if (userInput.isNotEmpty &&
                              userInput.startsWith('-')) {
                            userInput = userInput.substring(1);
                          }
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  } else if (index == 2) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  } else if (index == 18) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput =
                              userInput.substring(0, userInput.length - 1);
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.grey[600],
                      textColor: Colors.white,
                    );
                  } else if (index == 19) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          equalPressed();
                          newInput = true;
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.orange[300],
                      textColor: Colors.white,
                    );
                  } else if (isOperator(buttons[index])) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          if (currentOperator.isEmpty) {
                            currentOperator = buttons[index];
                            userInput += buttons[index];
                          } else if (isOperator(currentOperator) &&
                              isOperator(buttons[index])) {
                            userInput =
                                userInput.substring(0, userInput.length - 1) +
                                    buttons[index];
                            currentOperator = buttons[index];
                          }
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.orange[300],
                      textColor: Colors.white,
                    );
                  } else {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          if (newInput) {
                            userInput = buttons[index];
                            newInput = false;
                          } else {
                            userInput += buttons[index];
                          }
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.grey[600],
                      textColor: Colors.white,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    return x == '/' || x == 'x' || x == '-' || x == '+' || x == '=';
  }

  void equalPressed() {
    String finalUserInput = userInput;
    finalUserInput = userInput.replaceAll('x', '*').replaceAll('÷', '/');

    if (currentOperator == '=') {
      finalUserInput = previousAnswer.toString() + finalUserInput;
    }

    Parser p = Parser();
    Expression exp = p.parse(finalUserInput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
    previousAnswer = eval;

    setState(() {
      showUserInput = false;
    });
  }
}
