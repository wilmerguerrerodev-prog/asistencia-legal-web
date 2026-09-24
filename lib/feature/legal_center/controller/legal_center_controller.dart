import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/legal_case_model.dart';

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
    'Imbabura': ['Todos', 'Otavalo', 'Ibarra', 'Cotacachi'],
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
  String _selectedCanton = 'Todos';
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
    ];
  }

  void _loadInitialCases() {
    _cases = [
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
        dictamenIaCorto:
            'Art. 380 COIP: Acuerdo transaccional notarial • Pago directo de faro posterior sin paralizar unidad.',
        relatoConductor:
            'Motocicleta de reparto impactó faro posterior mientras esperaba el verde. Conductor de moto reconoce culpa y propone transferir el costo del faro.',
        articuloCoip: 'Art. 380 COIP • Procedimiento de acuerdo extrajudicial en tránsito',
        dictamenIaRecomendacion:
            'Fijar fotos finales, constatar transferencia de valor de repuesto y suscribir recibo de indemnidad recíproca.',
        abogadoAsignado: 'Dr. Marcelo Dávila',
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
    ];
  }

  // --- FILTRADO EN CASCADA ---
  void selectProvince(String province) {
    _selectedProvince = province;
    _selectedCanton = 'Todos';
    _ensureValidCaseSelection();
    update();
  }

  void selectCanton(String canton) {
    _selectedCanton = canton;
    _ensureValidCaseSelection();
    update();
  }

  void selectCooperative(String coop) {
    _selectedCooperative = coop;
    _ensureValidCaseSelection();
    update();
  }

  void resetFilters() {
    _selectedProvince = 'Imbabura';
    _selectedCanton = 'Todos';
    _selectedCooperative = 'Todas';
    _searchQuery = '';
    _activeKpiFilter = null;
    searchController.clear();
    _ensureValidCaseSelection();
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

  void selectCase(LegalCase caseItem, {bool isMobile = false}) {
    _selectedCase = caseItem;
    if (isMobile) {
      _mobileTabIndex = 1;
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

  // --- BOTÓN DE SIMULACIÓN PARA DEMOS EN VIVO ---
  void simulateIncomingDriverAlert() {
    final newCase = LegalCase(
      id: '#CASO-${1043 + _cases.length}',
      taxistaNombre: 'Patricio Guanoluisa',
      taxistaCedula: '1004928172',
      taxistaTelefono: '+593 99 777 8899',
      cooperativa: 'Los Lagos',
      unidad: 'Unidad 99',
      placa: 'IBX-9012',
      vehiculoModelo: 'Chevrolet Sail 1.5 (2023)',
      estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
      tipoIncidente: 'Colisión Frontal con Intento de Fuga y Agresión',
      urgencia: UrgencyLevel.alta,
      estado: CaseStatus.pendiente,
      ubicacionDireccion: 'Panamericana Norte Km 3, Salida a Cotacachi, Otavalo',
      provincia: 'Imbabura',
      canton: 'Otavalo',
      tieneHeridosORetencion: true,
      alertaNivel: AlertaNivel.critico,
      lat: 0.2412,
      lng: -78.2690,
      horaReporte: '¡Hace 15 segundos!',
      dictamenIaCorto:
          'Art. 380 COIP: Riesgo de fuga del tercero • Solicitar SIAT y acta de custodia inmediata.',
      relatoConductor:
          '¡Alerta desde la vía! Vehículo particular impactó de frente y el conductor pretende darse a la fuga. Hay presencia de agentes de tránsito. Necesito auxilio de abogado urgente en sitio.',
      articuloCoip: 'Art. 380 COIP • Flagrancia con riesgo de fuga y retención de bienes',
      dictamenIaRecomendacion:
          '1. Proceder con fijación fotográfica de placas del vehículo en fuga.\n2. Exigir prueba de alcoholemia SIAT.\n3. Despachar abogado penal/tránsito de guardia en Otavalo.',
      abogadoAsignado: null,
      horaDespacho: null,
      evidencias: [
        DriverEvidence(
          type: 'audio',
          title: 'Audio SOS Conductor en Vivo',
          detail: 'Duración: 0:18 seg • SOS activado en Otavalo',
          icon: Icons.mic_rounded,
        ),
      ],
      timeline: [
        CaseTimelineEvent(
          time: '¡Ahora mismo!',
          title: '🚨 Alerta SOS desde la App Taxista',
          description: 'El conductor presionó el botón de auxilio legal en la Panamericana Norte.',
          icon: Icons.warning_rounded,
          color: const Color(0xFFD32F2F),
        ),
      ],
    );

    _cases.insert(0, newCase);
    _selectedCase = newCase;
    _selectedProvince = 'Imbabura';
    _selectedCanton = 'Todos';
    _selectedCooperative = 'Todas';
    _activeKpiFilter = null;
    _dashboardTab = 0; // Mostrar tabla de incidentes

    if (_autoDispatchEnabled) {
      autoDispatchCase(newCase, notifySnackbar: false);
      update();

      Get.snackbar(
        '🚨 ¡SOS ENTRADA + ⚡ DESPACHO GPS AUTOMÁTICO!',
        'Conductor ${newCase.taxistaNombre} (Los Lagos • Otavalo). Asignado de inmediato a ${newCase.abogadoAsignado} (${newCase.distanciaAbogadoKm} km • ${newCase.horaDespacho}).',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFC62828),
        colorText: Colors.white,
        icon: const Icon(Icons.bolt_rounded, color: Colors.amber, size: 30),
        duration: const Duration(seconds: 7),
        margin: const EdgeInsets.all(16),
      );
    } else {
      update();

      Get.snackbar(
        '🚨 ¡NUEVA ALERTA CÓDIGO ROJO EN OTAVALO (MODO MANUAL)!',
        'Conductor Patricio Guanoluisa (Unidad 99 - Los Lagos). En espera de asignación manual por el operador.',
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
