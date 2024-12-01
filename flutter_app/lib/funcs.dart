import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

List<Map<String, dynamic>> df_productos = [];
List<Map<String, dynamic>> df_historial = [];

Future<List<Map<String, dynamic>>> LeerHistorial() async {
  final List<Map<String, dynamic>> movimientos = [];
  final directory = await getApplicationDocumentsDirectory();
  final File archivo = File('${directory.path}/Historial.csv');

  if (await archivo.exists()) {
    // Leer el archivo CSV
    final List<String> lineas = await archivo.readAsLines();

    // Procesar cada línea del archivo (asumiendo que tiene encabezados)
    for (int i = 1; i < lineas.length; i++) {
      final String linea = lineas[i];
      final List<String> columnas = linea.split(';');

      // Crear un registro basado en las columnas (ajusta los índices si es necesario)
      movimientos.add({
        'accion': columnas[0].trim(), // Ajusta según las columnas del CSV
        'producto': columnas[1].trim(),
        'cantidad': columnas[2].trim(),
        'talla': columnas[3].trim(),
        'fecha': columnas[4].trim(),
      });
    }
  } else {
    print('El archivo no existe en la ruta proporcionada');
  }

  return movimientos;
}

// Función para cargar archivos CSV en una lista de mapas de manera asincrónica
Future<List<Map<String, dynamic>>> cargarCSV(String filePath) async {
  final file = File(filePath);

  if (!await file.exists()) {
    return [];
  }

  final csvData = await file.readAsString();
  List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(fieldDelimiter: ';', eol: '\n').convert(csvData);

  List<Map<String, dynamic>> registros = [];
  List<String> headers = rowsAsListOfValues[0].map((header) => header.toString()).toList();

  for (var i = 1; i < rowsAsListOfValues.length; i++) {
    Map<String, dynamic> registro = {};
    for (var j = 0; j < headers.length; j++) {
      registro[headers[j]] = rowsAsListOfValues[i][j];
    }
    registros.add(registro);
  }

  return registros;
}

// Cargar el archivo de productos e historial (si existe) de forma asincrónica
Future<void> cargarDatos() async {
  df_productos = await cargarCSV('InventarioPruebas.csv');
  df_historial = await cargarCSV('Historial.csv');
}

// Contar registros en el historial
int contar_registros_historial() {
  return df_historial.length;
}



