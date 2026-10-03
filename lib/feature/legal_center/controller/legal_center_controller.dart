import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import '../model/legal_case_model.dart';

enum LegalDispatchViewMode {
  split,      // Vista Dividida (Tabla + Mapa)
  tableOnly,  // Solo Tabla
  mapOnly,    // Solo Mapa
}

class LegalCenterController extends GetxController {
  // --- DESPACHO AUTOMÁTICO POR GEORREFERENCIACIÓN (GPS SMART DISPATCH) ---
  bool _autoDispatchEnabled = true;
  bool get autoDispatchEnabled => _autoDispatchEnabled;

  void toggleAutoDispatch() {
    _autoDispatchEnabled = !_autoDispatchEnabled;
    update();

    Get.snackbar(
      _autoDispatchEnabled ? '⚡ Despacho Automático GPS Activado' : '⏸️ Despacho Automático GPS Pausado',
      _autoDispatchEnabled
          ? 'El sistema asignará automáticamente a la unidad móvil más cercana y disponible.'
          : 'Modo manual activo: El secretario u operador deberá asignar las unidades.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: _autoDispatchEnabled ? const Color(0xFF1B5E20) : const Color(0xFF37474F),
      colorText: Colors.white,
      icon: Icon(
        _autoDispatchEnabled ? Icons.bolt_rounded : Icons.pause_circle_filled_rounded,
        color: _autoDispatchEnabled ? Colors.amber : Colors.white,
        size: 28,
      ),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
    );
  }

  // --- BLOQUE 1: FILTROS TERRITORIALES EN CASCADA ---
  final String fixedCountry = 'Ecuador';

  final List<String> provinces = [
    'Todas',
    'Imbabura',
    'Pichincha',
  ];

  final Map<String, List<String>> cantonsByProvince = {
    'Todas': ['Todos'],
    'Imbabura': ['Todos', 'Ibarra', 'Otavalo', 'Cotacachi'],
    'Pichincha': ['Todos', 'Quito', 'Cayambe', 'Rumiñahui'],
  };

  final List<String> cooperatives = [
    'Todas',
    'Los Lagos',
    'Flota Imbabura',
    'Coop. El Tejar',
    'Coop. San Cristóbal',
    'Coop. 24 de Mayo',
  ];

  String _selectedProvince = 'Imbabura';
  String _selectedCanton = 'Ibarra'; // Piloto Ibarra como vista predeterminada
  String _selectedCooperative = 'Todas';

  String get selectedCountry => fixedCountry;
  String get selectedProvince => _selectedProvince;
  String get selectedCanton => _selectedCanton;
  String get selectedCooperative => _selectedCooperative;

  List<String> get availableCantons =>
      cantonsByProvince[_selectedProvince] ?? ['Todos'];

  // Pestaña principal del dashboard (0: Incidentes en Tiempo Real, 1: Supervisión de Abogados)
  int _dashboardTab = 0;
  int get dashboardTab => _dashboardTab;

  void setDashboardTab(int index) {
    _dashboardTab = index;
    update();
  }

  // Filtro activo por KPI (opcional para interactividad ejecutiva)
  String? _activeKpiFilter; // null, 'rojo', 'pendiente', 'proceso'
  String? get activeKpiFilter => _activeKpiFilter;

  void toggleKpiFilter(String filterKey) {
    if (_activeKpiFilter == filterKey) {
      _activeKpiFilter = null;
    } else {
      _activeKpiFilter = filterKey;
    }
    update();
  }

  // --- BUSCADOR Y ESTADO GENERAL ---
  LegalCase? _selectedCase;
  LegalCase? get selectedCase => _selectedCase;

  // --- MODO DE VISUALIZACIÓN EN CENTRO DE MANDO (SPLIT VIEW / TABLA / MAPA) ---
  LegalDispatchViewMode _dispatchViewMode = LegalDispatchViewMode.tableOnly;
  LegalDispatchViewMode get dispatchViewMode => _dispatchViewMode;

  void setDispatchViewMode(LegalDispatchViewMode mode) {
    _dispatchViewMode = mode;
    update();
  }

  // --- ESTADO Y CONTROL DEL MAPA INTERACTIVO (DISPATCH MAP) ---
  // Centro neurálgico del Piloto Ibarra (Parque Pedro Moncayo / Av. Mariano Acosta)
  double? _targetMapLat = 0.3517;
  double? _targetMapLng = -78.1223;
  double _targetMapZoom = 13.0;
  int _mapMoveCounter = 0;

  double? get targetMapLat => _targetMapLat;
  double? get targetMapLng => _targetMapLng;
  double get targetMapZoom => _targetMapZoom;
  int get mapMoveCounter => _mapMoveCounter;

  // Capas del mapa
  bool _showIncidentsLayer = true;
  bool _showLawyersLayer = true;
  bool _showRoutesLayer = true;

  bool get showIncidentsLayer => _showIncidentsLayer;
  bool get showLawyersLayer => _showLawyersLayer;
  bool get showRoutesLayer => _showRoutesLayer;

  void toggleIncidentsLayer() {
    _showIncidentsLayer = !_showIncidentsLayer;
    update();
  }

  void toggleLawyersLayer() {
    _showLawyersLayer = !_showLawyersLayer;
    update();
  }

  void toggleRoutesLayer() {
    _showRoutesLayer = !_showRoutesLayer;
    update();
  }

  // Abogado enfocado/seleccionado en el mapa
  TerritoryLawyer? _selectedLawyer;
  TerritoryLawyer? get selectedLawyer => _selectedLawyer;

  void selectLawyer(TerritoryLawyer? lawyer) {
    _selectedLawyer = lawyer;
    if (lawyer != null) {
      animateMapToCoordinates(lawyer.lat, lawyer.lng, zoom: 15.0);
    }
    update();
  }

  // ID del último caso alertado / simulado para animación en mapa
  String? _lastAlertedCaseId;
  String? get lastAlertedCaseId => _lastAlertedCaseId;

  void clearLastAlertedCase() {
    _lastAlertedCaseId = null;
    update();
  }

  void animateMapToCoordinates(double lat, double lng, {double zoom = 14.5}) {
    _targetMapLat = lat;
    _targetMapLng = lng;
    _targetMapZoom = zoom;
    _mapMoveCounter++;
    update();
  }

  void animateMapToCase(LegalCase caseItem, {double zoom = 14.8}) {
    _selectedCase = caseItem;
    _selectedLawyer = null;
    animateMapToCoordinates(caseItem.lat, caseItem.lng, zoom: zoom);
  }

  void focusCaseRoute(LegalCase caseItem) {
    _selectedCase = caseItem;
    _selectedLawyer = null;
    final lawyer = getAssignedLawyerForCase(caseItem);
    if (lawyer != null && _showRoutesLayer) {
      animateMapToRouteBetween(caseItem, lawyer);
    } else {
      animateMapToCoordinates(caseItem.lat, caseItem.lng, zoom: 14.8);
    }
  }

  void animateMapToRouteBetween(LegalCase caseItem, TerritoryLawyer lawyer) {
    final midLat = (caseItem.lat + lawyer.lat) / 2;
    final midLng = (caseItem.lng + lawyer.lng) / 2;
    final distKm = calculateDistanceKm(caseItem.lat, caseItem.lng, lawyer.lat, lawyer.lng);

    double optimalZoom;
    if (distKm < 1.0) {
      optimalZoom = 15.2;
    } else if (distKm < 2.5) {
      optimalZoom = 14.2;
    } else if (distKm < 5.0) {
      optimalZoom = 13.2;
    } else if (distKm < 10.0) {
      optimalZoom = 12.2;
    } else {
      optimalZoom = 11.2;
    }

    animateMapToCoordinates(midLat, midLng, zoom: optimalZoom);
  }

  void resetMapToDefaultBounds() {
    // Centro geográfico de Ibarra (Sede Piloto Laboratorio)
    _targetMapLat = 0.3517;
    _targetMapLng = -78.1223;
    _targetMapZoom = 13.0;
    _mapMoveCounter++;
    update();
  }

  TerritoryLawyer? getAssignedLawyerForCase(LegalCase caseItem) {
    if (caseItem.abogadoAsignado == null || caseItem.abogadoAsignado!.isEmpty) {
      return null;
    }
    final target = caseItem.abogadoAsignado!.toLowerCase().trim();
    try {
      return _lawyers.firstWhere(
        (l) =>
            l.nombre.toLowerCase().trim() == target ||
            target.contains(l.nombre.toLowerCase().trim()) ||
            l.nombre.toLowerCase().trim().contains(target),
      );
    } catch (_) {
      return null;
    }
  }

  int _mobileTabIndex = 0; // 0: Lista de Casos, 1: Expediente 360
  int get mobileTabIndex => _mobileTabIndex;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final TextEditingController searchController = TextEditingController();

  List<LegalCase> _cases = [];
  List<LegalCase> get allCases => _cases;

