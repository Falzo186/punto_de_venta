// ignore: file_names
import 'package:punto_de_venta/Modelos/Producto.dart';
class Venta {
  int id;
  String fecha;
  double total;
  int idCliente;
List<Producto> Productos;

  Venta({
   required this.id, 
   required this.fecha, 
   required this.total, 
   required this.idCliente, 
   required this.Productos,
   } );
   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'total': total,
      'idCliente':idCliente,
      'productos': Productos,
    };
  }
}