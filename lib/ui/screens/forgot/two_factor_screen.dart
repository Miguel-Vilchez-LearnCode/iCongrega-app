import 'package:flutter/material.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/forgot/my_password_screen.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';

class TwoFactorScreen extends StatelessWidget {
  const TwoFactorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "Código de verificación",
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
            SizedBox(height: 12),
            Image.asset(
              Theme.of(context).brightness == Brightness.dark
               ? "assets/images/two-factor/two-factor-dark.png"
               : "assets/images/two-factor/two-factor.png",
              height: 260,
              width: 260,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'Enviamos un código a tu correo registrado:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
                
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'example@gmail.com',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
                
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Email
            Row(
              spacing: 6,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "-",
                        hintStyle: TextStyle(color: AppColors.neutralMidDark),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "-",
                        hintStyle: TextStyle(color: AppColors.neutralMidDark),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "-",
                        hintStyle: TextStyle(color: AppColors.neutralMidDark),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "-",
                        hintStyle: TextStyle(color: AppColors.neutralMidDark),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "-",
                        hintStyle: TextStyle(color: AppColors.neutralMidDark),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.done,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "-",
                        hintStyle: TextStyle(color: AppColors.neutralMidDark),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: Text(
                'Reenviar código',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPasswordScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Validar y continuar",
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
