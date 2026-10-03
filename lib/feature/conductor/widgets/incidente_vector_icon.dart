import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';

/// Widget de icono vectorial de alta definición para los tipos de incidentes viales.
/// Soporta paleta moderna multi-color vibrante o modo monocromático de alto contraste.
class IncidenteVectorIcon extends StatelessWidget {
  final TipoIncidente tipo;
  final double size;
  final Color color;
  final bool useModernColors;

  const IncidenteVectorIcon({
    super.key,
    required this.tipo,
    this.size = 48,
    this.color = Colors.white,
    this.useModernColors = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _getPainter(tipo, color, useModernColors),
      ),
    );
  }

  CustomPainter _getPainter(TipoIncidente tipo, Color color, bool useModern) {
    switch (tipo) {
      case TipoIncidente.meChoque:
        return MeChoqueVectorPainter(color: color, useModernColors: useModern);
      case TipoIncidente.meChocaron:
        return MeChocaronVectorPainter(
            color: color, useModernColors: useModern);
      case TipoIncidente.operativoTransito:
        return OperativoTransitoVectorPainter(
            color: color, useModernColors: useModern);
      case TipoIncidente.agresionProblemaPersonal:
        return AgresionPersonalVectorPainter(
            color: color, useModernColors: useModern);
      case TipoIncidente.encarcelaronFamiliar:
        return EncarcelaronFamiliarVectorPainter(
            color: color, useModernColors: useModern);
      case TipoIncidente.otroProblema:
        return OtroProblemaVectorPainter(
            color: color, useModernColors: useModern);
    }
  }
}

// ============================================================================
// 1. ME CHOQUÉ: Un solo vehículo con impacto/deformación frontal contra obstáculo
// ============================================================================
class MeChoqueVectorPainter extends CustomPainter {
  final Color color;
  final bool useModernColors;

  const MeChoqueVectorPainter({
    required this.color,
    this.useModernColors = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    // Paleta de colores moderna vs monocromática
    final barrierColor = useModernColors ? const Color(0xFF334155) : color;
    final barrierStripeColor = useModernColors
        ? const Color(0xFFF59E0B)
        : Colors.black.withValues(alpha: 0.35);
    final carBodyColor = useModernColors ? const Color(0xFF0284C7) : color;
    final carWindowColor = useModernColors
        ? const Color(0xFF0F172A)
        : Colors.black.withValues(alpha: 0.32);
    final tireColor = useModernColors ? const Color(0xFF0F172A) : color;
    final rimColor = useModernColors
        ? const Color(0xFF94A3B8)
        : Colors.black.withValues(alpha: 0.4);
    final outerSparkColor = useModernColors ? const Color(0xFFFACC15) : color;
    final innerSparkColor = useModernColors ? const Color(0xFFEF4444) : color;
    final kineticLineColor = useModernColors ? const Color(0xFFEA580C) : color;

    // --- Muro / Poste de impacto en el extremo derecho ---
    final barrierPaint = Paint()
      ..color = barrierColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final barrierRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(85, 18, 10, 64),
      const Radius.circular(3.5),
    );
    canvas.drawRRect(barrierRRect, barrierPaint);

    // Franjas de seguridad reflectivas del muro
    final barrierStripePaint = Paint()
      ..color = barrierStripeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        const Offset(86, 30), const Offset(94, 38), barrierStripePaint);
    canvas.drawLine(
        const Offset(86, 46), const Offset(94, 54), barrierStripePaint);
    canvas.drawLine(
        const Offset(86, 62), const Offset(94, 70), barrierStripePaint);

    // --- Carrocería del auto colisionado (de perfil hacia la derecha) ---
    final carBodyPaint = Paint()
      ..color = carBodyColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final carPath = Path();
    carPath.moveTo(8, 68);
    carPath.lineTo(8, 54);
    carPath.quadraticBezierTo(9, 50, 15, 50);
    carPath.lineTo(26, 49);
    carPath.lineTo(37, 34); // Parabrisas trasero
    carPath.lineTo(59, 34); // Techo
    carPath.lineTo(69, 47); // Parabrisas delantero
    // Capó quebrado / arrugado por el choque frontal
    carPath.lineTo(76, 43); // Deformación hacia arriba
    carPath.lineTo(82, 53); // Quiebre del impacto contra el muro
    carPath.lineTo(79, 61); // Frente aplastado
    carPath.lineTo(84, 68); // Base contra el muro
    carPath.lineTo(68, 68);
    carPath.arcToPoint(
      const Offset(50, 68),
      radius: const Radius.circular(10),
      clockwise: false,
    );
    carPath.lineTo(32, 68);
    carPath.arcToPoint(
      const Offset(14, 68),
      radius: const Radius.circular(10),
      clockwise: false,
    );
    carPath.close();
    canvas.drawPath(carPath, carBodyPaint);

    // Ventanas oscurecidas con efecto polarizado
    final windowPaint = Paint()
      ..color = carWindowColor
      ..style = PaintingStyle.fill;

    final windowRear = Path()
      ..moveTo(28, 48)
      ..lineTo(37, 37)
      ..lineTo(46, 37)
      ..lineTo(46, 48)
      ..close();
    canvas.drawPath(windowRear, windowPaint);

    final windowFront = Path()
      ..moveTo(49, 48)
      ..lineTo(49, 37)
      ..lineTo(57, 37)
      ..lineTo(66, 48)
      ..close();
    canvas.drawPath(windowFront, windowPaint);

    // Ruedas deportivas con llanta y rin
    final tirePaint = Paint()..color = tireColor;
    final rimPaint = Paint()..color = rimColor;

    canvas.drawCircle(const Offset(23, 68), 8.5, tirePaint);
    canvas.drawCircle(const Offset(23, 68), 4.2, rimPaint);

    canvas.drawCircle(const Offset(59, 68), 8.5, tirePaint);
    canvas.drawCircle(const Offset(59, 68), 4.2, rimPaint);

