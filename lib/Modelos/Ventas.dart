class Ventas {
  int id;
  String fecha;
  double total;
  int idCliente;

  Ventas({required this.id, required this.fecha, required this.total, required this.idCliente});

  factory Ventas.fromJson(Map<String, dynamic> json) {
    return Ventas(
      id: json['id'],
      fecha: json['fecha'],
      total: json['total'],
      idCliente: json['idCliente'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fecha': fecha,
    'total': total,
    'idCliente': idCliente,
    };
  } 