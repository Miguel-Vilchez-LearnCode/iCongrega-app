import 'package:flutter/material.dart';
import 'package:icongrega/providers/auth_provider.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/auth/upload_image_screen.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:icongrega/ui/widgets/modals/loading_modal.dart';
import 'package:provider/provider.dart';

class EmailVerifyScreen extends StatefulWidget {
  final String userEmail;

  const EmailVerifyScreen({super.key, required this.userEmail});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isDialogVisible = false;
  AuthProvider? _authProvider;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Configurar focus nodes
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && _codeControllers[i].text.isEmpty) {
          _codeControllers[i].text = '';
        }
      });
    }
  }

  // Listener para el estado de carga
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Configurar listener del AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);
    if (_authProvider != authProvider) {
      _authProvider?.removeListener(_authListener);
      _authProvider = authProvider;
      _authProvider?.addListener(_authListener);
      _authListener();
    }
  }

  @override
  void dispose() {
    _authProvider?.removeListener(_authListener);
    if (_isDialogVisible) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Método para mostrar modal de progreso
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

  String _getVerificationCode() {
    return _codeControllers.map((controller) => controller.text).join();
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  Future<void> _verifyCode() async {
    final code = _getVerificationCode();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor ingresa el código completo de 6 dígitos'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.verifyEmailCode(code);

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      // Navegar al cambio de imagen después de verificación exitosa
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UploadImageScreen()),
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.verificationError ?? 'Error al verificar el código',
          ),
        ),
      );
    }
  }

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
              widget.userEmail, // mostrar el email
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // campos de codigo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textInputAction: index == 5
                          ? TextInputAction.done
                          : TextInputAction.next,
                      onChanged: (value) => _onCodeChanged(value, index),
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "-",
                        hintStyle: TextStyle(color: AppColors.neutralMidDark),
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
                );
              }),
            ),

            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // TODO: Implementar reenvío de código
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Código reenviado')));
              },
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
                onPressed: _isLoading
                    ? null
                    : _verifyCode, // ✅ VERIFICAR CÓDIGO
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black87,
                          ),
                        ),
                      )
                    : Text(
                        "Validar y continuar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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





















// class EmailVerifyScreen extends StatefulWidget {
  
//   final String userEmail;

//   const EmailVerifyScreen({super.key, required this.userEmail});

//   @override
//   State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
// }

// class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  
//   final List<TextEditingController> _codeControllers = List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // Configurar focus nodes
//     for (int i = 0; i < _focusNodes.length; i++) {
//       _focusNodes[i].addListener(() {
//         if (!_focusNodes[i].hasFocus && _codeControllers[i].text.isEmpty) {
//           _codeControllers[i].text = '';
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in _codeControllers) {
//       controller.dispose();
//     }
//     for (var focusNode in _focusNodes) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }

//   String _getVerificationCode() {
//     return _codeControllers.map((controller) => controller.text).join();
//   }

//   void _onCodeChanged(String value, int index) {
//     if (value.length == 1 && index < 5) {
//       FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//     } else if (value.isEmpty && index > 0) {
//       FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//     }
//   }

//   Future<void> _verifyCode() async {
//     final code = _getVerificationCode();
//     if (code.length != 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Por favor ingresa el código completo de 6 dígitos'))
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     final success = await authProvider.verifyEmailCode(code);

//     setState(() {
//       _isLoading = false;
//     });

//     if (success && mounted) {
      
//       // Navegar al home después de verificación exitosa
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => HomeTabs()),
//         (route) => false,
//       );
      
//     } else if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(authProvider.verificationError ?? 'Error al verificar el código'))
//       );
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: CustomAppBar(
//         title: "Código de verificación",
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//       body: SingleChildScrollView(
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: 12),
//             Image.asset(
//               Theme.of(context).brightness == Brightness.dark
//                ? "assets/images/two-factor/two-factor-dark.png"
//                : "assets/images/two-factor/two-factor.png",
//               height: 260,
//               width: 260,
//               fit: BoxFit.contain,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Enviamos un código a tu correo registrado:',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Inter',
                
