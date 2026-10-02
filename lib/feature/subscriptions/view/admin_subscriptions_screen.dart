import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/main_page_layout.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/subscriptions/controller/subscriptions_controller.dart';
import 'package:getdash/feature/subscriptions/model/driver_subscription_model.dart';
import 'package:getdash/utils/dimensions.dart';

class AdminSubscriptionsScreen extends StatelessWidget {
  const AdminSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SubscriptionsController>()
        ? Get.find<SubscriptionsController>()
        : Get.put(SubscriptionsController());

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return MainPageLayout(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : Dimensions.paddingSizeDefault,
          vertical: isMobile ? 12 : Dimensions.paddingSizeDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. CABECERA EJECUTIVA
            _buildHeader(context, isDark, isMobile),

            const SizedBox(height: 18),

            // 2. TARJETAS DE KPIs COMERCIALES & FINANCIEROS
            Obx(() => _buildKpiSection(controller, isDark, isMobile)),

            const SizedBox(height: 20),

            // 3. BARRA DE FILTROS Y BÚSQUEDA
            Obx(() => _buildFiltersAndSearchBar(controller, isDark, isMobile)),

            const SizedBox(height: 16),

            // 4. TABLA DE CONDUCTORES Y ACCIONES DE COBRO
            Obx(() {
              final items = controller.filteredSubscriptions;
              if (items.isEmpty) {
                return _buildEmptyState(context, isDark);
              }
              return isMobile
                  ? _buildMobileCardsList(context, controller, items, isDark)
                  : _buildDesktopDataTable(context, controller, items, isDark);
            }),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- 1. CABECERA PRINCIPAL ---
  Widget _buildHeader(BuildContext context, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      "Gestión de Suscripciones y Membresías",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: isMobile ? 15 : 19,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "\$1.00 USD / mes",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  "Supervisión comercial, cobros manuales y control de cobertura legal para conductores afiliados",
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    color: isDark ? Colors.white60 : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. SECCIÓN DE KPIs ---
  Widget _buildKpiSection(SubscriptionsController controller, bool isDark, bool isMobile) {
    final kpis = [
      _KpiData(
        title: "Total Afiliados",
        value: "${controller.totalConductores}",
        subtext: "Conductores registrados",
        icon: Icons.people_alt_rounded,
        color: const Color(0xFF2563EB),
      ),
      _KpiData(
        title: "Membresías Activas",
        value: "${controller.totalActivos}",
        subtext: "Ingresos: \$${controller.ingresosMensualesProyectados.toStringAsFixed(2)}/mes",
        icon: Icons.verified_rounded,
        color: const Color(0xFF16A34A),
      ),
      _KpiData(
        title: "Por Vencer (5 días)",
        value: "${controller.conductoresPorVencer}",
        subtext: "Periodo de cobro",
        icon: Icons.hourglass_top_rounded,
        color: const Color(0xFFD97706),
      ),
      _KpiData(
        title: "Mora / Vencidos",
        value: "${controller.conductoresVencidos}",
        subtext: "Requieren regularización",
        icon: Icons.warning_amber_rounded,
        color: const Color(0xFFDC2626),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int crossAxisCount = width < 380 ? 1 : (width < 540 ? 2 : (width < 960 ? 2 : 4));
        final double childAspectRatio = width < 380
            ? 2.6
            : (width < 540 ? 1.45 : (width < 960 ? 2.2 : 1.6));

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: kpis.length,
          itemBuilder: (context, index) => _buildKpiCard(kpis[index], isDark),
        );
      },
    );
  }

  Widget _buildKpiCard(_KpiData data, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white60 : const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, size: 15, color: data.color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              data.value,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.subtext,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10,
              color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- 3. BARRA DE FILTROS & BÚSQUEDA ---
  Widget _buildFiltersAndSearchBar(SubscriptionsController controller, bool isDark, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Buscador
          TextField(
            onChanged: (val) => controller.setSearchQuery(val),
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              hintText: "Buscar por conductor, cédula, unidad, placa o cooperativa...",
              hintStyle: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.5,
                color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
              ),
              prefixIcon: const Icon(Icons.search_rounded, size: 18, color: Color(0xFF2563EB)),
              filled: true,
              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Pestañas de Filtro Rápido
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip("Todos", 'all', controller, isDark),
              _buildFilterChip("Al Día", 'activos', controller, isDark),
              _buildFilterChip("Por Vencer (5 días)", 'porVencer', controller, isDark),
              _buildFilterChip("Vencidos / Mora", 'vencidos', controller, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String key, SubscriptionsController controller, bool isDark) {
    final isSelected = controller.statusFilter.value == key;
    return InkWell(
      onTap: () => controller.setStatusFilter(key),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2563EB)
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }

  // --- 4. TABLA EN ESCRITORIO ---
  Widget _buildDesktopDataTable(
    BuildContext context,
    SubscriptionsController controller,
    List<DriverSubscription> items,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            ),
            headingTextStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              letterSpacing: 0.5,
            ),
            dataRowMinHeight: 65,
            dataRowMaxHeight: 70,
            columnSpacing: 22,
            columns: const [
              DataColumn(label: Text("CONDUCTOR & UNIDAD")),
              DataColumn(label: Text("CÉDULA")),
              DataColumn(label: Text("COOPERATIVA")),
              DataColumn(label: Text("ESTADO")),
              DataColumn(label: Text("VENCIMIENTO")),
              DataColumn(label: Text("MONTO")),
              DataColumn(label: Text("ACCIONES")),
            ],
            rows: items.map((sub) {
              return DataRow(
                cells: [
                  // Conductor y Unidad
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sub.nombre,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${sub.unidad} • Placa: ${sub.placa}",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            color: isDark ? Colors.white60 : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Cédula
                  DataCell(
                    Text(
                      sub.cedula,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
                      ),
                    ),
                  ),

                  // Cooperativa
                  DataCell(
                    Text(
                      sub.cooperativa,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
                      ),
                    ),
                  ),

                  // Estado Badge
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: sub.estadoBadgeBgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: sub.estadoBadgeColor.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: sub.estadoBadgeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            sub.estadoBadgeLabel,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: sub.estadoBadgeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Vencimiento
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${sub.fechaVencimiento.day}/${sub.fechaVencimiento.month}/${sub.fechaVencimiento.year}",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          sub.diasRestantes >= 0
                              ? "Quedan ${sub.diasRestantes} días"
                              : "Venció hace ${sub.diasRestantes.abs()} días",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: sub.estadoBadgeColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Monto
                  DataCell(
                    Text(
                      "\$${sub.precio.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ),

                  // Acciones
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón Renovar / Registrar Pago
                        ElevatedButton.icon(
                          key: Key("btn_renovar_${sub.id}"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => _mostrarDialogoPagoManual(context, controller, sub, isDark),
                          icon: const Icon(Icons.payment_rounded, size: 14),
                          label: const Text(
                            "Renovar",
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Botón Suspender / Reactivar
                        IconButton(
                          key: Key("btn_toggle_${sub.id}"),
                          tooltip: sub.activa ? "Suspender por mora" : "Reactivar cobertura",
                          icon: Icon(
                            sub.activa ? Icons.block_rounded : Icons.check_circle_outline_rounded,
                            size: 18,
                            color: sub.activa ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                          ),
                          onPressed: () => controller.toggleSuspension(sub.id),
                        ),

                        // Botón Notificar WhatsApp
                        IconButton(
                          key: Key("btn_notificar_${sub.id}"),
                          tooltip: "Notificar Cobro / Regularización",
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFF2563EB)),
                          onPressed: () => controller.notificarCobro(sub),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // --- 4. LISTA EN TARJETAS MÓVILES ---
  Widget _buildMobileCardsList(
    BuildContext context,
    SubscriptionsController controller,
    List<DriverSubscription> items,
    bool isDark,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final sub = items[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    sub.nombre,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: sub.estadoBadgeBgColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: sub.estadoBadgeColor.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      sub.estadoBadgeLabel,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: sub.estadoBadgeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "${sub.unidad} • ${sub.cooperativa} • Placa: ${sub.placa}",
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11.5,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    "Cédula: ${sub.cedula}",
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                    ),
                  ),
                  Text(
                    "Vence: ${sub.fechaVencimiento.day}/${sub.fechaVencimiento.month}/${sub.fechaVencimiento.year}",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isVeryNarrow = constraints.maxWidth < 280;

                  final renewBtn = ElevatedButton.icon(
                    key: Key("btn_renovar_${sub.id}"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _mostrarDialogoPagoManual(context, controller, sub, isDark),
                    icon: const Icon(Icons.payment_rounded, size: 14),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Renovar (\$1.00)",
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 11.5, fontWeight: FontWeight.w800),
                      ),
                    ),
                  );

                  final toggleBtn = OutlinedButton.icon(
                    key: Key("btn_toggle_${sub.id}"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: sub.activa ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                      side: BorderSide(color: sub.activa ? const Color(0xFFDC2626) : const Color(0xFF16A34A)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => controller.toggleSuspension(sub.id),
                    icon: Icon(sub.activa ? Icons.block_rounded : Icons.check_circle_rounded, size: 14),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        sub.activa ? "Suspender" : "Activar",
                        style: const TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    ),
                  );

                  final notifyBtn = IconButton(
                    key: Key("btn_notificar_${sub.id}"),
                    tooltip: "Notificar Cobro",
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Color(0xFF2563EB)),
                    onPressed: () => controller.notificarCobro(sub),
                  );

                  if (isVeryNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        renewBtn,
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(child: toggleBtn),
                            notifyBtn,
                          ],
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: renewBtn),
                      const SizedBox(width: 8),
                      toggleBtn,
                      const SizedBox(width: 2),
                      notifyBtn,
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: isDark ? Colors.white38 : const Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          Text(
            "No se encontraron conductores con los filtros actuales.",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODAL: REGISTRAR PAGO MANUAL ---
  void _mostrarDialogoPagoManual(
    BuildContext context,
    SubscriptionsController controller,
    DriverSubscription sub,
    bool isDark,
  ) {
    String metodoSeleccionado = 'Efectivo en Oficina';
    int diasExtension = 30;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              actionsOverflowDirection: VerticalDirection.down,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.payments_rounded, color: Color(0xFF16A34A), size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Registrar Pago Manual",
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ficha del Conductor
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sub.nombre,
                            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13.5, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${sub.unidad} • ${sub.cooperativa} • C.I.: ${sub.cedula}",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
                              color: isDark ? Colors.white60 : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Vencimiento actual: ${sub.fechaVencimiento.day}/${sub.fechaVencimiento.month}/${sub.fechaVencimiento.year}",
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Selector de Periodo de Renovación
                    const Text(
                      "Periodo a Renovar:",
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 11.5, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      initialValue: diasExtension,
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 30,
                          child: Text("+30 días (1 mes • \$1.00 USD)", overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                        DropdownMenuItem(
                          value: 60,
                          child: Text("+60 días (2 meses • \$2.00 USD)", overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                        DropdownMenuItem(
                          value: 90,
                          child: Text("+90 días (3 meses • \$3.00 USD)", overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                        DropdownMenuItem(
                          value: 365,
                          child: Text("+365 días (1 año • \$12.00 USD)", overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setModalState(() => diasExtension = val);
                      },
                    ),

                    const SizedBox(height: 14),

                    // Selector de Método de Pago
                    const Text(
                      "Método de Pago Recibido:",
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 11.5, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: metodoSeleccionado,
                      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Efectivo en Oficina',
                          child: Text("Efectivo en Oficina", overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                        DropdownMenuItem(
                          value: 'Transferencia Bancaria Directa',
                          child: Text("Transferencia Bancaria Directa", overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                        DropdownMenuItem(
                          value: 'Cooperativa / Descuento de Rol',
                          child: Text("Cooperativa / Descuento de Rol", overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setModalState(() => metodoSeleccionado = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  child: const Text("Cancelar", style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700)),
                ),
                ElevatedButton.icon(
                  key: const Key("btn_confirmar_pago_modal"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(dialogCtx).pop();
                    controller.renovarPagoManual(
                      driverId: sub.id,
                      dias: diasExtension,
                      metodo: metodoSeleccionado,
                    );
                  },
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text("Confirmar Pago", style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _KpiData {
  final String title;
  final String value;
  final String subtext;
  final IconData icon;
  final Color color;

  _KpiData({
    required this.title,
    required this.value,
    required this.subtext,
    required this.icon,
    required this.color,
  });
}
