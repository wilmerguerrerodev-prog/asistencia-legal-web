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