  // --- BLOQUE 3: SUPERVISIÓN DE ABOGADOS DE TERRITORIO ---
  List<TerritoryLawyer> _lawyers = [];

  List<TerritoryLawyer> get allLawyers => _lawyers;

  List<TerritoryLawyer> get territoryLawyers {
    return _lawyers.where((l) {
      final matchesProv =
          _selectedProvince == 'Todas' || l.provincia == _selectedProvince;
      final matchesCanton =
          _selectedCanton == 'Todos' || l.canton == _selectedCanton;
      return matchesProv && matchesCanton;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadInitialLawyers();
    _loadInitialCases();
    if (_cases.isNotEmpty) {
      _selectedCase = _cases.first;
    }
  }

  void _loadInitialLawyers() {
    _lawyers = [
      TerritoryLawyer(
        id: 'CORP-01',
        nombre: 'Grupo Ecuador Total Abogados',
        canton: 'Ibarra',
        provincia: 'Imbabura',
        telefono: '+593 6 295 1000',
        unidadMovil: 'Central Jurídica Corporativa (Sede Ibarra)',
        estadoGuardia: LawyerGuardStatus.enLinea,
        casosRecibidos: 45,
        casosAtendidosATiempo: 44,
        tiempoPromedioRespuestaMin: 5,
        especialidad: 'Despacho Corporativo Central • Tránsito, Civil y Laboral',
        lat: 0.3530,
        lng: -78.1210,
        casosActivos: 1,
      ),
      TerritoryLawyer(
        id: 'ABG-01',
        nombre: 'Dr. Marcelo Dávila',
        canton: 'Otavalo',
        provincia: 'Imbabura',
        telefono: '+593 98 776 5544',
        unidadMovil: 'Móvil Legal #01 (Renault Duster • PBA-9921)',
        estadoGuardia: LawyerGuardStatus.enLinea,
        casosRecibidos: 12,
        casosAtendidosATiempo: 11,
        tiempoPromedioRespuestaMin: 6,
        especialidad: 'Defensa flagrancia y no retención Art. 380 COIP',
        lat: 0.2280,
        lng: -78.2600,
        casosActivos: 0,
      ),
      TerritoryLawyer(
        id: 'ABG-02',
        nombre: 'Dra. Elena Torres',
        canton: 'Cotacachi',
        provincia: 'Imbabura',
        telefono: '+593 99 445 1200',
        unidadMovil: 'Móvil Legal #02 (Suzuki Grand Vitara • PBX-3012)',
        estadoGuardia: LawyerGuardStatus.enLinea,
        casosRecibidos: 9,
        casosAtendidosATiempo: 8,
        tiempoPromedioRespuestaMin: 7,
        especialidad: 'Conciliación en vía y peritajes SIAT inmediatos',
        lat: 0.2980,
        lng: -78.2620,
        casosActivos: 0,
      ),
      TerritoryLawyer(
        id: 'ABG-03',
        nombre: 'Abg. Roberto Andrade',
        canton: 'Ibarra',
        provincia: 'Imbabura',
        telefono: '+593 96 332 1199',
        unidadMovil: 'Móvil Legal #04 (Kia Sportage • PCG-4120)',
        estadoGuardia: LawyerGuardStatus.enAudiencia,
        casosRecibidos: 8,
        casosAtendidosATiempo: 7,
        tiempoPromedioRespuestaMin: 9,
        especialidad: 'Siniestros con heridos leves y custodia procesal',
        lat: 0.3500,
        lng: -78.1200,
        casosActivos: 1,
      ),
      TerritoryLawyer(
        id: 'ABG-04',
        nombre: 'Dr. Fernando Salazar',
        canton: 'Ibarra',
        provincia: 'Imbabura',
        telefono: '+593 99 112 3344',
        unidadMovil: 'Móvil Legal #03 (Chevrolet Tracker • PCY-1100)',
        estadoGuardia: LawyerGuardStatus.enLinea,
        casosRecibidos: 14,
        casosAtendidosATiempo: 13,
        tiempoPromedioRespuestaMin: 8,
        especialidad: 'Impugnación de fotomultas y contravenciones ANT',
        lat: 0.3540,
        lng: -78.1250,
        casosActivos: 0,
      ),
      TerritoryLawyer(
        id: 'ABG-05',
        nombre: 'Dra. Sofía Proaño',
        canton: 'Quito',
        provincia: 'Pichincha',
        telefono: '+593 99 881 2233',
        unidadMovil: 'Móvil Legal #05 (Nissan Kicks • PBZ-8890)',
        estadoGuardia: LawyerGuardStatus.enLinea,
        casosRecibidos: 16,
        casosAtendidosATiempo: 15,
        tiempoPromedioRespuestaMin: 11,
        especialidad: 'Litigio penal de tránsito y mediación flagrante',
        lat: -0.1807,
        lng: -78.4678,
        casosActivos: 0,
      ),
      TerritoryLawyer(
        id: 'ABG-06',
        nombre: 'Dr. Patricio Moncayo',
        canton: 'Cayambe',
        provincia: 'Pichincha',
        telefono: '+593 98 441 5566',
        unidadMovil: 'Móvil Legal #06 (Toyota Hilux • PCX-5002)',
        estadoGuardia: LawyerGuardStatus.noDisponible,
        casosRecibidos: 6,
        casosAtendidosATiempo: 4,
        tiempoPromedioRespuestaMin: 18,
        especialidad: 'Tránsito interprovincial y peritajes viales',
        lat: 0.0420,
        lng: -78.1450,
        casosActivos: 0,
      ),
      TerritoryLawyer(
        id: 'LAWYER-001',
        nombre: 'Dra. Andrea Morales',
        canton: 'Ibarra',
        provincia: 'Imbabura',
        telefono: '+593 99 445 1200',
        unidadMovil: 'Móvil Legal #07 (Chevrolet D-Max • PCX-8822)',
        estadoGuardia: LawyerGuardStatus.enLinea,
        casosRecibidos: 10,
        casosAtendidosATiempo: 10,
        tiempoPromedioRespuestaMin: 6,
        especialidad: 'Defensa penal en flagrancia y peritajes SIAT Ibarra',
        lat: 0.3520,
        lng: -78.1230,
        casosActivos: 1,
      ),
    ];
  }

  void _loadInitialCases() {
    _cases = [
      LegalCase(
        id: '#CASO-1045',
        taxistaNombre: 'Esteban R. Benavides',
        taxistaCedula: '1004523891',
        taxistaTelefono: '+593 99 332 4455',
        cooperativa: 'Coop. 24 de Mayo',
        unidad: 'Unidad 33',
        placa: 'IBX-3301',
        vehiculoModelo: 'Kia Soluto 1.4 (2022)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: 'Otro problema: Conflicto Laboral y Despido Intempestivo',
        tipoAlertaCaso: TipoAlertaCaso.otroProblema,
        urgencia: UrgencyLevel.media,
        estado: CaseStatus.pendiente,
        ubicacionDireccion: 'Calle Bolívar y García Moreno, Los Ceibos, Ibarra',
        provincia: 'Imbabura',
        canton: 'Ibarra',
        tieneHeridosORetencion: false,
        alertaNivel: AlertaNivel.menor,
        lat: 0.3490,
        lng: -78.1235,
        horaReporte: 'Hace 4 min',
        dictamenIaCorto:
            'Art. 188 Código Trabajo: Procede liquidación por despido intempestivo más desahucio • Mediación laboral.',
        relatoConductor:
            'Terminación intempestiva de contrato de conducción y retención de depósito de garantía.',
        descripcionOtroProblema:
            'El dueño del taxi me notificó verbalmente la terminación del turno sin liquidación ni aviso previo tras 3 años de servicio continuo. Requiero asesoría jurídica laboral urgente para calcular el acta de finiquito y exigir la devolución de mi depósito en el Ministerio de Trabajo.',
        articuloCoip: 'Código del Trabajo Art. 188 • Despido Intempestivo y Liquidación Legal',
        dictamenIaRecomendacion:
            '1. No firmar finiquito en blanco ni desistimiento sin patrocinio legal.\n2. Concurrir a Inspectoría del Trabajo de Imbabura (Ibarra) para solicitar boleta única.\n3. Caso atendido bajo cobertura de Prueba Gratuita (7 de 10 consultas disponibles).',
        abogadoAsignado: null,
        horaDespacho: null,
        esPruebaGratuita: true,
        consultasGratuitasRestantes: 7,
        consultasGratuitasTotales: 10,
        esPlanVip: false,
        suscripcionPlan: 'Prueba Gratuita Piloto Ibarra (7/10 consultas)',
        evidencias: [
          DriverEvidence(
            type: 'doc',
            title: 'Contrato de Conducción y Rol',
            detail: 'PDF • Antigüedad 3 años',
            icon: Icons.description_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '10:20',
            title: 'Consulta Laboral Ingresada en Ibarra',
            description: 'Conductor reportó despido intempestivo desde la app.',
            icon: Icons.work_outline_rounded,
            color: const Color(0xFF7C3AED),
          ),
          CaseTimelineEvent(
            time: '10:21',
            title: 'Dictamen Preliminar IA Generado',
            description: 'Tipificación Art. 188 Código del Trabajo: procedencia de liquidación.',
            icon: Icons.auto_awesome,
            color: const Color(0xFF056AB4),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1046',
        taxistaNombre: 'Germán D. Cárdenas',
        taxistaCedula: '1003928174',
        taxistaTelefono: '+593 98 776 1122',
        cooperativa: 'Flota Imbabura',
        unidad: 'Unidad 05',
        placa: 'IAA-2099',
        vehiculoModelo: 'Chevrolet Sail 1.5 (2021)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: 'Agresión Física por Pasajero en Estado Etílico',
        tipoAlertaCaso: TipoAlertaCaso.agresionFisica,
        urgencia: UrgencyLevel.alta,
        estado: CaseStatus.pendiente,
        ubicacionDireccion: 'Av. Atahualpa y Teodoro Gómez, Ibarra',
        provincia: 'Imbabura',
        canton: 'Ibarra',
        tieneHeridosORetencion: true,
        alertaNivel: AlertaNivel.critico,
        lat: 0.3420,
        lng: -78.1280,
        horaReporte: 'Hace 6 min',
        dictamenIaCorto:
            'Art. 396 COIP: Contravención flagrante con agresión física • Fijación médica SIAT inmediata.',
        relatoConductor:
            'Pasajero en estado etílico me agredió físicamente con golpes en el rostro tras negarse a cancelar la tarifa de carrera reglamentaria. Se encuentra retenido con apoyo de otros compañeros taxistas en la Av. Atahualpa. Requiero presencia policial y auxilio legal urgente.',
        articuloCoip: 'Art. 396 COIP • Contravenciones de cuarta clase por agresión física y lesiones',
        dictamenIaRecomendacion:
            '1. Solicitar aprehensión flagrante del agresor por Policía Nacional.\n2. Traslado a médico legista de Fiscalía en Ibarra.\n3. Despachar abogado penal de guardia en Ibarra para audiencia contravencional.',
        abogadoAsignado: null,
        horaDespacho: null,
        esPruebaGratuita: false,
        esPlanVip: true,
        suscripcionPlan: 'Plan VIP Cobertura Total 24/7',
        evidencias: [
          DriverEvidence(
            type: 'photo',
            title: 'Foto Daño Físico y Retención',
            detail: 'JPG • Evidencia en Av. Atahualpa',
            icon: Icons.camera_alt_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '10:18',
            title: '🚨 Alerta Roja por Agresión Física',
            description: 'Conductor activó botón de emergencia ante agresión física en Ibarra.',
            icon: Icons.emergency_rounded,
            color: const Color(0xFFD32F2F),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1042',
        taxistaNombre: 'Carlos M. Mendoza',
        taxistaCedula: '1002849102',
        taxistaTelefono: '+593 99 482 1045',
        cooperativa: 'Los Lagos',
        unidad: 'Unidad 42',
        placa: 'IBX-4821',
        vehiculoModelo: 'Chevrolet Sail 1.5 (2022)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: 'Colisión Lateral / Intento de Retención en Patio',
        urgencia: UrgencyLevel.alta,
        estado: CaseStatus.pendiente,
        ubicacionDireccion: 'Panamericana Norte y Redondel, Otavalo',
        provincia: 'Imbabura',
        canton: 'Otavalo',
        tieneHeridosORetencion: true,
        alertaNivel: AlertaNivel.critico,
        lat: 0.2338,
        lng: -78.2612,
        horaReporte: 'Hace 5 min',
        dictamenIaCorto:
            'Art. 380 COIP: No conciliar sin SIAT • Entrega inmediata bajo acta de custodia sin retención en patio.',
        relatoConductor:
            'Vehículo particular rebasó en curva cerrada impactando mi costado izquierdo. Agentes civiles de Movidelnor intentan trasladar mi taxi al patio de retención alegando daño a bienes públicos.',
        articuloCoip: 'Art. 380 Inciso 3 COIP • Custodia Provisional de Vehículo en Siniestro',
        dictamenIaRecomendacion:
            '1. NO CONCILIAR bajo presión ni admitir responsabilidad preliminar.\n2. Al contar con matrícula vigente y SPPAT, según Art. 380 COIP procede entrega inmediata sin patio.\n3. Despachar abogado de guardia a Otavalo para vigilar emisión de parte policial.',
        abogadoAsignado: null,
        horaDespacho: null,
        evidencias: [
          DriverEvidence(
            type: 'audio',
            title: 'Audio Declaración Conductor en Vivo',
            detail: 'Duración: 0:38 seg • Otavalo',
            icon: Icons.mic_rounded,
          ),
          DriverEvidence(
            type: 'photo',
            title: 'Foto Daño Lateral Izquierdo',
            detail: 'JPG • Posición final en Panamericana',
            icon: Icons.camera_alt_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '10:14',
            title: 'Alerta SOS Recibida en Otavalo',
            description: 'Conductor activó el auxilio jurídico de emergencia.',
            icon: Icons.sensors_rounded,
            color: const Color(0xFFD32F2F),
          ),
          CaseTimelineEvent(
            time: '10:15',
            title: 'Dictamen IA Generado',
            description: 'Tipificación Art. 380 COIP: improcedencia de retención en patio.',
            icon: Icons.auto_awesome,
            color: const Color(0xFF056AB4),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1041',
        taxistaNombre: 'Segundo J. Chimarro',
        taxistaCedula: '1003849102',
        taxistaTelefono: '+593 98 554 4332',
        cooperativa: 'Flota Imbabura',
        unidad: 'Unidad 28',
        placa: 'IAA-4912',
        vehiculoModelo: 'Hyundai Elantra 1.6 (2022)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: '🚗💥 Me chocaron por alcance lateral con herido leve',
        urgencia: UrgencyLevel.alta,
        estado: CaseStatus.abogadoDespachado,
        ubicacionDireccion: 'Av. Mariano Acosta y Víctor Manuel Guzmán, Ibarra',
        provincia: 'Imbabura',
        canton: 'Ibarra',
        tieneHeridosORetencion: true,
        alertaNivel: AlertaNivel.critico,
        lat: 0.3480,
        lng: -78.1215,
        horaReporte: 'Hace 8 min',
        dictamenIaCorto:
            'Art. 379 COIP: Conductor impactado con derecho a indemnización • SPPAT activo para pasajero.',
        relatoConductor:
            'Camioneta invadió mi carril al girar en redondel de Ibarra. Pasajero presenta dolor cervical leve, ya llegó paramédico. Requiero que la abogada Dra. Andrea Morales levante el acta y peritaje SIAT para evitar retención del taxi.',
        articuloCoip: 'Art. 379 y 380 COIP • Daños materiales con lesiones leves y custodia inmediata',
        dictamenIaRecomendacion:
            '1. Asistir de inmediato al redondel para vigilar fijación fotográfica SIAT.\n2. Exigir prueba de alcoholemia al causante.\n3. Suscribir acta de entrega de unidad sin internamiento en patio Movidelnor.',
        abogadoAsignado: 'Dra. Andrea Morales',
        assignedLawyerId: 'LAWYER-001',
        horaDespacho: 'En camino (ETA: 4 min)',
        fueAsignadoAutomaticamente: true,
        distanciaAbogadoKm: 1.2,
        motivoAsignacion: 'Asignación directa a abogada de guardia en Ibarra',
        evidencias: [
          DriverEvidence(
            type: 'photo',
            title: 'Foto Impacto Lateral Redondel',
            detail: 'JPG • Daño puerta copiloto',
            icon: Icons.camera_alt_rounded,
          ),
          DriverEvidence(
            type: 'audio',
            title: 'Audio Conductor en Sitio',
            detail: 'Duración: 0:24 seg • Ibarra',
            icon: Icons.mic_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '10:05',
            title: 'Siniestro Reportado en Ibarra',
            description: 'Conductor reportó impacto lateral con herido leve.',
            icon: Icons.emergency_rounded,
            color: const Color(0xFFD32F2F),
          ),
          CaseTimelineEvent(
            time: '10:07',
            title: 'Asignación a Dra. Andrea Morales',
            description: 'Unidad Móvil #07 en desplazamiento hacia el redondel.',
            icon: Icons.directions_car_rounded,
            color: const Color(0xFF0D47A1),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1040',
        taxistaNombre: 'Marco V. Morales',
        taxistaCedula: '1001928374',
        taxistaTelefono: '+593 98 441 2233',
        cooperativa: 'Flota Imbabura',
        unidad: 'Unidad 15',
        placa: 'IAA-3012',
        vehiculoModelo: 'Hyundai Accent 1.4 (2021)',
        estadoSeguro: 'Póliza Activa • Aseguradora del Sur',
        tipoIncidente: 'Choque en Intersección con Pasajero Contuso',
        urgencia: UrgencyLevel.alta,
        estado: CaseStatus.abogadoDespachado,
        ubicacionDireccion: 'Av. Cristóbal de Troya y Fray Vacas Galindo, Ibarra',
        provincia: 'Imbabura',
        canton: 'Ibarra',
        tieneHeridosORetencion: true,
        alertaNivel: AlertaNivel.critico,
        lat: 0.3517,
        lng: -78.1223,
        horaReporte: 'Hace 12 min',
        dictamenIaCorto:
            'Art. 379/380 COIP: Lesiones leves • Custodia médica SPPAT y peritaje SIAT obligatorio antes de audiencia.',
        relatoConductor:
            'Motociclista invadió carril preferencial. El pasajero de mi unidad tiene golpe superficial en rodilla. Llegó ambulancia del 911 y se requiere abogado para levantar parte.',
        articuloCoip: 'Art. 379 COIP • Lesiones en siniestro de tránsito con incapacidad menor',
        dictamenIaRecomendacion:
            'Activar cobertura médica de pasajeros SPPAT. No permitir retención prolongada si SIAT constata posición en vía preferencial.',
        abogadoAsignado: 'Abg. Roberto Andrade',
        assignedLawyerId: 'ABG-03',
        horaDespacho: 'Hace 8 min (En camino)',
        fueAsignadoAutomaticamente: true,
        distanciaAbogadoKm: 1.8,
        motivoAsignacion: 'GPS inteligente: Unidad más cercana en Ibarra (1.8 km)',
        evidencias: [
          DriverEvidence(
            type: 'photo',
            title: 'Foto Posición Vehículos en Ibarra',
            detail: 'JPG • Fijación de huellas de frenado',
            icon: Icons.camera_alt_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '10:02',
            title: 'Alerta SOS Activada',
            description: 'Reporte de siniestro vial en Ibarra.',
            icon: Icons.emergency,
            color: const Color(0xFFD32F2F),
          ),
          CaseTimelineEvent(
            time: '10:06',
            title: '⚡ Despacho Automático por Georreferenciación GPS',
            description: 'Abg. Roberto Andrade despachado por motor inteligente (Distancia: 1.8 km).',
            icon: Icons.bolt_rounded,
            color: const Color(0xFF0D47A1),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1038',
        taxistaNombre: 'Nelson P. Farinango',
        taxistaCedula: '1004128901',
        taxistaTelefono: '+593 99 223 3445',
        cooperativa: 'Los Lagos',
        unidad: 'Unidad 08',
        placa: 'IBX-9901',
        vehiculoModelo: 'Kia Soluto 1.4 (2023)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: 'Choque por Alcance en Semáforo (Solo Daños)',
        urgencia: UrgencyLevel.media,
        estado: CaseStatus.dictamenAprobado,
        ubicacionDireccion: 'Calle Bolívar y Sucre, Parque Central, Cotacachi',
        provincia: 'Imbabura',
        canton: 'Cotacachi',
        tieneHeridosORetencion: false,
        alertaNivel: AlertaNivel.regular,
        lat: 0.3015,
        lng: -78.2638,
        horaReporte: 'Hace 22 min',
        dictamenIaCorto:
            'Art. 380 COIP: Mediación extrajudicial directa • Suscripción de acta de finiquito por repuesto (\$70).',
        relatoConductor:
            'Camioneta particular frenó de golpe en el parque central de Cotacachi y rozó mi parachoque delantero. Ambos conductores estamos de acuerdo en conciliar sin Movidelnor.',
        articuloCoip: 'Art. 380 COIP • Daños materiales con acuerdo transaccional voluntario',
        dictamenIaRecomendacion:
            'Formalizar acta de mediación directa con firma de desistimiento total. Dra. Elena Torres disponible en Cotacachi para sellar acta.',
        abogadoAsignado: 'Dra. Elena Torres',
        assignedLawyerId: 'ABG-02',
        horaDespacho: 'Hace 15 min',
        fueAsignadoAutomaticamente: true,
        distanciaAbogadoKm: 2.3,
        motivoAsignacion: 'GPS inteligente: Unidad disponible en Cotacachi (2.3 km)',
        evidencias: [
          DriverEvidence(
            type: 'photo',
            title: 'Foto Parachoques Delantero',
            detail: 'JPG • Daño estético menor',
            icon: Icons.camera_alt_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '09:55',
            title: 'Reporte Ingresado en Cotacachi',
            description: 'Conductor solicitó plantilla de conciliación.',
            icon: Icons.receipt_long,
            color: const Color(0xFF757575),
          ),
          CaseTimelineEvent(
            time: '10:00',
            title: 'Dictamen Aprobado',
            description: 'Acta transaccional enviada al WhatsApp del conductor.',
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF2E7D32),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1035',
        taxistaNombre: 'Wilson E. Caiza',
        taxistaCedula: '1003456781',
        taxistaTelefono: '+593 99 123 9876',
        cooperativa: 'Los Lagos',
        unidad: 'Unidad 78',
        placa: 'IBX-1122',
        vehiculoModelo: 'Kia Soluto 1.4 (2023)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: 'Choque por Alcance Posterior de Motocicleta',
        urgencia: UrgencyLevel.media,
        estado: CaseStatus.dictamenAprobado,
        ubicacionDireccion: 'Panamericana Sur y Eugenio Espejo, Otavalo',
        provincia: 'Imbabura',
        canton: 'Otavalo',
        tieneHeridosORetencion: false,
        alertaNivel: AlertaNivel.regular,
        lat: 0.2210,
        lng: -78.2580,
        horaReporte: 'Hace 35 min',
        suscripcionActiva: false,
        suscripcionEstado: 'Membresía Vencida',
        asistenciaCondicionadaAutorizada: false,
        dictamenIaCorto:
            'Art. 380 COIP: Acuerdo transaccional notarial • Pago directo de faro posterior sin paralizar unidad.',
        relatoConductor:
            'Motocicleta de reparto impactó faro posterior mientras esperaba el verde. Conductor de moto reconoce culpa y propone transferir el costo del faro.',
        articuloCoip: 'Art. 380 COIP • Procedimiento de acuerdo extrajudicial en tránsito',
        dictamenIaRecomendacion:
            'Fijar fotos finales, constatar transferencia de valor de repuesto y suscribir recibo de indemnidad recíproca.',
        abogadoAsignado: 'Dr. Marcelo Dávila',
        assignedLawyerId: 'ABG-01',
        horaDespacho: 'Hace 20 min',
        evidencias: [
          DriverEvidence(
            type: 'photo',
            title: 'Foto Faro Posterior Dañado',
            detail: 'JPG • Evidencia de impacto',
            icon: Icons.camera_alt_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '09:44',
            title: 'Incidente Registrado',
            description: 'Reporte ingresado desde Otavalo.',
            icon: Icons.receipt_long,
            color: const Color(0xFF757575),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1031',
        taxistaNombre: 'Segundo M. Quishpe',
        taxistaCedula: '1708819234',
        taxistaTelefono: '+593 96 345 6789',
        cooperativa: 'Coop. San Cristóbal',
        unidad: 'Unidad 25',
        placa: 'PBA-3401',
        vehiculoModelo: 'Chevrolet Aveo Family (2018)',
        estadoSeguro: 'Póliza Activa • Seguros Unidos',
        tipoIncidente: 'Citación Injustificada por Giro en Obra Vial',
        urgencia: UrgencyLevel.baja,
        estado: CaseStatus.dictamenAprobado,
        ubicacionDireccion: 'Av. Prensa y El Inca, La Concepción, Quito',
        provincia: 'Pichincha',
        canton: 'Quito',
        tieneHeridosORetencion: false,
        alertaNivel: AlertaNivel.menor,
        lat: -0.1554,
        lng: -78.4912,
        horaReporte: 'Hace 1 hora',
        dictamenIaCorto:
            'Art. 389 Num. 1 COIP: Impugnación de citación en 3 días • Eximente de fuerza mayor por desvío vial.',
        relatoConductor:
            'Agente civil emitió citación por invadir carril exclusivo cuando el desvío estaba señalizado por repavimentación.',
        articuloCoip: 'Art. 389 Numeral 1 COIP • Impugnación contravencional',
        dictamenIaRecomendacion:
            'Ingresar escrito de impugnación con fotos de la señalización temporal.',
        abogadoAsignado: 'Dra. Sofía Proaño',
        assignedLawyerId: 'ABG-05',
        horaDespacho: 'Hace 45 min',
        evidencias: [],
        timeline: [
          CaseTimelineEvent(
            time: '09:15',
            title: 'Ingreso para Impugnación',
            description: 'Carga de citación digital para defensa.',
            icon: Icons.balance,
            color: const Color(0xFF1565C0),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1024',
        taxistaNombre: 'Manuel A. Guamán',
        taxistaCedula: '1711223344',
        taxistaTelefono: '+593 98 111 2233',
        cooperativa: 'Coop. El Tejar',
        unidad: 'Unidad 14',
        placa: 'PBZ-7711',
        vehiculoModelo: 'Toyota Yaris 1.5 (2022)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: 'Rozamiento de Espejo Retrovisor en Túnel',
        urgencia: UrgencyLevel.baja,
        estado: CaseStatus.atendido,
        ubicacionDireccion: 'Túnel de San Juan, Quito',
        provincia: 'Pichincha',
        canton: 'Quito',
        tieneHeridosORetencion: false,
        alertaNivel: AlertaNivel.menor,
        lat: -0.2180,
        lng: -78.5080,
        horaReporte: 'Hace 2 horas',
        dictamenIaCorto:
            'Caso Resuelto: Acta transaccional finiquitada y conformidad de pago (\$40) sin riesgo legal.',
        relatoConductor:
            'Roce con bus urbano. Se acordó \$40 para pintura de espejo. Caso resuelto en el lugar.',
        articuloCoip: 'Conciliación Inmediata • Sin procedimiento judicial',
        dictamenIaRecomendacion:
            'Caso archivado con recibo de conformidad mutua firmado.',
        abogadoAsignado: 'Dra. Sofía Proaño',
        assignedLawyerId: 'ABG-05',
        horaDespacho: 'Hace 2 horas',
        evidencias: [],
        timeline: [
          CaseTimelineEvent(
            time: '08:10',
            title: 'Caso Finalizado',
            description: 'Conductor reportó conformidad y reanudó ruta.',
            icon: Icons.task_alt,
            color: const Color(0xFF2E7D32),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1029',
        taxistaNombre: 'Luis H. Alvear',
        taxistaCedula: '1002345671',
        taxistaTelefono: '+593 99 887 7665',
        cooperativa: 'Coop. 24 de Mayo',
        unidad: 'Unidad 19',
        placa: 'IBX-2200',
        vehiculoModelo: 'Kia Soluto (2021)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: 'Rozamiento en redondel Ajaví',
        urgencia: UrgencyLevel.baja,
        estado: CaseStatus.atendido,
        ubicacionDireccion: 'Redondel Ajaví, Ibarra',
        provincia: 'Imbabura',
        canton: 'Ibarra',
        tieneHeridosORetencion: false,
        alertaNivel: AlertaNivel.menor,
        lat: 0.3440,
        lng: -78.1250,
        horaReporte: 'Hace 3 horas',
        dictamenIaCorto:
            'Art. 380 COIP: Acta de mediación suscrita (\$60) sin paralizar la unidad.',
        relatoConductor:
            'Roce lateral menor resuelto en sitio con acta de desistimiento firmada ante la abogada Dra. Andrea Morales.',
        articuloCoip: 'Art. 380 COIP • Conciliación voluntaria extrajudicial',
        dictamenIaRecomendacion:
            'Caso resuelto favorablemente.',
        abogadoAsignado: 'Dra. Andrea Morales',
        assignedLawyerId: 'LAWYER-001',
        horaDespacho: 'Hace 3 horas',
        evidencias: [],
        timeline: [
          CaseTimelineEvent(
            time: '07:30',
            title: 'Caso Finalizado y Archivada Acta',
            description: 'Acuerdo económico cumplido y desistimiento firmado.',
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF2E7D32),
          ),
        ],
      ),
    ];
  }

  // --- FILTRADO EN CASCADA Y ACCESOS RÁPIDOS PILOTO IBARRA ---
  void selectPilotIbarra() {
    _selectedProvince = 'Imbabura';
    _selectedCanton = 'Ibarra';
    _selectedCooperative = 'Todas';
    _ensureValidCaseSelection();
    animateMapToCoordinates(0.3517, -78.1223, zoom: 13.5);
    update();
  }

  void selectProvinceImbaburaAll() {
    _selectedProvince = 'Imbabura';
    _selectedCanton = 'Todos';
    _selectedCooperative = 'Todas';
    _ensureValidCaseSelection();
    animateMapToCoordinates(0.3517, -78.1223, zoom: 11.5);
    update();
  }

  void selectProvincePichincha() {
    _selectedProvince = 'Pichincha';
    _selectedCanton = 'Todos';
    _selectedCooperative = 'Todas';
    _ensureValidCaseSelection();
    animateMapToCoordinates(-0.1807, -78.4678, zoom: 11.5);
    update();
  }

  void selectProvince(String province) {
    _selectedProvince = province;
    if (province == 'Imbabura') {
      _selectedCanton = 'Ibarra';
      animateMapToCoordinates(0.3517, -78.1223, zoom: 13.5);
    } else if (province == 'Pichincha') {
      _selectedCanton = 'Todos';
      animateMapToCoordinates(-0.1807, -78.4678, zoom: 11.5);
    } else {
      _selectedCanton = 'Todos';
      resetMapToDefaultBounds();
    }
    _ensureValidCaseSelection();
    update();
  }

  void selectCanton(String canton) {
    _selectedCanton = canton;
    _ensureValidCaseSelection();
    switch (canton.toLowerCase()) {
      case 'otavalo':
        animateMapToCoordinates(0.2338, -78.2612, zoom: 13.5);
        break;
      case 'ibarra':
        animateMapToCoordinates(0.3517, -78.1223, zoom: 13.5);
        break;
      case 'cotacachi':
        animateMapToCoordinates(0.2980, -78.2620, zoom: 13.5);
        break;
      case 'quito':
        animateMapToCoordinates(-0.1807, -78.4678, zoom: 13.0);
        break;
      case 'cayambe':
        animateMapToCoordinates(0.0420, -78.1450, zoom: 13.0);
        break;
      default:
        resetMapToDefaultBounds();
    }
    update();
  }

  void selectCooperative(String coop) {
    _selectedCooperative = coop;
    _ensureValidCaseSelection();
    update();
  }

  void resetFilters() {
    _selectedProvince = 'Imbabura';
    _selectedCanton = 'Ibarra';
    _selectedCooperative = 'Todas';
    _searchQuery = '';
    _activeKpiFilter = null;
    searchController.clear();
    _ensureValidCaseSelection();
    resetMapToDefaultBounds();
    update();
  }

  void resetCasesFilters({bool shouldUpdate = true}) {
    _searchQuery = '';
    searchController.clear();
    _selectedCooperative = 'Todas';
    _ensureValidCaseSelection();
    if (shouldUpdate) {
      update();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _ensureValidCaseSelection();
    update();
  }

  void selectCase(LegalCase caseItem, {bool isMobile = false, bool moveMap = true}) {
    _selectedCase = caseItem;
    _selectedLawyer = null;
    if (isMobile) {
      _mobileTabIndex = 1;
    }
    if (moveMap) {
      animateMapToCoordinates(caseItem.lat, caseItem.lng, zoom: 14.8);
    }
    update();
  }

  void setMobileTab(int index) {
    _mobileTabIndex = index;
    update();
  }

  void _ensureValidCaseSelection() {
    final filtered = filteredCases;
    if (filtered.isNotEmpty &&
        (_selectedCase == null || !filtered.contains(_selectedCase))) {
      _selectedCase = filtered.first;
    }
  }

  // Lista filtrada por territorio (para alimentar los KPIs de la cabecera)
  List<LegalCase> get filteredByTerritoryCases {
    return _cases.where((c) {
      final matchesProv =
          _selectedProvince == 'Todas' || c.provincia == _selectedProvince;
      final matchesCanton =
          _selectedCanton == 'Todos' || c.canton == _selectedCanton;
      final matchesCoop = _selectedCooperative == 'Todas' ||
          c.cooperativa.toLowerCase().contains(
                _selectedCooperative.toLowerCase().replaceAll('coop. ', ''),
              );
      return matchesProv && matchesCanton && matchesCoop;
    }).toList();
  }

  // Lista filtrada completa (Territorio + Buscador + KPI activo)
  List<LegalCase> get filteredCases {
    return filteredByTerritoryCases.where((c) {
      // Filtro KPI opcional
      if (_activeKpiFilter == 'rojo') {
        final isRed = (c.alertaNivel == AlertaNivel.critico || c.tieneHeridosORetencion) &&
            c.estado != CaseStatus.atendido;
        if (!isRed) return false;
      } else if (_activeKpiFilter == 'pendiente') {
        if (c.estado != CaseStatus.pendiente) return false;
      } else if (_activeKpiFilter == 'proceso') {
        final isInProcess = c.estado == CaseStatus.abogadoDespachado ||
            c.estado == CaseStatus.dictamenAprobado ||
            c.estado == CaseStatus.atendido;
        if (!isInProcess) return false;
      }

      // Buscador
      final query = _searchQuery.toLowerCase();
      if (query.isEmpty) return true;

      return c.id.toLowerCase().contains(query) ||
          c.taxistaNombre.toLowerCase().contains(query) ||
          c.placa.toLowerCase().contains(query) ||
          c.unidad.toLowerCase().contains(query) ||
          c.cooperativa.toLowerCase().contains(query) ||
          c.tipoIncidente.toLowerCase().contains(query) ||
          c.ubicacionDireccion.toLowerCase().contains(query) ||
          c.canton.toLowerCase().contains(query);
    }).toList();
  }

  // --- CASOS ASIGNADOS AL ABOGADO EN SESIÓN (ROLE: associateLawyer) ---
  List<LegalCase> get myAssignedCases {
    if (Get.isRegistered<AuthMockController>()) {
      final auth = Get.find<AuthMockController>();
      final lawyerId = auth.currentUser.value.id;
      final lawyerName = auth.currentUser.value.name.toLowerCase();

      return _cases.where((c) {
        if (c.assignedLawyerId != null && c.assignedLawyerId == lawyerId) {
          return true;
        }
        if (c.abogadoAsignado != null &&
            (c.abogadoAsignado!.toLowerCase().contains(lawyerName) ||
                lawyerName.contains(c.abogadoAsignado!.toLowerCase()))) {
          return true;
        }
        return false;
      }).toList();
    }
    return _cases.where((c) => c.assignedLawyerId == 'LAWYER-001').toList();
  }

  // Siniestro activo asignado al abogado de turno (en camino o en atención)
  LegalCase? get myActiveAssignedCase {
    final assigned = myAssignedCases;
    try {
      return assigned.firstWhere((c) => c.estado != CaseStatus.atendido);
    } catch (_) {
      return null;
    }
  }

  // --- BLOQUE 1: CONTADORES RÁPIDOS (KPI CARDS) ---
  // 🔴 Urgentes / Código Rojo: Incidentes con heridos o retenciones activas
  int get redCodeCount {
    return filteredByTerritoryCases
        .where((c) =>
            (c.alertaNivel == AlertaNivel.critico || c.tieneHeridosORetencion) &&
            c.estado != CaseStatus.atendido)
        .length;
  }

  // 🟡 Pendientes de Atención: En espera de abogado en territorio
  int get pendingAttentionCount {
    return filteredByTerritoryCases
        .where((c) => c.estado == CaseStatus.pendiente)
        .length;
  }

  // 🟢 Atendidos / En Proceso: Con abogado despachado o resuelto
  int get inProcessOrSolvedCount {
    return filteredByTerritoryCases
        .where((c) =>
            c.estado == CaseStatus.abogadoDespachado ||
            c.estado == CaseStatus.dictamenAprobado ||
            c.estado == CaseStatus.atendido)
        .length;
  }

  // Mantener compatibilidad con widgets existentes
  int get totalCasesCount => filteredByTerritoryCases.length;
  int get urgentPendingCasesCount => redCodeCount;
  int get dispatchedCount => filteredByTerritoryCases
      .where((c) => c.estado == CaseStatus.abogadoDespachado)
      .length;

  String get topCooperative {
    final counts = <String, int>{};
    for (var c in filteredByTerritoryCases) {
      counts[c.cooperativa] = (counts[c.cooperativa] ?? 0) + 1;
    }
    String top = 'Los Lagos';
    int max = 0;
    counts.forEach((k, v) {
      if (v > max) {
        max = v;
        top = k;
      }
    });
    return top;
  }

  Map<String, int> get cooperativeCounts {
    final map = <String, int>{
      'Todas': _cases.length,
    };
    for (var coop in cooperatives) {
      if (coop != 'Todas') {
        map[coop] = _cases.where((c) => c.cooperativa == coop).length;
      }
    }
    return map;
  }

  // --- REASIGNACIÓN RÁPIDA DE ABOGADO ---
  void reassignLawyer(String caseId, String lawyerName) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.abogadoAsignado = lawyerName;
      if (c.estado == CaseStatus.pendiente) {
        c.estado = CaseStatus.abogadoDespachado;
        c.horaDespacho = 'En camino (ETA: 10 min)';
      }
      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: 'Abogado Reasignado',
          description:
              'Caso asignado formalmente a $lawyerName para cobertura inmediata en territorio.',
          icon: Icons.person_pin_circle_rounded,
          color: const Color(0xFF1565C0),
        ),
      );
      _selectedCase = c;
      update();

      Get.snackbar(
        '👤 Abogado Asignado',
        'Se asignó a $lawyerName al caso $caseId con éxito.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D47A1),
        colorText: Colors.white,
        icon: const Icon(Icons.assignment_turned_in, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    }
  }

  // --- TOMA DE DECISIONES DE DESPACHO Y COBERTURA (ROL 2: DR. EMIR VÁSQUEZ) ---

  /// Autoriza asistencia legal condicionada a un conductor con membresía vencida
  void autorizarAsistenciaCondicionada(String caseId) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.asistenciaCondicionadaAutorizada = true;
      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: '🛡️ Cobertura Condicionada Autorizada',
          description:
              'El Director Legal Dr. Emir Vásquez autorizó el patrocinio humanitario inmediato para evitar retención del vehículo en patio.',
          icon: Icons.verified_user_rounded,
          color: const Color(0xFF16A34A),
        ),
      );
      _selectedCase = c;
      update();

      if (Get.key.currentState?.overlay != null) {
        Get.snackbar(
          '🛡️ Asistencia Condicionada Autorizada',
          'El Director Dr. Emir Vásquez aprobó la cobertura para ${c.taxistaNombre} (${c.cooperativa}). Procediendo con asignación prioritaria.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF16A34A),
          colorText: Colors.white,
          icon: const Icon(Icons.shield_rounded, color: Colors.amber, size: 28),
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  /// Notifica al conductor o a la cooperativa para regularizar el pago de membresía
  void notificarRegularizacionPago(String caseId) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: '📲 Notificación de Regularización Emitida',
          description:
              'Aviso formal enviado a ${c.taxistaNombre} y directiva de ${c.cooperativa} para regularizar el aporte (\$1.00/mes).',
          icon: Icons.notification_important_rounded,
          color: const Color(0xFFD97706),
        ),
      );
      _selectedCase = c;
      update();

      if (Get.key.currentState?.overlay != null) {
        Get.snackbar(
          '📲 Recordatorio de Pago Enviado',
          'Se notificó la regularización a ${c.taxistaNombre} (${c.cooperativa}) al teléfono ${c.taxistaTelefono}.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFD97706),
          colorText: Colors.white,
          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  // --- BLOQUE 3: ESCALAMIENTO DIRECTO DE CASOS ---
  void escalateLawyerCases(
    String fromLawyerName,
    String toLawyerName, {
    String? reason,
  }) {
    int affectedCases = 0;
    final isDisassociated = reason != null &&
        (reason.toLowerCase().contains('asociado') ||
            reason.toLowerCase().contains('desvincul'));

    for (var c in _cases) {
      if (c.abogadoAsignado == fromLawyerName &&
          c.estado != CaseStatus.atendido) {
        c.abogadoAsignado = toLawyerName;
        c.horaDespacho = isDisassociated
            ? 'Remitido por Desvinculación (ETA: 10 min)'
            : 'Escalamiento Directo (ETA: 8 min)';
        c.timeline.insert(
          0,
          CaseTimelineEvent(
            time: 'Ahora',
            title: isDisassociated
                ? '⚖️ Caso Remitido por Desvinculación'
                : '⚡ Escalamiento Territorial Directo',
            description: isDisassociated
                ? 'El abogado $fromLawyerName ya no se encuentra asociado a la red LegalTech. El caso se remitió de forma definitiva a $toLawyerName para continuar su representación.'
                : 'Caso transferido de urgencia de $fromLawyerName hacia $toLawyerName por: ${reason ?? "falta de respuesta en tiempo SLA"}.',
            icon: isDisassociated
                ? Icons.sync_alt_rounded
                : Icons.flash_on_rounded,
            color: isDisassociated
                ? const Color(0xFFE65100)
                : const Color(0xFFD32F2F),
          ),
        );
        affectedCases++;
      }
    }

    // Actualizar estado del abogado saliente
    final fromLawyerIndex =
        _lawyers.indexWhere((l) => l.nombre == fromLawyerName);
    if (fromLawyerIndex != -1) {
      _lawyers[fromLawyerIndex].estadoGuardia = isDisassociated
          ? LawyerGuardStatus.noAsociado
          : LawyerGuardStatus.noDisponible;
    }

    update();

    if (isDisassociated) {
      Get.snackbar(
        '⚖️ Casos Remitidos por Desvinculación',
        'El abogado $fromLawyerName ya no se encuentra asociado a la red. Se remitieron $affectedCases caso(s) formalmente a $toLawyerName.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF37474F),
        colorText: Colors.white,
        icon: const Icon(Icons.person_remove_rounded, color: Colors.white, size: 28),
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        '⚡ Escalamiento Ejecutado',
        'Se transfirieron $affectedCases casos de $fromLawyerName a $toLawyerName de forma inmediata.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        icon: const Icon(Icons.notification_important, color: Colors.white, size: 28),
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // Cambiar estado de guardia de un abogado
  void updateLawyerStatus(String lawyerId, LawyerGuardStatus newStatus) {
    final index = _lawyers.indexWhere((l) => l.id == lawyerId);
    if (index != -1) {
      _lawyers[index].estadoGuardia = newStatus;
      update();

      Get.snackbar(
        'Guardia Actualizada',
        '${_lawyers[index].nombre} ahora está: ${_lawyers[index].estadoLabel}.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF263238),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // --- APROBACIÓN DE DICTAMEN ---
  void approveDictamen(String caseId) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.estado = CaseStatus.dictamenAprobado;
      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: 'Dictamen Jurídico Aprobado',
          description:
              'El despacho jurídico aprobó el dictamen oficial con sello digital.',
          icon: Icons.verified_user_rounded,
          color: const Color(0xFF2E7D32),
        ),
      );
      _selectedCase = c;
      update();

      Get.snackbar(
        '⚖️ Dictamen Aprobado',
        'El dictamen para el caso $caseId fue validado exitosamente.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1B5E20),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    }
  }

  // --- DESPACHAR ABOGADO (Método existente compatible) ---
  void dispatchLawyer(String caseId, String lawyerName, String arrivalMinutes) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.estado = CaseStatus.abogadoDespachado;
      c.abogadoAsignado = lawyerName;
      c.horaDespacho = 'En camino (ETA: $arrivalMinutes min)';
      c.urgencia = UrgencyLevel.media;

      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: 'Abogado Móvil Despachado',
          description:
              '$lawyerName despachado en la Unidad Legal Móvil hacia la ubicación del siniestro. ETA: $arrivalMinutes min.',
          icon: Icons.local_taxi_rounded,
          color: const Color(0xFF1565C0),
        ),
      );
      _selectedCase = c;
      update();

      Get.snackbar(
        '🚨 Abogado Despachado',
        'Se asignó a $lawyerName al caso $caseId. Unidad en camino (ETA: $arrivalMinutes min).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D47A1),
        colorText: Colors.white,
        icon: const Icon(Icons.directions_car, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    }
  }

  // --- ENCOLAR CASO SECUNDARIO PARA ABOGADO CON ATENCIÓN ACTIVA ---
  void enqueueCaseForLawyer(String caseId, String lawyerName, {String? incidentTitle}) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.abogadoAsignado = '$lawyerName (En espera/cola)';
      c.horaDespacho = 'Encolado (Siguiente turno)';

      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: 'Caso Encolado en Turno Secundario',
          description:
              'Asignado a $lawyerName. La unidad móvil se trasladará automáticamente a este siniestro al concluir su gestión en curso.',
          icon: Icons.queue_rounded,
          color: const Color(0xFF0D47A1),
        ),
      );
      _selectedCase = c;
      update();

      Get.snackbar(
        '📋 Caso Encolado con Éxito',
        'El caso $caseId fue encolado para $lawyerName (se atenderá tras culminar su siniestro actual).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D47A1),
        colorText: Colors.white,
        icon: const Icon(Icons.queue_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
      );
    } else {
      Get.snackbar(
        '📋 Caso Encolado con Éxito',
        'El caso $caseId fue encolado para $lawyerName al culminar su siniestro actual.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D47A1),
        colorText: Colors.white,
        icon: const Icon(Icons.queue_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
      );
    }
  }

  // --- CÁLCULO DE DISTANCIA GPS (HAVERSINE) ---
  double calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295; // Pi / 180
    final double a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) * math.cos(lat2 * p) * (1 - math.cos((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }

  // --- MOTOR DE SELECCIÓN DE ABOGADO MÁS CERCANO Y DISPONIBLE ---
  TerritoryLawyer? findOptimalLawyerForCase(LegalCase caseItem) {
    // 1. Filtrar abogados que no estén desvinculados ni no disponibles
    final eligible = _lawyers.where((l) =>
        l.estadoGuardia != LawyerGuardStatus.noDisponible &&
        l.estadoGuardia != LawyerGuardStatus.noAsociado
    ).toList();

    if (eligible.isEmpty) return null;

    // 2. Dar prioridad a los que están 'enLinea' (disponibles en vía o guardia)
    final onlineLawyers = eligible.where((l) => l.estadoGuardia == LawyerGuardStatus.enLinea).toList();
    final candidates = onlineLawyers.isNotEmpty ? onlineLawyers : eligible;

    TerritoryLawyer? bestLawyer;
    double bestScore = double.infinity;

    for (final law in candidates) {
      final distKm = calculateDistanceKm(caseItem.lat, caseItem.lng, law.lat, law.lng);
      final cantonBonus = (law.canton.toLowerCase() == caseItem.canton.toLowerCase()) ? 0.0 : 4.0;
      final loadPenalty = law.casosActivos * 3.0;
      final statusPenalty = (law.estadoGuardia == LawyerGuardStatus.enLinea) ? 0.0 : 8.0;

      final score = distKm + cantonBonus + loadPenalty + statusPenalty;
      if (score < bestScore) {
        bestScore = score;
        bestLawyer = law;
      }
    }

    return bestLawyer;
  }

  // --- EJECUTAR DESPACHO AUTOMÁTICO ---
  bool autoDispatchCase(LegalCase caseItem, {bool notifySnackbar = true}) {
    final lawyer = findOptimalLawyerForCase(caseItem);
    if (lawyer == null) return false;

    final distKm = calculateDistanceKm(caseItem.lat, caseItem.lng, lawyer.lat, lawyer.lng);
    final distFormatted = distKm.toStringAsFixed(1);
    final etaMinutes = ((distKm / 35.0) * 60 + 3).round().clamp(5, 20).toString();

    caseItem.estado = CaseStatus.abogadoDespachado;
    caseItem.abogadoAsignado = lawyer.nombre;
    caseItem.horaDespacho = 'En camino (ETA: $etaMinutes min)';
    caseItem.fueAsignadoAutomaticamente = true;
    caseItem.distanciaAbogadoKm = double.tryParse(distFormatted) ?? distKm;
    caseItem.motivoAsignacion = 'GPS inteligente: Unidad libre más cercana ($distFormatted km • ${lawyer.canton})';
    lawyer.casosActivos += 1;

    caseItem.timeline.insert(
      0,
      CaseTimelineEvent(
        time: 'Ahora',
        title: '⚡ Despacho Automático por Georreferenciación GPS',
        description:
            'El algoritmo inteligente asignó a ${lawyer.nombre} (${lawyer.unidadMovil}) por ser la unidad libre más cercana ($distFormatted km). Arribo estimado: $etaMinutes min.',
        icon: Icons.bolt_rounded,
        color: const Color(0xFF0D47A1),
      ),
    );

    update();

    if (notifySnackbar) {
      Get.snackbar(
        '⚡ Despacho Automático por GPS',
        'Se asignó a ${lawyer.nombre} al caso ${caseItem.id} ($distFormatted km • ETA: $etaMinutes min).',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF0D47A1),
        colorText: Colors.white,
        icon: const Icon(Icons.bolt_rounded, color: Colors.amber, size: 28),
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(16),
      );
    }

    return true;
  }

  // --- REASIGNACIÓN / OVERRIDE MANUAL POR EL OPERADOR ---
  void overrideCaseLawyer(String caseId, String newLawyerName, String arrivalMinutes, {String reason = 'Reasignación manual del Administrador'}) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      final prevLawyer = c.abogadoAsignado ?? 'Sin asignar';

      c.estado = CaseStatus.abogadoDespachado;
      c.abogadoAsignado = newLawyerName;
      c.horaDespacho = 'En camino (ETA: $arrivalMinutes min)';
      c.fueAsignadoAutomaticamente = false;
      c.motivoAsignacion = reason;

      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: '👤 Asignación Manual por Operador Central',
          description:
              'El operador reasignó manualmente a $newLawyerName (anterior: $prevLawyer). Motivo: $reason.',
          icon: Icons.assignment_ind_rounded,
          color: const Color(0xFF1565C0),
        ),
      );
      _selectedCase = c;
      update();

      Get.snackbar(
        '👤 Asignación Manual Confirmada',
        'El caso $caseId fue asignado formalmente a $newLawyerName.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1565C0),
        colorText: Colors.white,
        icon: const Icon(Icons.verified_user_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    }
  }

  // --- ASIGNACIÓN AL DESPACHO CORPORATIVO (GRUPO ECUADOR TOTAL ABOGADOS) ---
  void dispatchToCorporateGroup(String caseId) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.estado = CaseStatus.abogadoDespachado;
      c.abogadoAsignado = 'Grupo Ecuador Total Abogados';
      c.assignedLawyerId = 'CORP-01';
      c.despachoCorporativo = 'Grupo Ecuador Total Abogados';
      c.horaDespacho = 'En gestión central corporativa (24/7)';
      c.fueAsignadoAutomaticamente = false;
      c.motivoAsignacion =
          'Asignación directa a Despacho Corporativo Central: Grupo Ecuador Total Abogados';
      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: '⚖️ Asignado al Despacho Corporativo',
          description:
              'Caso asignado formalmente a la central jurídica corporativa Grupo Ecuador Total Abogados para atención integral.',
          icon: Icons.business_rounded,
          color: const Color(0xFF0D47A1),
        ),
      );
      _selectedCase = c;
      update();

      if (Get.key.currentState?.overlay != null) {
        Get.snackbar(
          '⚖️ Despacho Corporativo Asignado',
          'El caso ${c.id} fue asignado al Grupo Ecuador Total Abogados con éxito.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0D47A1),
          colorText: Colors.white,
          icon: const Icon(Icons.business_rounded, color: Colors.amber, size: 28),
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  // --- BOTÓN DE SIMULACIÓN PARA DEMOS EN VIVO ---
  void simulateIncomingDriverAlert({bool notifySnackbar = true}) {
    final newCase = LegalCase(
      id: '#CASO-${1043 + _cases.length}',
      taxistaNombre: 'Patricio Guanoluisa',
      taxistaCedula: '1004928172',
      taxistaTelefono: '+593 99 777 8899',
      cooperativa: 'Flota Imbabura',
      unidad: 'Unidad 99',
      placa: 'IBX-9012',
      vehiculoModelo: 'Chevrolet Sail 1.5 (2023)',
      estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
      tipoIncidente: 'Colisión Frontal con Intento de Fuga y Agresión',
      tipoAlertaCaso: TipoAlertaCaso.transitoChoque,
      urgencia: UrgencyLevel.alta,
      estado: CaseStatus.pendiente,
      ubicacionDireccion: 'Av. Mariano Acosta y Fray Vacas Galindo, Ibarra',
      provincia: 'Imbabura',
      canton: 'Ibarra',
      tieneHeridosORetencion: true,
      alertaNivel: AlertaNivel.critico,
      lat: 0.3510,
      lng: -78.1220,
      horaReporte: '¡Hace 15 segundos!',
      dictamenIaCorto:
          'Art. 380 COIP: Riesgo de fuga del tercero • Solicitar SIAT y acta de custodia inmediata.',
      relatoConductor:
          '¡Alerta desde la vía! Vehículo particular impactó de frente en Ibarra y el conductor pretende darse a la fuga. Hay presencia de agentes civiles de Movidelnor. Necesito auxilio de abogado urgente en sitio.',
      articuloCoip: 'Art. 380 COIP • Flagrancia con riesgo de fuga y retención de bienes',
      dictamenIaRecomendacion:
          '1. Proceder con fijación fotográfica de placas del vehículo en fuga.\n2. Exigir prueba de alcoholemia SIAT.\n3. Despachar abogado penal/tránsito de guardia en Ibarra.',
      abogadoAsignado: null,
      horaDespacho: null,
      esPruebaGratuita: false,
      esPlanVip: true,
      evidencias: [
        DriverEvidence(
          type: 'audio',
          title: 'Audio SOS Conductor en Vivo',
          detail: 'Duración: 0:18 seg • SOS activado en Ibarra',
          icon: Icons.mic_rounded,
        ),
      ],
      timeline: [
        CaseTimelineEvent(
          time: '¡Ahora mismo!',
          title: '🚨 Alerta SOS desde la App Taxista',
          description: 'El conductor presionó el botón de auxilio legal en la Av. Mariano Acosta.',
          icon: Icons.warning_rounded,
          color: const Color(0xFFD32F2F),
        ),
      ],
    );

    _cases.insert(0, newCase);
    _selectedCase = newCase;
    _selectedLawyer = null;
    _lastAlertedCaseId = newCase.id;
    _selectedProvince = 'Imbabura';
    _selectedCanton = 'Ibarra';
    _selectedCooperative = 'Todas';
    _activeKpiFilter = null;
    _dashboardTab = 0; // Mostrar tabla de incidentes
    animateMapToCoordinates(newCase.lat, newCase.lng, zoom: 15.0);

    if (_autoDispatchEnabled) {
      autoDispatchCase(newCase, notifySnackbar: false);
      update();

      if (notifySnackbar && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          '🚨 ¡SOS ENTRADA + ⚡ DESPACHO GPS AUTOMÁTICO!',
          'Conductor ${newCase.taxistaNombre} (Flota Imbabura • Ibarra). Asignado de inmediato a ${newCase.abogadoAsignado} (${newCase.distanciaAbogadoKm} km • ${newCase.horaDespacho}).',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFC62828),
          colorText: Colors.white,
          icon: const Icon(Icons.bolt_rounded, color: Colors.amber, size: 30),
          duration: const Duration(seconds: 7),
          margin: const EdgeInsets.all(16),
        );
      }
    } else {
      update();

      if (notifySnackbar && Get.key.currentState?.overlay != null) {
        Get.snackbar(
          '🚨 ¡NUEVA ALERTA CÓDIGO ROJO EN IBARRA (MODO MANUAL)!',
          'Conductor Patricio Guanoluisa (Unidad 99 - Flota Imbabura). En espera de asignación manual por el operador.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFC62828),
          colorText: Colors.white,
          icon: const Icon(Icons.notification_important, color: Colors.white, size: 30),
          duration: const Duration(seconds: 6),
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  // =========================================================================
  // ACCIONES OPERATIVAS SEGÚN ROL (ABOGADO ASOCIADO EN VÍA)
  // =========================================================================

  /// Iniciar traslado hacia la ubicación del siniestro
  void startLawyerTransit(String caseId) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.horaDespacho = 'En traslado activo (GPS en vivo)';
      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: '🚗 Traslado Iniciado',
          description:
              'El abogado ${c.abogadoAsignado ?? "de guardia"} inició la ruta hacia la escena del siniestro.',
          icon: Icons.navigation_rounded,
          color: const Color(0xFF0284C7),
        ),
      );
      _selectedCase = c;
      update();

      if (Get.key.currentState?.overlay != null) {
        Get.snackbar(
          '🚗 En Ruta hacia el Siniestro',
          'Has iniciado el traslado. La Central y el conductor visualizan tu ruta.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0284C7),
          colorText: Colors.white,
          icon: const Icon(Icons.navigation_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  /// Reportar llegada a la escena del siniestro
  void reportLawyerArrived(String caseId) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.horaDespacho = 'En escena (Atendiendo)';
      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: '🛡️ Abogado en Escena',
          description:
              'El abogado arribó al lugar del siniestro y toma contacto directo con el conductor y las autoridades.',
          icon: Icons.location_on_rounded,
          color: const Color(0xFF16A34A),
        ),
      );
      _selectedCase = c;
      update();

      if (Get.key.currentState?.overlay != null) {
        Get.snackbar(
          '📍 Arribo a Escena Confirmado',
          'Se notificó a la Central de Despacho y al conductor que estás presente en el lugar.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF16A34A),
          colorText: Colors.white,
          icon: const Icon(Icons.verified_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  /// Solicitar refuerzo o apoyo de la Central / Director General
  void requestLawyerSupport(String caseId, String reason) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: '⚠️ Solicitud de Refuerzo a Central',
          description:
              'El abogado en vía solicitó apoyo urgente al Director General: "$reason".',
          icon: Icons.warning_rounded,
          color: const Color(0xFFEA580C),
        ),
      );
      _selectedCase = c;
      update();

      if (Get.key.currentState?.overlay != null) {
        Get.snackbar(
          '⚠️ Solicitud de Refuerzo Enviada',
          'Se notificó al Director General: "$reason". La Central gestionará la unidad de apoyo.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEA580C),
          colorText: Colors.white,
          icon: const Icon(Icons.shield_outlined, color: Colors.white),
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  /// Auto-asignarse un caso no asignado (disponible para abogados asociados)
  void selfAssignCase(String caseId, String lawyerName, String lawyerId) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.estado = CaseStatus.abogadoDespachado;
      c.abogadoAsignado = lawyerName;
      c.assignedLawyerId = lawyerId;
      c.horaDespacho = 'Auto-asignado por abogado en vía';
      c.fueAsignadoAutomaticamente = false;
      c.motivoAsignacion = 'Auto-asignación directa por patrullaje en zona';
      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: '✋ Caso Tomado por Abogado en Vía',
          description:
              '$lawyerName se auto-asignó el caso para atención inmediata en sitio.',
          icon: Icons.front_hand_rounded,
          color: const Color(0xFF2563EB),
        ),
      );
      _selectedCase = c;
      update();

      if (Get.key.currentState?.overlay != null) {
        Get.snackbar(
          '✋ Caso Auto-asignado',
          'Has tomado el caso $caseId. Dirígete a la escena y reporta tu llegada.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF2563EB),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }
}