//               ),
//               textAlign: TextAlign.center,
//             ),
//             Text(
//               'example@gmail.com',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Inter',
                
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             // Email
//             Row(
//               spacing: 6,
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Theme.of(context).colorScheme.shadow,
//                           blurRadius: 3,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                       border: Border.all(color: Theme.of(context).colorScheme.outline),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: TextField(
//                       maxLength: 1,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       textInputAction: TextInputAction.next,
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       decoration: InputDecoration(
//                         counterText: "",
//                         hintText: "-",
//                         hintStyle: TextStyle(color: AppColors.neutralMidDark),
//                         filled: true,
//                         fillColor: Theme.of(context).colorScheme.surfaceContainer,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Theme.of(context).colorScheme.shadow,
//                           blurRadius: 3,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                       border: Border.all(color: Theme.of(context).colorScheme.outline),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: TextField(
//                       maxLength: 1,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       textInputAction: TextInputAction.next,
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       decoration: InputDecoration(
//                         counterText: "",
//                         hintText: "-",
//                         hintStyle: TextStyle(color: AppColors.neutralMidDark),
//                         filled: true,
//                         fillColor: Theme.of(context).colorScheme.surfaceContainer,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Theme.of(context).colorScheme.shadow,
//                           blurRadius: 3,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                       border: Border.all(color: Theme.of(context).colorScheme.outline),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: TextField(
//                       maxLength: 1,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       textInputAction: TextInputAction.next,
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       decoration: InputDecoration(
//                         counterText: "",
//                         hintText: "-",
//                         hintStyle: TextStyle(color: AppColors.neutralMidDark),
//                         filled: true,
//                         fillColor: Theme.of(context).colorScheme.surfaceContainer,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Theme.of(context).colorScheme.shadow,
//                           blurRadius: 3,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                       border: Border.all(color: Theme.of(context).colorScheme.outline),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: TextField(
//                       maxLength: 1,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       textInputAction: TextInputAction.next,
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       decoration: InputDecoration(
//                         counterText: "",
//                         hintText: "-",
//                         hintStyle: TextStyle(color: AppColors.neutralMidDark),
//                         filled: true,
//                         fillColor: Theme.of(context).colorScheme.surfaceContainer,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Theme.of(context).colorScheme.shadow,
//                           blurRadius: 3,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                       border: Border.all(color: Theme.of(context).colorScheme.outline),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: TextField(
//                       maxLength: 1,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       textInputAction: TextInputAction.next,
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                       decoration: InputDecoration(
//                         counterText: "",
//                         hintText: "-",
//                         hintStyle: TextStyle(color: AppColors.neutralMidDark),
//                         filled: true,
//                         fillColor: Theme.of(context).colorScheme.surfaceContainer,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Theme.of(context).colorScheme.shadow,
//                           blurRadius: 3,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                       border: Border.all(color: Theme.of(context).colorScheme.outline),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: TextField(
//                       maxLength: 1,
//                       keyboardType: TextInputType.number,
//                       textAlign: TextAlign.center,
//                       textInputAction: TextInputAction.done,
//                       onChanged: (value) {
//                         if (value.length == 1) {
//                           FocusScope.of(context).unfocus();
//                         }
//                       },
//                       decoration: InputDecoration(
//                         counterText: "",
//                         hintText: "-",
//                         hintStyle: TextStyle(color: AppColors.neutralMidDark),
//                         filled: true,
//                         fillColor: Theme.of(context).colorScheme.surfaceContainer,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             TextButton(
//               onPressed: () {},
//               child: Text(
//                 'Reenviar código',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: 'Inter',
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MyPasswordScreen()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).colorScheme.primary,
//                   foregroundColor: Colors.black87,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text(
//                   "Validar y continuar",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 28),
//           ],
//         ),
//       ),
//     );
//   }
// }
