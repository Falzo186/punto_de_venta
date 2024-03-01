import 'package:flutter/material.dart';
import 'package:punto_de_venta/Modelos/Venta.dart';
class VistaVentas extends StatefulWidget {
  @override
  State<VistaVentas> createState() => _VistaVentasState();
}

class _VistaVentasState extends State<VistaVentas> {
 final List<Venta> ventas = [];


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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: ventas[index].Productos.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(ventas[index].Productos[i].nombre),
                      subtitle: Text('Cantidad: ${ventas[index].Productos[i].stock}'),
                    );
                  },
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
