class Cliente{
  String name;
  String email;
  String telefono;

  Cliente({required this.name, required this.email, required this.telefono});

  Cliente.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        telefono = json['telefone'];
   
  

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.name;
    data['email'] = this.email;
    data['telefone'] = this.telefono;
    return data;
  }
}