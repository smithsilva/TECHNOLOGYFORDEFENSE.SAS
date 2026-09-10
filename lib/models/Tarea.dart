/// Modelo de Tarea (Asignación).
/// Colócalo en: lib/models/tarea.dart
class Tarea {
  final int id; // id_asignacion
  final int? idMantenimiento;
  final int idMecanico;
  final String mecanicoNombre; // viene de usuarios.username
  final String vehiculo;
  final String tipoTrabajo;
  final String descripcion;
  final String prioridad; // "Alta" | "Media" | "Baja"
  final String fechaLimite; // "2026-08-03"
  final String estado; // "Pendiente" | "En proceso" | "Finalizada"
  final String fechaAsignacion;
  final int costo;
  final int idMetodoPago;
  final int idCliente;
  final int idSucursal;

  Tarea({
    required this.id,
    this.idMantenimiento,
    required this.idMecanico,
    required this.mecanicoNombre,
    required this.vehiculo,
    required this.tipoTrabajo,
    required this.descripcion,
    required this.prioridad,
    required this.fechaLimite,
    required this.estado,
    required this.fechaAsignacion,
    required this.costo,
    required this.idMetodoPago,
    required this.idCliente,
    required this.idSucursal,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    final mecanicoAnidado = json['usuarios'] as Map<String, dynamic>?;

    return Tarea(
      id: json['id_asignacion'] is int
          ? json['id_asignacion']
          : int.tryParse('${json['id_asignacion']}') ?? 0,
      idMantenimiento: json['id_mantenimiento'] == null
          ? null
          : (json['id_mantenimiento'] is int
              ? json['id_mantenimiento']
              : int.tryParse('${json['id_mantenimiento']}')),
      idMecanico: json['id_mecanico'] is int
          ? json['id_mecanico']
          : int.tryParse('${json['id_mecanico']}') ?? 0,
      mecanicoNombre: mecanicoAnidado != null
          ? (mecanicoAnidado['username'] ?? 'Sin asignar')
          : 'Sin asignar',
      vehiculo: json['vehiculo'] ?? '',
      tipoTrabajo: json['tipo_trabajo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      prioridad: json['prioridad'] ?? 'Media',
      fechaLimite: json['fecha_limite'] ?? '',
      estado: json['estado'] ?? 'Pendiente',
      fechaAsignacion: json['fecha_asignacion'] ?? '',
      costo: json['costo'] is int
          ? json['costo']
          : int.tryParse('${json['costo']}') ?? 0,
      idMetodoPago: json['id_metodo_pago'] is int
          ? json['id_metodo_pago']
          : int.tryParse('${json['id_metodo_pago']}') ?? 0,
      idCliente: json['id_cliente'] is int
          ? json['id_cliente']
          : int.tryParse('${json['id_cliente']}') ?? 0,
      idSucursal: json['id_sucursal'] is int
          ? json['id_sucursal']
          : int.tryParse('${json['id_sucursal']}') ?? 0,
    );
  }

  /// Body para crear (POST). No incluye id ni id_mantenimiento
  /// porque normalmente los pone el backend.
  Map<String, dynamic> toCreateJson() => {
        'id_mecanico': idMecanico,
        'vehiculo': vehiculo,
        'tipo_trabajo': tipoTrabajo,
        'descripcion': descripcion,
        'prioridad': prioridad,
        'fecha_limite': fechaLimite,
        'estado': estado,
        'costo': costo,
        'id_metodo_pago': idMetodoPago,
        'id_cliente': idCliente,
        'id_sucursal': idSucursal,
      };

  /// Body para actualizar (PATCH), todos los campos editables.
  Map<String, dynamic> toUpdateJson() => {
        'id_mecanico': idMecanico,
        'vehiculo': vehiculo,
        'tipo_trabajo': tipoTrabajo,
        'descripcion': descripcion,
        'prioridad': prioridad,
        'fecha_limite': fechaLimite,
        'estado': estado,
        'costo': costo,
        'id_metodo_pago': idMetodoPago,
        'id_cliente': idCliente,
        'id_sucursal': idSucursal,
      };
}