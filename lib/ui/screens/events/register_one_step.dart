import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/ui/screens/events/register_three_step.dart';
import 'package:icongrega/ui/screens/events/register_two_step.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class RegisterOneStep extends StatefulWidget {
  const RegisterOneStep({super.key});

  @override
  State<RegisterOneStep> createState() => _RegisterOneStepState();
}

class _RegisterOneStepState extends State<RegisterOneStep> {
  File? _paymentProof;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int _selectedTypeIndex = 0;
  int _selectedLocationIndex = 0;
  int _day = 0;
  String _mon = '';

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onFormChange);
    _descriptionController.addListener(_onFormChange);
    _dateController.addListener(_onFormChange);
    _timeController.addListener(_onFormChange);
  }

  void _onFormChange() {
    setState(() {});
  }

  void _onSelectTypeTap(int index) {
    setState(() {
      _selectedTypeIndex = index;
    });
  }

  void _onSelectLocationTap(int index) {
    setState(() {
      _selectedLocationIndex = index;
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _titleController.removeListener(_onFormChange);
    _descriptionController.removeListener(_onFormChange);
    _dateController.removeListener(_onFormChange);
    _timeController.removeListener(_onFormChange);
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    // Este código es asíncrono, no debe bloquearse mucho tiempo
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
        _day = picked.day;
        _mon = months[picked.month - 1];
      });
    }
  }

  bool get _isFormValid {
    return _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _timeController.text.isNotEmpty &&
        _paymentProof != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "1 de 3",
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
              'Informacíon Principal del Evento',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),

            // form titulo
            Text(
              'Título',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),
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
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Escribe un título",
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

            // form descripcion
            Text(
              'Descripción',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),
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
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: "Escribe una descripción",
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

            // form imagen
            Text(
              'Agregar Imagen o Foto',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
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
                      Icons.add_circle_outline,
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
                    'Adjuntar',
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

            Container(
              width: double.infinity,
              child: Row(
                spacing: 6,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // form fecha
                        Text(
                          'Fecha',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            color: Theme.of(context).colorScheme.background,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 12),
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
                            controller: _dateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: "DD/MM/AAAA",
                              hintStyle: TextStyle(
                                color: AppColors.neutralMidLight,
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onTap: () async {
                              _selectDate(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // form hora
                        Text(
                          'Hora',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                            color: Theme.of(context).colorScheme.background,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 12),
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
                            controller: _timeController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: "00:00",
                              hintStyle: TextStyle(
                                color: AppColors.neutralMidLight,
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (pickedTime != null) {
                                _timeController.text = pickedTime.format(
                                  context,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // form tipo
            Text(
              'Seleccionar Tipo',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _onSelectTypeTap(0);
                  },
                  borderRadius: BorderRadius.circular(14),
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _selectedTypeIndex == 0
                              ? Theme.of(context).colorScheme.shadow
                              : Colors.transparent,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      color: _selectedTypeIndex == 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'Presencial',
                      style: GoogleFonts.inter(
                        color: _selectedTypeIndex == 0
                            ? AppColors.botDark
                            : AppColors.neutralMidDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    _onSelectTypeTap(1);
                  },
                  borderRadius: BorderRadius.circular(14),
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _selectedTypeIndex == 1
                              ? Theme.of(context).colorScheme.shadow
                              : Colors.transparent,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      color: _selectedTypeIndex == 1
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'Virtual',
                      style: GoogleFonts.inter(
                        color: _selectedTypeIndex == 1
                            ? AppColors.botDark
                            : AppColors.neutralMidDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    _onSelectTypeTap(2);
                  },
                  borderRadius: BorderRadius.circular(14),
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _selectedTypeIndex == 2
                              ? Theme.of(context).colorScheme.shadow
                              : Colors.transparent,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      color: _selectedTypeIndex == 2
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'En vivo',
                      style: GoogleFonts.inter(
                        color: _selectedTypeIndex == 2
                            ? AppColors.botDark
                            : AppColors.neutralMidDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // form tipo
            Text(
              '¿Agregar Ubicación al Continuar?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _onSelectLocationTap(0);
                  },
                  borderRadius: BorderRadius.circular(14),
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _selectedLocationIndex == 0
                              ? Theme.of(context).colorScheme.shadow
                              : Colors.transparent,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      color: _selectedLocationIndex == 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'Si',
                      style: GoogleFonts.inter(
                        color: _selectedLocationIndex == 0
                            ? AppColors.botDark
                            : AppColors.neutralMidDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    _onSelectLocationTap(1);
                  },
                  borderRadius: BorderRadius.circular(14),
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _selectedLocationIndex == 1
                              ? Theme.of(context).colorScheme.shadow
                              : Colors.transparent,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      color: _selectedLocationIndex == 1
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'No',
                      style: GoogleFonts.inter(
                        color: _selectedLocationIndex == 1
                            ? AppColors.botDark
                            : AppColors.neutralMidDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),
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
              child: ElevatedButton(
                onPressed: _isFormValid
                    ? () {
                        if (_selectedLocationIndex == 0) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => RegisterTwoStep(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                image: _paymentProof,
                                type: _selectedTypeIndex,
                                location: _selectedLocationIndex,
                                day: _day,
                                mon: _mon,
                                time: _timeController.text,
                              ),
                            ),
                          );
                        } else {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (_) => RegisterThreeStep(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                image: _paymentProof,
                                type: _selectedTypeIndex,
                                location: _selectedLocationIndex,
                                day: _day,
                                mon: _mon,
                                time: _timeController.text,
                                address: 'false',
                                reference: 'false',
                              ),
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.neutralMidLight,
                  foregroundColor: _isFormValid
                      ? Colors.black87
                      : AppColors.botLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Continuar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _isFormValid
                        ? AppColors.botDark
                        : AppColors.botLight,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
