import 'package:finance/finance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import '../constantes.dart';

class ValorPresenteCalc extends StatefulWidget {
  @override
  _ValorPresenteCalcState createState() => _ValorPresenteCalcState();
}

class _ValorPresenteCalcState extends State<ValorPresenteCalc> {
  double value = 0;
  double years = 0;
  double percent = 0;
  double result = 0;
  String rawValue = '';
  String rawYears = '';
  String rawPercent = '';
  String rawResult = '';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              'Calculadora de valor presente de un fondo que se recibirá en el futuro',
              style: kTitleStyle,
            ),
            SizedBox(height: 10.0),
            Divider(indent: 30.0, endIndent: 30.0, thickness: 2.0),
            SizedBox(height: 10.0),
            intNumberField('Valor futuro del fondo:', '\$', rawValue,
                (String v) {
              rawValue = v;
              try {
                value = double.parse(rawValue.replaceAll(',', ''));
              } catch (e) {
                print(e);
                value = 0.0;
              }
              return null;
            }, isMoney: true),
            intNumberField('Años que faltan para recibirla:', 'A', rawYears,
                (String v) {
              rawYears = v;
              try {
                years = double.parse(rawYears);
              } catch (e) {
                print(e);
                years = 0.0;
              }
              return null;
            }),
            intNumberField('Inflación anual:', '\%', rawPercent, (String v) {
              //percent = v;
              rawPercent = v;
              try {
                percent = double.parse(rawPercent);
              } catch (e) {
                print(e);
                percent = 0.0;
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
                  print(e);
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
        //trailingSymbol: ' USD');
      );

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '\$ $_texto',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
          ),
          Text(
            'Valor actual de la pensión',
            style: TextStyle(color: kGrisclaro),
          ),
        ],
      ),
    );
  }

  Widget calculateButton() {
    _calcular() {
      setState(() {
        result = Finance.pv(rate: percent / 100, nper: years, pmt: 0, fv: value)
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
        if (formKey.currentState.validate()) {
          formKey.currentState.save();

          _calcular();
        }
      },
    );
  }
}
