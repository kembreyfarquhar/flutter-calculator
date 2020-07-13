import 'package:flutter/material.dart';
import 'package:expression_language/expression_language.dart';

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

class _operations {
  final int multiply = 1;
  final int divide = 1;
  final int add = 2;
  final int subtract = 2;
}

var expressionGrammarDefinition = ExpressionGrammarParser({});
var parser = expressionGrammarDefinition.build();

class _MyHomePageState extends State<MyHomePage> {
  String display = "0";
  List <String> values = [];
  List <String> operations = [];
  bool entered = false;
  bool numPress = false;
  bool opPress = false;



  void _handleNumberPress(val) {
    if (entered == true) return;

    if (values.length == 0 && display == "0"){
      setState(() {
        display = val;
        values.add(val);
      });
    } else if (values.length == 1 && operations.length == 0 && numPress == true){
      setState(() {
        display = display + val;
        values[0] = values[0] + val;
      });
    } else if (operations.length > 0 && numPress == false){
      setState(() {
        display = val;
        values.add(val);
      });
    } else if (operations.length > 0 && numPress == true){
      setState(() {
        display = display + val;
        values[operations.length - 1] = values[operations.length - 1] + val;
      });
    }

    setState(() {
      numPress = true;
      opPress = false;
    });
  }

  void _enter() {
    if (values.length < 2) return;

    setState(() {
      entered = true;
      numPress = false;
    });

    if (values.length == 2){
      var string = values[0] + operations[0] + values[1];
      var result = parser.parse(string);
      var expression = result.value as Expression;
      var value = expression.evaluate();
      setState(() => display = value.toString());
    } else {
      for (var i = 0; i < operations.length; i++){
        if (operations[i] == "*" || operations[i] == "/"){
          var string = values[i] + operations[i] + values[i+1];
          var result = parser.parse(string);
          var expression = result.value as Expression;
          var value = expression.evaluate();
          setState(() {
            values.replaceRange(i, i+2, [value.toString()]);
            operations.removeAt(i);
          });
        }
      }
      var resultArr = [];

      for (var i = 0; i < values.length; i ++){
        if (i < operations.length){
          resultArr.add(values[i]);
          resultArr.add(operations[i]);
        } else {
          resultArr.add(values[i]);
        }
      }
      var result = parser.parse(resultArr.join(""));
      var expression = result.value as Expression;
      var value = expression.evaluate();
      setState(() {
        display = value.toString();
      });
    }
  }

  void _setOperation(op) {
    setState(() {
      if (opPress == false){
        operations.add(op);
      } else {
        operations.replaceRange(operations.length-1, operations.length-1, [op]);
      }
      entered = false;
      numPress = false;
    });
    setState(() => opPress = true);
  }

  void _clear() {
    setState(() {
      display = "0";
      entered = numPress = opPress = false;
      values = [];
      operations = [];
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
//        Text(
//          values
//              .where((element) => element != null && element != "0")
//              .join(" "),
//          style: TextStyle(fontSize: 16.0, color: Colors.black),
//          textAlign: TextAlign.left,
//          textDirection: TextDirection.ltr,
//        ),
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
