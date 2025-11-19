import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/ui/screens/auth/login_screen.dart';
import 'package:icongrega/ui/screens/auth/register_church_screen.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/auth/select_religion_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final primary = const Color.fromARGB(255, 226, 170, 0);

  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  bool _obscure = true;

  double _strength = 0.0; // 0.0 a 1.0

  // Caracteres especiales
  final RegExp _digit = RegExp(r"\d");
  final RegExp _lower = RegExp(r"[a-z]");
  final RegExp _special = RegExp(r"[^A-Za-z0-9]");

  void _onPasswordChanged(String value) {
    final lengthOK = value.length >= 8;
    final hasDigit = _digit.hasMatch(value);
    final hasLower = _lower.hasMatch(value);
    final hasSpecial = _special.hasMatch(value);

    int strengthScore = 0;
    if (lengthOK) strengthScore++;
    if (hasLower) strengthScore++;
    if (hasDigit) strengthScore++;
    if (hasSpecial) strengthScore++;
    //  Aumento adicional para longitudes >= 12
    if (value.length >= 12) strengthScore++;
    final strength = strengthScore / 5.0; // normalizar to 0..1

    setState(() {
      _strength = strength.clamp(0.0, 1.0);
    });
  }

  Color _colorForStrength(double v) {
    if (v < 0.34) return Colors.red;
    if (v < 0.67) return Colors.orange;
    return Colors.green;
  }

  void _submit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectReligionScreen(
          nameCtrl: _nameCtrl.text,
          lastNameCtrl: _lastNameCtrl.text,
          emailCtrl: _emailCtrl.text,
          passwordCtrl: _passwordCtrl.text,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con fondo amarillo y logo iCongrega
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: primary,
                  image: const DecorationImage(
                    image: AssetImage("assets/images/bg_pattern.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 130,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              // Card blanca con formulario
              Container(
                transform: Matrix4.translationValues(0, -50, 0),
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Crear cuenta",
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),

                    // Divider graphic under the title
                    Center(
                      child: Image.asset(
                        'assets/icons/divition_border.png',
                        height: 20,
                        width: 240,
                        fit: BoxFit.contain,
                      ),
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
                        border: BoxBorder.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _emailCtrl,
                        decoration: InputDecoration(
                          hintText: "Correo electrónico",
                          hintStyle: TextStyle(
                            color: AppColors.neutralMidLight,
                            fontSize: 15,
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
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      spacing: 4,
                      children: [
                        // Nombre
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: BoxBorder.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _nameCtrl,
                              decoration: InputDecoration(
                                hintText: "Nombre",
                                hintStyle: TextStyle(
                                  color: AppColors.neutralMidLight,
                                  fontSize: 15,
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
                            ),
                          ),
                        ),

                        // Apellido
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow,
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: BoxBorder.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _lastNameCtrl,
                              decoration: InputDecoration(
                                hintText: "Apellido",
                                hintStyle: TextStyle(
                                  color: AppColors.neutralMidLight,
                                  fontSize: 15,
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

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
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
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
                              color: AppColors.neutralMidLight,
                            ),
                            onPressed: () {
                              setState(() => _obscure = !_obscure);
                            },
                          ),
                          hintText: "Nueva contraseña",
                          hintStyle: TextStyle(
                            color: AppColors.neutralMidLight,
                            fontSize: 15,
                          ),
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainer,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // barra de progreso
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dificultad',
                              style: TextStyle(fontSize: 14),
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
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer, // Colors.black12
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _colorForStrength(_strength),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterChurchScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary, // Colors.blue
                        ),
                        child: const Text(
                          "¿Eres una iglesia? Registra tu congregación aquí",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Botón principal
                    ElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor:
                            AppColors.neutralBlack, // Colors.black87
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: const Text(
                        "Crear cuenta",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Social login
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainer,
                                border: Border.all(color: primary),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/icons/google.png',
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainer,
                                border: Border.all(color: primary),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.apple,
                                size: 24,
                                color: Theme.of(
                                  context,
                                ).colorScheme.background, // Colors.black
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Divider graphic under the title
                    Center(
                      child: Image.asset(
                        'assets/icons/divition_border.png',
                        height: 20,
                        width: 240,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Register link
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    LoginScreen(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ), // Colors.blue
                          text: "¿Ya tienes cuenta? ",
                          children: [
                            TextSpan(
                              text: "inicia sesión",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface, // Colors.blue
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
