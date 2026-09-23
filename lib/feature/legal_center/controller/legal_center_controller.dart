import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/legal_case_model.dart';

class LegalCenterController extends GetxController {
  final List<String> cooperatives = [
    'Todas',
    'Coop. Los Lagos',
    'Coop. El Tejar',
    'Coop. San Cristóbal',
    'Coop. 24 de Mayo',
  ];

  String _selectedCooperative = 'Todas';
  String get selectedCooperative => _selectedCooperative;

  LegalCase? _selectedCase;
  LegalCase? get selectedCase => _selectedCase;

  int _mobileTabIndex = 0; // 0: Lista de Casos, 1: Expediente 360
  int get mobileTabIndex => _mobileTabIndex;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final TextEditingController searchController = TextEditingController();

  List<LegalCase> _cases = [];
  List<LegalCase> get allCases => _cases;

  @override
  void onInit() {
    super.onInit();
    _loadInitialCases();
    if (_cases.isNotEmpty) {
      _selectedCase = _cases.first;
    }
  }

  void _loadInitialCases() {
    _cases = [
      LegalCase(
        id: '#CASO-1042',
        taxistaNombre: 'Carlos R. Mendoza',
        taxistaCedula: '1718942301',
        taxistaTelefono: '+593 99 482 1045',
        cooperativa: 'Coop. Los Lagos',
        unidad: 'Unidad 042',
        placa: 'PBX-4821',
        vehiculoModelo: 'Chevrolet Sail 1.5 (2022)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: 'Colisión Lateral / Alcance',
        urgencia: UrgencyLevel.alta,
        estado: CaseStatus.pendiente,
        ubicacionDireccion: 'Av. Simón Bolívar y Granados, Redondel del Ciclista (Quito)',
        lat: -0.1652,
        lng: -78.4721,
        horaReporte: 'Hace 4 min',
        relatoConductor:
            'Estaba realizando una carrera legal en sentido norte-sur y un vehículo particular intentó rebasar bruscamente sin direccional e impactó el costado izquierdo de mi unidad. El conductor particular está agresivo y los agentes civiles pretenden trasladar mi vehículo al patio de retención de Calderón.',
        articuloCoip: 'Art. 380 COIP • Daños materiales en siniestro de tránsito',
        dictamenIaRecomendacion:
            '1. NO CONCILIAR bajo presión de agentes en flagrancia sin peritaje SIAT.\n2. Al presentar SOAT/SPPAT y matrícula vigente, según el Art. 380 inciso 3 del COIP, procede la entrega inmediata del vehículo bajo acta de custodia provisional sin retención en patio.\n3. Se recomienda despacho de abogado de turno para vigilar parte policial.',
        abogadoAsignado: null,
        horaDespacho: null,
        evidencias: [
          DriverEvidence(
            type: 'audio',
            title: 'Audio Declaración Conductor',
            detail: 'Duración: 0:42 seg • Grabado en vivo',
            icon: Icons.mic_rounded,
          ),
          DriverEvidence(
            type: 'photo',
            title: 'Foto Daño Lateral Izquierdo',
            detail: 'JPG • Evidencia de huella de impacto',
            icon: Icons.camera_alt_rounded,
          ),
          DriverEvidence(
            type: 'photo',
            title: 'Foto Placa Vehículo Tercero',
            detail: 'JPG • Identificación vehículo particular',
            icon: Icons.image_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '10:14',
            title: 'Alerta SOS Recibida',
            description: 'Conductor activó el botón de asistencia jurídica desde la app móvil en calle.',
            icon: Icons.sensors_rounded,
            color: const Color(0xFFD32F2F),
          ),
          CaseTimelineEvent(
            time: '10:15',
            title: 'Pre-Dictamen IA Generado',
            description: 'El motor LegalTech tipificó el caso bajo el Art. 380 COIP y evaluó no procedencia de retención.',
            icon: Icons.auto_awesome,
            color: const Color(0xFF056AB4),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1039',
        taxistaNombre: 'Jorge L. Tipán',
        taxistaCedula: '1709482155',
        taxistaTelefono: '+593 98 765 4321',
        cooperativa: 'Coop. El Tejar',
        unidad: 'Unidad 115',
        placa: 'PCX-8930',
        vehiculoModelo: 'Hyundai Accent 1.4 (2021)',
        estadoSeguro: 'Póliza Activa • Aseguradora del Sur',
        tipoIncidente: 'Retén de Tránsito / Intento de Retención',
        urgencia: UrgencyLevel.alta,
        estado: CaseStatus.pendiente,
        ubicacionDireccion: 'Calle Pichincha y Sucre, Centro Histórico (Quito)',
        lat: -0.2223,
        lng: -78.5144,
        horaReporte: 'Hace 18 min',
        relatoConductor:
            'Agente civil de tránsito solicita matrícula física cuando la tengo digital en el portal de la ANT con código QR válido. Pretende emitir citación contravencional injustificada y retener el vehículo alegando falta de revisión vehicular actualizada.',
        articuloCoip: 'Art. 391 Numeral 21 COIP • Validez de credencial digital',
        dictamenIaRecomendacion:
            'Conforme a la Resolución 038-DIR-ANT y Ley Orgánica de Tránsito reformada, el documento digital con QR tiene plena validez jurídica. Despachar oficio o llamada de asistencia inmediata para evitar la emisión nula de la citación.',
        abogadoAsignado: null,
        horaDespacho: null,
        evidencias: [
          DriverEvidence(
            type: 'audio',
            title: 'Audio Diálogo con Agente Civil',
            detail: 'Duración: 1:15 min • Constatación de hechos',
            icon: Icons.mic_rounded,
          ),
          DriverEvidence(
            type: 'photo',
            title: 'Captura QR Documento ANT',
            detail: 'PNG • Certificado de matrícula al día',
            icon: Icons.qr_code_2_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '10:01',
            title: 'Reporte de Retén',
            description: 'Conductor reportó discrepancia legal en operativo de control.',
            icon: Icons.warning_amber_rounded,
            color: const Color(0xFFF57C00),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1035',
        taxistaNombre: 'Wilson E. Caiza',
        taxistaCedula: '1720394812',
        taxistaTelefono: '+593 99 123 9876',
        cooperativa: 'Coop. Los Lagos',
        unidad: 'Unidad 078',
        placa: 'PBX-1122',
        vehiculoModelo: 'Kia Soluto 1.4 (2023)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: 'Choque por Alcance Posterior',
        urgencia: UrgencyLevel.media,
        estado: CaseStatus.dictamenAprobado,
        ubicacionDireccion: 'Av. 10 de Agosto y Mariana de Jesús, Norte (Quito)',
        lat: -0.1882,
        lng: -78.4905,
        horaReporte: 'Hace 35 min',
        relatoConductor:
            'Motocicleta de delivery impactó parachoques posterior mientras estaba detenido en semáforo en rojo. No hay heridos, únicamente abolladura de latas y faro posterior roto.',
        articuloCoip: 'Art. 380 COIP • Procedimiento de acuerdo extrajudicial en tránsito',
        dictamenIaRecomendacion:
            'Fijar fotografías de posición final de ambos vehículos. Proceder con acta de acuerdo transaccional notariado o mediación en centro arbitral para pago directo de repuestos sin retención de unidades.',
        abogadoAsignado: 'Dra. Elena Torres',
        horaDespacho: 'Hace 20 min',
        evidencias: [
          DriverEvidence(
            type: 'photo',
            title: 'Foto Parachoques Posterior',
            detail: 'JPG • Evidencia de golpe en luz de freno',
            icon: Icons.camera_alt_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '09:44',
            title: 'Incidente Registrado',
            description: 'Reporte ingresado por el taxista.',
            icon: Icons.receipt_long,
            color: const Color(0xFF757575),
          ),
          CaseTimelineEvent(
            time: '09:50',
            title: 'Dictamen Aprobado por Despacho',
            description: 'Abogado aprobó acta de acuerdo conciliatorio directo.',
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF2E7D32),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1031',
        taxistaNombre: 'Segundo M. Quishpe',
        taxistaCedula: '1708819234',
        taxistaTelefono: '+593 96 345 6789',
        cooperativa: 'Coop. San Cristóbal',
        unidad: 'Unidad 025',
        placa: 'PBA-3401',
        vehiculoModelo: 'Chevrolet Aveo Family (2018)',
        estadoSeguro: 'Póliza Activa • Seguros Unidos',
        tipoIncidente: 'Contravención Injustificada de Carril Exclusivo',
        urgencia: UrgencyLevel.baja,
        estado: CaseStatus.dictamenAprobado,
        ubicacionDireccion: 'Av. Prensa y El Inca, La Concepción',
        lat: -0.1554,
        lng: -78.4912,
        horaReporte: 'Hace 1 hora',
        relatoConductor:
            'Citación por supuesto ingreso a carril exclusivo del Trolebús, cuando el giro a la derecha estaba autorizado por señalética de obra vial temporal.',
        articuloCoip: 'Art. 389 Numeral 1 COIP • Impugnación de contravención de tránsito',
        dictamenIaRecomendacion:
            'Presentar impugnación ante el Juez de Tránsito dentro del término de 3 días adjuntando video de dashcam como prueba de fuerza mayor por desvío de tránsito.',
        abogadoAsignado: 'Dr. Fernando Salazar',
        horaDespacho: 'Hace 45 min',
        evidencias: [
          DriverEvidence(
            type: 'doc',
            title: 'Boleta de Citación AMT #8921',
            detail: 'PDF • Escaneo de boleta con observaciones',
            icon: Icons.description_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '09:15',
            title: 'Ingreso para Impugnación',
            description: 'Carga de citación para defensa legal en juzgado.',
            icon: Icons.balance,
            color: const Color(0xFF1565C0),
          ),
        ],
      ),
      LegalCase(
        id: '#CASO-1028',
        taxistaNombre: 'Luis Fernando Morales',
        taxistaCedula: '1714529018',
        taxistaTelefono: '+593 99 876 5432',
        cooperativa: 'Coop. 24 de Mayo',
        unidad: 'Unidad 060',
        placa: 'PCY-9900',
        vehiculoModelo: 'Nissan Versa 1.6 (2020)',
        estadoSeguro: 'Póliza Activa • Seguros Alianza',
        tipoIncidente: 'Choque por Alcance con Motocicleta',
        urgencia: UrgencyLevel.media,
        estado: CaseStatus.abogadoDespachado,
        ubicacionDireccion: 'Av. Rodrigo de Chávez y 5 de Junio, Villaflora',
        lat: -0.2450,
        lng: -78.5200,
        horaReporte: 'Hace 1 hora y media',
        relatoConductor:
            'Colisión en intersección semafórica. Se requiere presencia del abogado para firmar acta de desistimiento mutuo ante el agente SIAT.',
        articuloCoip: 'Art. 380 COIP • Daños materiales con mediación legal',
        dictamenIaRecomendacion:
            'Verificar que el acta contenga cláusula de indemnidad total para que la cooperativa y el taxista no tengan reclamos posteriores.',
        abogadoAsignado: 'Dr. Marcelo Dávila (Móvil Legal #1)',
        horaDespacho: 'Hace 1 hora',
        evidencias: [
          DriverEvidence(
            type: 'photo',
            title: 'Foto Acta Transaccional Borrador',
            detail: 'JPG • Borrador elaborado por agentes',
            icon: Icons.camera_alt_rounded,
          ),
        ],
        timeline: [
          CaseTimelineEvent(
            time: '08:45',
            title: 'Alerta Reportada',
            description: 'Llamada urgente de la directiva de Coop. 24 de Mayo.',
            icon: Icons.phone_callback,
            color: const Color(0xFFF57C00),
          ),
          CaseTimelineEvent(
            time: '08:52',
            title: 'Abogado Despachado',
            description: 'Dr. Marcelo Dávila asignado en vehículo de asistencia legal.',
            icon: Icons.directions_car,
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
        unidad: 'Unidad 014',
        placa: 'PBZ-7711',
        vehiculoModelo: 'Toyota Yaris 1.5 (2022)',
        estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
        tipoIncidente: 'Rozamiento en Curva sin heridos',
        urgencia: UrgencyLevel.baja,
        estado: CaseStatus.atendido,
        ubicacionDireccion: 'Túnel de San Juan, Sentido Sur-Norte',
        lat: -0.2180,
        lng: -78.5080,
        horaReporte: 'Hace 2 horas',
        relatoConductor:
            'Espejo retrovisor roto por roce con bus de transporte urbano. Se llegó a acuerdo directo por \$40 para reposición de repuesto.',
        articuloCoip: 'Conciliación Inmediata • Sin procedimiento judicial',
        dictamenIaRecomendacion:
            'Caso cerrado con recibo de conformidad firmado por ambas partes. Ningún riesgo legal para la cooperativa.',
        abogadoAsignado: 'Dra. Elena Torres',
        horaDespacho: 'Hace 2 horas',
        evidencias: [],
        timeline: [
          CaseTimelineEvent(
            time: '08:10',
            title: 'Caso Finalizado',
            description: 'Conductor reportó conformidad de pago y reanudó operaciones.',
            icon: Icons.task_alt,
            color: const Color(0xFF2E7D32),
          ),
        ],
      ),
    ];
  }

  // --- FILTROS ---
  List<LegalCase> get filteredCases {
    return _cases.where((c) {
      final matchesCoop =
          _selectedCooperative == 'Todas' || c.cooperativa == _selectedCooperative;
      final query = _searchQuery.toLowerCase();
      final matchesQuery = query.isEmpty ||
          c.id.toLowerCase().contains(query) ||
          c.taxistaNombre.toLowerCase().contains(query) ||
          c.placa.toLowerCase().contains(query) ||
          c.unidad.toLowerCase().contains(query) ||
          c.cooperativa.toLowerCase().contains(query) ||
          c.tipoIncidente.toLowerCase().contains(query);
      return matchesCoop && matchesQuery;
    }).toList();
  }

  void selectCooperative(String coop) {
    _selectedCooperative = coop;
    // Si el caso actual no pertenece a la cooperativa filtrada, seleccionar el primero disponible
    final filtered = filteredCases;
    if (filtered.isNotEmpty && (_selectedCase == null || !filtered.contains(_selectedCase))) {
      _selectedCase = filtered.first;
    }
    update();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    final filtered = filteredCases;
    if (filtered.isNotEmpty && (_selectedCase == null || !filtered.contains(_selectedCase))) {
      _selectedCase = filtered.first;
    }
    update();
  }

  void selectCase(LegalCase caseItem, {bool isMobile = false}) {
    _selectedCase = caseItem;
    if (isMobile) {
      _mobileTabIndex = 1; // Pasa a vista Expediente 360 en móvil
    }
    update();
  }

  void setMobileTab(int index) {
    _mobileTabIndex = index;
    update();
  }

  // --- CONTADORES Y KPIs ---
  int get totalCasesCount => _cases.length;

  int get urgentPendingCasesCount => _cases
      .where((c) => c.urgencia == UrgencyLevel.alta && c.estado == CaseStatus.pendiente)
      .length;

  int get dispatchedCount =>
      _cases.where((c) => c.estado == CaseStatus.abogadoDespachado).length;

  String get topCooperative {
    final counts = <String, int>{};
    for (var c in _cases) {
      counts[c.cooperativa] = (counts[c.cooperativa] ?? 0) + 1;
    }
    String top = 'Coop. Los Lagos';
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

  // --- INTERACCIÓN 1: APROBAR DICTAMEN ---
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
              'El despacho jurídico aprobó el dictamen oficial con sello digital. Se instruye al conductor no permitir retención del vehículo.',
          icon: Icons.verified_user_rounded,
          color: const Color(0xFF2E7D32),
        ),
      );
      _selectedCase = c;
      update();

      Get.snackbar(
        '⚖️ Dictamen Aprobado',
        'El dictamen para el caso $caseId fue validado exitosamente con sello digital.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1B5E20),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    }
  }

  // --- INTERACCIÓN 2: DESPACHAR ABOGADO ---
  void dispatchLawyer(String caseId, String lawyerName, String arrivalMinutes) {
    final index = _cases.indexWhere((c) => c.id == caseId);
    if (index != -1) {
      final c = _cases[index];
      c.estado = CaseStatus.abogadoDespachado;
      c.abogadoAsignado = lawyerName;
      c.horaDespacho = 'En camino (ETA: $arrivalMinutes min)';
      // La urgencia crítica se atenúa a Media / En gestión
      c.urgencia = UrgencyLevel.media;

      c.timeline.insert(
        0,
        CaseTimelineEvent(
          time: 'Ahora',
          title: 'Abogado Móvil Despachado',
          description:
              '$lawyerName ha sido despachado en la Unidad Legal Móvil hacia la ubicación del siniestro. Tiempo estimado de arribo: $arrivalMinutes min.',
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

  // --- BOTÓN DE SIMULACIÓN PARA LA DEMO EN VIVO ---
  void simulateIncomingDriverAlert() {
    final newCase = LegalCase(
      id: '#CASO-${1043 + _cases.length}',
      taxistaNombre: 'Patricio Guanoluisa',
      taxistaCedula: '1719876543',
      taxistaTelefono: '+593 99 777 8899',
      cooperativa: 'Coop. Los Lagos',
      unidad: 'Unidad 099',
      placa: 'PCG-9012',
      vehiculoModelo: 'Chevrolet Sail 1.5 (2023)',
      estadoSeguro: 'Póliza Activa • Seguros Equinoccial',
      tipoIncidente: 'Emergencia en Vía: Choque por Alcance Múltiple',
      urgencia: UrgencyLevel.alta,
      estado: CaseStatus.pendiente,
      ubicacionDireccion: 'Av. Mariscal Sucre y Av. Mariana de Jesús (Túneles de San Juan)',
      lat: -0.2012,
      lng: -78.5023,
      horaReporte: '¡Hace 10 segundos!',
      relatoConductor:
          '¡Alerta desde la calle! Choque múltiple en el carril central con pasajero a bordo. El conductor del vehículo de atrás intenta darse a la fuga y hay presencia de policía nacional. Necesito auxilio de abogado urgente en sitio.',
      articuloCoip: 'Art. 380 COIP • Flagrancia con riesgo de fuga de tercero',
      dictamenIaRecomendacion:
          '1. Proceder con retención visual del vehículo en fuga.\n2. Solicitar de inmediato peritaje SIAT en sitio.\n3. Despachar abogado penal/tránsito de guardia para garantizar indemnidad del taxista.',
      abogadoAsignado: null,
      horaDespacho: null,
      evidencias: [
        DriverEvidence(
          type: 'audio',
          title: 'Audio SOS Conductor en Vivo',
          detail: 'Duración: 0:18 seg • SOS activado desde App Taxista',
          icon: Icons.mic_rounded,
        ),
        DriverEvidence(
          type: 'photo',
          title: 'Fotografía Impacto Múltiple',
          detail: 'JPG • Daño severo en guardafango',
          icon: Icons.camera_alt_rounded,
        ),
      ],
      timeline: [
        CaseTimelineEvent(
          time: '¡Ahora mismo!',
          title: '🚨 Alerta SOS desde la App Taxista',
          description: 'El conductor presionó el botón de auxilio legal inmediato en la calle.',
          icon: Icons.warning_rounded,
          color: const Color(0xFFD32F2F),
        ),
      ],
    );

    _cases.insert(0, newCase);
    _selectedCase = newCase;
    _selectedCooperative = 'Todas';
    update();

    Get.snackbar(
      '🚨 ¡NUEVA ALERTA DE TAXISTA EN VIVO!',
      'Conductor Patricio Guanoluisa (Coop. Los Lagos - Unidad 099) solicita auxilio inmediato en Av. Mariscal Sucre.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFC62828),
      colorText: Colors.white,
      icon: const Icon(Icons.notification_important, color: Colors.white, size: 30),
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(16),
    );
  }
}
