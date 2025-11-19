import 'package:flutter/material.dart';
import 'package:icongrega/ui/widgets/animated_logo_progress.dart';

class LoadingModal extends StatefulWidget {
  const LoadingModal({super.key});

  @override
  State<LoadingModal> createState() => _LoadingModalState();
}

class _LoadingModalState extends State<LoadingModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedLogoProgress(
              // progress: _progress,
              size: 120,
              primaryColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}