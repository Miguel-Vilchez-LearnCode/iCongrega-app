import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/ui/screens/events/register_three_step.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class RegisterTwoStep extends StatefulWidget {
  const RegisterTwoStep({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.type,
    required this.location,
    required this.time,
    required this.day,
    required this.mon,
  });

  final String title;
  final String description;
  final File? image;
  final int type;
  final int location;
  final int day;
  final String mon;
  final String time;

  @override
  State<RegisterTwoStep> createState() => _RegisterTwoStepState();
}

class _RegisterTwoStepState extends State<RegisterTwoStep> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  File? _paymentProof;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_onFormChange);
    _referenceController.addListener(_onFormChange);
  }

  void _onFormChange() {
    setState(() {}); // fuerza rebuild para recalcular _isFormValid
  }

  @override
  void dispose() {
    _referenceController.removeListener(_onFormChange);
    _addressController.removeListener(_onFormChange);
    super.dispose();
  }

  bool get _isFormValid {
    return _addressController.text.trim().isNotEmpty &&
           _referenceController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "2 de 3",
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Ubicación y Referencia',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),

            // form ubicacion
            Text(
              'Ubicación en el Mapa',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
                image: _paymentProof != null
                    ? DecorationImage(
                        image: FileImage(_paymentProof!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_location_outlined,
                      color: _paymentProof != null
                          ? Colors.white
                          : AppColors.primaryLight,
                      size: 32,
                    ),
                    onPressed: () async {
                      final XFile? picked = await _picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        setState(() {
                          _paymentProof = File(picked.path);
                        });
                      }
                    },
                  ),
                  Text(
                    'Seleccionar',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _paymentProof != null
                          ? Colors.white
                          : Theme.of(context).colorScheme.background,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Ubicación',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _paymentProof != null
                          ? Colors.white
                          : Theme.of(context).colorScheme.background,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // form direccion
            Text(
              'Dirección',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "Escribe una dirección",
                  hintStyle: TextStyle(color: AppColors.neutralMidLight),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // form referencia
            Text(
              'Referencia',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _referenceController,
                decoration: InputDecoration(
                  hintText: "Escribe una referencia de ubicación",
                  hintStyle: TextStyle(color: AppColors.neutralMidLight),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 48),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 12,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainer,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Retroceder",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isFormValid ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RegisterThreeStep(
                              title: widget.title,
                              description: widget.description,
                              image: widget.image,
                              type: widget.type,
                              location: widget.location,
                              day: widget.day,
                              mon: widget.mon,
                              time: widget.time,
                              address: _addressController.text,
                              reference: _referenceController.text,
                            ),
                          ),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid 
                            ? Theme.of(context).colorScheme.primary
                            : AppColors.neutralMidDark,
                        foregroundColor: _isFormValid ? Colors.black87 : AppColors.neutralMidLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Continuar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600, color: _isFormValid ? AppColors.botDark : AppColors.botLight
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
