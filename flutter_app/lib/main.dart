import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'funcs.dart' as funcs;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  funcs.cargarDatos();
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _usuarioExiste = false; // Inicializa el estado

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales(); // Llama a la función que obtiene el boolean
  }

  Future<void> _cargarDatosIniciales() async {
    // Aquí va tu lógica para obtener el boolean
    bool resultado = await funcs.InicioAplicacion();

    setState(() {
      _usuarioExiste = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _usuarioExiste ? const LoginScreen() : const RegisterScreen(),
      ),
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
    return Scaffold(
      // AppBar con título y botón de retroceso
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
        title: const Text(
          'Registro de usuario',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Cuerpo de la pantalla
      body: BackgroundContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              // Agregamos el Container con fondo blanco
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0), // Opcional: para bordes redondeados
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  TextField(
                    controller: _userController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      hintText: 'Ingrese su nombre de usuario',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    cursorColor: Colors.black,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      hintText: 'Ingrese su contraseña',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
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
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      hintText: 'Confirme su contraseña',
                      hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await funcs.RegistrarUsuario(
                        _userController.text,
                        _passwordController.text,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 30.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Registrar usuario',
                      style: TextStyle(fontSize: 16, color: Colors.white),
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






//PANTALLA INICIO DE SESION


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey para gestionar el estado del formulario
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;  // Variable para almacenar el mensaje de error

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Cierra el teclado al tocar fuera de los campos
        },
        child: BackgroundContainer(
          child: Center(
            child: SingleChildScrollView( // Permite desplazar si hay mucho contenido
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(  // Envolvemos los campos dentro del Form
                    key: _formKey,  // Asignamos el GlobalKey
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(  // Usamos TextFormField en lugar de TextField
                          controller: _userController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: 'Usuario',
                            labelStyle: const TextStyle(color: Colors.grey),
                            hintText: 'Ingrese su nombre de usuario',
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su nombre de usuario';
                            }
                            return null;  // Si no hay error, retorna null
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(  // Usamos TextFormField también para la contraseña
                          controller: _passwordController,
                          obscureText: true,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: const TextStyle(color: Colors.grey),
                            hintText: 'Ingrese su contraseña',
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su contraseña';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        // Mostrar mensaje de error si existe
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool usuarioCoincide = await funcs.InicioSesion(
                                _userController.text,
                                _passwordController.text,
                              );

                              if (usuarioCoincide) {
                                setState(() {
                                  _errorMessage = null;  // Limpiamos el mensaje de error
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyHomePage()),
                                );
                              } else {
                                setState(() {
                                  _errorMessage = 'Usuario o contraseña incorrectos';
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 12.0,
                            ),
                          ),
                          child: const Text('Iniciar Sesión'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}











//PANTALLA PRINCIPAL


class MyHomePage extends StatefulWidget {

  const MyHomePage({
    super.key,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<bool> _onWillPop() async {
    SystemNavigator.pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF), // Color similar al de la barra superior en la imagen
          title: const Text('¡Hola! ¿Que deseas hacer?'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'), // Asegúrate de que la imagen esté en la ruta correcta
              fit: BoxFit.cover, // Ajusta la imagen para cubrir toda la pantalla
            ),

          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Alinea al inicio del centro
              children: [
                const SizedBox(height: 80), // Espacio en la parte superior
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Fondo blanco
                    ),
                    child: const Text(
                      "Agregar producto",
                      style: TextStyle(fontSize: 18,color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espacio entre los botones
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Fondo blanco
                    ),
                    child: const Text(
                      "Actualizar producto",
                      style: TextStyle(fontSize: 18,color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espacio entre los botones
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Fondo blanco
                    ),
                    child: const Text(
                      "Buscador de productos",
                      style: TextStyle(fontSize: 18,color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espacio entre los botones
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Fondo blanco
                    ),
                    child: const Text(
                      "Generar reporte",
                      style: TextStyle(fontSize: 18,color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espacio entre los botones
                SizedBox(
                  width: 355,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () async {
                      var movements = await funcs.LeerHistorial();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MovementsScreen(movimientos: movements)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Fondo blanco
                    ),
                    child: const Text(
                      "Historial de movimientos",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
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





// PANTALLA HISTORIAL DE MOVIMIENTOS

class MovementsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> movimientos;

  const MovementsScreen({
    super.key,
    required this.movimientos,
  });

  @override
  _MovementsScreenState createState() => _MovementsScreenState();
}

class _MovementsScreenState extends State<MovementsScreen> {
  @override
  Widget build(BuildContext context) {
    // Invertimos la lista para mostrar los movimientos más recientes primero
    final movimientosInvertidos = widget.movimientos.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Movimientos"),
      ),
      body: ListView.builder(
        itemCount: movimientosInvertidos.length,
        itemBuilder: (context, index) {
          final movimiento = movimientosInvertidos[index];
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
      case "Agregar":
        return const Color.fromRGBO(139, 255, 110, 1);
      case "Disminuir":
      case "Aumentar":
        return Colors.blue;
      case "Eliminar":
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
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? selectedSize; // Variable para almacenar la talla seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        backgroundColor: const Color(0xFFFFFFFF),
      ),
      body: BackgroundContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: 'Tipo de producto',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  maxLength: 50,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')) // Denegar el caracter "/"
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '¡Falta el nombre del producto!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _schoolController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: 'Colegio del producto',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  maxLength: 50,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')) // Denegar el caracter "/"
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '¡Falta el colegio al que pertenece!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Menú desplegable para la talla
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),

                        boxShadow: [
                        BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),

                ),
              ],
            ),
              child: DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  value: selectedSize,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Talla',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSize = newValue;
                    });
                  },
                  validator: (value) {  // <-- Aquí se agrega el validador
                    if (value == null || value.isEmpty) {
                      return '¡Falta la talla!';
                    }
                    return null;
                  },
                  items: <String>['', '3', '4', '6', '8', '10', '12', '14', '16', 'S', 'M', 'L', 'XL', 'XXL']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),

                  hint: const Text('Talla'),

          ),
        ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _unitsController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad del producto',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[^0-9]')) // Bloquear todos los caracteres excepto números
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '¡Falta una cantidad inicial!';
                    }
                    else if (int.parse(value) < 0) {
                      return '¡La cantidad no puede ser menor a cero!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Precio del producto',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[^0-9]')) // Bloquear todos los caracteres excepto números
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '¡Falta el precio por unidad!';
                    }
                    else if (int.parse(value) < 0) {
                      return '¡El precio no puede ser menor a cero!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Asegúrate de que selectedSize no sea nulo
                        if (selectedSize == null) {
                          // Manejar el caso en que no se ha seleccionado una talla
                          // Puedes mostrar un mensaje de error o establecer un valor por defecto
                          return;
                        }

                        List<dynamic> nuevoProducto = await funcs.AgregarProducto(
                          _nameController.text,
                          _schoolController.text,
                          selectedSize!, // Pasar la talla seleccionada
                          _unitsController.text,
                          _priceController.text,
                        );
                        await funcs.AgregarHistorial(
                          "Agregar",
                          _nameController.text,
                          int.parse(_unitsController.text),
                          selectedSize!, // Pasar la talla seleccionada
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              nombre: nuevoProducto[0],
                              colegio: nuevoProducto[1],
                              talla: nuevoProducto[2],
                              cantidad: nuevoProducto[3],
                              precio: nuevoProducto[4],
                              direccionqr: nuevoProducto[5],
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Guardar Producto'),
                  ),
                ),
              ],
            ),
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
        title: const Text('Detalles del Producto'),
        backgroundColor: Colors.white,
      ),
      body: BackgroundContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Nombre: ${widget.nombre}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Colegio: ${widget.colegio}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Talla: ${widget.talla}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Cantidad: ${widget.cantidad}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Precio: ${widget.precio}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.cover,
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity, // Asegura que ambos botones tengan el mismo ancho
                  child: ElevatedButton(
                    onPressed: () async {
                      await funcs.GuardarArchivo(imageFile, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text('Descargar QR'),
                  ),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: double.infinity, // Asegura que ambos botones tengan el mismo ancho
                  child: ElevatedButton(
                    onPressed: () async {
                      await funcs.EliminarProducto(
                        widget.nombre,
                        widget.colegio,
                        widget.talla,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: const Text('Eliminar producto'),
                  ),
                ),
              ],
            ),
          ),
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
        backgroundColor: const Color(0xffffffff),
      ),
      body: BackgroundContainer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black, // Color del cursor
                    onChanged: (value) {
                      setState(() {
                        selectedName = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue), // Color azul al enfocar
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey), // Color gris cuando no está enfocado
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black, // Color del cursor
                    onChanged: (value) {
                      setState(() {
                        selectedCollege = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Colegio',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue), // Color azul al enfocar
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey), // Color gris cuando no está enfocado
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: selectedSize,
                    isExpanded: true,
                    underline: Container(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSize = newValue;
                      });
                    },
                    items: <String>['', '3', '4', '6', '8', '10', '12', '14', '16', 'S', 'M', 'L', 'XL', 'XXL']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: const Text('Talla'),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rango de Cantidad'),
                      RangeSlider(
                        values: quantityRange,
                        min: 0,
                        max: 200,
                        divisions: 100,
                        activeColor: Colors.blue, // Color azul para el rango activo
                        inactiveColor: Colors.grey, // Color gris para el rango inactivo
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rango de Precio'),
                      RangeSlider(
                        values: priceRange,
                        min: 0,
                        max: 30000,
                        divisions: 100,
                        activeColor: Colors.blue, // Color azul para el rango activo
                        inactiveColor: Colors.grey, // Color gris para el rango inactivo
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () async {
                      final filtrados = await funcs.FiltrarProductos(
                        selectedName,
                        selectedCollege,
                        selectedSize,
                        quantityRange,
                        priceRange,
                      );
                      setState(() {
                        additionalButtons = [];
                        for (int i = 0; i < filtrados.length; i++) {
                          String filtrado = filtrados[i][0] as String;
                          List<String> elemento = filtrado.split(';');
                          additionalButtons.add(
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
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
                                            direccionqr: elemento[5],
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                                      alignment: Alignment.centerLeft,
                                    ),
                                    child: Text(
                                      elemento[0],
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color del fondo del botón
                      foregroundColor: Colors.white,),
                    child: const Text('Buscar'),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: additionalButtons,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






//PANTALLA CREACION DE REPORTES

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte Diario'),
        backgroundColor: Colors.white,
      ),
      body: BackgroundContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Reporte creado',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final historial = await funcs.LeerHistorial();
                      await funcs.ReporteDiario(historial);

                      final fechaActual = DateFormat('yyyy-MM-dd').format(DateTime.now());

                      // Obtener el archivo PDF generado
                      final directory = await getApplicationDocumentsDirectory();
                      final file = File('${directory.path}/reporte_diario_transacciones$fechaActual.pdf');
                      funcs.GuardarArchivo(file, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color del botón
                      foregroundColor: Colors.white, // Color del texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Descargar',
                      style: TextStyle(fontSize: 16),
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


//PANTALLA DE STOCK FINAL
class StockScreen extends StatefulWidget {
  final String accion;
  final String nuevaCant;

  const StockScreen({
    super.key,
    required this.accion,
    required this.nuevaCant,
  });

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock actual'),
        backgroundColor: Colors.white,
      ),
      body: BackgroundContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(20),
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.accion == 'aumentar' || widget.accion == 'disminuir'
                    ? 'Cantidad actualizada, nueva cantidad: ${widget.nuevaCant}'
                        : widget.accion == 'cambiarPrecio'
                    ? 'Precio actualizado, nuevo precio: ${widget.nuevaCant}'
                        : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Volver al inicio',
                      style: TextStyle(fontSize: 16),
                    ),
                  )

                ],
              ),
            ),
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
      appBar: AppBar(
        title: const Text('Escanear QR'),
        backgroundColor: Colors.white,
      ),
      body: BackgroundContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                qrResult,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 16), // Espacio entre los botones
                ElevatedButton(
                  onPressed: () {
                    controller?.pauseCamera();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RequestProductScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: const Text('Ingresar Datos Manuales'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        setState(() async {
          qrResult = scanData.code!;
          final elemento = qrResult.split('-');
          final productoDelQR = await funcs.FiltrarProductos(
            elemento[0],
            elemento[1],
            elemento[2],
            const RangeValues(0, double.infinity),
            const RangeValues(0, double.infinity),
          );
          String fila = productoDelQR[0][0] as String;

          List<String> element =
          fila.substring(0, fila.length).split(';');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModifyProductScreen(
                nombre: element[0],
                colegio: element[1],
                talla: element[2],
                cantidad: element[3],
                precio: element[4],
              ),
            );
            controller.pauseCamera();
          });
        } else {
          // Mostrar un mensaje de error o realizar una acción si el código QR no es válido
          setState(() {
            qrResult = 'Código QR no válido';
          });
        }
      }
    });
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
  final _formKey = GlobalKey<FormState>(); // GlobalKey para gestionar el estado del formulario
  String? selectedName;
  String? selectedCollege;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar Datos Manuales'),
        backgroundColor: Colors.white,
      ),
      body: BackgroundContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(  // Usamos un Form para manejar validaciones
                key: _formKey, // Asignamos el GlobalKey
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      cursorColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          selectedName = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Falta nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      cursorColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          selectedCollege = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Colegio',
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Falta colegio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: selectedSize,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSize = newValue;
                        });
                      },
                      items: <String>['', '3', '4', '6', '8', '10', '12', '14', '16', 'S', 'M', 'L', 'XL', 'XXL']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Talla',
                        labelStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Falta talla';
                        }
                        return null;
                      },
                      dropdownColor: Colors.white,
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final aModificar = await funcs.FiltrarProductos(
                              selectedName,
                              selectedCollege,
                              selectedSize,
                              const RangeValues(0, 500),
                              const RangeValues(0, 50000),
                            );
                            String fila = aModificar[0][0] as String;

                            List<String> elemento =
                            fila.substring(0, fila.length).split(';');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModifyProductScreen(
                                  nombre: elemento[0],
                                  colegio: elemento[1],
                                  talla: elemento[2],
                                  cantidad: elemento[3],
                                  precio: elemento[4],
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: const Text('Modificar'),
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
        title: const Text('Modificar Producto'),
        backgroundColor: Colors.white,
      ),
      body: BackgroundContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrar los botones
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
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
                crossAxisAlignment: CrossAxisAlignment.start,  // Esto alinea todo a la izquierda
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'NOMBRE PRODUCTO:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.nombre,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'COLEGIO PRODUCTO:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.colegio,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'TALLA PRODUCTO:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.talla,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'CANTIDAD ACTUAL:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.cantidad,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'PRECIO ACTUAL PRODUCTO:',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.precio,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(355, 70), // Ancho y alto
                backgroundColor: Colors.white, // Fondo blanco
                foregroundColor: Colors.black, // Texto negro
                textStyle: const TextStyle(fontSize: 18), // Tamaño de fuente
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuantityModifyProductScreen(
                      nombre: widget.nombre,
                      colegio: widget.colegio,
                      talla: widget.talla,
                      cantidad: widget.cantidad,
                      precio: widget.precio,
                      accion: 'aumentar',
                    ),
                  ),
                );
              },
              child: const Text('Aumentar cantidad'),
            ),
            const SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(355, 70), // Ancho y alto
                backgroundColor: Colors.white, // Fondo blanco
                foregroundColor: Colors.black, // Texto negro
                textStyle: const TextStyle(fontSize: 18), // Tamaño de fuente
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuantityModifyProductScreen(
                      nombre: widget.nombre,
                      colegio: widget.colegio,
                      talla: widget.talla,
                      cantidad: widget.cantidad,
                      precio: widget.precio,
                      accion: 'disminuir',
                    ),
                  ),
                );
              },
              child: const Text('Disminuir cantidad'),
            ),
            const SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(355, 70), // Ancho y alto
                backgroundColor: Colors.white, // Fondo blanco
                foregroundColor: Colors.black, // Texto negro
                textStyle: const TextStyle(fontSize: 18), // Tamaño de fuente
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuantityModifyProductScreen(
                      nombre: widget.nombre,
                      colegio: widget.colegio,
                      talla: widget.talla,
                      cantidad: widget.cantidad,
                      precio: widget.precio,
                      accion: 'cambiarPrecio',
                    ),
                  ),
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
  _QuantityModifyProductScreenState createState() =>
      _QuantityModifyProductScreenState();
}

