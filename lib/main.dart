import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String display = "0";
  String valA;
  String valB;
  String operation;
  bool entered = false;

  void _handleNumberPress(val) {
    if (entered == true) return;

    if (display == "0") {
      setState(() {
        display = val;
        valA = val;
      });
    } else if (valA != null && valB == null && operation == null) {
      setState(() {
        display = display + val;
        valA = valA + val;
      });
    } else if (valA != null && operation != null && valB == null){
      setState(() {
        display = val;
        valB = val;
      });
    } else if (valA != null && operation != null && valB != null){
      setState(() {
        display = display + val;
        valB = valB + val;
      });
    }
  }

  void _enter() {
    if (valA == null || valB == null) return;
    var num1 = int.tryParse(valA);
    var num2 = int.tryParse(valB);

    setState(() => entered = true);

    switch (operation) {
      case "+":
        setState(() {
          display = (num1 + num2).toString();
        });
        break;
      case "-":
        setState(() {
          display = (num1 - num2).toString();
        });
        break;
      case "*":
        setState(() {
          display = (num1 * num2).toString();
        });
        break;
      case "/":
        setState(() {
          display = (num1 / num2).toString();
        });
        break;
    }
  }

  void _setOperation(op) {
    setState(() {
      operation = op;
      entered = false;
      if (valA != null && valB != null) {
        valA = display;
        valB = null;
      }
    });
  }

  void _clear() {
    setState(() {
      display = "0";
      entered = false;
      valA = valB = operation = null;
    });
  }

  Widget _button(String number, Function() f) {
    return Expanded(
        child: MaterialButton(
      height: 60,
      child: Text(
        number,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
      ),
      textColor: Colors.black,
      color: Colors.grey[100],
      onPressed: f,
    ));
  }

  Widget _display() {
    List values = [valA, operation, valB];
    return Stack(
      children: <Widget>[
        Container(
          constraints: BoxConstraints.expand(
            height:
                Theme.of(context).textTheme.headline4.fontSize * 1.1 + 100.0,
          ),
          alignment: Alignment.bottomRight,
          color: Colors.white,
          child: Text(
            display,
            style: TextStyle(fontSize: 50.0, color: Colors.black),
            textAlign: TextAlign.right,
          ),
        ),
        Text(
          values
              .where((element) => element != null && element != "0")
              .join(" "),
          style: TextStyle(fontSize: 16.0, color: Colors.black),
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }

  Widget _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _button("7", () => _handleNumberPress("7")),
        _button("8", () => _handleNumberPress("8")),
        _button("9", () => _handleNumberPress("9")),
        _button("+", () => _setOperation("+"))
      ],
    );
  }

  Widget _middleTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _button("4", () => _handleNumberPress("4")),
        _button("5", () => _handleNumberPress("5")),
        _button("6", () => _handleNumberPress("6")),
        _button("-", () => _setOperation("-"))
      ],
    );
  }

  Widget _middleBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _button("1", () => _handleNumberPress("1")),
        _button("2", () => _handleNumberPress("2")),
        _button("3", () => _handleNumberPress("3")),
        _button("*", () => _setOperation("*"))
      ],
    );
  }

  Widget _bottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _button("C", () => _clear()),
        _button("0", () => _handleNumberPress("0")),
        _button("=", () => _enter()),
        _button("/", () => _setOperation("/"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _display(),
            _topRow(),
            _middleTopRow(),
            _middleBottomRow(),
            _bottomRow(),
          ],
        ),
      ),
    );
  }
}
