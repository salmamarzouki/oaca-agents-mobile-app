import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OacaLogo extends StatelessWidget {
  final double? height;
  final double? width;
  
  const OacaLogo({
    Key? key,
    this.height = 80,
    this.width = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo OACA stylisé
          Container(
            height: height! * 0.7,
            child: CustomPaint(
              painter: OacaLogoPainter(),
              size: Size(width!, height! * 0.7),
            ),
          ),
          SizedBox(height: 8),
          // Texte OACA
          Text(
            'OACA',
            style: TextStyle(
              fontSize: height! * 0.15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E5F8A),
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class OacaLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Gradient bleu
    final gradient = LinearGradient(
      colors: [
        Color(0xFF4A90E2),
        Color(0xFF357ABD),
        Color(0xFF2E5F8A),
      ],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = gradient.createShader(rect);

    final center = Offset(size.width * 0.3, size.height * 0.5);
    final radius = size.height * 0.3;

    // Cercle principal
    canvas.drawCircle(center, radius, paint);

    // Éléments intérieurs stylisés
    paint.strokeWidth = 1.5;
    
    // Courbes intérieures représentant l'aviation
    final path1 = Path();
    path1.moveTo(center.dx - radius * 0.6, center.dy);
    path1.quadraticBezierTo(center.dx, center.dy - radius * 0.6, center.dx + radius * 0.6, center.dy);
    path1.quadraticBezierTo(center.dx, center.dy + radius * 0.6, center.dx - radius * 0.6, center.dy);
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(center.dx, center.dy - radius * 0.6);
    path2.quadraticBezierTo(center.dx + radius * 0.6, center.dy, center.dx, center.dy + radius * 0.6);
    path2.quadraticBezierTo(center.dx - radius * 0.6, center.dy, center.dx, center.dy - radius * 0.6);
    canvas.drawPath(path2, paint);

    // Lignes horizontales représentant les pistes
    paint.strokeWidth = 3.0;
    final startX = size.width * 0.65;
    final lineY1 = size.height * 0.35;
    final lineY2 = size.height * 0.5;
    final lineY3 = size.height * 0.65;

    canvas.drawLine(Offset(startX, lineY1), Offset(size.width * 0.9, lineY1), paint);
    
    paint.strokeWidth = 2.0;
    canvas.drawLine(Offset(startX, lineY2), Offset(size.width * 0.85, lineY2), paint);
    canvas.drawLine(Offset(startX, lineY3), Offset(size.width * 0.8, lineY3), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