    // --- Destello / Rayos de impacto frontal (Doble capa: dorado exterior + rojo centro) ---
    final outerSparkPaint = Paint()..color = outerSparkColor;
    final innerSparkPaint = Paint()..color = innerSparkColor;

    const cx = 83.0;
    const cy = 46.0;

    // Destello exterior grande dorado
    final outerSpark = Path();
    outerSpark.moveTo(cx, cy - 16);
    outerSpark.lineTo(cx + 4, cy - 5);
    outerSpark.lineTo(cx + 14, cy - 7);
    outerSpark.lineTo(cx + 6, cy + 2);
    outerSpark.lineTo(cx + 13, cy + 13);
    outerSpark.lineTo(cx + 3, cy + 7);
    outerSpark.lineTo(cx, cy + 17);
    outerSpark.lineTo(cx - 3, cy + 7);
    outerSpark.lineTo(cx - 12, cy + 10);
    outerSpark.lineTo(cx - 6, cy + 1);
    outerSpark.lineTo(cx - 14, cy - 6);
    outerSpark.lineTo(cx - 4, cy - 4);
    outerSpark.close();
    canvas.drawPath(outerSpark, outerSparkPaint);

    // Destello interior ardiente rojo
    final innerSpark = Path();
    innerSpark.moveTo(cx, cy - 8);
    innerSpark.lineTo(cx + 2, cy - 2);
    innerSpark.lineTo(cx + 7, cy - 3);
    innerSpark.lineTo(cx + 3, cy + 1);
    innerSpark.lineTo(cx + 6, cy + 6);
    innerSpark.lineTo(cx + 1.5, cy + 3.5);
    innerSpark.lineTo(cx, cy + 8);
    innerSpark.lineTo(cx - 1.5, cy + 3.5);
    innerSpark.lineTo(cx - 6, cy + 5);
    innerSpark.lineTo(cx - 3, cy + 0.5);
    innerSpark.lineTo(cx - 7, cy - 3);
    innerSpark.lineTo(cx - 2, cy - 2);
    innerSpark.close();
    canvas.drawPath(innerSpark, innerSparkPaint);

    // Líneas de impacto cinético / chispas
    final kineticPaint = Paint()
      ..color = kineticLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(68, 27), const Offset(75, 18), kineticPaint);
    canvas.drawLine(const Offset(78, 25), const Offset(86, 15), kineticPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MeChoqueVectorPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.useModernColors != useModernColors;
}

// ============================================================================
// 2. ME CHOCARON: Dos autos, el de atrás embistiendo la parte trasera del delantero
// ============================================================================
class MeChocaronVectorPainter extends CustomPainter {
  final Color color;
  final bool useModernColors;

