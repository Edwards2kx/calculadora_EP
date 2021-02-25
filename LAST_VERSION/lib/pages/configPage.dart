import 'package:flutter/material.dart';
import 'package:valor_presente_calculator/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valor_presente_calculator/main.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
//  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //SharedPreferences.setMockInitialValues (Map<String, dynamic> values);
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TextEditingController _textController1;
  TextEditingController _textController2;

  // getPreferences() async {
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   setState(() {});
  // }

  double interesAportacion = 0.0;
  double interesMeta = 0.0;
  double numericValue1 = 0.0;
  double numericValue2 = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      interesAportacion =
          (prefs.getDouble('interesAportacion') ?? kInteresesAportacion);
      interesMeta = (prefs.getDouble('interesMeta') ?? kInteresMeta);
      print('valor leido de memoria interesAportacion $interesAportacion');
      print('valor leido de memoria interesMeta $interesMeta');
      _textController1 = TextEditingController(text: '$interesAportacion');
      _textController2 = TextEditingController(text: '$interesMeta');
    });
  }

  _savePreferences(double aportacion, double meta) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('interesAportacion', aportacion);
      prefs.setDouble('interesMeta', meta);
    });
  }

  String msg = ''; //mensaje para un indicador de error

  @override
  Widget build(BuildContext context) {
    final InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: kAzul),
    );

    final InputDecoration textFieldDecoration = InputDecoration(
      //labelStyle: TextStyle(color: kAzul),
      enabledBorder: inputBorder,
      border: inputBorder,
      focusedBorder: inputBorder,
//      labelStyle: TextStyle(color: Colors.white),
    );

    double _spacerValue = 10.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kAzul),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: kColorBackGround,
          padding: EdgeInsets.symmetric(horizontal: 26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: _spacerValue),
              _logoHeader(),
              SizedBox(height: _spacerValue), //spacer
              _buildTitle(),
              SizedBox(height: _spacerValue), //spacer
              buildBodyText(),
              SizedBox(height: _spacerValue),
              buildTextField1(textFieldDecoration),
              SizedBox(height: 12.0),
              buildTextField2(textFieldDecoration),
              SizedBox(height: 18.0),
              Text(msg, style: TextStyle(color: kGrisOscuro, fontSize: 18.0)),
              SizedBox(height: 12.0),
              buildSaveButton(context)
            ],
          ),
        ),
      ),
    );
  }

  RaisedButton buildSaveButton(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      elevation: 2.0,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      child: Text(
        'GUARDAR',
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w500, color: kAzul),
      ),
      onPressed: () {
        if (_validar()) {
          setState(() {});
          showDialog(context: context, builder: (_) => buildAlertDialog());
        } else {
          setState(() {});
          msg = 'Alguno de los valores es incorrecto';
        }

        //buildAlertDialog();
      },
    );
  }

  Widget buildTextField1(InputDecoration textFieldDecoration) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Plan retiro',
            style: TextStyle(color: kGrisOscuro, fontSize: 18.0),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
                controller: _textController1,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                cursorColor: kAzul,
                decoration: textFieldDecoration),
          ),
        ),
      ],
    );
  }

  Widget buildTextField2(InputDecoration textFieldDecoration) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Lograr una meta',
            style: TextStyle(color: kGrisOscuro, fontSize: 18.0),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
                controller: _textController2,
                textAlign: TextAlign.end,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                cursorColor: kAzul,
                decoration: textFieldDecoration),
          ),
        ),
      ],
    );
  }

  Widget buildBodyText() {
    return Column(
      children: [
        Text(
          kTextoConfigPage1,
          style: TextStyle(color: kGrisclaro),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 20.0),
        Text(
          kTextoConfigPage2,
          style: TextStyle(color: kGrisclaro),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: 20.0),
        Text(
          kTextoConfigPage3,
          style: TextStyle(color: kGrisclaro),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Row _buildTitle() {
    return Row(
      children: [
        Text(
          'Valor del interés',
          style: TextStyle(
              color: kAzul, fontSize: 26.0, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      title: Text('¿Guardar estos cambios?'),
      content: Text(
        'Si guarda los cambios en estos variables los resultados de los cálculos realizados en la aplicación se podrían ver afectados',
        textAlign: TextAlign.justify,
      ),
      actions: [
        FlatButton(
          child: Text(
            'Si',
            style: TextStyle(fontSize: 18.0, color: kAzul),
          ),
          onPressed: () {
            _savePreferences(numericValue1, numericValue2);
            msg = 'Los cambios se guardaron correctamente';
            Navigator.pop(context);
            //Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(
            'No',
            style: TextStyle(fontSize: 18.0, color: kAzul),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  bool _validar() {
    try {
      if (_textController1.text.isNotEmpty &&
          _textController2.text.isNotEmpty) {
        numericValue1 = double.parse(_textController1.text);
        numericValue2 = double.parse(_textController2.text);
        if (numericValue1 >= 1 ||
            numericValue1 < 0 ||
            numericValue2 >= 1 ||
            numericValue2 < 0) {
          msg = 'Rango invalido';
          print('rango invalido');
          return false;
        } else {
          msg = ''; //no hubo mensaje de error
          return true;
        }
      } else {
        msg = 'No debe dejar campos sin rellenar';
        return false;
      }
    } catch (e) {
      msg = 'No es un numero valido';
      return false;
    }
  }

  Container _logoHeader() {
    return Container(
      height: 100.0,
      child: Image.asset(
        'assets/logo_small.png',
      ),
    );
  }
}
