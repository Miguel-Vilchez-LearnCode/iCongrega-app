import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/providers/auth_provider.dart';
import 'package:icongrega/ui/screens/auth/sign_up_screen.dart';
import 'package:icongrega/ui/screens/root/home_tabs.dart';
import 'package:icongrega/ui/screens/forgot/forgot_password_screen.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final primary = const Color.fromARGB(255, 226, 170, 0);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;

  void _submitForm(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Verificar si el login fue exitoso
      if (authProvider.loginResponse != null && authProvider.errorMessage.isEmpty) {
        _navigateToHome();
      } else {
        // Mostrar mensaje de error manejado por el Consumer
        print('Error de login: ${authProvider.errorMessage}');
      }
    }
  }

  void _navigateToHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeTabs()));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header con fondo amarillo y logo iCongrega
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.38,
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
                    width: 150,
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
                child: Form(
                  key: _formKey,
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Iniciar sesión",
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
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              controller: _emailController,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu email';
                                }
                                if (!value.contains('@')) {
                                  return 'Formato de email inválido';
                                }
                                return null;
                              },
                            ),
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
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscure,
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
                                hintText: "Contraseña",
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu contraseña';
                                }
                                return null;
                              },
                            ),
                          ),
                      
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.infoLight, // Colors.blue
                              ),
                              child: const Text("¿No recuerdas tu contraseña?"),
                            ),
                          ),
                      
                          const SizedBox(height: 12),

                          // Mensaje de error
                          if (authProvider.errorMessage.isNotEmpty)
                            Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error, color: Colors.red),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.errorMessage,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, size: 16),
                                    onPressed: () => authProvider.clearError(),
                                  ),
                                ],
                              ),
                            ),
                      
                          // Botón principal
                          authProvider.isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () => _submitForm(authProvider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryLight,
                                  foregroundColor:
                                      AppColors.neutralBlack, // Colors.black87
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                ),
                                child: const Text(
                                  "Iniciar sesión",
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
                                      border: Border.all(
                                        color: AppColors.primaryLight,
                                      ),
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
                                      border: Border.all(
                                        color: AppColors.primaryLight,
                                      ),
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
                      
                          const SizedBox(height: 6),
                      
                          // Register link
                          TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => SignUpScreen(),
                              //   ),
                              // );
                      
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 300),
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                          SignUpScreen(),
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
                                text: "¿No tienes cuenta? ",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ), // Colors.blue
                                children: [
                                  TextSpan(
                                    text: "Regístrate",
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
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } catch (e, stackTrace) {
    print("ERROR en LoginScreen: $e");
    print("Stack trace: $stackTrace");
    return Scaffold(
      body: Center(
        child: Text("Error: $e"),
      ),
    );
  }
    
  }
}
