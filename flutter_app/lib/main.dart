import 'dart:io';

import 'package:flutter/material.dart';
import 'funcs.dart' as funcs;
//import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  //funcs.CrearInventario();
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
                  MaterialPageRoute(builder: (context) => const AddProductScreen()),
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
              child: const Text('Actualizar producto'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: const Text('Buscador de productos'),
            ),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Generar reporte'),
            ),
          ],
        ),
      ),
    );
  }
}





// PANTALLA AGREGAR PRODUCTOS

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
                    List<dynamic> NuevoProducto = await funcs.AgregarProducto(_nameController.text,_schoolController.text,_sizeController.text,_unitsController.text,_priceController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductDetailsScreen(nombre: NuevoProducto[0],colegio: NuevoProducto[1],talla: NuevoProducto[2],cantidad: NuevoProducto[3],precio: NuevoProducto[4], direccionqr: NuevoProducto[5],)),
                    );
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



//PANTALLA DE DETALLES PRODUCTO

class ProductDetailsScreen extends StatefulWidget {
  final String nombre;
  final String colegio;
  final String talla;
  final String cantidad;
  final String precio;
  final String direccionqr;

  const ProductDetailsScreen({
    super.key,
    required this.nombre,
    required this.colegio,
    required this.talla,
    required this.cantidad,
    required this.precio,
    required this.direccionqr,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final File imageFile = File(widget.direccionqr);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${widget.nombre}'),
            Text('Colegio: ${widget.colegio}'),
            Text('Talla: ${widget.talla}'),
            Text('Cantidad: ${widget.cantidad}'),
            Text('Precio: ${widget.precio}'),
            SizedBox(height: 16.0), // Add some spacing,
            Image.file(imageFile),
            const SizedBox(height: 16.0), // Add some spacing between image and button
            ElevatedButton(
              onPressed: () async {
                await funcs.GuardarArchivo(imageFile, context);
              },
              child: const Text('Descargar QR'),
            ),
          ],
        ),
      ),
    );
  }
}


//PANTALLA BUSQUEDA CON FILTROS


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Widget> additionalButtons = [];
  String? selectedName;
  String? selectedCollege;
  String? selectedSize;
  RangeValues quantityRange = const RangeValues(0, 1000);
  RangeValues priceRange = const RangeValues(0, 50000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros de Búsqueda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  selectedName = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  selectedCollege = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Colegio'),
            ),
            DropdownButton<String>(
              value: selectedSize,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSize = newValue;
                });
              },
              items: <String>['','S', 'M', 'L', 'XL'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text('Talla'),
            ),
            const Text('Rango de Cantidad'),
            RangeSlider(
              values: quantityRange,
              min: 0,
              max: 1000,
              divisions: 100,
              labels: RangeLabels(
                quantityRange.start.toString(),
                quantityRange.end.toString(),
              ),
              onChanged: (RangeValues newRange) {
                setState(() {
                  quantityRange = newRange;
                });
              },
            ),
            const Text('Rango de precio'),
            RangeSlider(
              values: priceRange,
              min: 0,
              max: 50000,
              divisions: 100,
              labels: RangeLabels(
                priceRange.start.toString(),
                priceRange.end.toString(),
              ),
              onChanged: (RangeValues newRange) {
                setState(() {
                  priceRange = newRange;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                // Aquí se aplicaría la lógica para filtrar los productos
                final filtrados = await funcs.FiltrarProductos(selectedName, selectedCollege, selectedSize, quantityRange, priceRange);
                print(filtrados);
                setState(() {
                  additionalButtons = [];
                  for (int i = 0; i < filtrados.length; i++){
                    String filtrado = filtrados[i][0] as String;

                    // Dividir la cadena, ignorando los corchetes
                    List<String> elemento = filtrado.substring(0, filtrado.length).split(';');
                    additionalButtons.add(
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProductDetailsScreen(nombre: elemento[0],colegio: elemento[1],talla: elemento[2],cantidad: elemento[3],precio: elemento[4], direccionqr: elemento[5],)),
                          );
                        },
                        child: Text(elemento[0]),
                      ),
                    );
                  }

                });
              },
              child: const Text('Aplicar Filtros'),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  // ... other elements
                  ...additionalButtons,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
