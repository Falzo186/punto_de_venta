import 'package:punto_de_venta/Modelos/Cliente.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ControladorCliente {
  var clientes = Hive.box('clientes');

  bool agregarCliente(Cliente cliente) {
    if (!clientes.containsKey(cliente.id)) {
      clientes.put(cliente.id, cliente.toMap());
      return true;
    } else {
      return false;
    }
  }

  bool eliminarCliente(int id) {
    if (clientes.containsKey(id)) {
      clientes.delete(id);
      return true; // Cliente eliminado
    }
    return false; // Cliente no encontrado
  }

  bool modificarCliente(Cliente cliente) {
    try {
      clientes.put(cliente.id, cliente.toMap());
      return true; // Cliente modificado correctamente
    } catch (e) {
      return false; // Error al modificar el cliente
    }
  }
}


