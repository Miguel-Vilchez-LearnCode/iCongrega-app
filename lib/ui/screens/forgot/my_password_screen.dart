import 'package:flutter/material.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';

class MyPasswordScreen extends StatefulWidget {
  const MyPasswordScreen({super.key});

  @override
  State<MyPasswordScreen> createState() => _MyPasswordScreenState();
}

class _MyPasswordScreenState extends State<MyPasswordScreen> {

  final TextEditingController _passwordCtrl = TextEditingController();
  bool _obscure = true;

  double _strength = 0.0; // 0.0 a 1.0
  double _compliance = 0.0; // 0.0 a 1.0

  // Any non-alphanumeric counts as especial
  final RegExp _digit = RegExp(r"\d");
  final RegExp _lower = RegExp(r"[a-z]");
  final RegExp _special = RegExp(r"[^A-Za-z0-9]");

  void _onPasswordChanged(String value) {
    final lengthOK = value.length >= 8;
    final hasDigit = _digit.hasMatch(value);
    final hasLower = _lower.hasMatch(value);
    final hasSpecial = _special.hasMatch(value);

    // Compliance with stated rules (length, digit, special)
    final int okCount = [lengthOK, hasDigit, hasSpecial].where((v) => v).length;
    final compliance = okCount / 1.0;

    // Strength heuristic: reward length and variety
    int strengthScore = 0;
    if (lengthOK) strengthScore++;
    if (hasLower) strengthScore++;
    if (hasDigit) strengthScore++;
    if (hasSpecial) strengthScore++;
    // Additional bump for longer length >= 12
    if (value.length >= 12) strengthScore++;
    final strength = strengthScore / 5.0; // normalize to 0..1

    setState(() {
      _compliance = compliance.clamp(0.0, 1.0);
      _strength = strength.clamp(0.0, 1.0);
    });
  }

  Color _colorForStrength(double v) {
    if (v < 0.34) return Colors.red;
    if (v < 0.67) return Colors.orange;
    return Colors.green;
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "Reestablecer contraseña",
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
            SizedBox(height: 16),
            Image.asset(
              Theme.of(context).brightness == Brightness.dark
                ? "assets/images/my-password/my-password-dark.png"
                : "assets/images/my-password/my-password.png",
              height: 260,
              width: 260,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 24),
            Text(
              'Tu nueva contraseña debe tener al menos 8 caracteres, e incluir al menos un número y un carácter especial (@, #, %, ^, *, ?, !).',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // barra de progreso
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Dificultad',
                      style: TextStyle(fontSize: 14,),
                    ),
                    Text(
                      _strength >= 0.67
                          ? 'Fuerte'
                          : _strength >= 0.34
                          ? 'Media'
                          : 'Débil',
                      style: TextStyle(
                        fontSize: 14,
                        color: _colorForStrength(_strength),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: _strength,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _colorForStrength(_strength),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Password
            Container(
              margin: const EdgeInsets.only(top: 6),
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
                controller: _passwordCtrl,
                obscureText: _obscure,
                onChanged: _onPasswordChanged,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.neutralMidDark,
                    ),
                    onPressed: () {
                      setState(() => _obscure = !_obscure);
                    },
                  ),
                  hintText: "Nueva contraseña",
                  hintStyle: TextStyle(color: AppColors.neutralMidDark),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
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
                onPressed: _compliance >= 1.0 ? () {} : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.black12;
                    }
                    return Theme.of(context).colorScheme.primary;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith<Color?>((
                    states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.black45;
                    }
                    return Colors.black87;
                  }),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                child: const Text(
                  "Cambiar contraseña",
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
