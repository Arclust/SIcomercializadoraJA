import 'dart:io';
import 'package:flutter/material.dart';
import 'funcs.dart' as funcs;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

void main() {
  runApp(MyApp());
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool _usuarioExiste = false;
//
//   @override
//   Future<void> initState() async{
//     _usuarioExiste = await funcs.InicioAplicacion();
//     print(_usuarioExiste);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return _usuarioExiste
//         ? MyHomePage(title: 'Camiloco')
//         : MyHomePage(title: 'Camiloco');
//   }
// }

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
      home: const MyHomePage(title: 'Johanna'),
    );
  }
}


//PANTALLA DE REGISTRO USUARIO

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.blue.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Registro de usuario',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _userController, // Assign the controller
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        hintText: 'Ingrese su nombre de usuario',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController, // Assign the controller
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Ingrese su contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar contraseña',
                        hintText: 'Ingrese su contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await funcs.RegistrarUsuario(_userController.text, _passwordController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage(title: _userController.text)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Registrar usuario',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


//PANTALLA INICIO DE SESION


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Container(
        color: Colors.blue.shade200, // Fondo azul shade 200
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _passwordController, // Assign the controller
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      hintText: 'Ingrese su nombre de usuario',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController, // Assign the controller
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      hintText: 'Ingrese su contraseña',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      await funcs.InicioSesion(_userController as String, _passwordController as String);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(title: _userController as String,)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color de fondo del botón
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                    ),
                    child: Text('Iniciar Sesión'),
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      // Acción de "Olvidaste la contraseña"
                    },
                    child: const Text(
                      '¿Olvidaste la contraseña?',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3D9CA8), // Color similar al de la barra superior en la imagen
        title: const Text('¡Hola! ¿Que deseas hacer?'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.png'), // Asegúrate de que la imagen esté en la ruta correcta
            fit: BoxFit.cover, // Ajusta la imagen para cubrir toda la pantalla
          ),

        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Alinea al inicio del centro
            children: [
              SizedBox(height: 80), // Espacio en la parte superior
              SizedBox(
                width: 355,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddProductScreen()),
                    );
                  },
                  child: Text(
                    "Agregar producto",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre los botones
              SizedBox(
                width: 355,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScanQRScreen()),
                    );
                  },
                  child: Text(
                    "Actualizar producto",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre los botones
              SizedBox(
                width: 355,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchScreen()),
                    );
                  },
                  child: Text(
                    "Buscador de productos",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre los botones
              SizedBox(
                width: 355,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReportScreen()),
                    );
                  },
                  child: Text(
                    "Generar reporte",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre los botones
              SizedBox(
                width: 355,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MovementsScreen()),
                    );
                  },
                  child: Text(
                    "Historial de movimientos",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


  Widget _buildMenuButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0), // Ajuste de padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }


//PANTALLA PRINCIPAL


/*class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('¡Hola ${widget.title}!¿Que te gustaria hacer?'),
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
                Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => ScanQRScreen()),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportScreen()),
                );
              },
              child: const Text('Generar reporte'),
            ),
            ElevatedButton(
              onPressed: () {
                //funcs.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovementsScreen()),
                );
              },
              child: const Text('Historial de movimientos'),
            ),
          ],
        ),
      ),
    );
  }
}*/

// PANTALLA HISTORIAL DE MOVIMIENTOS

class MovementsScreen extends StatefulWidget {
  const MovementsScreen({super.key});

  @override
  _MovementsScreenState createState() => _MovementsScreenState();
}

