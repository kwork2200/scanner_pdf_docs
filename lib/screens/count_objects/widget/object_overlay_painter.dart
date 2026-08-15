import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:scanner_pdf_docs/utils/app_colors.dart';

class ObjectOverlayPainter extends CustomPainter {
  final List<DetectedObject> objects;
  final Size imageSize;

  ObjectOverlayPainter({required this.objects, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = (size.width / imageSize.width <
        size.height / imageSize.height)
        ? size.width / imageSize.width
        : size.height / imageSize.height;

    final dx = (size.width - imageSize.width * scale) / 2;
    final dy = (size.height - imageSize.height * scale) / 2;

    for (int i = 0; i < objects.length; i++) {
      final obj = objects[i];
      final boundingBox = obj.boundingBox;

      final imgCenterX = boundingBox.left + (boundingBox.width / 2);
      final imgCenterY = boundingBox.top + (boundingBox.height / 2);

      final centerX = dx + imgCenterX * scale;
      final centerY = dy + imgCenterY * scale;

      final outerCirclePaint = Paint()
        ..color = AppColors.deepPurple.withValues(alpha: 0.9)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(centerX, centerY), 25, outerCirclePaint);

      final innerCirclePaint = Paint()
        ..color = AppColors.deepPurple
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(centerX, centerY), 22, innerCirclePaint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: TextStyle(color: AppColors.backgroundColor, fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final textOffset = Offset(
        centerX - (textPainter.width / 2),
        centerY - (textPainter.height / 2),
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(ObjectOverlayPainter oldDelegate) {
    return objects != oldDelegate.objects || imageSize != oldDelegate.imageSize;
  }
}