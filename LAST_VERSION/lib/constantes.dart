import 'package:flutter/material.dart';

const Color kGrisOscuro = Color(0xFFA3A399);
const Color kGrisclaro = Color(0xFFA9A9A1);
const Color kAzul = Color(0xFF1A2375);

const double kInteresesAportacion = 0.06391;
const double kInteresMeta = 0.063459;

const TextStyle kTitleStyle = TextStyle(
  fontSize: 16.0,
  color: kAzul,
  fontWeight: FontWeight.w600,
);

//const String textoLargo  = ' texto linea 1 texto linea 2 texto linea 3texto linea 1 texto linea 2texto linea 3texto linea 1 \n texto linea 2 \n texto linea 3 texto linea 1 \n texto linea 2 \n texto linea 3';

const String textoLargo = '''Plazos disponibles: 
  • Mínimo 5 años 
  • máximo 20 años 
  • Periodo preliminar 12 meses 
\u9658 Edades de aceptación
  ► Mínimo 18 años
  Máximo 80 años (a la conclusión del plan)
Formas de pago y aportación mínima
  Mensual, con mínimo de \$250.00 dólares
  Trimestral, con mínimo de \$750.00 dólares
  Semestral, con mínimo de \$1,500.00 dólares
  Anual, con mínimo de \$3,000.00 dólares
Método de pago
  Visa
  MasterCard
  Transferencia
Aportaciones extraordinarias
  Se puede hacer en cualquier momento, mínimo \$1,500 dólares''';

List<String> contenidoList = [
  'Plazos disponibles:',
  ' Mínimo 5 años',
  ' máximo 20 años',
  'Periodo preliminar 12 meses',
  'Edades de aceptación',
  ' Mínimo 18 años',
  ' Máximo 80 años (a la conclusión del plan)',
  'Formas de pago y aportación mínima',
  ' Mensual, con mínimo de \$250.00 dólares',
  ' Trimestral, con mínimo de \$750.00 dólares',
  ' Semestral, con mínimo de \$1,500.00 dólares',
  ' Anual, con mínimo de \$3,000.00 dólares',
  'Método de pago',
  ' Visa',
  ' MasterCard',
  ' Transferencia',
  'Aportaciones extraordinarias',
  ' Se puede hacer en cualquier momento, mínimo \$1,500 dólares',
];


const String kTextoConfigPage1  = 'Aquí encuentra las variables correspondientes al interés anual usado en la calculadora de plan retiro y de meta, no se recomienda modificar estos valores sino sabe cómo afectan a los cálculos realizados en las opciones anteriormente descritas.';
const String kTextoConfigPage2 = 'Si desea continuar, en los 2 campos de texto de abajo puede colocar los valores que desea usar para los cálculos, modifíquelos según se requiera y luego presione el botón guardar, tenga en cuenta que una vez guardados estos valores debe volver a presionar el boton de calcular para actualizar el resultado con el nuevo valor introducido en el campo de interes.';
const String kTextoConfigPage3 = 'El valor debe ser introducido en notación decimal por ejemplo: 0.63459.';

