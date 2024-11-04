import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generador de Código QR e Historial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final HistorialManager historialManager = HistorialManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Ejemplo de agregar un registro al historial
                await historialManager.agregarHistorial(
                    "Agregar", "ProductoX", 5, "L");
                print("Registro agregado al historial.");
              },
              child: Text("Agregar al Historial"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Ejemplo de contar registros
                int total = await historialManager.contarRegistrosHistorial();
                print("Total de registros: $total");
              },
              child: Text("Contar Registros"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegar al generador de QR
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodeGenerator(data: "Datos de Ejemplo"),
                  ),
                );
              },
              child: Text("Generar Código QR"),
            ),
          ],
        ),
      ),
    );
  }
}

class HistorialManager {
  // Obtiene el directorio de documentos del dispositivo
  Future<String> _getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  // Cargar el historial existente o crear uno nuevo si no existe
  Future<List<List<dynamic>>> cargarHistorial() async {
    final filePath = await _getFilePath('historial.csv');
    final file = File(filePath);

    if (await file.exists()) {
      final content = await file.readAsString();
      return CsvToListConverter().convert(content);
    } else {
      // Crear un archivo nuevo con encabezados
      await file.writeAsString(const ListToCsvConverter().convert([
        ["tipo_accion", "tipo_producto", "cantidad_h", "talla_h", "hora"]
      ]));
      return [];
    }
  }

  // Contar registros en el historial
  Future<int> contarRegistrosHistorial() async {
    final historial = await cargarHistorial();
    return historial.length - 1; // Resta 1 para no contar la fila de encabezado
  }

  // Eliminar el registro más antiguo (segunda fila del historial)
  Future<void> eliminarRegistroAntiguo() async {
    final filePath = await _getFilePath('historial.csv');
    final file = File(filePath);

    if (await file.exists()) {
      final historial = await cargarHistorial();
      if (historial.length > 1) {
        // Eliminar el primer registro de datos
        historial.removeAt(1);
        final updatedContent = const ListToCsvConverter().convert(historial);
        await file.writeAsString(updatedContent);
        print("Registro más antiguo eliminado.");
      } else {
        print("No hay registros para eliminar.");
      }
    }
  }

  // Agregar un nuevo registro al historial
  Future<void> agregarHistorial(
      String accion, String producto, int cantidad, String talla) async {
    final filePath = await _getFilePath('historial.csv');
    final file = File(filePath);
    final DateTime now = DateTime.now();
    final nuevoRegistro = [
      accion,
      producto,
      cantidad,
      talla,
      now.toIso8601String()
    ];

    final historial = await cargarHistorial();
    historial.add(nuevoRegistro);
    final updatedContent = const ListToCsvConverter().convert(historial);
    await file.writeAsString(updatedContent);
  }
}

// Widget para generar el código QR
class QRCodeGenerator extends StatelessWidget {
  final String data;

  QRCodeGenerator({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generador de Código QR"),
      ),
      body: Center(
        child: QrImage(
          data: data,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
