import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Generador de Código QR e Historial',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }


Future<String> AgregarProducto(String tipo, String colegio, String talla, String cantidad, String precio) async {
  try {
    await InsertarFilaCSV('Inventario.csv',['$tipo;$colegio;$talla;$cantidad;$precio']);
  } catch (e) {
    print('Error: $e');
  }
  // String data = '$tipo-$colegio-$talla-$cantidad-$precio';
  // final qrImage = QrImage( 
  //   data: data,
  //   version: QrVersions.auto,
  //   size: 200.0,
  // );
  // final imagePath = 'QRs productos/qr_$tipo.png';

  // final ui.Image image = await qrImage.toImage(200);
  // final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  // Im.Image img = Im.decodePng(byteData!.buffer.asUint8List());
  // Im.Image imageToSave = Im.copyResize(img, width: 200);
  // Im.encodePng(new File(imagePath), imageToSave);
  return '';
}

Future<String> lecturaCSV(String rutaArchivo) async {
  try {
    return rootBundle.loadString(rutaArchivo);
  } catch (e) {
    print('Error al cargar el archivo CSV: $e');
    return ''; // O maneja el error de otra forma
  }
}

Future<void> InsertarFilaCSV(String nombreArchivo, List<String> fila) async {
  try {
    // 1. Obtén la ruta del directorio de documentos de la aplicación.
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    final rutaArchivo = '${directory.path}/$nombreArchivo';

    // 2. Lee el contenido del archivo CSV utilizando rootBundle (si existe).
    String csvContent = "";
    try {
      csvContent = await rootBundle.loadString('assets/$nombreArchivo');
    } catch (e) {
      print("No se pudo leer el archivo CSV desde assets: $e");
      // El archivo no existe en assets, se creará uno nuevo.
    }

    // 3. Convierte el contenido del archivo CSV a una lista de filas.
    final List<List<dynamic>> filas = const CsvToListConverter().convert(csvContent);

    // 4. Agrega la nueva fila a la lista de filas.
    filas.add(fila);

    // 5. Convierte la lista de filas de nuevo a un string CSV.
    final String newCsvContent = const ListToCsvConverter().convert(filas);

    // 6. Escribe el nuevo contenido CSV en el archivo en el directorio de documentos.
    await File(rutaArchivo).writeAsString(newCsvContent);

  } catch (e) {
    print('Error al insertar fila en el archivo CSV: $e');
  }
}



// Future<void> InsertarFilaCSV(String nombreArchivo, List<String> fila) async {
//   try {
//     // Obtiene el directorio de documentos de la aplicación
//     final directory = await getApplicationDocumentsDirectory();
//     final rutaArchivo = '${directory.path}/$nombreArchivo';

//     // Si el archivo no existe en almacenamiento local, cópialo de assets
//     if (!File(rutaArchivo).existsSync()) {
//       final String contenidoInicial = await rootBundle.loadString(nombreArchivo);
//       await File(rutaArchivo).writeAsString(contenidoInicial);
//     }

//     // Lee el contenido del archivo CSV desde el almacenamiento local
//     final String csvContent = await File(rutaArchivo).readAsString();
//     // Convierte el contenido del archivo CSV a una lista de filas
//     final List<List<dynamic>> filas = CsvToListConverter().convert(csvContent);
//     // Agrega la nueva fila a la lista de filas
//     filas.add(fila);
//     // Convierte la lista de filas de nuevo a un string CSV
//     final String newCsvContent = ListToCsvConverter().convert(filas);
//     // Escribe el nuevo contenido CSV en el archivo local
//     await File(rutaArchivo).writeAsString(newCsvContent);
//   } catch (e) {
//     print('Error al insertar fila en el archivo CSV: $e');
//   }
// }

// int contarRegistrosHistorial(String rutaArchivo) {
//   final datos = leerCsv(rutaArchivo);
//   return datos.length;
// }

