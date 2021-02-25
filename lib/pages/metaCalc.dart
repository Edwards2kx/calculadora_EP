import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:finance/finance.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constantes.dart';

class MetaCalc extends StatefulWidget {
  @override
  _MetaCalcState createState() => _MetaCalcState();
}

class _MetaCalcState extends State<MetaCalc> {
  final formKey3 = GlobalKey<FormState>();

  double meta = 0;
  double years = 0; //se pasa a meses
  //double interes = 0.063459 / 12; // 6.3459% anual
  double interes = kInteresMeta; // 6.3459% anual

  String rawMeta = '';
  String rawYears = '';

  double result = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey3,
        child: Column(
          children: [
            Text(
              'Calcula una meta',
              style: kTitleStyle,
            ),
            SizedBox(height: 10.0),
            Divider(indent: 30.0, endIndent: 30.0, thickness: 2.0),
            SizedBox(height: 10.0),
            intNumberField('Cuál es tu meta:', 'USD', rawMeta, (String v) {
              rawMeta = v;
              try {
                meta = double.parse(rawMeta.replaceAll(',', ''));
              } catch (e) {
                meta = 0.0;
              }
              return null;
            }, isMoney: true),
            intNumberField('Años para alcanzar la meta:', 'A', rawYears,
                (String v) {
              rawYears = v;
              try {
                years = double.parse(rawYears);
              } catch (e) {
                years = 0.0;
              }
              return null;
            }),
            SizedBox(height: 10.0),
            Divider(indent: 30.0, endIndent: 30.0, thickness: 2.0),
            SizedBox(height: 10.0),
            resultBanner(),
            SizedBox(height: 20.0),
            calculateButton(),
          ],
        ),
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
                if (v.isEmpty && canBeZero == false) {
                  callback('');
                  return 'ERROR';
                }

                return null;
              },
              onSaved: (v) {
                try {
                  callback(v);
                } catch (e) {
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

  Container resultBanner() {
    String _texto;
    if (result.isNaN)
      _texto = '0.00';
    else
      _texto = result.toCurrencyString(
          mantissaLength: 2,
          thousandSeparator: ThousandSeparator.Comma,
          trailingSymbol: ' USD');

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '\$ $_texto',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
          ),
          Text(
            'Ahorro mensual requerido',
            style: TextStyle(color: kGrisclaro),
          ),
        ],
      ),
    );
  }

  Widget calculateButton() {
    _calcular() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      interes = (prefs.getDouble('interesMeta') ?? kInteresMeta);
      setState(() {
        result = Finance.pmt(
                rate: interes / 12,
                nper: years * 12,
                pv: 0,
                fv: meta,
                end: false)
            .abs();
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
        if (formKey3.currentState.validate()) {
          formKey3.currentState.save();
          _calcular();
        }
      },
    );
  }
}