// Agregar un nuevo registro al historial de forma asincrónica
Future<void> AgregarHistorial(String accion, String producto, int cantidad, String talla) async {

  var horaAccion = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  List<String> ultima_modificacion = ['$accion;$producto;$cantidad;$talla;$horaAccion;'];

  // Guardar el nuevo registro al archivo
  await InsertarFilaCSV('Historial.csv', ultima_modificacion);
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
    // Verificar si el archivo existe antes de copiarlo
    if (!archivo.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El archivo no existe para guardar.')),
      );
      return;
    }

    // Definir la carpeta de descargas
    final directory = Directory('/storage/emulated/0/Download');

    // Crear la carpeta de descargas si no existe (en dispositivos antiguos puede ser necesario)
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Crear un nuevo nombre para el archivo
    final nuevoNombre = 'copia_de_${archivo.path.split('/').last}';
    final nuevaRuta = '${directory.path}/$nuevoNombre';

    // Copiar el archivo a la carpeta de descargas
    await archivo.copy(nuevaRuta);

    // Informar al usuario que el archivo fue guardado exitosamente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Archivo guardado exitosamente en Descargas como $nuevoNombre')),
    );

    // Imprimir la ruta para depuración
    print('Archivo guardado en: $nuevaRuta');
  } catch (e) {
    // Mostrar un mensaje de error si ocurre una excepción
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al guardar el archivo: $e')),
    );

    // Imprimir el error en la consola para depuración
    print('Error: $e');
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

    String fila = filas[i][0] as String;


    List<String> elemento = fila.substring(0, fila.length).split(';');

    if (
    RegExp(nombre ?? '').hasMatch(elemento[0]) &&
        RegExp(colegio ?? '').hasMatch(elemento[1]) &&
        RegExp(talla ?? '').hasMatch(elemento[2])
    ) {

      switch (accion) {
        case "aumentar":
          cantidadActual+= cantidadAccion;
          await AgregarHistorial("Aumentar", nombre, cantidadAccion, talla);
          break;
        case "disminuir":
          cantidadActual -= cantidadAccion;
          await AgregarHistorial("Disminuir", nombre, cantidadAccion, talla);
          break;
        case "cambiarPrecio":
          elemento[4] = cantidadAccion.toString();
          await AgregarHistorial("Cambio precio", nombre, cantidadAccion, talla);
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
    // Leer el contenido del archivo CSV
    csvContent = await File(rutaArchivo).readAsString();
  } catch (e) {
    print("Error al leer el archivo CSV: $e");
    return false; // Retornar falso si no se puede leer el archivo
  }

  // Convertir el contenido del CSV a una lista
  final List<List<dynamic>> filas = const CsvToListConverter().convert(csvContent, fieldDelimiter: ';');

  // Iterar sobre cada fila del CSV
  for (var fila in filas) {
    if (fila.length < 2) continue; // Ignorar filas inválidas

    final usuario = fila[0].toString().trim();
    final clave = fila[1].toString().trim();

    // Comparar usuario y contraseña
    if (usuario == nombreUsuario && clave == contrasena) {
      return true; // Credenciales correctas
    }
  }

  return false; // Credenciales incorrectas
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

Future<void> ReporteDiario(List<Map<String, dynamic>> historial) async {
  final pdf = pw.Document();
  final fechaActual = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // Filtrar las transacciones del día actual
  final transaccionesDia = historial.where((registro) => registro['fecha'].substring(0, 10) == fechaActual).toList();

  // Crear un mapa para almacenar el total por producto
  final Map<String, Map<String, int>> resumenPorProducto = {};

  // Procesar cada transacción
  for (var transaccion in transaccionesDia) {
    final tipoAccion = transaccion['accion'];
    final producto = transaccion['producto'];
    final cantidad = int.parse(transaccion['cantidad']);

    // Si el producto no existe, inicializar las variables
    if (!resumenPorProducto.containsKey(producto)) {
      resumenPorProducto[producto] = {
        'totalAumentado': 0,
        'totalDisminuido': 0,
        'recaudacion': 0,
      };
    }

    // Actualizar el resumen por producto
    if (tipoAccion == 'Disminuir') {
      resumenPorProducto[producto]!['totalDisminuido'] = (resumenPorProducto[producto]!['totalDisminuido'] ?? 0) + cantidad;
    } else if (tipoAccion == 'Aumentar') {
      resumenPorProducto[producto]!['totalAumentado'] = (resumenPorProducto[producto]!['totalAumentado'] ?? 0) + cantidad;
    }
  }

  // Crear los datos de la tabla para el PDF
  final List<List<String>> datosTabla = [
    ['Producto', 'Total Aumentado', 'Total Disminuido', 'Recaudación del Día'], // Encabezados
  ];

  // Usar un bucle tradicional para manejar operaciones asíncronas
  for (var producto in resumenPorProducto.keys) {
    final valores = resumenPorProducto[producto]!;

    // Llamar a la función asíncrona para obtener el precio del producto
    final filtrado = await FiltrarProductos(
      producto,
      null,
      null,
      const RangeValues(0, double.infinity),
      const RangeValues(0, double.infinity),
    );

    String filtradoPost = filtrado[0][0] as String;
    List<String> elemento = filtradoPost.split(';');
    final precio = double.tryParse(elemento[4]) ?? 0.0;

    final totalAumentado = valores['totalAumentado'] ?? 0;
    final totalDisminuido = valores['totalDisminuido'] ?? 0;

    // Calcular la recaudación como el precio multiplicado por la cantidad disminuida
    final recaudacion = precio * totalDisminuido;

    datosTabla.add([
      producto,
      totalAumentado.toString(),
      totalDisminuido.toString(),
      recaudacion.toStringAsFixed(2), // Formatear a dos decimales
    ]);
  }

  // Añadir contenido al PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text(
              'Reporte Diario de Transacciones - $fechaActual',
              style: pw.TextStyle(font: pw.Font.courier(), fontSize: 24), // Fuente Courier por defecto
            ),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              data: datosTabla,
              headerStyle: pw.TextStyle(font: pw.Font.courierBold()), // Courier en negrita
              cellStyle: pw.TextStyle(font: pw.Font.courier()), // Courier normal
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ],
        );
      },
    ),
  );

  // Guardar el archivo PDF
  final bytes = await pdf.save();
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/reporte_diario_transacciones$fechaActual.pdf');
  await file.writeAsBytes(bytes);
}