class _QuantityModifyProductScreenState
    extends State<QuantityModifyProductScreen> {
  late String selectedQuantity;
  final _formKey = GlobalKey<FormState>();  // <-- Agregar la clave del formulario

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modificar Producto',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Opcional: elimina la sombra del AppBar
        iconTheme: const IconThemeData(color: Colors.black), // Íconos en negro
      ),
      body: BackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(  // <-- Aquí es donde se envuelve el formulario
            key: _formKey,  // <-- Asignamos la clave al Form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(  // <-- Cambié TextField por TextFormField
                  cursorColor: Colors.black, // Cursor negro
                  onChanged: (value) {
                    setState(() {
                      selectedQuantity = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: widget.accion == 'aumentar'
                        ? 'Ingrese cuanto desea aumentar'
                        : widget.accion == 'disminuir'
                        ? 'Ingrese cuanto desea disminuir'
                        : widget.accion == 'cambiarPrecio'
                        ? 'Ingrese nuevo precio'
                        : '',
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '¡Este campo no puede estar vacío!';
                    }
                    // Validar si la cantidad a disminuir es mayor al stock actual
                    if (widget.accion == 'disminuir') {
                      int cantidad = int.parse(widget.cantidad); // Stock actual
                      int cantidadIngresada = int.parse(value); // Cantidad ingresada
                      if (cantidadIngresada > cantidad) {
                        return '¡La cantidad a disminuir es mayor a la cantidad actual!';
                      }
                    }
                    // Validar si el precio es negativo
                    if (widget.accion == 'cambiarPrecio') {
                      double precioNuevo = double.parse(value); // Precio ingresado
                      if (precioNuevo <= 0) {
                        return '¡El precio nuevo debe ser mayor a cero!';
                      }
                    }
                    if (widget.accion == 'aumentar') {
                      int cantidad = int.parse(widget.cantidad); // Stock actual
                      int cantidadIngresada = int.parse(value); // Precio ingresado
                      if (cantidadIngresada+cantidad > 200) {
                        return '¡La cantidad a aumentar sobrepasa el limite de 200!';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Si el formulario es válido, proceder con la actualización
                        if (widget.accion == 'aumentar') {
                          int cantidad = int.parse(widget.cantidad); // Stock actual
                          int cantidadIngresada = int.parse(selectedQuantity);
                          int cantidadNueva = cantidad + cantidadIngresada;
                          await funcs.ActualizarProducto(
                              widget.nombre,
                              widget.colegio,
                              widget.talla,
                              widget.cantidad,
                              widget.precio,
                              'aumentar',
                              int.parse(selectedQuantity));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StockScreen(accion: widget.accion, nuevaCant: cantidadNueva.toString())),
                          );
                        } else if (widget.accion == 'disminuir') {
                          int cantidad = int.parse(widget.cantidad); // Stock actual
                          int cantidadIngresada = int.parse(selectedQuantity);
                          int cantidadNueva = cantidad - cantidadIngresada;
                          await funcs.ActualizarProducto(
                              widget.nombre,
                              widget.colegio,
                              widget.talla,
                              widget.cantidad,
                              widget.precio,
                              'disminuir',
                              int.parse(selectedQuantity));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StockScreen(accion: widget.accion, nuevaCant: cantidadNueva.toString())),
                          );
                        } else if (widget.accion == 'cambiarPrecio') {
                          await funcs.ActualizarProducto(
                              widget.nombre,
                              widget.colegio,
                              widget.talla,
                              widget.cantidad,
                              widget.precio,
                              'cambiarPrecio',
                              int.parse(selectedQuantity));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StockScreen(accion: widget.accion, nuevaCant: selectedQuantity)),
                          );
                        }
                      }
                    },
                    child: const Text('Actualizar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




//AÑADIR FONDO
class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'), // Ruta de tu imagen
          fit: BoxFit.cover, // Ajusta la imagen para cubrir el contenedor
        ),
      ),
      child: child,
    );
  }
}