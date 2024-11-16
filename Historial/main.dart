import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

List<Map<String, dynamic>> df_productos = [];
List<Map<String, dynamic>> df_historial = [];

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
  df_historial = await cargarCSV('historial.csv');
}

// Contar registros en el historial
int contar_registros_historial() {
  return df_historial.length;
}

// Eliminar el registro más antiguo de forma asincrónica
Future<void> EliminarRegistroAntiguo() async {
  if (df_historial.isNotEmpty) {
    df_historial.removeAt(0);
    await guardarCSV('historial.csv', df_historial, overwrite: true);
    print("Registro más antiguo eliminado.");
  } else {
    print("No hay registros para eliminar.");
  }
}

// Agregar un nuevo registro al historial de forma asincrónica
Future<void> Agregar_historial(String accion, String producto, int cantidad, String talla) async {
  Map<String, dynamic> ultima_modificacion = {
    "tipo_accion": accion,
    "tipo_producto": producto,
    "cantidad_h": cantidad,
    "talla_h": talla,
    "hora": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
  };

  // Guardar el nuevo registro al archivo
  await guardarCSV('historial.csv', [ultima_modificacion], append: true);

  // Recargar df_historial para reflejar el nuevo estado del archivo
  df_historial = await cargarCSV('historial.csv');
}

// Función para guardar una lista de mapas como CSV de forma asincrónica
Future<void> guardarCSV(String filePath, List<Map<String, dynamic>> data, {bool append = false, bool overwrite = false}) async {
  if (data.isEmpty) return;

  List<List<dynamic>> rows = [];

  if (!append || overwrite) {
    // Agregar encabezados si no estamos agregando al archivo existente
    rows.add(data[0].keys.toList());
  }

  for (var registro in data) {
    rows.add(registro.values.toList());
  }

  String csvData = const ListToCsvConverter(fieldDelimiter: ';').convert(rows);

  if (append && !overwrite) {
    // Agregar al final del archivo
    await File(filePath).writeAsString(csvData + '\n', mode: FileMode.append, encoding: utf8);
  } else {
    // Sobreescribir el archivo
    await File(filePath).writeAsString(csvData, encoding: utf8);
  }
}

Future<List<Map<String, dynamic>>> procesarCSV(String rutaCSV) async {
  final List<Map<String, dynamic>> movimientos = [];
  final File archivo = File(rutaCSV);

  if (await archivo.exists()) {
    // Leer el archivo CSV
    final List<String> lineas = await archivo.readAsLines();

    // Procesar cada línea del archivo (asumiendo que tiene encabezados)
    for (int i = 1; i < lineas.length; i++) {
      final String linea = lineas[i];
      final List<String> columnas = linea.split(';');

      // Crear un registro basado en las columnas (ajusta los índices si es necesario)
      movimientos.add({
        'acción': columnas[0].trim(), // Ajusta según las columnas del CSV
        'descripción': columnas[1].trim(),
        'fecha': columnas[2].trim(),
      });
    }
  } else {
    print('El archivo no existe en la ruta proporcionada: $rutaCSV');
  }

  return movimientos;
}
void main() async {
  // Cargar los datos iniciales de los archivos CSV
  await cargarDatos();

  // Ejemplos de uso
  print("Total de registros en historial antes de agregar: ${contar_registros_historial()}");
  await Agregar_historial("Agregar", "Producto X", 5, "L");
  await Agregar_historial("Agregar", "Producto Y", 10, "M");
  await Agregar_historial("Agregar", "Producto Z", 3, "S");
  print("Total de registros en historial después de agregar: ${contar_registros_historial()}");
  final String rutaCSV = 'historial.csv'; // Ruta al archivo CSV
  final List<Map<String, dynamic>> datos = await procesarCSV(rutaCSV);

  // Imprimir los datos procesados
  for (var movimiento in datos) {
    print(movimiento);
  }
}
