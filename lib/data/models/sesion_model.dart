// =========================================================
// sesion_model.dart
// =========================================================

// Lo que me regresa el servidor al abrir una sesion de mesa
class SesionModel {
  final int? id;
  final int mesaId;
  final String estado;

  SesionModel({this.id, required this.mesaId, required this.estado});

  factory SesionModel.fromJson(Map<String, dynamic> json) {
    return SesionModel(
      id:     json['id'],
      mesaId: json['mesaId'] ?? 0,
      estado: json['estado'] ?? '',
    );
  }
}

// Para cambiar la orden de una mesa a otra
class CambiarMesaRequest {
  final int mesaOrigenId;
  final int mesaDestinoId;

  CambiarMesaRequest({
    required this.mesaOrigenId,
    required this.mesaDestinoId,
  });

  Map<String, dynamic> toJson() => {
    'mesaOrigenId':  mesaOrigenId,
    'mesaDestinoId': mesaDestinoId,
  };
}

// Para aceptar un lote de pedidos en cocina
class AceptarLoteRequest {
  final List<int> pedidoIds;

  AceptarLoteRequest({required this.pedidoIds});

  Map<String, dynamic> toJson() => {'pedidoIds': pedidoIds};
}
