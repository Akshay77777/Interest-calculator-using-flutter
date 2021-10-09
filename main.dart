import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(new MaterialApp(
    title: "IntCal",
    debugShowCheckedModeBanner: false,
    checkerboardOffscreenLayers: false,
    theme: ThemeData.dark(),
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title:Center(child:Text("Interest Calculator",
          )
        ),
      ),
      body: Home(
      ),)
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _formKey = GlobalKey<FormState>();

  var _currencies = [ "Rupees", "Dollar"];
  var _currentItemSelected = "";
  String Result = "";
  TextEditingController principleControler = TextEditingController();
  TextEditingController amountControler = TextEditingController();
  TextEditingController rateControler = TextEditingController();

  DateTime backButtonPressedTime;

  Future<bool> _onWillPop() async {
    DateTime currentTime = DateTime.now();

    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);

    if (backButton) {
      backButtonPressedTime = currentTime;
      Fluttertoast.showToast(msg: "Double Click to exit app",
          backgroundColor: Colors.black,
          textColor: Colors.white);

      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,

      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              getImageAssets(),
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: principleControler,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "please enter a value";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Principal',
                      hintText: "Enter your principle amount ex: 1000",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: amountControler,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "please enter the text";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Rate of interest",
                      hintText: "Enter rate ex: 10%",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 10.0, top: 5.0),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: rateControler,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "please enter the text";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Term",
                            hintText: "Time for amount ex: 6 month",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        items: _currencies.map((String dropDownItem) {
                          return DropdownMenuItem<String>(
                              value: dropDownItem,
                              child: Center(
                                child: Text(
                                  dropDownItem,
                                  style: TextStyle(color: Colors.redAccent,
                                      fontSize: 20),
                                ),
                              ));
                        }).toList(),
                        onChanged: (String newValueSelected) {
                          _onDropDownSelected(newValueSelected);
                        },
                        value: _currentItemSelected,
                        iconSize: 30.0,
                        style: TextStyle(),
                      ),
                    ),
                  ],
                  )

              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.only(),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FloatingActionButton(
                          elevation: 8.0,
                          backgroundColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () {
                            setState(() {
                              if (_formKey.currentState.validate()) {
                                Result = calculate();
                              }
                            });
                          },
                          child: Text(
                            "Calculate",
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6.0,
                      ),
                      Expanded(
                          child: FloatingActionButton(
                            elevation: 8.0,
                            backgroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            onPressed: () {
                              reset();
                            },
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                          )),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(Result,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        height: 1.5
                    ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAssets() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(
      image: assetImage,
      width: 250,
      height: 200.0,
    );
    return Container(
      child: image,
    );
  }

  void _onDropDownSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String calculate() {
    double principle = double.parse(principleControler.text);
    double amount = double.parse(amountControler.text);
    double rate = double.parse(rateControler.text);
    double total = (principle + (principle * rate * amount) / 100);
    String result = 'After $rate  months your interest will be $total $_currentItemSelected';
    return result;
  }

  void reset() {
    _currentItemSelected = _currencies[0];
    principleControler.text = "";
    amountControler.text = "";
    rateControler.text = "";
  }
}