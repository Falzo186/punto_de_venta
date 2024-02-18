import 'package:flutter/material.dart';
import 'package:punto_de_venta/modelos/Producto.dart';

class VistaAlmacen extends StatelessWidget {
 
List<Producto> products = [
    Producto('Producto 1', 100, 10),
    Producto('Producto 2', 200, 20),
    Producto('Producto 3', 300, 30),
];

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
                  subtitle: Text('Price: \$${products[index].precio.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add product logic
                },
                child: const Text('Agregar'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Modify product logic
                },
                child: const Text('Modificar'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Delete product logic
                },
                child: const Text('Eliminar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