  const MeChocaronVectorPainter({
    required this.color,
    this.useModernColors = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    // Paleta: Auto delantero (Amarillo taxi de la víctima) vs Auto trasero (Gris titanio agresor)
    final frontCarColor = useModernColors ? const Color(0xFFFACC15) : color;
    final rearCarColor = useModernColors ? const Color(0xFF475569) : color;
    final windowColor = useModernColors
        ? const Color(0xFF0F172A)
        : Colors.black.withValues(alpha: 0.35);
    final tireColor = useModernColors ? const Color(0xFF0F172A) : color;
    final rimColor = useModernColors
        ? const Color(0xFFCBD5E1)
        : Colors.black.withValues(alpha: 0.4);
    final outerBurstColor = useModernColors ? const Color(0xFFFDE047) : color;
    final innerBurstColor = useModernColors ? const Color(0xFFDC2626) : color;
    final thrustColor = useModernColors ? const Color(0xFFEA580C) : color;

    // --- AUTO 2 (DELANTERO / TAXI VÍCTIMA - DERECHA) ---
    final frontCarPaint = Paint()..color = frontCarColor;
    final frontCar = Path();
    frontCar.moveTo(48, 70); // Parachoques trasero recibido
    frontCar.lineTo(48, 54);
    frontCar.quadraticBezierTo(49, 49, 54, 49);
    frontCar.lineTo(60, 48);
    frontCar.lineTo(68, 36); // Parabrisas trasero
    frontCar.lineTo(82, 36); // Techo
    frontCar.lineTo(88, 48); // Parabrisas delantero
    frontCar.lineTo(95, 50); // Capó
    frontCar.lineTo(97, 60); // Frente
    frontCar.lineTo(97, 70); // Parachoques delantero
    frontCar.lineTo(89, 70);
    frontCar.arcToPoint(const Offset(75, 70),
        radius: const Radius.circular(8), clockwise: false);
    frontCar.lineTo(61, 70);
    frontCar.arcToPoint(const Offset(49, 70),
        radius: const Radius.circular(7), clockwise: false);
    frontCar.close();
    canvas.drawPath(frontCar, frontCarPaint);

    // Ventana auto delantero
    final windowPaint = Paint()..color = windowColor;
    final frontWindow = Path()
      ..moveTo(63, 47)
      ..lineTo(69, 39)
      ..lineTo(80, 39)
      ..lineTo(85, 47)
      ..close();
    canvas.drawPath(frontWindow, windowPaint);

    // Ruedas auto delantero
    final tirePaint = Paint()..color = tireColor;
    final rimPaint = Paint()..color = rimColor;

    canvas.drawCircle(const Offset(55, 70), 6.5, tirePaint);
    canvas.drawCircle(const Offset(55, 70), 3.0, rimPaint);
    canvas.drawCircle(const Offset(82, 70), 6.5, tirePaint);
    canvas.drawCircle(const Offset(82, 70), 3.0, rimPaint);

    // --- AUTO 1 (TRASERO / AUTO QUE EMBISTE - IZQUIERDA) ---
    final rearCarPaint = Paint()..color = rearCarColor;
    final rearCar = Path();
    rearCar.moveTo(4, 70);
    rearCar.lineTo(4, 55);
    rearCar.quadraticBezierTo(5, 50, 10, 50);
    rearCar.lineTo(16, 49);
    rearCar.lineTo(23, 38); // Parabrisas trasero
    rearCar.lineTo(36, 38); // Techo
    rearCar.lineTo(42, 50); // Parabrisas delantero
    rearCar.lineTo(48, 52); // Frente inclinado impactando
    rearCar.lineTo(48, 70); // Parachoques chocando
    rearCar.lineTo(41, 70);
    rearCar.arcToPoint(const Offset(29, 70),
        radius: const Radius.circular(7), clockwise: false);
    rearCar.lineTo(17, 70);
    rearCar.arcToPoint(const Offset(7, 70),
        radius: const Radius.circular(6), clockwise: false);
    rearCar.close();
    canvas.drawPath(rearCar, rearCarPaint);

    // Ventana auto trasero
    final rearWindow = Path()
      ..moveTo(19, 48)
      ..lineTo(24, 40)
      ..lineTo(34, 40)
      ..lineTo(39, 48)
      ..close();
    canvas.drawPath(rearWindow, windowPaint);

    // Ruedas auto trasero
    canvas.drawCircle(const Offset(12, 70), 6.5, tirePaint);
    canvas.drawCircle(const Offset(12, 70), 3.0, rimPaint);
    canvas.drawCircle(const Offset(35, 70), 6.5, tirePaint);
    canvas.drawCircle(const Offset(35, 70), 3.0, rimPaint);

    // --- DESTELLO DE IMPACTO CENTRAL (Doble capa: amarillo dorado + rojo de choque) ---
    const bx = 48.0;
    const by = 50.0;

    final outerBurstPaint = Paint()..color = outerBurstColor;
    final impactBurst = Path();
    impactBurst.moveTo(bx, by - 18);
    impactBurst.lineTo(bx + 4.5, by - 5);
    impactBurst.lineTo(bx + 15, by - 10);
    impactBurst.lineTo(bx + 8, by);
    impactBurst.lineTo(bx + 17, by + 9);
    impactBurst.lineTo(bx + 4.5, by + 7);
    impactBurst.lineTo(bx, by + 18);
    impactBurst.lineTo(bx - 4.5, by + 7);
    impactBurst.lineTo(bx - 15, by + 10);
    impactBurst.lineTo(bx - 7, by);
    impactBurst.lineTo(bx - 16, by - 9);
    impactBurst.lineTo(bx - 4.5, by - 4.5);
    impactBurst.close();
    canvas.drawPath(impactBurst, outerBurstPaint);

    final innerBurstPaint = Paint()..color = innerBurstColor;
    final innerBurst = Path();
    innerBurst.moveTo(bx, by - 9);
    innerBurst.lineTo(bx + 2.5, by - 2.5);
    innerBurst.lineTo(bx + 8, by - 5);
    innerBurst.lineTo(bx + 4, by);
    innerBurst.lineTo(bx + 8, by + 5);
    innerBurst.lineTo(bx + 2.5, by + 3.5);
    innerBurst.lineTo(bx, by + 9);
    innerBurst.lineTo(bx - 2.5, by + 3.5);
    innerBurst.lineTo(bx - 7, by + 5);
    innerBurst.lineTo(bx - 3.5, by);
    innerBurst.lineTo(bx - 8, by - 4.5);
    innerBurst.lineTo(bx - 2.5, by - 2);
    innerBurst.close();
    canvas.drawPath(innerBurst, innerBurstPaint);

    // Líneas de empuje cinético
    final thrustPaint = Paint()
      ..color = thrustColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(48, 25), const Offset(56, 17), thrustPaint);
    canvas.drawLine(const Offset(37, 27), const Offset(31, 18), thrustPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant MeChocaronVectorPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.useModernColors != useModernColors;
}

// ============================================================================
// 3. OPERATIVO DE TRÁNSITO / RETENCIÓN ILEGAL: Agente policial con señal de ALTO y cono
// ============================================================================
class OperativoTransitoVectorPainter extends CustomPainter {
  final Color color;
  final bool useModernColors;

  const OperativoTransitoVectorPainter({
    required this.color,
    this.useModernColors = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    // Paleta: Agente con uniforme azul marino, chaleco verde neón, cono naranja y paleta roja de ALTO
    final coneColor = useModernColors ? const Color(0xFFEA580C) : color;
    final coneStripeColor = useModernColors
        ? const Color(0xFFFFFFFF)
        : Colors.black.withValues(alpha: 0.35);
    final coneBaseColor = useModernColors ? const Color(0xFF1E293B) : color;

    final skinColor = useModernColors ? const Color(0xFFFDBA74) : color;
    final uniformColor = useModernColors ? const Color(0xFF1E3A8A) : color;
    final vestColor = useModernColors
        ? const Color(0xFF84CC16)
        : Colors.black.withValues(alpha: 0.35);
    final capVisorColor = useModernColors ? const Color(0xFF0F172A) : color;
    final badgeColor = useModernColors
        ? const Color(0xFFFACC15)
        : Colors.black.withValues(alpha: 0.35);
    final stopSignColor = useModernColors ? const Color(0xFFDC2626) : color;

    // --- CONO DE TRÁNSITO / RETÉN (Lado izquierdo) ---
    final coneBasePaint = Paint()..color = coneBaseColor;
    final coneBase = RRect.fromRectAndRadius(
      const Rect.fromLTWH(8, 76, 22, 6),
      const Radius.circular(2.5),
    );
    canvas.drawRRect(coneBase, coneBasePaint);

    final conePaint = Paint()..color = coneColor;
    final coneBody = Path()
      ..moveTo(11, 76)
      ..lineTo(16, 44)
      ..lineTo(22, 44)
      ..lineTo(27, 76)
      ..close();
    canvas.drawPath(coneBody, conePaint);

    // Franja reflectiva del cono
    final coneStripePaint = Paint()..color = coneStripeColor;
    final coneStripe = Path()
      ..moveTo(13.5, 62)
      ..lineTo(15, 52)
      ..lineTo(23, 52)
      ..lineTo(24.5, 62)
      ..close();
    canvas.drawPath(coneStripe, coneStripePaint);

    // --- AGENTE DE TRÁNSITO / POLICÍA ---
    // Cabeza (tono de piel)
    final skinPaint = Paint()..color = skinColor;
    canvas.drawCircle(const Offset(46, 27), 9.5, skinPaint);

    // Gorra policial / Kepis
    final capPaint = Paint()..color = uniformColor;
    final capPath = Path()
      ..moveTo(34, 25)
      ..lineTo(36, 17)
      ..quadraticBezierTo(46, 13, 56, 17)
      ..lineTo(58, 25)
      ..close();
    canvas.drawPath(capPath, capPaint);

    // Visera negra reglamentaria
    final visorPaint = Paint()..color = capVisorColor;
    final visorPath = Path()
      ..moveTo(34, 25)
      ..lineTo(64, 25)
      ..lineTo(56, 28)
      ..lineTo(34, 28)
      ..close();
    canvas.drawPath(visorPath, visorPaint);

    // Insignia dorada en la gorra
    final badgePaint = Paint()..color = badgeColor;
    canvas.drawCircle(const Offset(46, 19), 2.5, badgePaint);

    // Torso / Chaqueta uniforme
    final uniformPaint = Paint()..color = uniformColor;
    final bodyPath = Path()
      ..moveTo(34, 38)
      ..quadraticBezierTo(46, 36, 58, 38)
      ..lineTo(62, 54)
      ..lineTo(59, 82)
      ..lineTo(33, 82)
      ..lineTo(30, 54)
      ..close();
    canvas.drawPath(bodyPath, uniformPaint);

    // Chaleco reflectivo de seguridad vial (Verde neón de alta visibilidad)
    final vestPaint = Paint()..color = vestColor;
    final vestPath = Path()
      ..moveTo(40, 38)
      ..lineTo(52, 38)
      ..lineTo(54, 70)
      ..lineTo(38, 70)
      ..close();
    canvas.drawPath(vestPath, vestPaint);

    // Cinturón táctico
    final beltPaint = Paint()..color = capVisorColor;
    final beltRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(32, 70, 28, 5.5),
      const Radius.circular(2),
    );
    canvas.drawRRect(beltRect, beltPaint);

    // Brazo extendido hacia la derecha con PALETA DE ALTO
    final armPath = Path()
      ..moveTo(57, 43)
      ..lineTo(76, 39)
      ..lineTo(77, 47)
      ..lineTo(59, 52)
      ..close();
    canvas.drawPath(armPath, uniformPaint);

    // Mano sujetando la paleta
    canvas.drawCircle(const Offset(76, 43), 4.5, skinPaint);

    // Mango de la paleta
    final handlePaint = Paint()..color = const Color(0xFF475569);
    final handleRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(74, 34, 4, 34),
      const Radius.circular(2),
    );
    canvas.drawRRect(handleRect, handlePaint);

    // Disco octagonal de ALTO / STOP
    const signCenter = Offset(76, 25);
    const signRadius = 14.5;
    final stopSignPaint = Paint()..color = stopSignColor;
    final stopSignPath = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45 - 22.5) * math.pi / 180;
      final x = signCenter.dx + signRadius * math.cos(angle);
      final y = signCenter.dy + signRadius * math.sin(angle);
      if (i == 0) {
        stopSignPath.moveTo(x, y);
      } else {
        stopSignPath.lineTo(x, y);
      }
    }
    stopSignPath.close();
    canvas.drawPath(stopSignPath, stopSignPaint);