// void eliminarRegistroAntiguo(String rutaArchivo) {
//   final datos = leerCsv(rutaArchivo);
//   if (datos.isNotEmpty) {
//     datos.removeAt(0);
    
//     final csv = const ListToCsvConverter().convert(datos);
//     File(rutaArchivo).writeAsStringSync(csv);
//     print('Registro más antiguo eliminado.');
//   } else {
//     print('No hay registros para eliminar.');
//   }
// }

// class HomePage extends StatelessWidget {
//   final HistorialManager historialManager = HistorialManager();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Inicio"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 // Ejemplo de agregar un registro al historial
//                 await historialManager.agregarHistorial(
//                     "Agregar", "ProductoX", 5, "L");
//                 print("Registro agregado al historial.");
//               },
//               child: Text("Agregar al Historial"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // Ejemplo de contar registros
//                 int total = await historialManager.contarRegistrosHistorial();
//                 print("Total de registros: $total");
//               },
//               child: Text("Contar Registros"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // // Navegar al generador de QR
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(
//                 //     builder: (context) => QRCodeGenerator(data: "Datos de Ejemplo"),
//                 //   ),
//                 // );
//               },
//               child: Text("Generar Código QR"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HistorialManager {
//   // Obtiene el directorio de documentos del dispositivo
//   Future<String> _getFilePath(String fileName) async {
//     final directory = await getApplicationDocumentsDirectory();
//     return '${directory.path}/$fileName';
//   }

//   // Cargar el historial existente o crear uno nuevo si no existe
//   Future<List<List<dynamic>>> cargarHistorial() async {
//     final filePath = await _getFilePath('historial.csv');
//     final file = File(filePath);

//     if (await file.exists()) {
//       final content = await file.readAsString();
//       return CsvToListConverter().convert(content);
//     } else {
//       // Crear un archivo nuevo con encabezados
//       await file.writeAsString(const ListToCsvConverter().convert([
//         ["tipo_accion", "tipo_producto", "cantidad_h", "talla_h", "hora"]
//       ]));
//       return [];
//     }
//   }

//   // Contar registros en el historial
//   Future<int> contarRegistrosHistorial() async {
//     final historial = await cargarHistorial();
//     return historial.length - 1; // Resta 1 para no contar la fila de encabezado
//   }

//   // Eliminar el registro más antiguo (segunda fila del historial)
//   Future<void> eliminarRegistroAntiguo() async {
//     final filePath = await _getFilePath('historial.csv');
//     final file = File(filePath);

//     if (await file.exists()) {
//       final historial = await cargarHistorial();
//       if (historial.length > 1) {
//         // Eliminar el primer registro de datos
//         historial.removeAt(1);
//         final updatedContent = const ListToCsvConverter().convert(historial);
//         await file.writeAsString(updatedContent);
//         print("Registro más antiguo eliminado.");
//       } else {
//         print("No hay registros para eliminar.");
//       }
//     }
//   }

//   // Agregar un nuevo registro al historial
//   Future<void> agregarHistorial(
//       String accion, String producto, int cantidad, String talla) async {
//     final filePath = await _getFilePath('historial.csv');
//     final file = File(filePath);
//     final DateTime now = DateTime.now();
//     final nuevoRegistro = [
//       accion,
//       producto,
//       cantidad,
//       talla,
//       now.toIso8601String()
//     ];

//     final historial = await cargarHistorial();
//     historial.add(nuevoRegistro);
//     final updatedContent = const ListToCsvConverter().convert(historial);
//     await file.writeAsString(updatedContent);
//   }
// }

// Widget para generar el código QR
// class QRCodeGenerator extends StatelessWidget {
//   final String data;

//   QRCodeGenerator({required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Generador de Código QR"),
//       ),
//       body: Center(
//         // child: QrImage(
//         //   data: data,
//         //   version: QrVersions.auto,
//         //   size: 200.0,
//         // ),
//       ),
//     );
//   }
// }
