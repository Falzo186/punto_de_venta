import 'package:flutter/material.dart';
import 'package:punto_de_venta/widgets/custom_button_navigation.dart';
import 'package:punto_de_venta/Vistas/vista_almacen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nombre de la tienda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
       
      ),
      home: const MyHomePage(title: 'Nombre de la tienda'),
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

  

Widget build(BuildContext context) {
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
              color: Color.fromARGB(255, 4, 63, 110),
            ),
          ),
          ListTile(
            title: const Text('inventario'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return VistaAlmacen(
                       //productos: productos,
                     );
                    },
                  ),
                );
              // Actualiza el estado de la aplicación...
              // ...
            },
          ),
          ListTile(
            title: const Text('ventas'),
            onTap: () {
              // Actualiza el estado de la aplicación...
              // ...
            },
          ),
          ListTile(
            title: const Text('compras'),
            onTap: () {
              // Actualiza el estado de la aplicación...
              // ...
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
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'ID DEL PRODUCTO',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
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
                    // Acción del botón Comprar
                  },
                  child: const Text('Comprar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción del botón Eliminar
                  },
                  child: const Text('Eliminar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción del botón Cancelar
                  },
                  child: const Text('Cancelar'),
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
            child: const Text('Sub total actual: 0 MX'),
          ),
        ),
      ],
    ),
  );
}
}

