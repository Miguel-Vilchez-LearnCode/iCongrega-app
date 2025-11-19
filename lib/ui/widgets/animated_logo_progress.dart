

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnimatedLogoProgress extends StatefulWidget {
  // final double progress;
  final double size;
  final Color primaryColor;

  const AnimatedLogoProgress({
    super.key,
    // required this.progress,
    this.size = 120,
    this.primaryColor = const Color(0xFFEFB200),
  });

  @override
  State<AnimatedLogoProgress> createState() => _AnimatedLogoProgressState();
}

class _AnimatedLogoProgressState extends State<AnimatedLogoProgress> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de fondo con borde sutil
          Container(
            width: widget.size - 12,
            height: widget.size - 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),

          // Progreso circular
          SizedBox(
            width: widget.size - 24,
            height: widget.size - 24,
            child: CircularProgressIndicator(
              // value: widget.progress,
              strokeWidth: 3,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
            ),
          ),

          // Logo con efecto de pulso
          ScaleTransition(
            scale: Tween<double>(
              begin: 0.8,
              end: 1.0,
            ).animate(_pulseController),
            child: Container(
              width: widget.size * 0.4,
              height: widget.size * 0.4,
              child: SvgPicture.asset(
                'assets/icons/iCongrega-icono.svg',
                color: widget.primaryColor,
              ),
            ),
          ),

          // Porcentaje (opcional)
          // if (widget.progress < 1.0)
          //   Positioned(
          //     bottom: 10,
          //     child: Text(
          //       '${(widget.progress * 100).toInt()}%',
          //       style: TextStyle(
          //         color: widget.primaryColor,
          //         fontSize: 12,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}