class _MovementsScreenState extends State<MovementsScreen> {
  // Datos de ejemplo para los movimientos
  final List<Map<String, dynamic>> movimientos = [
    {"accion": "add", "producto": "Polera negra", "cantidad": "9", "talla": "L", "fecha": "2023-11-14"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial de Movimientos"),
      ),
      body: ListView.builder(
        itemCount: movimientos.length,
        itemBuilder: (context, index) {
          final movimiento = movimientos[index];
          final color = obtenerColor(movimiento["accion"]);

          return Card(
            color: color.withOpacity(0.3),
            child: ListTile(
              leading: Icon(
                obtenerIcono(movimiento["accion"]),
                color: color,
              ),
              title: Text(
                movimiento["producto"],
                style: TextStyle(color: color),
              ),
              subtitle: Text(
              'Cantidad: ${movimiento['cantidad']}, Talla: ${movimiento['talla']}, Fecha: ${movimiento['fecha']}',
              ),
            ),
          );
        },
      ),
    );
  }

  // Retorna el color dependiendo de la acción
  Color obtenerColor(String accion) {
    switch (accion) {
      case "add":
        return Color.fromRGBO(139, 255, 110, 1);
      case "update":
        return Colors.blue;
      case "delete":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Retorna el icono dependiendo de la acción
  IconData obtenerIcono(String accion) {
    switch (accion) {
      case "add":
        return Icons.add;
      case "update":
        return Icons.update;
      case "delete":
        return Icons.delete;
      default:
        return Icons.info;
    }
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
            ElevatedButton(
              onPressed: () async {
                await funcs.EliminarProducto(widget.nombre, widget.colegio, widget.talla);
                Navigator.pop(context);
              },
              child: const Text('Eliminar producto'),
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
  RangeValues quantityRange = const RangeValues(0, 200);
  RangeValues priceRange = const RangeValues(0, 30000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros de Búsqueda'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                items: <String>['', 'S', 'M', 'L', 'XL']
                    .map<DropdownMenuItem<String>>((String value) {
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
                max: 200,
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
                max: 30000,
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
                  final filtrados = await funcs.FiltrarProductos(
                      selectedName,
                      selectedCollege,
                      selectedSize,
                      quantityRange,
                      priceRange);
                  print(filtrados);
                  setState(() {
                    additionalButtons = [];
                    for (int i = 0; i < filtrados.length; i++) {
                      String filtrado = filtrados[i][0] as String;

                      // Dividir la cadena, ignorando los corchetes
                      List<String> elemento = filtrado
                          .substring(0, filtrado.length)
                          .split(';');
                      additionalButtons.add(
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                    nombre: elemento[0],
                                    colegio: elemento[1],
                                    talla: elemento[2],
                                    cantidad: elemento[3],
                                    precio: elemento[4],
                                    direccionqr: elemento[5]),
                              ),
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
              // Aquí mostramos los botones adicionales dentro de un Column
              // como parte del scrollable
              Column(
                children: additionalButtons,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Widget> additionalButtons = [];
  String? selectedName;
  String? selectedCollege;
  String? selectedSize;
  RangeValues quantityRange = const RangeValues(0, 200);
  RangeValues priceRange = const RangeValues(0, 30000);

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
              max: 200,
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
              max: 30000,
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
                            MaterialPageRoute(builder: (context) => ProductDetailsScreen(nombre: elemento[0],colegio: elemento[1],talla: elemento[2],cantidad: elemento[3],precio: elemento[4], direccionqr: elemento[5])),
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
}*/


//PANTALLA CREACION DE REPORTES


class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC), // Fondo similar al de la imagen
      body: Center(
        child: Container(
          width: 300,
          height: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Reporte creado',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espacio para el contenido vacío
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    // GuardarArchivo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00B0FF), // Color del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Descargar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// PANTALLA DE SOLICITUD DE QR


class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrResult = 'No se ha escaneado ningún código QR';
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                qrResult,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        setState(() {
          qrResult = scanData.code!;
          final elemento = qrResult.split('-');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ModifyProductScreen(nombre: elemento[0], colegio: elemento[1], talla: elemento[2], cantidad: elemento[3], precio: elemento[4])),
          );// Call the dialog function
        });
      }
    });
  }

  void _showDataDialog(BuildContext context, String data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Datos del código QR'),
        content: Text(data),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


// PANTALLA DE SOLICITAR DATOS MANUALES

class RequestProductScreen extends StatefulWidget {
  const RequestProductScreen({super.key});

  @override
  _RequestProductScreenState createState() => _RequestProductScreenState();
}

class _RequestProductScreenState extends State<RequestProductScreen> {
  String? selectedName;
  String? selectedCollege;
  String? selectedSize;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC), // Fondo similar al de la imagen
      body: Center(
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
            ElevatedButton(
              onPressed: () async {
                // Aquí se aplicaría la lógica para filtrar los productos
                final aModificar = await funcs.FiltrarProductos(selectedName, selectedCollege, selectedSize,RangeValues(0, 500), RangeValues(0, 50000));
                String fila = aModificar[0][0] as String;

                // Dividir la cadena, ignorando los corchetes
                List<String> elemento = fila.substring(0, fila.length).split(';');
                print(elemento[0]);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ModifyProductScreen(nombre: elemento[0], colegio: elemento[1], talla: elemento[2], cantidad: elemento[3], precio: elemento[4])),
                );
              },
              child: const Text('Modificar'),
            ),
          ],
        ),
      ),
    );
  }
}


