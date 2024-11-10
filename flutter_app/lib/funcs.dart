import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';



Future<void> CrearInventario() async{
  print("a");
}



Future<List<dynamic>> AgregarProducto(String tipo, String colegio, String talla, String cantidad, String precio) async {
  List<dynamic> fila = [];
  try {
    String qrImagePath = await generarQRProducto(tipo, colegio, talla, cantidad, precio);
    print('QR generado en: $qrImagePath');
    await InsertarFilaCSV('Inventario.csv',['$tipo;$colegio;$talla;$cantidad;$precio;$qrImagePath']);
    fila = [tipo,colegio,talla,cantidad,precio,qrImagePath];
  } catch (e) {
    print('Error: $e');
  }
  return fila;
}



Future<String> generarQRProducto(String tipo, String colegio, String talla, String cantidad, String precio) async {
  try {
    // Crear código QR
    String data = '$tipo-$colegio-$talla-$cantidad-$precio';

    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: false,
    );

    // Obtener el directorio de documentos
    final directory = await getApplicationDocumentsDirectory();

    // Crear una carpeta llamada "QRs" si no existe
    final qrDirectory = Directory('${directory.path}/QRs');
    if (!await qrDirectory.exists()) {
      await qrDirectory.create();
    }

    // Guardar la imagen QR en la carpeta "QRs"
    final imagePath = '${qrDirectory.path}/qr_$tipo.png';

    // Crear una imagen a partir del QrPainter
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final size = Size(200, 200);
    qrPainter.paint(canvas, size);

    final img = await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    await File(imagePath).writeAsBytes(byteData!.buffer.asUint8List());

    return imagePath; // Devuelve la ruta de la imagen QR
  } catch (e) {
    print('Error al generar QR: $e');
    return ''; // Devuelve una cadena vacía en caso de error
  }
}








Future<void> InsertarFilaCSV(String nombreArchivo, List<String> fila) async {
  try {
    // 1. Obtén la ruta del directorio de documentos de la aplicación.
    final directory = await getApplicationDocumentsDirectory();
    final rutaArchivo = '${directory.path}/$nombreArchivo';

    // 2. Lee el contenido del archivo CSV utilizando rootBundle (si existe).
    String csvContent = "";
    if (await File(rutaArchivo).exists()) {
      csvContent = await File(rutaArchivo).readAsString();
    } else{
      csvContent = await rootBundle.loadString('assets/$nombreArchivo');
    }
    // 3. Convierte el contenido del archivo CSV a una lista de filas.
    final List<List<dynamic>> filas =
    const CsvToListConverter().convert(csvContent);

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

Future<List<List<dynamic>>> FiltrarProductos(

    String? nombre,
    String? colegio,
    String? talla,
    RangeValues rangoCantidad,
    RangeValues rangoPrecio) async {

  final directory = await getApplicationDocumentsDirectory();
  final rutaArchivo = '${directory.path}/Inventario.csv';
  String csvContent = "";

  try {
    csvContent = await File(rutaArchivo).readAsString();
  } catch (e) {
    print("Error al leer el archivo CSV: $e");
    return [];
  }

  final List<List<dynamic>> filas = const CsvToListConverter().convert(csvContent);

  final List<List<dynamic>> ProductosFiltrados = [];;

  for (int i = 0; i < filas.length; i++) {
    // Acceder al elemento i de la lista filas
    String fila = filas[i][0] as String;

    // Dividir la cadena, ignorando los corchetes
    List<String> elemento = fila.substring(0, fila.length).split(';');

    if (
      RegExp(nombre ?? '').hasMatch(elemento[0]) &&
        RegExp(colegio ?? '').hasMatch(elemento[1]) &&
        RegExp(talla ?? '').hasMatch(elemento[2]) &&
        (int.parse(elemento[3]) >= rangoCantidad.start && int.parse(elemento[3]) <= rangoCantidad.end) &&
        (int.parse(elemento[4]) >= rangoPrecio.start && int.parse(elemento[4]) <= rangoPrecio.end)
    ) {
      ProductosFiltrados.add(filas[i]);
    }
  }

  return ProductosFiltrados;
}



Future<void> GuardarArchivo(File archivo, BuildContext context) async {
  try {
    // Obtener la carpeta de descargas del dispositivo
    final directory = await getExternalStorageDirectory();

    // Crear un nuevo nombre de archivo (opcional)
    // Puedes personalizar el nombre basado en el nombre original del archivo
    final nuevoNombre = 'copia_de_${archivo.path.split('/').last}';

    // Crear la ruta completa del nuevo archivo
    final nuevaRuta = '${directory?.path}/$nuevoNombre';

    // Copiar el archivo a la nueva ubicación
    await archivo.copy(nuevaRuta);

    // Informar al usuario (puedes usar un snackbar o un diálogo)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Archivo guardado exitosamente')),
    );
  } catch (e) {
    // Mostrar un mensaje de error al usuario
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al guardar el archivo: $e')),
    );
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
