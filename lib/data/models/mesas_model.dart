// =========================================================
// mesas_model.dart
// =========================================================
class MesaModel {
  final int id;
  final int numero;
  final int capacidad;
  final String estado; // 'Libre', 'Ocupada', 'Reservada'

  MesaModel({
    required this.id,
    required this.numero,
    required this.capacidad,
    required this.estado,
  });

  factory MesaModel.fromJson(Map<String, dynamic> json) {
    return MesaModel(
      id:        json['id']        ?? 0,
      numero:    json['numero']    ?? 0,
      capacidad: json['capacidad'] ?? 0,
      estado:    json['estado']    ?? 'Libre',
    );
  }

  Map<String, dynamic> toJson() => {
    'numero':    numero,
    'capacidad': capacidad,
    'estado':    estado,
  };
}
