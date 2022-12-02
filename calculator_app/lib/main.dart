import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: const CalculatePage(title: 'My Mobile Calculator'),
    );
  }
}
class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key, required this.title});

  final String title;
  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  String _equation = "";
  String _answer = "= ";
  
  
  Widget displaySection(){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: double.infinity,
      color: Colors.white,
     child: Column(
        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children : <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: RawScrollbar( child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child:Text(_equation, 
                          style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w300)
                          )
            )
            )
          ),
          Text(_answer,
            style: const TextStyle(fontSize:25, color: Color.fromARGB(255, 72, 71, 71)
            , fontStyle:  FontStyle.italic)
          )
        ]
      )
    );
  }

  Widget topSection(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
         ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(3),
            ),
            onPressed: () => {
                setState(() => {
                  _equation = ''
                })
            },
            child: const Text("Clr", style: TextStyle(fontSize: 22, color: Colors.orange)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(3),
            ),
            onPressed: () => {
              setState(() => {
                  if(_equation.isNotEmpty){
                    _equation = _equation.substring(0, _equation.length-1)
                 }
                })
            },
            child: const Text("Del", style: TextStyle(fontSize: 22, color: Colors.orange)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(3),
            ),
            onPressed: () => {
              setState(() =>{
                if(_equation.isNotEmpty && !". ".contains(_equation[_equation.length - 1])){
                  _equation = '$_equation.'
                }
              })
            },
            child: const Text(".", style: TextStyle(fontSize: 22, color: Colors.orange)),
          )
      ]
    );
  }

  Widget numberBtn(String key){
    return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal:5),
            ),
            onPressed: () => {
                setState(() => {
                  _equation = '$_equation$key'
                })
            },
            child: Text(key, style: const TextStyle(fontSize: 22, color: Colors.black))
          );
  }


  Widget numPad(){
    return GridView.count(
      mainAxisSpacing: 11,
      crossAxisSpacing: 7,
      crossAxisCount: 3,
      shrinkWrap: true,
    children: <Widget>[
      numberBtn("7"),
      numberBtn("8"),
      numberBtn("9"),
      numberBtn("4"),
      numberBtn("5"),
      numberBtn("6"),
      numberBtn("1"),
      numberBtn("2"),
      numberBtn("3"),
      numberBtn("("),
      numberBtn("0"),
      numberBtn(")"),

    ]);
  }

  Widget operatorBtn(String value, IconData? icon) {
    return 
    Container(
      margin: const EdgeInsets.symmetric(vertical: 9.0),
      child: ElevatedButton(
        onPressed: () => {
          setState(() => {
                  _equation = '$_equation $value '
                })
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(10)
        ),
       child: 
          icon!=null?Icon(icon, color: Colors.orange, size: 43):
                     Text(value, style: const TextStyle(fontSize: 40, color: Colors.orange))
    )
    );
  }

  void equalPushed(){
    try{
      var fEquation = _equation.trim();
      //replace necessary changes
      fEquation = fEquation.replaceAll('X', '*').replaceAll('÷', '/');
      fEquation = fEquation.replaceAllMapped(RegExp(r'([0-9])(\()'), (r)=> "${r[1]} * (");

      Parser parser = Parser();
      Expression exp = parser.parse(fEquation);
      double eval = exp.evaluate(EvaluationType.REAL, ContextModel());

      setState(()=>{
        _answer = '= $eval'
      });
    }
    catch (e){
      ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(
                    content: Text("The system detected your equation has an error."), 
                    duration:  Duration(seconds: 3)));
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Column(
        children: <Widget>[
          displaySection(),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: const Color.fromARGB(255, 52, 50, 50),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        topSection(),
                        Container(
                         margin: const EdgeInsets.all(10),
                        child:numPad()
                        )
                      ]
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(  
                      mainAxisAlignment: MainAxisAlignment.end, 
                      children: <Widget>[
                        operatorBtn("+", Icons.add),
                        operatorBtn("-", Icons.remove),
                        operatorBtn("X", Icons.close),
                        operatorBtn("÷", null),
                        ElevatedButton(
                          onPressed: equalPushed,
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.all(10)
                          ),
                        child: const Text("=", style: TextStyle(fontSize: 40, color: Colors.white))
                        ),
                      ]
                    
                    )

                  )
                ]
              )
            )
          )
          //Center(child: const Text("HELLO"))
        ]
      )
    );
  }
}