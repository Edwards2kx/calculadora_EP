import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:finance/finance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
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

  String rawEdadActual = '';
  String rawEdadFinal = '';
  String rawRequerimientoRetiroHoy = '';
  String rawFondoActual = '';
  String rawFondoReq = '';

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
          intNumberField('Edad actual:', 'A', rawEdadActual, (String v) {
//            print(v);
            rawEdadActual = v;
            try {
              edadActual = double.parse(rawEdadActual);
            } catch (e) {
              //            print(e);
              edadActual = 0.0;
            }
            return null;
            //edadActual = v;
            //return null;
          }),
          intNumberField('Edad deseada de retiro:', 'A', rawEdadFinal,
              (String v) {
            rawEdadFinal = v;
//                    print(v);
            rawEdadFinal = v;
            try {
              edadFinal = double.parse(rawEdadFinal);
            } catch (e) {
//              print(e);
              edadFinal = 0.0;
            }
            //edadFinal = v;
            return null;
          }),
          //intNumberField('Requerimiento mensual si el retiro fuera hoy:', 'MXN',
          intNumberField(
              'Requerimiento mensual:', 'MXN', rawRequerimientoRetiroHoy,
              (String v) {
            rawRequerimientoRetiroHoy = v;
            try {
              //requerimientoRetiroHoy = double.parse(rawRequerimientoRetiroHoy);
              requerimientoRetiroHoy =
                  double.parse(rawRequerimientoRetiroHoy.replaceAll(',', ''));
            } catch (e) {
//              print(e);
              requerimientoRetiroHoy = 0.0;
            }
            //requerimientoRetiroHoy = v;
            return null;
          }, isMoney: true),
          intNumberField('Fondo actual existente:', 'USD', rawFondoActual,
              (String v) {
            rawFondoActual = v;
            //          print(v);
            try {
              //fondoActual = double.parse(rawFondoActual);
              fondoActual = double.parse(rawFondoActual.replaceAll(',', ''));
            } catch (e) {
              //          print(e);
              fondoActual = 0.0;
            }
            //fondoActual = v;
            return null;
          }, isMoney: true, canBeZero: true),

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

  Widget intNumberField(String label, String decoration, String initialValue,
      Function callback(String v),
      {bool canBeZero = false, bool isMoney = false}) {
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

    TextEditingController _controller =
        TextEditingController(text: initialValue);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 9,
            child: TextFormField(
              controller: _controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // inputFormatters: [
              //   isMoney
              //       ? MoneyInputFormatter(
              //           thousandSeparator: ThousandSeparator.Comma,
              //           onValueChange: (v) {
              //             if (v == 0.00) {
              //               setState(() {
              //                 callback('');
              //                 _controller.text = '';
              //               });
              //             }
              //           },
              //         )
              //       : //LengthLimitingTextInputFormatter(3)
              //       FilteringTextInputFormatter.deny(' '),
              //   FilteringTextInputFormatter.deny(RegExp("[a-zA-Z]")),
              // ],
              // inputFormatters: [
              //   FilteringTextInputFormatter.deny(' '),
              //   FilteringTextInputFormatter.deny(RegExp("[a-zA-Z]")),
              // ],
              inputFormatters: [
                isMoney
                    ? CurrencyTextInputFormatter()
                    : FilteringTextInputFormatter.deny(' '),
                FilteringTextInputFormatter.deny(RegExp("[a-zA-Z]")),
              ],

              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () {
                    _controller.text = '';
                  },
                ),
                errorStyle: TextStyle(
                    fontSize:
                        0.0), //evita el reescalado del widget cuando sale un error
                labelStyle: TextStyle(color: kAzul, fontSize: 12.0),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                enabledBorder: _outlineInputBorderNormal,
                focusedBorder: _outlineInputBorderNormal,
                errorBorder: _outlineInputBorderError,
                border: _outlineInputBorderNormal,
                labelText: label,
              ),
              onEditingComplete: () {
                callback(_controller.text);
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              validator: (v) {
                //var v = maskFormatter.getUnmaskedText();
//                print(v);
                //if (v.isEmpty) {
                if (v.isEmpty && canBeZero == false) {
                  callback('');
                  return 'ERROR';
                }
                //if (v.isEmpty) return 'ERROR';
                return null;
              },
              onSaved: (v) {
//                print('esto voy a guardar $v');
                //var _value;
                try {
                  callback(v);
                } catch (e) {
  //                print(e);
                  callback('0.0');
                }
              },
            ),
          ),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                //child: decoration,
                child: Text(decoration, style: TextStyle(color: kGrisclaro)),
              ))
        ],
      ),
    );
  }

  Widget calculateButton() {
    fondoReq = 0.0;
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
      //_texto = fondoReq.toStringAsFixed(2);
      _texto = fondoReq.toCurrencyString(
          mantissaLength: 2,
          thousandSeparator: ThousandSeparator.Comma,
          trailingSymbol: ' USD');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Fondo requerido:',
          style: TextStyle(
            color: kGrisclaro,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Text('\$ $_texto',
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
      //_texto = result.toStringAsFixed(2);
      _texto = result.toCurrencyString(
          mantissaLength: 2,
          thousandSeparator: ThousandSeparator.Comma,
          trailingSymbol: ' USD');

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
            '\$ $_texto',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
