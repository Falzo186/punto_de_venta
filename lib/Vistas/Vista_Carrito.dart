import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:punto_de_venta/Controladores/Controlador_Principal.dart';
import 'package:punto_de_venta/Modelos/Producto.dart';

class VistaCarrito extends StatefulWidget {
  const VistaCarrito({Key? key}) : super(key: key);

  @override
  _VistaCarritoState createState() => _VistaCarritoState();
}

class _VistaCarritoState extends State<VistaCarrito> {
  final ControladorPrincipal _controladorPrincipal = ControladorPrincipal();
  late List<Producto> carrito;
  var carritoBox = Hive.box('carrito');

  List<Producto> cargarCarritoDeHive() {
    List<Producto> carritoCargado = [];
    for (var key in carritoBox.keys) {
      var producto = carritoBox.get(key);
      carritoCargado.add(Producto(
        id: producto['id'],
        nombre: producto['nombre'],
        precio: producto['precio'],
        stock: producto['stock'],
      ));
    }
    return carritoCargado;
  }

  @override
  void initState() {
    super.initState();
    carrito = cargarCarritoDeHive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
      ),
      body: ListView.builder(
        itemCount: carrito.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(carrito[index].toString()),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                print(carrito[index].id);
                setState(() {
                  if (_controladorPrincipal.EliminarProducto(carrito[index].id)) {
                    carrito.removeAt(index);
                    mostrarMensajeError(context, 'Producto eliminado correctamente');
                  } else {
                    mostrarMensajeError(context, 'Error al eliminar el producto');
                  }
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _controladorPrincipal.CancelarCompra();
                  carrito.clear();
                });
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implementa la lógica para finalizar la compra
                _controladorPrincipal.FinalizarCompra();
                setState(() {
                  carrito.clear();
                });
              },
              child: const Text('Finalizar Compra'),
            ),
          ],
        ),
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







