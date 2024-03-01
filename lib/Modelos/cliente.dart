class Cliente {
  int id;
  String nombre;
  String telefono;
  
  Cliente({
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