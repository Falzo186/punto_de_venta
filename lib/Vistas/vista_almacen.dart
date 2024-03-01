
import 'package:flutter/material.dart';
import 'package:punto_de_venta/Modelos/Producto.dart';
import 'package:punto_de_venta/Controladores/Controlador_Almacen.dart';
import 'package:hive_flutter/hive_flutter.dart';
class VistaAlmacen extends StatefulWidget {
  const VistaAlmacen({super.key});

  @override
  State<VistaAlmacen> createState() => _VistaAlmacenState();
}
class _VistaAlmacenState extends State<VistaAlmacen> {
  List<Producto> products = [];
  @override
  void initState() {
    super.initState();
    products = obtenerProductos();
  }

List<Producto> obtenerProductos() {
  var productos = Hive.box('productos');
  List<Producto> listaProductos = [];
  for (var key in productos.keys) {
    var producto = productos.get(key);
    listaProductos.add(Producto(
      id: producto['id'],
      nombre: producto['nombre'],
      precio: producto['precio'],
      stock: producto['stock'],
    ));
  }
  return listaProductos;
}
final ControladorAlmacen _controladorAlmacen = ControladorAlmacen();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Almacen'),
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(products[index].nombre),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${products[index].id}'),
                    Text('Precio: \$${products[index].precio.toStringAsFixed(2)}'),
                    Text('Stock: ${products[index].stock}'),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                agregarProductoDialog(context);
              },
              child: const Text('Agregar'),
            ),
            ElevatedButton(
              onPressed: () {
                mostrarDialogoModificarProducto(context);
              },
              child: const Text('Modificar'),
            ),
            ElevatedButton(
              onPressed: () {
                eliminarProducto(context);
              },
              child: const Text('Eliminar'),
            ),
          ],
        ),
      ],
    ),
  );
}
  //metodos para el controlador de modificar producto

void mostrarDialogoModificar(BuildContext context, Producto producto) {
  TextEditingController nombreController = TextEditingController(text: producto.nombre);
  TextEditingController precioController = TextEditingController(text: producto.precio.toString());
  TextEditingController stockController = TextEditingController(text: producto.stock.toString());
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Modificar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: precioController,
              decoration: const InputDecoration(
                labelText: 'Precio',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(
                labelText: 'Stock',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Modificar el producto en la lista
              setState(() {
                producto.nombre = nombreController.text;
                producto.precio = double.tryParse(precioController.text) ?? 0.0;
                producto.stock = int.tryParse(stockController.text) ?? 0;
              });

              // Actualizar el producto en la caja Hive
              _controladorAlmacen.modificarProducto(producto);

              Navigator.of(context).pop();
            },
            child: const Text('Modificar'),
          ),
        ],
      );
    },
  );
}
void mostrarDialogoModificarProducto(BuildContext context) {
  final TextEditingController idController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Modificar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID del Producto',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              int? productId = int.tryParse(idController.text);

              if (productId != null) {
                Producto? productoEncontrado = buscarProductoPorId(productId);
                if (productoEncontrado != null) {
                  mostrarDialogoModificar(context, productoEncontrado);
                } else {
                  mostrarMensajeError(context, 'Producto no encontrado');
                }
              } else {
                mostrarMensajeError(context, 'ID inválido');
              }
            },
            child: const Text('Buscar'),
          ),
        ],
      );
    },
  );
}

Producto? buscarProductoPorId(int productId) {
  return products.firstWhere((producto) => producto.id == productId);
}
// 5. Función para mostrar un mensaje de error
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
//6. agregar el metodo para agregar producto
void agregarProductoDialog(BuildContext context) {
  TextEditingController idController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Agregar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: precioController,
              decoration: const InputDecoration(
                labelText: 'Precio',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(
                labelText: 'Stock',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              int? id = int.tryParse(idController.text);
              String nombre = nombreController.text;
              double precio = double.tryParse(precioController.text) ?? 0.0;
              int stock = int.tryParse(stockController.text) ?? 0;

              Producto producto = Producto(id: id!, nombre: nombre, precio: precio, stock: stock);
              if (_controladorAlmacen.agregarProducto(producto)) {
                // El producto se agregó correctamente
                
               // Cerrar el diálogo
                setState(() {
                  products = obtenerProductos(); // Actualizar la lista de productos
                });
                 Navigator.of(context).pop();
                  mostrarMensajeError(context, 'Producto agregado correctamente');
              } else {
                // El producto no se pudo agregar
                mostrarMensajeError(context, '¡El producto con ID ${producto.id} ya existe!');
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      );
    },
  );
}
//7.metodo para eliminar producto
void eliminarProducto(BuildContext context) {
  TextEditingController idController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID del Producto',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              int id = int.tryParse(idController.text) ?? 0;
              

              if (_controladorAlmacen.eliminarProducto(id)) {
                 setState(() {
                  products = obtenerProductos(); // Actualizar la lista de productos
                });
               Navigator.of(context).pop();
                mostrarMensajeError(context, 'Producto eliminado correctamente');

              } else {
                mostrarMensajeError(context, 'No se pudo eliminar el producto');
              }

              
            },
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
}
}

