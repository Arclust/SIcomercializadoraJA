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

// Future<void> ModificarProducto(String tipo,String colegio,String talla,int nuevaCantidad,double nuevoPrecio,) async{
//     final directory = await getApplicationDocumentsDirectory()
// }


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

Future<void> ActualizarProducto(
  String nombre,
  String colegio,
  String talla,
  String cantidad,
  String precio,
  String accion,
  int cantidadAccion,
) async {

  final directory = await getApplicationDocumentsDirectory();
  final rutaArchivo = '${directory.path}/Inventario.csv';
  String csvContent = "";

  try {
    csvContent = await File(rutaArchivo).readAsString();
  } catch (e) {
    print("Error al leer el archivo CSV: $e");
    return;
  }

  final List<List<dynamic>> filas = const CsvToListConverter().convert(csvContent);

  int cantidadActual = int.parse(cantidad);

  for (int i = 0; i < filas.length; i++) {
    // Acceder al elemento i de la lista filas
    String fila = filas[i][0] as String;

    // Dividir la cadena, ignorando los corchetes
    List<String> elemento = fila.substring(0, fila.length).split(';');

    if (
      RegExp(nombre ?? '').hasMatch(elemento[0]) &&
      RegExp(colegio ?? '').hasMatch(elemento[1]) &&
      RegExp(talla ?? '').hasMatch(elemento[2])
    ) {

      switch (accion) {
        case "aumentar":
          cantidadActual+= cantidadAccion;
          break;
        case "disminuir":
          cantidadActual -= cantidadAccion;
//           if (cantidadActual < 0) {
//             cantidadActual = 0;
//           }
          break;
        case "cambiarPrecio":
          elemento[4] = cantidadAccion.toString();
          break;
        default:
          print("Acción inválida.");
          return;
      }
      elemento[3] = cantidadActual.toString();
      filas[i][0] = elemento.join(';');

      final nuevoCsvContent = const ListToCsvConverter().convert(filas);
      await File(rutaArchivo).writeAsString(nuevoCsvContent);
    }
  }

  print("Producto actualizado correctamente.");
}

Future<void> EliminarProducto(String nombre,String colegio,String talla,) async {
  final directory = await getApplicationDocumentsDirectory();
  final rutaArchivo = '${directory.path}/Inventario.csv';
  String csvContent = "";

  try {
  csvContent = await File(rutaArchivo).readAsString();
  } catch (e) {
     print("Error al leer el archivo CSV: $e");
     return;
  }
  final List<List<dynamic>> filas = const CsvToListConverter().convert(csvContent);

  for (int i = 0; i < filas.length; i++) {
    String fila = filas[i][0] as String;

    List<String> elemento = fila.substring(0, fila.length).split(';');

    if (RegExp(nombre ?? '').hasMatch(elemento[0]) &&
        RegExp(colegio ?? '').hasMatch(elemento[1]) &&
        RegExp(talla ?? '').hasMatch(elemento[2])) {
      filas.removeAt(i);

      break;
    }
  }
  final nuevoCsvContent = const ListToCsvConverter().convert(filas);
  await File(rutaArchivo).writeAsString(nuevoCsvContent);

  print("Producto eliminado correctamente.");
}

Future<bool> InicioSesion(String nombreUsuario, String contrasena) async {
  final directory = await getApplicationDocumentsDirectory();
  final rutaArchivo = '${directory.path}/credenciales.csv';
  String csvContent = "";

  try {
    csvContent = await File(rutaArchivo).readAsString();
  } catch (e) {
    print("Error al leer el archivo CSV: $e");
    return false;
  }

  final List<List<dynamic>> filas = const CsvToListConverter().convert(csvContent);

  for (int i = 0; i < filas.length; i++) {
    String fila = filas[i][0] as String;
    List<String> elemento = fila.substring(0, fila.length).split(';');

    if (elemento[0] == nombreUsuario && elemento[1] == contrasena) {
      return true;
    }
  }

  return false;
}

Future<bool> InicioAplicacion() async {
  final directory = await getApplicationDocumentsDirectory();
  final rutaArchivo = '${directory.path}/credenciales.csv';

  if (await File(rutaArchivo).exists()) {
    try {

      String csvContent = await File(rutaArchivo).readAsString();

      if (csvContent.isNotEmpty) {
        return true;
      }
    } catch (e) {
      print("Error al leer el archivo CSV: $e");
    }
  }

  return false;
}


Future<void> RegistrarUsuario(String nombreUsuario,String contrasena) async {
  final directory = await getApplicationDocumentsDirectory();
  final rutaArchivo = '${directory.path}/credenciales.csv';

  final archivo = File(rutaArchivo);
  if (!await archivo.exists()) {
    await archivo.create();
  }

  try {
    final contenido = '$nombreUsuario;$contrasena\n';
    await archivo.writeAsString(contenido, mode: FileMode.append);
    print('Usuario registrado correctamente.');
  } catch (e) {
    print('Error al registrar el usuario: $e');
  }

}