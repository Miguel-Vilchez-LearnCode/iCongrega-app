import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/providers/auth_provider.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/root/home_tabs.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:icongrega/ui/widgets/modals/loading_modal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

void _modalProgress(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, anim1, anim2) {
      return const LoadingModal();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1,
        child: ScaleTransition(scale: anim1, child: child),
      );
    },
  );
}

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _paymentProof;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _aboutCtrl = TextEditingController();
  bool _isSubmitting = false;
  bool _isDialogVisible = false;
  AuthProvider? _authProvider;

  @override
  void dispose() {
    _aboutCtrl.dispose();
    super.dispose();
  }

  void _authListener() {
    if (!mounted) return;
    final authProvider = _authProvider;
    if (authProvider == null) return;

    if (authProvider.isLoading && !_isDialogVisible) {
      _isDialogVisible = true;
      _modalProgress(context);
    } else if (!authProvider.isLoading && _isDialogVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogVisible = false;
    }
  }

  Future<void> _submit() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Validar que al menos haya algo que actualizar
    if (_paymentProof == null && _aboutCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega una foto de perfil o una descripción'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      String? imagePath;

      // Paso 1: Subir la imagen si existe
      if (_paymentProof != null) {
        imagePath = await authProvider.uploadProfileImage(_paymentProof!);

        if (imagePath == null) {
          // Error al subir imagen
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  authProvider.errorMessage.isNotEmpty
                      ? authProvider.errorMessage
                      : 'Error al subir la imagen',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      // Paso 2: Actualizar el perfil con la ruta de la imagen y/o about
      final success = await authProvider.updateUserProfile(
        profileImage: imagePath,
        about: _aboutCtrl.text.trim().isNotEmpty
            ? _aboutCtrl.text.trim()
            : null,
      );

      if (mounted) {
        if (success) {
          // Éxito - navegar a HomeTabs
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeTabs()),
            (route) => false,
          );
        } else {
          // Error al actualizar perfil
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                authProvider.errorMessage.isNotEmpty
                    ? authProvider.errorMessage
                    : 'Error al actualizar el perfil',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context);
    if (_authProvider != authProvider) {
      _authProvider?.removeListener(_authListener);
      _authProvider = authProvider;
      _authProvider?.addListener(_authListener);
      _authListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeTabs()),
          );
        },
        title: 'Registro de usuario',
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Detalles de tu Perfil',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 16),

              // form descripcion
              Text(
                'Acerca de ti',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,

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
                  minLines: 1,
                  maxLines: 5,
                  controller: _aboutCtrl,
                  decoration: InputDecoration(
                    hintText: "Soy un fiel creyente de la palabra...",
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.neutralMidLight,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // form imagen
              Text(
                'Agregar Foto de Perfil',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,

                  color: Theme.of(context).colorScheme.background,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(100),
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
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: _paymentProof != null
                            ? Colors.white
                            : AppColors.primaryLight,
                        size: 34,
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
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
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
                onPressed: _isSubmitting ? null : () => _submit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Continuar",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
