import 'package:punto_de_venta/Modelos/Producto.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ControladorAlmacen{

   var productos = Hive.box('productos');

  bool agregarProducto(Producto producto) {
    if (!productos.containsKey(producto.id)) {
         productos.put(producto.id, producto.toMap());
        return true; 
    } else {
        
        return false; 
    }
}
  bool eliminarProducto(int id) {
  if (productos.containsKey(id)) {
    productos.delete(id);
    return true; // Producto eliminado
  } 
  return false; // Producto no encontrado
}

 bool modificarProducto(Producto producto) {
    try {
      productos.put(producto.id, producto.toMap());
      return true; // Producto modificado correctamente
    } catch (e) {
      return false; // Error al modificar el producto
    }
  }
}

