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
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    final rawNumero = parseInt(
      json['numeroMesa'] ??
          json['NumeroMesa'] ??
          json['numero'] ??
          json['Numero'],
    );
    final rawId = parseInt(
      json['mesaID'] ??
          json['mesaId'] ??
          json['MesaID'] ??
          json['MesaId'] ??
          json['idMesa'] ??
          json['id'] ??
          json['Id'],
    );

    final effectiveNumero = rawNumero > 0 ? rawNumero : (rawId > 0 ? rawId : 1);
    final effectiveId = rawId > 0 ? rawId : effectiveNumero;

    return MesaModel(
      id: effectiveId,
      numero: effectiveNumero,
      capacidad: parseInt(json['capacidad'] ?? json['Capacidad'] ?? 4),
      estado: (json['estado'] ?? json['Estado'] ?? 'Disponible').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'numero': numero,
        'capacidad': capacidad,
        'estado': estado,
      };
}
