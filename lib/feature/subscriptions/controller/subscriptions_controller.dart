import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/services/firebase_service.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import '../model/driver_subscription_model.dart';

class SubscriptionsController extends GetxController {
  static SubscriptionsController get to => Get.find<SubscriptionsController>();

  final RxList<DriverSubscription> subscriptions = <DriverSubscription>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString statusFilter = 'all'.obs; // 'all', 'activos', 'porVencer', 'vencidos'
  final RxString selectedCoopFilter = 'Todas'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialSubscriptions();
  }

  void _loadInitialSubscriptions() {
    final now = DateTime.now();

    subscriptions.assignAll([
      // 1. Conductor oficial en sesión (Carlos Mendoza)
      DriverSubscription(
        id: 'DRIVER-042',
        nombre: 'Carlos Mendoza',
        cedula: '1002345678',
        telefono: '+593 99 482 1045',
        cooperativa: 'Cooperativa Los Lagos',
        unidad: 'Unidad #42',
        placa: 'IBA-1234',
        activa: true,
        estado: 'Activo y Protegido',
        fechaUltimoPago: now.subtract(const Duration(days: 16)),
        fechaVencimiento: now.add(const Duration(days: 14)),
        metodoPago: 'Cooperativa / Descuento de Rol',
      ),
      // 2. Conductor con vencimiento próximo (alerta amarilla en 3 días)
      DriverSubscription(
        id: 'DRIVER-099',
        nombre: 'Patricio Guanoluisa',
        cedula: '1004928172',
        telefono: '+593 99 777 8899',
        cooperativa: 'Cooperativa Los Lagos',
        unidad: 'Unidad #99',
        placa: 'IBX-9012',
        activa: true,
        estado: 'Por vencer',
        fechaUltimoPago: now.subtract(const Duration(days: 27)),
        fechaVencimiento: now.add(const Duration(days: 3)),
        metodoPago: 'Efectivo en Oficina',
      ),
      // 3. Conductor al día (Flota Imbabura)
      DriverSubscription(
        id: 'DRIVER-028',
        nombre: 'Segundo J. Chimarro',
        cedula: '1003849102',
        telefono: '+593 98 554 4332',
        cooperativa: 'Flota Imbabura',
        unidad: 'Unidad #28',
        placa: 'IAA-4912',
        activa: true,
        estado: 'Activo y Protegido',
        fechaUltimoPago: now.subtract(const Duration(days: 8)),
        fechaVencimiento: now.add(const Duration(days: 22)),
        metodoPago: 'Cooperativa / Descuento de Rol',
      ),
      // 4. Conductor al día (Flota Imbabura)
      DriverSubscription(
        id: 'DRIVER-015',
        nombre: 'Marco V. Morales',
        cedula: '1001928374',
        telefono: '+593 98 441 2233',
        cooperativa: 'Flota Imbabura',
        unidad: 'Unidad #15',
        placa: 'IAA-3012',
        activa: true,
        estado: 'Activo y Protegido',
        fechaUltimoPago: now.subtract(const Duration(days: 12)),
        fechaVencimiento: now.add(const Duration(days: 18)),
        metodoPago: 'Cooperativa / Descuento de Rol',
      ),
      // 5. Conductor vencido (mora de 5 días)
      DriverSubscription(
        id: 'DRIVER-078',
        nombre: 'Wilson E. Caiza',
        cedula: '1003456781',
        telefono: '+593 99 123 9876',
        cooperativa: 'Cooperativa Los Lagos',
        unidad: 'Unidad #78',
        placa: 'IBX-1122',
        activa: true,
        estado: 'Vencido',
        fechaUltimoPago: now.subtract(const Duration(days: 35)),
        fechaVencimiento: now.subtract(const Duration(days: 5)),
        metodoPago: 'Transferencia Bancaria Directa',
      ),
      // 6. Conductor suspendido por mora
      DriverSubscription(
        id: 'DRIVER-033',
        nombre: 'Luis F. Imbaquingo',
        cedula: '1002938475',
        telefono: '+593 98 901 2345',
        cooperativa: 'Coop. San Cristóbal',
        unidad: 'Unidad #33',
        placa: 'IBX-3344',
        activa: false,
        estado: 'Suspendido por Mora',
        fechaUltimoPago: now.subtract(const Duration(days: 45)),
        fechaVencimiento: now.subtract(const Duration(days: 15)),
        metodoPago: 'Efectivo en Oficina',
      ),
      // 7. Conductor próximo a vencer (2 días)
      DriverSubscription(
        id: 'DRIVER-012',
        nombre: 'Jorge M. Flores',
        cedula: '1005123984',
        telefono: '+593 97 888 1234',
        cooperativa: 'Coop. San Cristóbal',
        unidad: 'Unidad #12',
        placa: 'IBX-5566',
        activa: true,
        estado: 'Por vencer',
        fechaUltimoPago: now.subtract(const Duration(days: 28)),
        fechaVencimiento: now.add(const Duration(days: 2)),
        metodoPago: 'Cooperativa / Descuento de Rol',
      ),
      // 8. Conductor al día (Los Lagos)
      DriverSubscription(
        id: 'DRIVER-008',
        nombre: 'Nelson P. Farinango',
        cedula: '1004128901',
        telefono: '+593 99 223 3445',
        cooperativa: 'Cooperativa Los Lagos',
        unidad: 'Unidad #08',
        placa: 'IBX-9901',
        activa: true,
        estado: 'Activo y Protegido',
        fechaUltimoPago: now.subtract(const Duration(days: 4)),
        fechaVencimiento: now.add(const Duration(days: 26)),
        metodoPago: 'Cooperativa / Descuento de Rol',
      ),
    ]);
  }

  // --- KPIs COMERCIALES Y FINANCIEROS ($1.00 / mes) ---
  int get totalConductores => subscriptions.length;

  int get totalActivos => subscriptions.where((s) => s.activa && !s.isVencida).length;

  double get ingresosMensualesProyectados => totalActivos * 1.00;

  int get conductoresPorVencer => subscriptions.where((s) => s.isPorVencer).length;

  int get conductoresVencidos => subscriptions.where((s) => s.isVencida).length;

  List<String> get availableCooperatives {
    final coops = subscriptions.map((s) => s.cooperativa).toSet().toList();
    coops.sort();
    return ['Todas', ...coops];
  }

  // --- FILTRADO DE CONDUCTORES ---
  List<DriverSubscription> get filteredSubscriptions {
    return subscriptions.where((s) {
      // 1. Filtro por Estado
      if (statusFilter.value == 'activos' && (s.isVencida || !s.activa)) return false;
      if (statusFilter.value == 'porVencer' && !s.isPorVencer) return false;
      if (statusFilter.value == 'vencidos' && !s.isVencida) return false;

      // 2. Filtro por Cooperativa
      if (selectedCoopFilter.value != 'Todas' && s.cooperativa != selectedCoopFilter.value) {
        return false;
      }

      // 3. Filtro por Buscador (Nombre, Cédula, Unidad, Placa)
      final query = searchQuery.value.trim().toLowerCase();
      if (query.isEmpty) return true;

      return s.nombre.toLowerCase().contains(query) ||
          s.cedula.toLowerCase().contains(query) ||
          s.unidad.toLowerCase().contains(query) ||
          s.placa.toLowerCase().contains(query) ||
          s.cooperativa.toLowerCase().contains(query);
    }).toList();
  }

  void setSearchQuery(String q) {
    searchQuery.value = q;
    update();
  }

  void setStatusFilter(String filter) {
    statusFilter.value = filter;
    update();
  }

  void setCoopFilter(String coop) {
    selectedCoopFilter.value = coop;
    update();
  }

  // --- ACCIONES MANUALES DE OVERRIDE (ADMIN TI) ---

  /// Registra el pago manual de un conductor (+30 días o personalizados)
  void renovarPagoManual({
    required String driverId,
    int dias = 30,
    String metodo = 'Efectivo en Oficina',
    double monto = 1.00,
  }) {
    final idx = subscriptions.indexWhere((s) => s.id == driverId);
    if (idx != -1) {
      final s = subscriptions[idx];
      final now = DateTime.now();

      // Si la fecha actual ya venció, renovar a partir de hoy; si no, sumar al vencimiento previo
      final baseDate = s.fechaVencimiento.isAfter(now) ? s.fechaVencimiento : now;
      final nuevaFechaVencimiento = baseDate.add(Duration(days: dias));

      s.activa = true;
      s.estado = 'Activo y Protegido';
      s.fechaUltimoPago = now;
      s.fechaVencimiento = nuevaFechaVencimiento;
      s.metodoPago = metodo;

      subscriptions[idx] = s;
      subscriptions.refresh();
      update();

      // Sincronizar en memoria con ConductorController si es el usuario en sesión
      _sincronizarConConductorController(s);

      // Sincronizar en Firebase Firestore
      _sincronizarConFirestore(s);

      if (Get.key.currentState?.overlay != null) {
        Get.snackbar(
          '💳 Pago Registrado con Éxito',
          'Membresía renovada para ${s.nombre} (${s.unidad}). Nueva vigencia hasta el ${_formatDate(nuevaFechaVencimiento)}.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF16A34A),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  /// Alterna la suspensión de la cobertura en caso de mora
  void toggleSuspension(String driverId) {
    final idx = subscriptions.indexWhere((s) => s.id == driverId);
    if (idx != -1) {
      final s = subscriptions[idx];
      s.activa = !s.activa;
      s.estado = s.activa ? (s.isVencida ? 'Vencido' : 'Activo y Protegido') : 'Suspendido por Mora';

      subscriptions[idx] = s;
      subscriptions.refresh();
      update();

      _sincronizarConConductorController(s);
      _sincronizarConFirestore(s);

      if (Get.key.currentState?.overlay != null) {
        Get.snackbar(
          s.activa ? '🛡️ Cobertura Reactivada' : '⚠️ Cobertura Suspendida',
          'El estado de ${s.nombre} (${s.unidad}) se actualizó a: ${s.estado}.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: s.activa ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
          colorText: Colors.white,
          icon: Icon(s.activa ? Icons.shield_rounded : Icons.block_rounded, color: Colors.white, size: 28),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
      }
    }
  }

  /// Notifica al conductor o cooperativa sobre su pago pendiente
  void notificarCobro(DriverSubscription sub) {
    if (Get.key.currentState?.overlay != null) {
      Get.snackbar(
        '📲 Aviso de Cobro Enviado',
        'Recordatorio enviado al teléfono ${sub.telefono} de ${sub.nombre} (${sub.cooperativa}).',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF2563EB),
        colorText: Colors.white,
        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 26),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    }
  }

  // --- SINCRONIZACIÓN REACTIVA BIDIRECCIONAL ---

  void _sincronizarConConductorController(DriverSubscription sub) {
    if (Get.isRegistered<ConductorController>()) {
      final condCtrl = Get.find<ConductorController>();
      if (condCtrl.cedulaConductor == sub.cedula ||
          condCtrl.nombreConductor.toLowerCase() == sub.nombre.toLowerCase()) {
        condCtrl.actualizarSuscripcion(
          activa: sub.activa,
          estado: sub.estado,
          plan: sub.planNombre,
          ultimoPago: _formatDate(sub.fechaUltimoPago),
          vencimiento: _formatDate(sub.fechaVencimiento),
          diasRestantes: sub.diasRestantes,
        );
      }
    }
  }

  Future<void> _sincronizarConFirestore(DriverSubscription sub) async {
    try {
      await FirebaseService().updateDriverSubscription(
        driverId: sub.id,
        subscriptionData: (sub.toMap()['suscripcion'] as Map<String, dynamic>?) ?? sub.toMap(),
      );
    } catch (e) {
      debugPrint('Firestore sync offline: $e');
    }
  }

  String _formatDate(DateTime d) {
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${d.day} de ${meses[d.month - 1]}, ${d.year}';
  }
}