    // Borde blanco interior del disco de ALTO
    final innerSignBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final innerSignCircle = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45 - 22.5) * math.pi / 180;
      final x = signCenter.dx + (signRadius - 2.8) * math.cos(angle);
      final y = signCenter.dy + (signRadius - 2.8) * math.sin(angle);
      if (i == 0) {
        innerSignCircle.moveTo(x, y);
      } else {
        innerSignCircle.lineTo(x, y);
      }
    }
    innerSignCircle.close();
    canvas.drawPath(innerSignCircle, innerSignBorderPaint);

    // Palma blanca de ALTO en el centro de la paleta
    final palmPaint = Paint()..color = Colors.white;
    canvas.drawCircle(signCenter, 4.2, palmPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant OperativoTransitoVectorPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.useModernColors != useModernColors;
}

// ============================================================================
// 4. AGRESIÓN / PROBLEMA PERSONAL: Dos personas enfrentadas con rayo de conflicto
// ============================================================================
class AgresionPersonalVectorPainter extends CustomPainter {
  final Color color;
  final bool useModernColors;

  const AgresionPersonalVectorPainter({
    required this.color,
    this.useModernColors = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    // Paleta: Persona agresora (Rojo), Persona defensora (Azul), Rayo de conflicto (Amarillo eléctrico)
    final skinColor = useModernColors ? const Color(0xFFFDBA74) : color;
    final person1ShirtColor = useModernColors ? const Color(0xFFDC2626) : color;
    final person2ShirtColor = useModernColors ? const Color(0xFF0284C7) : color;
    final pantsColor = useModernColors ? const Color(0xFF1E293B) : color;
    final lightningColor = useModernColors ? const Color(0xFFFACC15) : color;
    final sparkColor = useModernColors ? const Color(0xFFEA580C) : color;

    final skinPaint = Paint()..color = skinColor;
    final person1ShirtPaint = Paint()..color = person1ShirtColor;
    final person2ShirtPaint = Paint()..color = person2ShirtColor;
    final pantsPaint = Paint()..color = pantsColor;

    // --- PERSONA 1 (IZQUIERDA - AGRESIVA / RECLAMANDO) ---
    // Cabeza
    canvas.drawCircle(const Offset(22, 28), 9.5, skinPaint);

    // Torso en rojo
    final body1 = Path()
      ..moveTo(12, 42)
      ..lineTo(27, 40)
      ..lineTo(31, 62)
      ..lineTo(27, 68)
      ..lineTo(14, 68)
      ..lineTo(11, 56)
      ..close();
    canvas.drawPath(body1, person1ShirtPaint);

    // Pantalón persona 1
    final pants1 = Path()
      ..moveTo(14, 68)
      ..lineTo(27, 68)
      ..lineTo(27, 82)
      ..lineTo(14, 82)
      ..close();
    canvas.drawPath(pants1, pantsPaint);

    // Brazo extendido hacia el rival con puño
    final arm1 = Path()
      ..moveTo(24, 43)
      ..lineTo(41, 41)
      ..lineTo(42, 49)
      ..lineTo(25, 53)
      ..close();
    canvas.drawPath(arm1, person1ShirtPaint);
    canvas.drawCircle(const Offset(42, 45), 4.5, skinPaint);

    // --- PERSONA 2 (DERECHA - ENFRENTANDO / CONFLICTO) ---
    // Cabeza
    canvas.drawCircle(const Offset(78, 28), 9.5, skinPaint);

    // Torso en azul
    final body2 = Path()
      ..moveTo(73, 40)
      ..lineTo(88, 42)
      ..lineTo(89, 56)
      ..lineTo(86, 68)
      ..lineTo(73, 68)
      ..lineTo(69, 62)
      ..close();
    canvas.drawPath(body2, person2ShirtPaint);

    // Pantalón persona 2
    final pants2 = Path()
      ..moveTo(73, 68)
      ..lineTo(86, 68)
      ..lineTo(86, 82)
      ..lineTo(73, 82)
      ..close();
    canvas.drawPath(pants2, pantsPaint);

    // Brazo 2 levantado
    final arm2 = Path()
      ..moveTo(76, 43)
      ..lineTo(59, 41)
      ..lineTo(58, 49)
      ..lineTo(75, 53)
      ..close();
    canvas.drawPath(arm2, person2ShirtPaint);
    canvas.drawCircle(const Offset(58, 45), 4.5, skinPaint);

    // --- SÍMBOLO CENTRAL: RAYO ELÉCTRICO DE CONFLICTO Y CHISPAS ---
    final boltPaint = Paint()..color = lightningColor;
    final boltPath = Path()
      ..moveTo(52, 14)
      ..lineTo(42, 38)
      ..lineTo(50, 38)
      ..lineTo(46, 60)
      ..lineTo(58, 34)
      ..lineTo(50, 34)
      ..close();
    canvas.drawPath(boltPath, boltPaint);

    // Chispas de tensión / discusión
    final sparkPaint = Paint()
      ..color = sparkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(37, 24), const Offset(31, 20), sparkPaint);
    canvas.drawLine(const Offset(63, 24), const Offset(69, 20), sparkPaint);
    canvas.drawLine(const Offset(50, 66), const Offset(50, 74), sparkPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AgresionPersonalVectorPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.useModernColors != useModernColors;
}

// ============================================================================
// 5. OTRO PROBLEMA: Portafolio / Carpeta jurídica con documentos y sello legal
// ============================================================================
class OtroProblemaVectorPainter extends CustomPainter {
  final Color color;
  final bool useModernColors;

  const OtroProblemaVectorPainter({
    required this.color,
    this.useModernColors = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    final folderBackColor =
        useModernColors ? const Color(0xFF0F766E) : color;
    final folderFrontColor =
        useModernColors ? const Color(0xFF14B8A6) : color;
    final paperColor =
        useModernColors ? const Color(0xFFF8FAFC) : Colors.white;
    final textLineColor = useModernColors
        ? const Color(0xFF94A3B8)
        : Colors.black.withValues(alpha: 0.3);

    // --- 1. Pestaña y fondo de la carpeta (Folder back) ---
    final backPaint = Paint()
      ..color = folderBackColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Pestaña superior izquierda
    final tabPath = Path()
      ..moveTo(16, 26)
      ..lineTo(16, 20)
      ..quadraticBezierTo(16, 16, 20, 16)
      ..lineTo(44, 16)
      ..quadraticBezierTo(48, 16, 52, 22)
      ..lineTo(56, 26)
      ..close();
    canvas.drawPath(tabPath, backPaint);

    final folderBackRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(14, 24, 72, 60),
      const Radius.circular(8),
    );
    canvas.drawRRect(folderBackRRect, backPaint);

    // --- 2. Hoja de documento legal saliendo (Document sheet) ---
    final paperPaint = Paint()
      ..color = paperColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final paperPath = Path()
      ..moveTo(26, 12)
      ..lineTo(64, 12)
      ..lineTo(74, 22) // Esquina doblada
      ..lineTo(74, 58)
      ..lineTo(26, 58)
      ..close();
    canvas.drawPath(paperPath, paperPaint);

    // Esquina doblada del documento
    final foldPaint = Paint()
      ..color = useModernColors
          ? const Color(0xFFCBD5E1)
          : Colors.black.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final foldPath = Path()
      ..moveTo(64, 12)
      ..lineTo(64, 22)
      ..lineTo(74, 22)
      ..close();
    canvas.drawPath(foldPath, foldPaint);

    // Líneas simuladas de texto legal en el documento
    final linePaint = Paint()
      ..color = textLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(34, 24), const Offset(58, 24), linePaint);
    canvas.drawLine(const Offset(34, 32), const Offset(66, 32), linePaint);
    canvas.drawLine(const Offset(34, 40), const Offset(56, 40), linePaint);

    // --- 3. Frente de la carpeta con corte diagonal / bolsillo ---
    final frontPaint = Paint()
      ..color = folderFrontColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final frontPath = Path()
      ..moveTo(14, 42)
      ..lineTo(44, 38)
      ..quadraticBezierTo(50, 37, 56, 42)
      ..lineTo(86, 42)
      ..lineTo(86, 80)
      ..quadraticBezierTo(86, 84, 82, 84)
      ..lineTo(18, 84)
      ..quadraticBezierTo(14, 84, 14, 80)
      ..close();
    canvas.drawPath(frontPath, frontPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant OtroProblemaVectorPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.useModernColors != useModernColors;
}

// ============================================================================
// 6. ENCARCELARON UN FAMILIAR: Rejas de detención con persona y balanza de justicia
// ============================================================================
class EncarcelaronFamiliarVectorPainter extends CustomPainter {
  final Color color;
  final bool useModernColors;

  const EncarcelaronFamiliarVectorPainter({
    required this.color,
    this.useModernColors = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    final cellBgColor = useModernColors ? const Color(0xFF1E293B) : color;
    final wallColor = useModernColors
        ? const Color(0xFF0F172A)
        : Colors.black.withValues(alpha: 0.35);
    final skinColor = useModernColors ? const Color(0xFFFDBA74) : color;
    final shirtColor = useModernColors ? const Color(0xFF4F46E5) : color;
    final barColor = useModernColors ? const Color(0xFF94A3B8) : Colors.white;
    final barHighlightColor = useModernColors
        ? const Color(0xFFF1F5F9)
        : Colors.white.withValues(alpha: 0.5);

    // --- 1. Fondo de la celda / Marco de seguridad ---
    final bgPaint = Paint()..color = cellBgColor;
    final bgRRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(10, 12, 80, 76),
      const Radius.circular(10),
    );
    canvas.drawRRect(bgRRect, bgPaint);

    // Muro perimetral oscuro interior
    final wallPaint = Paint()
      ..color = wallColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawRRect(bgRRect, wallPaint);

    // --- 2. Silueta del familiar detenido (dentro de la celda) ---
    // Cabeza
    final skinPaint = Paint()..color = skinColor;
    canvas.drawCircle(const Offset(50, 36), 11, skinPaint);

    // Cabello
    final hairPaint = Paint()..color = const Color(0xFF334155);
    final hairPath = Path()
      ..moveTo(39, 36)
      ..quadraticBezierTo(40, 24, 50, 24)
      ..quadraticBezierTo(60, 24, 61, 36)
      ..lineTo(59, 30)
      ..quadraticBezierTo(50, 27, 41, 30)
      ..close();
    canvas.drawPath(hairPath, hairPaint);

    // Torso / Ropa
    final shirtPaint = Paint()..color = shirtColor;
    final torsoPath = Path()
      ..moveTo(34, 50)
      ..quadraticBezierTo(50, 46, 66, 50)
      ..lineTo(70, 76)
      ..lineTo(30, 76)
      ..close();
    canvas.drawPath(torsoPath, shirtPaint);

    // Cuello
    final neckPaint = Paint()..color = skinColor;
    const neckRect = Rect.fromLTWH(46, 44, 8, 8);
    canvas.drawRect(neckRect, neckPaint);

    // --- 3. Rejas verticales de prisión (Detención) ---
    final barPaint = Paint()
      ..color = barColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.2
      ..strokeCap = StrokeCap.round;

    final barHighlightPaint = Paint()
      ..color = barHighlightColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    const barXPositions = [26.0, 42.0, 58.0, 74.0];
    for (final x in barXPositions) {
      canvas.drawLine(Offset(x, 14), Offset(x, 86), barPaint);
      canvas.drawLine(
          Offset(x - 0.8, 16), Offset(x - 0.8, 84), barHighlightPaint);
    }

    // Travesaños horizontales (superior e inferior)
    final railPaint = Paint()
      ..color = useModernColors ? const Color(0xFF64748B) : barColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(const Offset(12, 22), const Offset(88, 22), railPaint);
    canvas.drawLine(const Offset(12, 78), const Offset(88, 78), railPaint);

    // Manos del familiar sosteniendo las rejas (en x = 42 y x = 58 a la altura y = 54)
    canvas.drawCircle(const Offset(42, 54), 3.8, skinPaint);
    canvas.drawCircle(const Offset(58, 54), 3.8, skinPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant EncarcelaronFamiliarVectorPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.useModernColors != useModernColors;
}

// ============================================================================
// 7. TRIAGE: AGRESIÓN FÍSICA O HERIDOS (Una persona golpeando a otra con impacto)
// ============================================================================
class AgresionFisicaGolpeIcon extends StatelessWidget {
  final double size;
  final bool useModernColors;

  const AgresionFisicaGolpeIcon({
    super.key,
    this.size = 34,
    this.useModernColors = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: AgresionFisicaGolpeVectorPainter(
          useModernColors: useModernColors,
        ),
      ),
    );
  }
}

class AgresionFisicaGolpeVectorPainter extends CustomPainter {
  final bool useModernColors;

  const AgresionFisicaGolpeVectorPainter({
    this.useModernColors = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    final skinColor =
        useModernColors ? const Color(0xFFFDBA74) : const Color(0xFFDC2626);
    final puncherShirtColor =
        useModernColors ? const Color(0xFFDC2626) : const Color(0xFFDC2626);
    final victimShirtColor =
        useModernColors ? const Color(0xFF0284C7) : const Color(0xFF475569);
    final pantsColor =
        useModernColors ? const Color(0xFF1E293B) : const Color(0xFF1E293B);
    final starColor =
        useModernColors ? const Color(0xFFFACC15) : const Color(0xFFDC2626);
    final starCoreColor =
        useModernColors ? const Color(0xFFEA580C) : const Color(0xFFDC2626);

    final skinPaint = Paint()..color = skinColor;
    final puncherShirtPaint = Paint()..color = puncherShirtColor;
    final victimShirtPaint = Paint()..color = victimShirtColor;
    final pantsPaint = Paint()..color = pantsColor;

    // --- PERSONA AGRESORA (IZQUIERDA) ---
    // Cabeza
    canvas.drawCircle(const Offset(22, 28), 9, skinPaint);

    // Torso avanzando con fuerza hacia la derecha
    final puncherBody = Path()
      ..moveTo(14, 42)
      ..lineTo(32, 40)
      ..lineTo(30, 64)
      ..lineTo(16, 64)
      ..close();
    canvas.drawPath(puncherBody, puncherShirtPaint);

    // Piernas en postura de avance
    final puncherLegs = Path()
      ..moveTo(16, 64)
      ..lineTo(12, 86)
      ..lineTo(19, 86)
      ..lineTo(22, 68)
      ..lineTo(26, 68)
      ..lineTo(33, 86)
      ..lineTo(40, 86)
      ..lineTo(30, 64)
      ..close();
    canvas.drawPath(puncherLegs, pantsPaint);

    // Brazo extendido lanzando el puñetazo
    final punchArm = Path()
      ..moveTo(28, 42)
      ..lineTo(54, 38)
      ..lineTo(54, 46)
      ..lineTo(28, 50)
      ..close();
    canvas.drawPath(punchArm, puncherShirtPaint);

    // Puño cerrado
    final fistRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(53, 36, 10, 11),
      const Radius.circular(4.5),
    );
    canvas.drawRRect(fistRect, skinPaint);

    // Líneas de velocidad del golpe
    final speedLinePaint = Paint()
      ..color = const Color(0xFFEA580C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        const Offset(38, 34), const Offset(48, 34), speedLinePaint);
    canvas.drawLine(
        const Offset(36, 52), const Offset(46, 52), speedLinePaint);

    // --- PERSONA VÍCTIMA (DERECHA - IMPACTADA Y CAYENDO HACIA ATRÁS) ---
    // Cabeza echada hacia atrás por el golpe
    canvas.drawCircle(const Offset(80, 24), 9, skinPaint);

    // Torso inclinado hacia atrás por el impacto
    final victimBody = Path()
      ..moveTo(68, 40)
      ..lineTo(86, 44)
      ..lineTo(82, 68)
      ..lineTo(66, 64)
      ..close();
    canvas.drawPath(victimBody, victimShirtPaint);

    // Brazo hacia atrás por el desbalance
    final victimArm = Path()
      ..moveTo(82, 45)
      ..lineTo(94, 38)
      ..lineTo(96, 45)
      ..lineTo(83, 52)
      ..close();
    canvas.drawPath(victimArm, victimShirtPaint);
    canvas.drawCircle(const Offset(95, 41), 4.2, skinPaint);

    // Piernas tambaleándose hacia atrás
    final victimLegs = Path()
      ..moveTo(66, 64)
      ..lineTo(62, 86)
      ..lineTo(69, 86)
      ..lineTo(73, 68)
      ..lineTo(77, 68)
      ..lineTo(85, 86)
      ..lineTo(92, 86)
      ..lineTo(82, 68)
      ..close();
    canvas.drawPath(victimLegs, pantsPaint);

    // --- ESTRELLA / DESTELLO DE IMPACTO (GOLPE 💥) ---
    const impactCenter = Offset(68, 36);
    final impactPath = Path();
    const int numSpikes = 8;
    const double outerR = 14.0;
    const double innerR = 6.0;
    for (int i = 0; i < numSpikes * 2; i++) {
      final double r = (i % 2 == 0) ? outerR : innerR;
      final double angle = (i * math.pi / numSpikes) - (math.pi / 2);
      final double x = impactCenter.dx + r * math.cos(angle);
      final double y = impactCenter.dy + r * math.sin(angle);
      if (i == 0) {
        impactPath.moveTo(x, y);
      } else {
        impactPath.lineTo(x, y);
      }
    }
    impactPath.close();

    final starPaint = Paint()..color = starColor;
    canvas.drawPath(impactPath, starPaint);

    // Núcleo naranja brillante del impacto
    final starCorePaint = Paint()..color = starCoreColor;
    canvas.drawCircle(impactCenter, 4.2, starCorePaint);

    // Chispas de impacto adicionales
    final sparkPaint = Paint()
      ..color = starCoreColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(68, 18), const Offset(68, 14), sparkPaint);
    canvas.drawLine(const Offset(84, 20), const Offset(88, 16), sparkPaint);
    canvas.drawLine(const Offset(76, 52), const Offset(80, 56), sparkPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AgresionFisicaGolpeVectorPainter oldDelegate) =>
      oldDelegate.useModernColors != useModernColors;
}

// ============================================================================
// 8. TRIAGE: CONFLICTO VERBAL O AMENAZA (Dos personas insultándose / discutiendo)
// ============================================================================
class ConflictoVerbalInsultosIcon extends StatelessWidget {
  final double size;
  final bool useModernColors;

  const ConflictoVerbalInsultosIcon({
    super.key,
    this.size = 34,
    this.useModernColors = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: ConflictoVerbalInsultosVectorPainter(
          useModernColors: useModernColors,
        ),
      ),
    );
  }
}

class ConflictoVerbalInsultosVectorPainter extends CustomPainter {
  final bool useModernColors;

  const ConflictoVerbalInsultosVectorPainter({
    this.useModernColors = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);

    final skinColor =
        useModernColors ? const Color(0xFFFDBA74) : const Color(0xFF7C3AED);
    final person1ShirtColor =
        useModernColors ? const Color(0xFF7C3AED) : const Color(0xFF7C3AED);
    final person2ShirtColor =
        useModernColors ? const Color(0xFF4338CA) : const Color(0xFF7C3AED);
    final pantsColor =
        useModernColors ? const Color(0xFF1E293B) : const Color(0xFF1E293B);
    final bubbleBgColor =
        useModernColors ? const Color(0xFFFEF3C7) : Colors.white;
    final bubbleBorderColor =
        useModernColors ? const Color(0xFFDC2626) : const Color(0xFF7C3AED);
    final lightningColor =
        useModernColors ? const Color(0xFFDC2626) : const Color(0xFF7C3AED);

    final skinPaint = Paint()..color = skinColor;
    final person1ShirtPaint = Paint()..color = person1ShirtColor;
    final person2ShirtPaint = Paint()..color = person2ShirtColor;
    final pantsPaint = Paint()..color = pantsColor;

    // --- PERSONA 1 (IZQUIERDA - APUNTANDO CON EL DEDO Y GRITANDO) ---
    // Cabeza inclinada hacia el frente discutiendo
    canvas.drawCircle(const Offset(22, 40), 9.0, skinPaint);
    // Boca abierta gritando (perfil)
    final mouthPaint = Paint()..color = const Color(0xFF991B1B);
    canvas.drawArc(
      const Rect.fromLTWH(26, 38, 5, 5),
      -math.pi / 2,
      math.pi,
      true,
      mouthPaint,
    );

    // Torso persona 1
    final body1 = Path()
      ..moveTo(14, 52)
      ..lineTo(30, 50)
      ..lineTo(29, 74)
      ..lineTo(15, 74)
      ..close();
    canvas.drawPath(body1, person1ShirtPaint);

    // Pantalón persona 1
    final pants1 = Path()
      ..moveTo(15, 74)
      ..lineTo(29, 74)
      ..lineTo(29, 88)
      ..lineTo(15, 88)
      ..close();
    canvas.drawPath(pants1, pantsPaint);

    // Brazo extendido señalando acusatoriamente al rival
    final arm1 = Path()
      ..moveTo(26, 52)
      ..lineTo(44, 50)
      ..lineTo(44, 57)
      ..lineTo(26, 61)
      ..close();
    canvas.drawPath(arm1, person1ShirtPaint);
    // Mano con dedo índice acusador
    final hand1 = Path()
      ..moveTo(44, 51)
      ..lineTo(51, 51) // Dedo índice
      ..lineTo(51, 54)
      ..lineTo(48, 54)
      ..lineTo(48, 57)
      ..lineTo(44, 57)
      ..close();
    canvas.drawPath(hand1, skinPaint);

    // Ondas sonoras de grito / insulto saliendo de la boca
    final shoutPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(const Rect.fromLTWH(31, 35, 8, 12), -math.pi / 3,
        2 * math.pi / 3, false, shoutPaint);

    // --- PERSONA 2 (DERECHA - RECLAMANDO CON LAS MANOS ALZADAS) ---
    // Cabeza
    canvas.drawCircle(const Offset(78, 40), 9.0, skinPaint);
    // Boca abierta respondiendo
    canvas.drawArc(
      const Rect.fromLTWH(69, 38, 5, 5),
      math.pi / 2,
      math.pi,
      true,
      mouthPaint,
    );

    // Torso persona 2
    final body2 = Path()
      ..moveTo(70, 50)
      ..lineTo(86, 52)
      ..lineTo(85, 74)
      ..lineTo(71, 74)
      ..close();
    canvas.drawPath(body2, person2ShirtPaint);

    // Pantalón persona 2
    final pants2 = Path()
      ..moveTo(71, 74)
      ..lineTo(85, 74)
      ..lineTo(85, 88)
      ..lineTo(71, 88)
      ..close();
    canvas.drawPath(pants2, pantsPaint);

    // Brazo alzado discutiendo / gesticulando con furia
    final arm2 = Path()
      ..moveTo(73, 54)
      ..lineTo(58, 48)
      ..lineTo(56, 55)
      ..lineTo(72, 62)
      ..close();
    canvas.drawPath(arm2, person2ShirtPaint);
    canvas.drawCircle(const Offset(57, 50), 4.2, skinPaint);

    // Ondas sonoras saliendo de la boca derecha
    canvas.drawArc(const Rect.fromLTWH(61, 35, 8, 12), 2 * math.pi / 3,
        2 * math.pi / 3, false, shoutPaint);

    // --- BURBUJA DE DISCORDIA / INSULTOS EN LA PARTE SUPERIOR CENTRAL ---
    const bubbleCenter = Offset(50, 20);
    final bubblePath = Path();
    const int spikes = 10;
    const double outerR = 16.0;
    const double innerR = 11.5;
    for (int i = 0; i < spikes * 2; i++) {
      final double r = (i % 2 == 0) ? outerR : innerR;
      final double angle = (i * math.pi / spikes) - (math.pi / 2);
      final double x = bubbleCenter.dx + r * math.cos(angle);
      final double y = bubbleCenter.dy + r * math.sin(angle);
      if (i == 0) {
        bubblePath.moveTo(x, y);
      } else {
        bubblePath.lineTo(x, y);
      }
    }
    bubblePath.close();

    // Cola del bocadillo apuntando hacia las cabezas
    bubblePath.moveTo(46, 32);
    bubblePath.lineTo(50, 38);
    bubblePath.lineTo(54, 32);

    final bubbleBgPaint = Paint()..color = bubbleBgColor;
    canvas.drawPath(bubblePath, bubbleBgPaint);

    final bubbleBorderPaint = Paint()
      ..color = bubbleBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(bubblePath, bubbleBorderPaint);

    // Símbolo de cólera / rayo de discordia dentro de la burbuja
    final lightningPath = Path()
      ..moveTo(53, 11)
      ..lineTo(45, 20)
      ..lineTo(51, 20)
      ..lineTo(47, 29)
      ..lineTo(56, 18)
      ..lineTo(50, 18)
      ..close();
    final lightningPaint = Paint()..color = lightningColor;
    canvas.drawPath(lightningPath, lightningPaint);

    // Signo de exclamación (!) al lado del rayo
    final exclPaint = Paint()..color = const Color(0xFFDC2626);
    final exclBar = RRect.fromRectAndRadius(
      const Rect.fromLTWH(39, 13, 2.8, 8),
      const Radius.circular(1.4),
    );
    canvas.drawRRect(exclBar, exclPaint);
    canvas.drawCircle(const Offset(40.4, 25), 1.5, exclPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ConflictoVerbalInsultosVectorPainter oldDelegate) =>
      oldDelegate.useModernColors != useModernColors;
}


