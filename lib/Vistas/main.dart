import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punto_de_venta/Controladores/Controlador_Principal.dart';
import 'package:punto_de_venta/Vistas/Vista_Carrito.dart';
import 'package:punto_de_venta/Vistas/Vista_Proveedores.dart';
import 'package:punto_de_venta/Vistas/Vista_Ventas.dart';
import 'package:punto_de_venta/Vistas/vista_clientes.dart';
import 'package:punto_de_venta/Vistas/vista_almacen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:punto_de_venta/Modelos/Producto.dart';
import 'package:punto_de_venta/Vistas/Vista_Carrito.dart';
void main() async {
  await Hive.initFlutter();
  await Hive.openBox('productos');
  await Hive.openBox('clientes');
  await Hive.openBox('proveedores');
  await Hive.openBox('carrito');
  await Hive.openBox('ventas');
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

 final List<Producto> productos = [];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nombre de la tienda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 192, 49, 44)),
       
      ),
      home: const MyHomePage(title: 'El Parque'),
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

  final ControladorPrincipal _controladorPrincipal = ControladorPrincipal();
  @override
double totalCompra = 0;
Widget build(BuildContext context) {
  final TextEditingController _idProductoController = TextEditingController();
   
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    ),
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text('Menú'),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 173, 117, 94),
            ),
          ),
          ListTile(
            title: const Text('Inventario'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const VistaAlmacen();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Clientes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return VistaClientes();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Ventas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return VistaVentas();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Proveedores'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return VistaProveedores();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Carrito de compras'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return  VistaCarrito();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text('SALIR'),
            onTap: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
        ],
      ),
    ),
    body: Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _idProductoController,
                      decoration: const InputDecoration(
                        labelText: 'ID DEL PRODUCTO',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Acción del botón
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    int idProducto = int.tryParse(_idProductoController.text) ?? 0;
                if(_controladorPrincipal.ComprarProductos(idProducto)){
                    totalCompra = 0;
                    totalCompra=_controladorPrincipal.getTotalCompra();
                    mostrarMensajeError(context, 'Producto agregado al carrito');
                    setState(() {
                      
                    });
                    }else{
                      mostrarMensajeError(context, 'El producto no existe');
                    }
                   },
                  child: const Text('Comprar'),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(8.0),
           child: Text('Sub total actual: \$${totalCompra.toString()} MX'),

          ),
        ),
      ],
    ),
  );
}

void mostrarMensajeError(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Aviso'),
        content: Text(mensaje),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

}