//PANTALLA MODIFICAR PRODUCTO


class ModifyProductScreen extends StatefulWidget {
  final String nombre;
  final String colegio;
  final String talla;
  final String cantidad;
  final String precio;

  const ModifyProductScreen({
    super.key,
    required this.nombre,
    required this.colegio,
    required this.talla,
    required this.cantidad,
    required this.precio,
  });

  @override
  _ModifyProductScreenState createState() => _ModifyProductScreenState();
}

class _ModifyProductScreenState extends State<ModifyProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          // ... other widgets
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuantityModifyProductScreen(nombre: widget.nombre, colegio: widget.colegio, talla: widget.talla, cantidad: widget.cantidad, precio: widget.precio, accion: 'aumentar')),
                );
              },
              child: const Text('Aumentar cantidad'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuantityModifyProductScreen(nombre: widget.nombre, colegio: widget.colegio, talla: widget.talla, cantidad: widget.cantidad, precio: widget.precio, accion: 'disminuir')),
                );
              },
              child: const Text('Disminuir cantidad'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuantityModifyProductScreen(nombre: widget.nombre, colegio: widget.colegio, talla: widget.talla, cantidad: widget.cantidad, precio: widget.precio, accion: 'cambiarPrecio')),
                );
              },
              child: const Text('Cambiar precio'),
            ),
          ],
        ),
      ),
    );
  }
}


//PANTALLA CANTIDAD DESEADA ACTUALIZAR


class QuantityModifyProductScreen extends StatefulWidget {
  final String nombre;
  final String colegio;
  final String talla;
  final String cantidad;
  final String precio;
  final String accion;

  const QuantityModifyProductScreen({
    super.key,
    required this.nombre,
    required this.colegio,
    required this.talla,
    required this.cantidad,
    required this.precio,
    required this.accion,
  });

  @override
  _QuantityModifyProductScreenState createState() => _QuantityModifyProductScreenState();
}

class _QuantityModifyProductScreenState extends State<QuantityModifyProductScreen> {
  late String selectedQuantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          // ... other widgets
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  selectedQuantity = value;
                });
              },
              decoration: InputDecoration(
                labelText: widget.accion == 'aumentar'
                  ? 'Ingrese cuanto desea aumentar'
                  : widget.accion == 'disminuir'
                  ? 'Ingrese cuanto desea disminuir' // Si es "aumentar" o "disminuir", muestra "Cantidad"
                  : widget.accion == 'cambiarPrecio'
                  ? 'Ingrese nuevo precio' // Si es "cambiarprecio", muestra "Papa"
                  : '', // Si no coincide con ninguna opción, muestra una cadena vacía
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (widget.accion=='aumentar'){
                  await funcs.ActualizarProducto(widget.nombre, widget.colegio, widget.talla, widget.cantidad, widget.precio,'aumentar',int.parse(selectedQuantity));
                }else if(widget.accion=='disminuir'){
                  await funcs.ActualizarProducto(widget.nombre, widget.colegio, widget.talla, widget.cantidad, widget.precio,'disminuir',int.parse(selectedQuantity));
                }else if(widget.accion=='cambiarPrecio'){
                  await funcs.ActualizarProducto(widget.nombre, widget.colegio, widget.talla, widget.cantidad, widget.precio,'cambiarPrecio',int.parse(selectedQuantity));
                }
                Navigator.pop(context);
              },
              child: const Text('Actualizar precio'),
            ),
          ],
        ),
      ),
    );
  }
}