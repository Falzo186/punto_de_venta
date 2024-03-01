import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:punto_de_venta/Modelos/Producto.dart';
import 'package:punto_de_venta/Modelos/Venta.dart';
class VistaVentas extends StatefulWidget {
  @override
  State<VistaVentas> createState() => _VistaVentasState();
}

class _VistaVentasState extends State<VistaVentas> {
 List<Venta> ventas = [];

  void initState() {
    super.initState();
    ventas = obtenerVentas();
  }


List<Venta> obtenerVentas() {
  var ventasBox = Hive.box('ventas');
  List<Venta> listaVentas = [];
  for (var key in ventasBox.keys) {
    var venta = ventasBox.get(key);
    listaVentas.add(Venta(
      id: venta['id'],
      fecha: venta['fecha'],
      total: venta['total'],
      idCliente: venta['idCliente'],
      Productos: List<Producto>.from(venta['productos'].map((producto) => Producto(
        id: producto['id'],
        nombre: producto['nombre'],
        precio: producto['precio'],
        stock: producto['stock'],
      ))),
    ));
  }
  return listaVentas;
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Ventas'),
    ),
    body: ListView.builder(
      itemCount: ventas.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Venta ${ventas[index].id}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fecha: ${ventas[index].fecha}'),
              Text('Total: \$${ventas[index].total.toStringAsFixed(2)}'),
              Text('Cliente: ${ventas[index].idCliente}'),
              Text('Productos:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ventas[index].Productos.map((producto) => ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Cantidad: ${producto.stock}'),
                )).toList(),
              ),
            ],
          ),
        );
      },
    ),
    bottomNavigationBar: BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              // Acción para modificar venta
              print('Modificar Venta');
              setState(() {
                ventas = obtenerVentas();
              });
            },
            child: const Text('Modificar Venta'),
          ),
          ElevatedButton(
            onPressed: () {
              // Acción para eliminar venta
              print('Eliminar Venta');
            },
            child: const Text('Eliminar Venta'),
          ),
        ],
      ),
    ),
  );
}

}
