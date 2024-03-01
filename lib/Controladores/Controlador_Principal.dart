import 'package:hive_flutter/hive_flutter.dart';
import 'package:punto_de_venta/Controladores/Controlador_Almacen.dart';
import 'package:punto_de_venta/Modelos/Producto.dart';

class ControladorPrincipal {
  final ControladorAlmacen _controladorAlmacen = ControladorAlmacen();
  var carritoBox = Hive.box('carrito');
  double totalCompra = 0;
  late List<Producto> productos;
 List<Producto> carrito = [];

  List<Producto> obtenerProductos() {
    var productosBox = Hive.box('productos');
    List<Producto> listaProductos = [];
    for (var key in productosBox.keys) {
      var producto = productosBox.get(key);
      listaProductos.add(Producto(
        id: producto['id'],
        nombre: producto['nombre'],
        precio: producto['precio'],
        stock: producto['stock'],
      ));
    }
    return listaProductos;
  }
bool ComprarProductos(int id) {
  productos = obtenerProductos();
  Producto productoExistente;

  for (int i = 0; i < carrito.length; i++) {
    if (carrito[i].id == id) {
      productoExistente = carrito[i];
      productoExistente.stock += 1; // Se compra una unidad más del producto existente
      totalCompra += productoExistente.precio; // Se suma el precio unitario al total de la compra
      for (int j = 0; j < productos.length; j++) {
        if (productos[j].id == id) {
          productos[j].stock -= 1; // Se resta 1 al stock del producto en la lista de productos
          break;
        }
      }
      guardarCarritoEnHive();
      return true;
    }
  }
  for (int i = 0; i < productos.length; i++) {
    if (productos[i].id == id) {
      Producto nuevoProducto = productos[i].copyWith(stock: 1); // Se agrega el nuevo producto al carrito con una unidad
      carrito.add(nuevoProducto);
      totalCompra += nuevoProducto.precio; // Se suma el precio unitario al total de la compra
      productos[i].stock -= 1; // Se resta 1 al stock del producto en la lista de productos
      guardarCarritoEnHive();
      return true;
    }
  }

  return false; // No se encontró el producto en la lista de productos
}

bool EliminarProducto(int id) {
  Producto productoEliminar;
  
  for (int i = 0; i < carrito.length; i++) {
    if (carrito[i].id == id) {
      productoEliminar = carrito[i];
      totalCompra -= productoEliminar.precio * productoEliminar.stock; // Restar el precio total del producto al total de la compra
      for (int j = 0; j < productos.length; j++) {
        if (productos[j].id == id) {
          productos[j].stock += productoEliminar.stock; // Se suma la cantidad de stock del producto que se estaba en el carrito al stock del producto en la lista de productos
          break;
        }
      }
      carritoBox.delete(id); // Eliminar el producto del Hive
      return true;
    }
  }

  return false; // No se encontró el producto en el carrito
}


void CancelarCompra() {
  carritoBox.clear(); // Vaciar el Hive
  carrito.clear(); // Vaciar la lista de carrito
  totalCompra = 0; // Reiniciar el total de la compra
  productos = obtenerProductos(); // Actualizar la lista de productos
}
void FinalizarCompra() {
  
  for (int i = 0; i < productos.length; i++) {
    Producto producto = productos[i];
    _controladorAlmacen.modificarProducto(producto); // Actualizar el stock del producto en el almacén
  }
  carrito.clear(); // Vaciar la lista de carrito
  totalCompra = 0; // Reiniciar el total de la compra
}
void guardarCarritoEnHive() {
  for (var producto in carrito) {
    carritoBox.put(producto.id, {
      'id': producto.id,
      'nombre': producto.nombre,
      'precio': producto.precio,
      'stock': producto.stock,
    });
  }
}
  double getTotalCompra() {
    return totalCompra;
  }
}





