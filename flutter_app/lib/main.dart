import 'package:flutter/material.dart';
import 'funcs.dart' as funcs;
//import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SI - uniformes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 41, 125, 139)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SI - uniformes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // ... other widgets
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()),
                );
              },
              child: const Text('Agregar producto'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ScanQrScreen()),
                // );
              },
              child: const Text('Modificar producto'),
            ),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Eliminar producto'),
            ),
          ],
        ),
      ),
    );
  }
}






class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tipo de producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '¡Falta el nombre del producto!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _schoolController,
                decoration: const InputDecoration(labelText: 'Colegio del producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '¡Falta el colegio al que pertenece!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: 'Talla del producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '¡Falta la talla la cual es!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _unitsController,
                decoration: const InputDecoration(labelText: 'Cantidad del producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '¡Falta una cantidad inicial!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio del producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '¡Falta el precio por unidad!';
                  }
                  return null;
                },
              ),
              // ... otros TextFormField para descripción y precio
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String urlQRcode = await funcs.AgregarProducto(_nameController.text,_schoolController.text,_sizeController.text,_unitsController.text,_priceController.text);
                    print(urlQRcode);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// class ScanQrScreen extends StatefulWidget {
//   @override
//   _ScanQrScreenState createState() => _ScanQrScreenState();
// }

// class _ScanQrScreenState extends State<ScanQrScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   var qrResult;

//   Iniciar y parar el escaneo
//   void _onQRViewCreated(QRViewController controller) {
//     ...
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: QRView(
//         key: qrKey,
//         onQRViewCreated: _onQRViewCreated,
//       ),
//     );
//   }
// }