import 'package:flutter/material.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:icongrega/theme/app_colors.dart';

class RegisterChurchScreen extends StatelessWidget {
  const RegisterChurchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "Registra tu iglesia",
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
              'Para registrar una iglesia en nuestra plataforma, comunícate con nuestro equipo de atención al cliente. Te responderemos en menos de 24 horas.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Opciones de contacto',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),

            // Social Contact
            Row(
              spacing: 10,
              children: [
                // widget para Contacts
                // whatsapp
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).colorScheme.primary),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/whatsapp.png',
                          height: 30,
                          width: 30,
                        ),
                      ],
                    ),
                  ),
                ),

                // email
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).colorScheme.primary),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/google_mail.png',
                          height: 30,
                          width: 30,
                        ),
                      ],
                    ),
                  ),
                ),

                // call
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).colorScheme.primary),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/phone_call.png',
                          height: 30,
                          width: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Divider graphic under the title
            Center(
              child: Image.asset(
                'assets/icons/divition_border.png',
                height: 20,
                width: 240,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16),

            // form contact
            Text(
              'Formulario de contacto',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 16),
            // Email
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Correo electrónico",
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
            const SizedBox(height: 16),
            // Message
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Builder(
                builder: (context) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                  final double targetHeight = bottomInset > 0 ? 140 : 220;
                  return SizedBox(
                    height: targetHeight,
                    child: Scrollbar(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        expands: true,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.top,
                        scrollPadding: const EdgeInsets.only(bottom: 120),
                        decoration: InputDecoration(
                          hintText: "Mensaje",
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
                  );
                },
              ),
            ),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Enviar solicitud",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
