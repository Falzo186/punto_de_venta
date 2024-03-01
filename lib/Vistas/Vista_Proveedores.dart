import 'package:flutter/material.dart';
import 'package:punto_de_venta/Controladores/Controlador_Proveedor.dart';
import 'package:punto_de_venta/Modelos/Proveedor.dart';
import 'package:hive_flutter/hive_flutter.dart';
class VistaProveedores extends StatefulWidget {
  @override
  State<VistaProveedores> createState() => _VistaProveedoresState();
}

class _VistaProveedoresState extends State<VistaProveedores> {
  final _controladorProveedores = ControladorProveedores();
   List<Proveedor> proveedores = [];
      @override
  void initState() {
    super.initState();
    proveedores = obtenerClientes();
  }

  List<Proveedor> obtenerClientes() {
    var clientes = Hive.box('proveedores');
    List<Proveedor> listaClientes = [];
    for (var key in clientes.keys) {
      var cliente = clientes.get(key);
      listaClientes.add(Proveedor(
        id: cliente['id'],
        nombre: cliente['nombre'],
        telefono: cliente['telefono'],
      ));
    }
    return listaClientes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Proveedores'),
      ),
      body: ListView.builder(
        itemCount: proveedores.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(proveedores[index].nombre),
            subtitle: Text(proveedores[index].telefono),
          );
        },
      ),
bottomNavigationBar: Container(
  height: 60, // Establece el alto deseado
  child: BottomAppBar(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espacio uniforme entre los botones
      children: [
        SizedBox( // Establece un tamaño fijo para cada botón
          width: 120,
          child: ElevatedButton(
            onPressed: () {
              agregarProveedor(context);
             
            },
            child: const Text('Agregar'),
          ),
        ),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            onPressed: () {
              modificarProveedor(context);
              
            },
            child: const Text('Modificar'),
          ),
        ),
        SizedBox(
          width: 120,
          child: ElevatedButton(
            onPressed: () {
              eliminarProveedor(context);
           
            },
            child: const Text('Eliminar'),
          ),
        ),
      ],
    ),
  ),
),
    );
  }

//metodos de controlador 
void agregarProveedor(BuildContext context) {
  TextEditingController idController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Agregar Proveedor'),
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
              controller: telefonoController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              int id = int.tryParse(idController.text) ?? 0;
              String nombre = nombreController.text;
              String telefono = telefonoController.text;

              if (id != 0 && !proveedores.any((proveedor) => proveedor.id == id)) {
                _controladorProveedores.agregarProveedor(Proveedor(id: id, nombre: nombre, telefono: telefono));
                setState(() {
                  proveedores = obtenerClientes();
                });
                Navigator.of(context).pop();
              } else {
                mostrarMensajeError(context, 'El ID ya existe o es inválido');
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      );
    },
  );
}

void modificarProveedor(BuildContext context) {
  TextEditingController idController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Modificar Proveedor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID del Proveedor',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              int id = int.tryParse(idController.text) ?? 0;

              Proveedor? proveedorEncontrado = buscarProveedorPorId(id);
              if (proveedorEncontrado != null) {
                Navigator.of(context).pop();
                mostrarDialogoModificarProveedor(context, proveedorEncontrado);
              } else {
                mostrarMensajeError(context, 'Proveedor no encontrado');
              }
            },
            child: const Text('Buscar'),
          ),
        ],
      );
    },
  );
}

void mostrarDialogoModificarProveedor(BuildContext context, Proveedor proveedor) {
  TextEditingController nombreController = TextEditingController(text: proveedor.nombre);
  TextEditingController telefonoController = TextEditingController(text: proveedor.telefono);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Modificar Proveedor'),
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
              controller: telefonoController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              proveedor.nombre = nombreController.text;
              proveedor.telefono = telefonoController.text;

              _controladorProveedores.modificarProveedor(proveedor);
              setState(() {
                proveedores = obtenerClientes();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Modificar'),
          ),
        ],
      );
    },
  );
}

Proveedor? buscarProveedorPorId(int id) {
  return proveedores.firstWhere((proveedor) => proveedor.id == id);
}

void eliminarProveedor(BuildContext context) {
  TextEditingController idController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar Proveedor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID del Proveedor',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              int id = int.tryParse(idController.text) ?? 0;

              if (_controladorProveedores.eliminarProveedor(id)) {
                setState(() {
                  proveedores = obtenerClientes();
                });
                Navigator.of(context).pop();
              } else {
                mostrarMensajeError(context, 'Proveedor no encontrado');
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
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
