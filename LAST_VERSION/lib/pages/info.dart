import 'package:flutter/material.dart';

import '../constantes.dart';

//final Color backGroundColor = Colors.indigo;
final Color backGroundColor = Color.fromRGBO(0, 21, 62, 1);

class InfoPage extends StatelessWidget {

List<Widget> buildContentList() {
    List<Widget> _list = [];

    contenidoList.forEach(
      (element) {
        if (element.startsWith(' '))
          element = '     ' + '►  $element';
        else
          element = '►  $element';
        _list.add(
          Text(
            element,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w200),
          ),
        );
      },
    );

    return _list;
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: true,
      backgroundColor: backGroundColor,
      appBar: AppBar(
        
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12.0),
              _logoHeader(),
              SizedBox(height: 12.0),
              _planRow(),
              SizedBox(height: 16.0),
              _dominionRow(),
              SizedBox(height: 16.0),
              _institutionRow(),
              SizedBox(height: 16.0),
              _strategyRow(),
              SizedBox(height: 16.0),
              _contentRow(),
            ],
          ),
        ),
      ),
    );
  }

  Container _institutionRow() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2.0),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text:
                    '► Institución de servicios financieros registrada en el Reino Unido.',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _contentRow() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildContentList(),
      ),
    );
  }

  Row _strategyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Caracteristicas principales:',
            style: TextStyle(color: Colors.white , decoration: TextDecoration.underline),
          ),
        ),
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 5,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/strategy.png',
              width: 140.0,
            ),
          ),
        ),
      ],
    );
 
  }

  Row _dominionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Dominion Capital Strategies',
            style: TextStyle(color: Colors.white , decoration: TextDecoration.underline ),
          ),
        ),
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 5,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/dominion.png',
              width: 140.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _planRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Plan de ahorro regular',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 5,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'MY SAVINGS STRATEGY',
              style: TextStyle(
                  color: Colors.yellow, decoration: TextDecoration.underline),
            ),
          ),
        ),

      ],
    );
  }

  Container _logoHeader() {
    return Container(
      height: 100.0,
      child: Image.asset(
        'assets/logo_large.png',
      ),
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   color: Colors.white30,
      // ),
    );
  }
}
