class Proveedor{
  int id;
  String nombre;
  String telefono;

  Proveedor({
    required this.id,
    required this.nombre, 
    required this.telefono
    });
    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
    };
  }
}