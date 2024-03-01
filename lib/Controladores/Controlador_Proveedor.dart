import 'package:punto_de_venta/Modelos/Proveedor.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ControladorProveedores {
  var proveedores = Hive.box('proveedores');

    bool modificarProveedor(Proveedor proveedor) {
    try {
      proveedores.put(proveedor.id, proveedor.toMap());
      return true; // Cliente modificado correctamente
    } catch (e) {
      return false; // Error al modificar el cliente
    }
  }

  bool agregarProveedor(Proveedor proveedor) {
    if (!proveedores.containsKey(proveedor.id)) {
      proveedores.put(proveedor.id, proveedor.toMap());
      return true;
    } else {
      return false;
    }
  }

  bool eliminarProveedor(int id) {
    if (proveedores.containsKey(id)) {
      proveedores.delete(id);
      return true; // Proveedor eliminado
    }
    return false; // Proveedor no encontrado
  }

  Proveedor buscarProveedorPorId(int id) {
    return proveedores.values.firstWhere((proveedor) => proveedor.id == id);
  }
}
