
import 'package:hive_flutter/hive_flutter.dart';
import 'package:punto_de_venta/Modelos/Producto.dart';
import 'package:punto_de_venta/Modelos/Venta.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';



class ControladorVenta {
  List<Venta> ventas = [];
var ventasBox = Hive.box('ventas');
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

  void hacerVenta(double total, List<Producto> productos) {
    // Aquí podrías pedir al usuario el ID del cliente
    int idCliente = pedirIdCliente();

    // Obtener la fecha actual
    DateTime now = DateTime.now();
    String fecha = now.toString();

    // Crear la venta
    Venta nuevaVenta = Venta(id: ventas.length + 1, fecha: fecha, total: total, idCliente: idCliente, Productos: productos);

    // Agregar la venta a la lista de ventas
    ventas.add(nuevaVenta);

    // Generar el ticket de venta en PDF
    // generarTicketVenta(nuevaVenta);
   ventasBox.put(nuevaVenta.id, nuevaVenta.toMap());
  }
    
  int pedirIdCliente() {
    // Aquí puedes implementar la lógica para pedir el ID del cliente al usuario
    // Por simplicidad, en este ejemplo simplemente se retorna un ID de cliente ficticio
    return 1;
  }



// void generarTicketVenta(Venta venta) async {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.Page(
//       build: (context) => pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text('Venta #${venta.id}'),
//           pw.SizedBox(height: 10),
//           pw.Text('Fecha: ${venta.fecha}'),
//           pw.SizedBox(height: 10),
//           pw.Text('Cliente: Cliente #${venta.idCliente}'),
//           pw.SizedBox(height: 10),
//           pw.Text('Total: \$${venta.total.toStringAsFixed(2)}'),
//           pw.SizedBox(height: 20),
//           pw.Text('Productos:'),
//           pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: venta.Productos.map((producto) => pw.Text('${producto.nombre} - \$${producto.precio.toStringAsFixed(2)}')).toList(),
//           ),
//         ],
//       ),
//     ),
//   );

//   final bytes = await pdf.save();
//   final dir = await getApplicationDocumentsDirectory();
//   final file = File('${dir.path}/ticket_venta_${venta.id}.pdf');
//   await file.writeAsBytes(bytes);

//   await abrirPDF(venta);
// }



// Future<void> abrirPDF(Venta venta) async {
//   final dir = await getApplicationDocumentsDirectory();
//   final pdfPath = '${dir.path}/ticket_venta_${venta.id}.pdf';
//   await OpenFile.open(pdfPath);
// }


}

