import 'package:flutter/material.dart';
import 'package:punto_de_venta/Controladores/Controlador_Cliente.dart';
import 'package:punto_de_venta/Modelos/Cliente.dart';
import 'package:hive_flutter/hive_flutter.dart';

class VistaClientes extends StatefulWidget {
 

  VistaClientes({Key? key}) : super(key: key);

  @override
  State<VistaClientes> createState() => _VistaClientesState();
}

class _VistaClientesState extends State<VistaClientes> {
  final _controladorCliente = ControladorCliente();
 List<Cliente> clientes = [];

  @override
  void initState() {
    super.initState();
    clientes = obtenerClientes();
  }

  List<Cliente> obtenerClientes() {
    var clientes = Hive.box('clientes');
    List<Cliente> listaClientes = [];
    for (var key in clientes.keys) {
      var cliente = clientes.get(key);
      listaClientes.add(Cliente(
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
        title: const Text('Clientes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(clientes[index].nombre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${clientes[index].id}'),
                      Text('Teléfono: ${clientes[index].telefono}'),
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
                  agregarCliente(context);
                },
                child: const Text('Agregar'),
              ),
              ElevatedButton(
                onPressed: () {
                  modificarCliente(context);
                },
                child: const Text('Modificar'),
              ),
              ElevatedButton(
                onPressed: () {
                  eliminarCliente(context);
                },
                child: const Text('Eliminar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

// metodos controlador 
void agregarCliente(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController nombreController = TextEditingController();
    TextEditingController telefonoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Cliente'),
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

                if (id != 0 && !clientes.any((cliente) => cliente.id == id)) {
                  _controladorCliente.agregarCliente(Cliente(id: id, nombre: nombre, telefono: telefono));
                  Navigator.of(context).pop();
                  setState(() {
                    clientes = obtenerClientes();
                  });
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

  void modificarCliente(BuildContext context) {
    TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modificar Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'ID del Cliente',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                int id = int.tryParse(idController.text) ?? 0;

                Cliente? clienteEncontrado = buscarClientePorId(id);
                if (clienteEncontrado != null) {
                  Navigator.of(context).pop();
                  mostrarDialogoModificar(context, clienteEncontrado);
                } else {
                  mostrarMensajeError(context, 'Cliente no encontrado');
                }
              },
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  void mostrarDialogoModificar(BuildContext context, Cliente cliente) {
    TextEditingController nombreController = TextEditingController(text: cliente.nombre);
    TextEditingController telefonoController = TextEditingController(text: cliente.telefono);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modificar Cliente'),
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
                cliente.nombre = nombreController.text;
                cliente.telefono = telefonoController.text;

                _controladorCliente.modificarCliente(cliente);
                Navigator.of(context).pop();
                setState(() {
                  clientes = obtenerClientes();
                });
              },
              child: const Text('Modificar'),
            ),
          ],
        );
      },
    );
  }

  Cliente? buscarClientePorId(int id) {
    return clientes.firstWhere((cliente) => cliente.id == id);
  }

  void eliminarCliente(BuildContext context) {
    TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'ID del Cliente',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                int id = int.tryParse(idController.text) ?? 0;

                if (_controladorCliente.eliminarCliente(id)) {
                  Navigator.of(context).pop();
                  setState(() {
                    clientes = obtenerClientes();
                  });
                  mostrarMensajeError(context, 'Cliente eliminado correctamente');
                } else {
                  mostrarMensajeError(context, 'No se pudo eliminar el cliente');
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