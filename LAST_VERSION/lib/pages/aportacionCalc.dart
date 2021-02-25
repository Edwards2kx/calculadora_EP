import 'package:finance/finance.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constantes.dart';
// import 'package:valor_presente_calculator/constantes.dart';

class AportacionCalc extends StatefulWidget {
  @override
  _AportacionCalcState createState() => _AportacionCalcState();
}

class _AportacionCalcState extends State<AportacionCalc> {
  int tempVar = 0;
  double value = 0;
  double edadActual = 0;
  double edadFinal = 0;
  double requerimientoRetiroHoy = 0;
  double fondoActual = 0;
  double fondoRequerido = 0;
//double fondoReq = 317460.32;
  double fondoReq = 0;

//double interes = 0.06391 / 12;
//double interes = 0.06391;
  double interes = kInteresesAportacion;
//double interesAportacion = 0.0;

  double constanteFR1 = 21;
  double constanteFR2 = 0.09;
  double valorFuturo = 0.0;

  int aportacionMensual = 0;

  double result = 0.0;
  double resultTemp = 0.0;

  final formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
//    _loadPreferences();
    return Container(
      child: Form(
        key: formKey2,
        child: Column(children: [
          Text(
            'Calculadora de monto a contribuir a plan de retiro',
            style: kTitleStyle,
          ),
          SizedBox(height: 10.0),
          Divider(indent: 30.0, endIndent: 30.0, thickness: 2.0),
          SizedBox(height: 10.0),
          intNumberField('Edad actual:', 'A', (double v) {
            edadActual = v;
            return null;
          }),
          intNumberField('Edad deseada de retiro:', 'A', (double v) {
            edadFinal = v;
            return null;
          }),
          //intNumberField('Requerimiento mensual si el retiro fuera hoy:', 'MXN',
          intNumberField('Requerimiento mensual:', 'MXN', (double v) {
            requerimientoRetiroHoy = v;
            return null;
          }, canBeZero: true),
          intNumberField('Fondo actual existente:', 'USD', (double v) {
            fondoActual = v;
            return null;
          }, canBeZero: true),
          //esto no va
          // intNumberField('Fondo Requerido:', Text('\$'), (double v) {
          //   fondoRequerido = v;
          //   return null;
          // }),
          SizedBox(height: 10.0),
          Divider(indent: 30.0, endIndent: 30.0, thickness: 2.0),
          SizedBox(height: 10.0),
          Column(
            children: [
              subResultBanner(),
              resultBanner(),
            ],
          ),
          SizedBox(height: 20.0),
          calculateButton(),
        ]),
      ),
    );
  }

  Widget intNumberField(
      String label, String decoration, Function callback(double v),
      {bool canBeZero = false}) {
    final _outlineInputBorderNormal = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: kAzul),
      gapPadding: 10,
    );
    final _outlineInputBorderError = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: Colors.red),
      gapPadding: 10,
    );
    return Container(
      //padding: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 9,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              //keyboardType: TextInputType.number,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,

              decoration: InputDecoration(
                errorStyle: TextStyle(
                    fontSize:
                        0.0), //evita el reescalado del widget cuando sale un error
                labelStyle: TextStyle(
                  color: kAzul,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                enabledBorder: _outlineInputBorderNormal,
                focusedBorder: _outlineInputBorderNormal,
                errorBorder: _outlineInputBorderError,
                border: _outlineInputBorderNormal,
                labelText: label,

                //alignLabelWithHint: true

                //floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (v) {
                if (v.isEmpty && canBeZero == false) {
                  return 'ERROR';
                }
                return null;
              },
              onSaved: (v) {
                var _value;
                try {
                  _value = double.parse(v);
                  callback(_value);
                } catch (e) {
                  print(e);
                  callback(0.0);
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                decoration,
                style: TextStyle(color: kGrisclaro),
                overflow: TextOverflow.clip,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget calculateButton() {
    _calcular() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        interes =
            (prefs.getDouble('interesAportacion') ?? kInteresesAportacion);
        print('valor leido de memoria interesAportacion $interes');
      });

      valorFuturo = Finance.fv(
          rate: (interes / 12),
          nper: (edadFinal - edadActual) * 12,
          pmt: 0,
          pv: (fondoActual) * (-1));

//      print('valor futuro = $valorFuturo');

      setState(() {
        fondoReq =
            (((requerimientoRetiroHoy * 12) / constanteFR1) / constanteFR2) -
                valorFuturo;

//        print('fondoRequerido = $fondoReq');
        result = Finance.ppmt(
              rate: (interes / 12),
              per: 1,
              nper: (edadFinal - edadActual) * 12,
//              pv: fondoActual,
              pv: 0,
              fv: fondoReq,
//              fv: fondoRequerido,
            ) *
            (-1);
      });
    }

    return RaisedButton(
      elevation: 2.0,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      child: Text(
        'CALCULAR',
        style: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w500, color: kAzul),
      ),
      color: Colors.white,
      onPressed: () {
        setState(() => result = 0.0);
        if (formKey2.currentState.validate()) {
          formKey2.currentState.save();
          _calcular();
        }
      },
    );
  }

  Widget subResultBanner() {
    String _texto;
    if (fondoReq.isNaN)
      _texto = '0.00';
    else
      _texto = fondoReq.toStringAsFixed(2);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Fondo requerido:',
          style: TextStyle(
            color: kGrisclaro,
            //  fontSize: 18.0,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Text('$_texto \$ USD',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget resultBanner() {
    String _texto;
    if (result.isNaN)
      _texto = '0.00';
    else
      _texto = result.toStringAsFixed(2);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Aportación mensual:',
          style: TextStyle(
            color: kGrisclaro,
            //  fontSize: 18.0,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Text(
            '$_texto \$ USD',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
