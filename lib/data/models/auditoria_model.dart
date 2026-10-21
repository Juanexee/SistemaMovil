// =========================================================
// auditoria_model.dart
// Modelo para los logs del sistema guardados en MongoDB
// Cubre RF-MOV-AUD-01 y RF-MOV-AUD-02
// =========================================================

class LogAuditoriaModel {
  final String id;                // ID del documento en MongoDB
  final String fecha;             // Cuando ocurrio el evento
  final String tipoEvento;        // Tipo: 'LOGIN', 'VENTA', 'ANULACION', etc.
  final String modulo;            // Modulo del sistema: 'Ventas', 'Inventario'
  final String usuarioResponsable;// Quien hizo la accion
  final String descripcion;       // Detalle de lo que paso

  LogAuditoriaModel({
    required this.id,
    required this.fecha,
    required this.tipoEvento,
    required this.modulo,
    required this.usuarioResponsable,
    required this.descripcion,
  });

  factory LogAuditoriaModel.fromJson(Map<String, dynamic> json) {
    return LogAuditoriaModel(
      // MongoDB usa '_id' en lugar de 'id'
      id:                  json['_id']                ?? json['id'] ?? '',
      fecha:               json['fecha']              ?? '',
      tipoEvento:          json['tipoEvento']         ?? '',
      modulo:              json['modulo']             ?? '',
      usuarioResponsable:  json['usuarioResponsable'] ?? '',
      descripcion:         json['descripcion']        ?? '',
    );
  }
}
