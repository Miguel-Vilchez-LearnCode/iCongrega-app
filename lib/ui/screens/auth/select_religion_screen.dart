import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/providers/religion_provider.dart';
import 'package:icongrega/ui/screens/auth/email_verify_screen.dart';
import 'package:icongrega/ui/screens/auth/register_religion_screen.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:icongrega/providers/auth_provider.dart';
import 'package:icongrega/ui/widgets/modals/loading_modal.dart';
import 'package:provider/provider.dart';

class SelectReligionScreen extends StatefulWidget {
  const SelectReligionScreen({
    super.key,
    required this.nameCtrl,
    required this.lastNameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
  });

  final String nameCtrl;
  final String lastNameCtrl;
  final String emailCtrl;
  final String passwordCtrl;

  @override
  State<SelectReligionScreen> createState() => _SelectReligionScreenState();
}

class _SelectReligionScreenState extends State<SelectReligionScreen> {
  int? _selectedReligionId;

  bool _isDialogVisible = false;
  AuthProvider? _authProvider;
  ReligionProvider? _religionProvider;

  void _onReligionSelected(int id) {
    setState(() {
      _selectedReligionId == id
          ? _selectedReligionId = 1
          : _selectedReligionId = id;
    });
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

  late VoidCallback _religionListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final religionProvider = Provider.of<ReligionProvider>(context);
    if (_religionProvider != religionProvider) {
      _religionProvider?.removeListener(_religionListener);
      _religionProvider = religionProvider;
      _religionListener = () {
        if (!mounted) return;
        if (religionProvider.isLoading && !_isDialogVisible) {
          _isDialogVisible = true;
          _modalProgress(context);
        } else if (!religionProvider.isLoading && _isDialogVisible) {
          Navigator.of(context, rootNavigator: true).pop();
          _isDialogVisible = false;
        }
      };
      _religionProvider?.addListener(_religionListener);
      _religionListener();
    }

    final authProvider = Provider.of<AuthProvider>(context);
    if (_authProvider != authProvider) {
      _authProvider?.removeListener(_authListener);
      _authProvider = authProvider;
      _authProvider?.addListener(_authListener);
      _authListener();
    }
  }

  void _submit() async {
    final body = {
      "name": widget.nameCtrl,
      "lastname": widget.lastNameCtrl,
      "email": widget.emailCtrl,
      "religion_id": _selectedReligionId,
      "password": widget.passwordCtrl,
    };

    final auth = context.read<AuthProvider>();

    final ok = await auth.registerUser(body);

    if (ok && mounted) {
      // guardar el email para verificación en el provider
      auth.setEmailForVerification(widget.emailCtrl);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailVerifyScreen(userEmail: widget.emailCtrl),
        ),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(auth.errorMessage)));
      }
    }
  }

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _religionProvider = context.read<ReligionProvider>();
      _religionProvider!.loadReligions();
    });
  }

  @override
  void dispose() {
    _religionProvider?.removeListener(_religionListener);
    _authProvider?.removeListener(_authListener);
    if (_isDialogVisible) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // instanciar proveedor de religiones
    final rp = Provider.of<ReligionProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Selecciona tu religión',
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Elige la opción que mejor represente tus creencias.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,

                  color: Theme.of(context).colorScheme.background,
                ),
                textAlign: TextAlign.center,
              ),
              // Text(
              //   'Puedes seleccionar más de una si aplica.',
              //   style: GoogleFonts.inter(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w500,

              //     color: Theme.of(context).colorScheme.background,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              SizedBox(height: 8),

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
              Wrap(
                direction: Axis.horizontal,
                spacing: 16,
                runSpacing: 16,
                children: [
                  // widgets seleccion de religion
                  ...rp.religions.map(
                    (religion) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 95,
                          height: 130,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedReligionId == religion.id
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                              width: 1.3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedReligionId == religion.id
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.3)
                                    : Theme.of(context).colorScheme.shadow,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              _onReligionSelected(religion.id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  opacity: _selectedReligionId == religion.id
                                      ? 0.2
                                      : 0.4,
                                  image: AssetImage(
                                    'assets/images/religion/judia.jpg',
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    religion.name,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      shadows: [
                                        BoxShadow(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.shadow,
                                          blurRadius: 1,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.background,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (_selectedReligionId == religion.id)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // // widget para abrir bottomSheets
                  // Container(
                  //   width: 95,
                  //   height: 130,
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).colorScheme.surfaceContainer,
                  //     borderRadius: BorderRadius.circular(12),
                  //     border: Border.all(
                  //       color: Theme.of(context).colorScheme.primary,
                  //     ),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Theme.of(context).colorScheme.shadow,
                  //         blurRadius: 6,
                  //         offset: const Offset(0, 2),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       IconButton(
                  //         onPressed: () {
                  //           // bottomSheet
                  //           showModalBottomSheet<void>(
                  //             showDragHandle: true,
                  //             isScrollControlled: true,
                  //             useRootNavigator: true,
                  //             context: context,
                  //             builder: (BuildContext context) {
                  //               return AnimatedPadding(
                  //                 duration: const Duration(milliseconds: 200),
                  //                 curve: Curves.easeOut,
                  //                 padding: EdgeInsets.only(
                  //                   bottom:
                  //                       MediaQuery.of(
                  //                         context,
                  //                       ).viewInsets.bottom +
                  //                       36,
                  //                 ),
                  //                 child: SafeArea(
                  //                   top: false,
                  //                   child: SingleChildScrollView(
                  //                     child: Column(
                  //                       mainAxisSize: MainAxisSize.min,
                  //                       children: <Widget>[
                  //                         // Search
                  //                         Container(
                  //                           margin: const EdgeInsets.symmetric(
                  //                             horizontal: 16,
                  //                           ),
                  //                           decoration: BoxDecoration(
                  //                             boxShadow: [
                  //                               BoxShadow(
                  //                                 color: Theme.of(
                  //                                   context,
                  //                                 ).colorScheme.shadow,
                  //                                 blurRadius: 6,
                  //                                 offset: const Offset(0, 2),
                  //                               ),
                  //                             ],
                  //                             border: Border.all(
                  //                               color: Theme.of(
                  //                                 context,
                  //                               ).colorScheme.outline,
                  //                             ),
                  //                             borderRadius:
                  //                                 BorderRadius.circular(12),
                  //                           ),
                  //                           child: TextField(
                  //                             style: GoogleFonts.inter(
                  //
                  //                               fontWeight: FontWeight.w500,
                  //                               color: Theme.of(
                  //                                 context,
                  //                               ).colorScheme.onSurface,
                  //                             ),
                  //                             decoration: InputDecoration(
                  //                               suffixIcon: IconButton(
                  //                                 icon: Icon(
                  //                                   Icons.search_outlined,
                  //                                   color: AppColors
                  //                                       .neutralMidLight,
                  //                                 ),
                  //                                 onPressed: () {},
                  //                               ),
                  //                               hintText: "Buscar",
                  //                               hintStyle: GoogleFonts.inter(
                  //                                 color:
                  //                                     AppColors.neutralMidLight,
                  //                               ),
                  //                               filled: true,
                  //                               fillColor: Theme.of(
                  //                                 context,
                  //                               ).colorScheme.surfaceContainer,
                  //                               border: OutlineInputBorder(
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(12),
                  //                                 borderSide: BorderSide.none,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         const SizedBox(height: 20),
                  //                         Wrap(
                  //                           direction: Axis.horizontal,
                  //                           spacing: 16,
                  //                           runSpacing: 16,
                  //                           children: [
                  //                             // widgets seleccion de religion
                  //                             Container(
                  //                               width: 95,
                  //                               height: 130,
                  //                               decoration: BoxDecoration(
                  //                                 color: Theme.of(context)
                  //                                     .colorScheme
                  //                                     .surfaceContainer,
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(12),
                  //                                 border: Border.all(
                  //                                   color: Theme.of(
                  //                                     context,
                  //                                   ).colorScheme.primary,
                  //                                 ),
                  //                                 boxShadow: [
                  //                                   BoxShadow(
                  //                                     color: Theme.of(
                  //                                       context,
                  //                                     ).colorScheme.shadow,
                  //                                     blurRadius: 6,
                  //                                     offset: const Offset(
                  //                                       0,
                  //                                       2,
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                               child: Container(
                  //                                 decoration: BoxDecoration(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(
                  //                                         12,
                  //                                       ),
                  //                                   image: DecorationImage(
                  //                                     fit: BoxFit.cover,
                  //                                     opacity: 0.5,
                  //                                     image: AssetImage(
                  //                                       'assets/images/religion/judia.jpg',
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                                 child: Column(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .center,
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment
                  //                                           .center,
                  //                                   children: [
                  //                                     Text(
                  //                                       'Judía',
                  //                                       textAlign:
                  //                                           TextAlign.center,
                  //                                       style: GoogleFonts.inter(
                  //
                  //                                         shadows: [
                  //                                           BoxShadow(
                  //                                             color:
                  //                                                 Theme.of(
                  //                                                       context,
                  //                                                     )
                  //                                                     .colorScheme
                  //                                                     .shadow,
                  //                                             blurRadius: 1,
                  //                                             offset:
                  //                                                 const Offset(
                  //                                                   0,
                  //                                                   1,
                  //                                                 ),
                  //                                           ),
                  //                                         ],
                  //                                         fontWeight:
                  //                                             FontWeight.w500,
                  //                                         color:
                  //                                             Theme.of(context)
                  //                                                 .colorScheme
                  //                                                 .background,
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Container(
                  //                               width: 95,
                  //                               height: 130,
                  //                               decoration: BoxDecoration(
                  //                                 color: Theme.of(context)
                  //                                     .colorScheme
                  //                                     .surfaceContainer,
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(12),
                  //                                 border: Border.all(
                  //                                   color: Theme.of(
                  //                                     context,
                  //                                   ).colorScheme.primary,
                  //                                 ),
                  //                                 boxShadow: [
                  //                                   BoxShadow(
                  //                                     color: Theme.of(
                  //                                       context,
                  //                                     ).colorScheme.shadow,
                  //                                     blurRadius: 6,
                  //                                     offset: const Offset(
                  //                                       0,
                  //                                       2,
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                               child: Container(
                  //                                 decoration: BoxDecoration(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(
                  //                                         12,
                  //                                       ),
                  //                                   image: DecorationImage(
                  //                                     fit: BoxFit.cover,
                  //                                     opacity: 0.5,
                  //                                     image: AssetImage(
                  //                                       'assets/images/religion/pentecostal_nombre_jesus.jpg',
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                                 child: Column(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .center,
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment
                  //                                           .center,
                  //                                   children: [
                  //                                     Text(
                  //                                       'Cristiana',
                  //                                       textAlign:
                  //                                           TextAlign.center,
                  //                                       style: GoogleFonts.inter(
                  //
                  //                                         shadows: [
                  //                                           BoxShadow(
                  //                                             color:
                  //                                                 Theme.of(
                  //                                                       context,
                  //                                                     )
                  //                                                     .colorScheme
                  //                                                     .shadow,
                  //                                             blurRadius: 1,
                  //                                             offset:
                  //                                                 const Offset(
                  //                                                   0,
                  //                                                   1,
                  //                                                 ),
                  //                                           ),
                  //                                         ],
                  //                                         fontWeight:
                  //                                             FontWeight.w500,
                  //                                         color:
                  //                                             Theme.of(context)
                  //                                                 .colorScheme
                  //                                                 .background,
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Container(
                  //                               width: 95,
                  //                               height: 130,
                  //                               decoration: BoxDecoration(
                  //                                 color: Theme.of(context)
                  //                                     .colorScheme
                  //                                     .surfaceContainer,
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(12),
                  //                                 border: Border.all(
                  //                                   color: Theme.of(
                  //                                     context,
                  //                                   ).colorScheme.primary,
                  //                                 ),
                  //                                 boxShadow: [
                  //                                   BoxShadow(
                  //                                     color: Theme.of(
                  //                                       context,
                  //                                     ).colorScheme.shadow,
                  //                                     blurRadius: 6,
                  //                                     offset: const Offset(
                  //                                       0,
                  //                                       2,
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                               child: Container(
                  //                                 decoration: BoxDecoration(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(
                  //                                         12,
                  //                                       ),
                  //                                   image: DecorationImage(
                  //                                     fit: BoxFit.cover,
                  //                                     opacity: 0.5,
                  //                                     image: AssetImage(
                  //                                       'assets/images/religion/adventista.jpg',
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                                 child: Column(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .center,
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment
                  //                                           .center,
                  //                                   children: [
                  //                                     Text(
                  //                                       'Adventista',
                  //                                       textAlign:
                  //                                           TextAlign.center,
                  //                                       style: GoogleFonts.inter(
                  //
                  //                                         shadows: [
                  //                                           BoxShadow(
                  //                                             color:
                  //                                                 Theme.of(
                  //                                                       context,
                  //                                                     )
                  //                                                     .colorScheme
                  //                                                     .shadow,
                  //                                             blurRadius: 1,
                  //                                             offset:
                  //                                                 const Offset(
                  //                                                   0,
                  //                                                   1,
                  //                                                 ),
                  //                                           ),
                  //                                         ],
                  //                                         fontWeight:
                  //                                             FontWeight.w500,
                  //                                         color:
                  //                                             Theme.of(context)
                  //                                                 .colorScheme
                  //                                                 .background,
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Container(
                  //                               width: 95,
                  //                               height: 130,
                  //                               decoration: BoxDecoration(
                  //                                 color: Theme.of(context)
                  //                                     .colorScheme
                  //                                     .surfaceContainer,
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(12),
                  //                                 border: Border.all(
                  //                                   color: Theme.of(
                  //                                     context,
                  //                                   ).colorScheme.primary,
                  //                                 ),
                  //                                 boxShadow: [
                  //                                   BoxShadow(
                  //                                     color: Theme.of(
                  //                                       context,
                  //                                     ).colorScheme.shadow,
                  //                                     blurRadius: 6,
                  //                                     offset: const Offset(
                  //                                       0,
                  //                                       2,
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                               child: Container(
                  //                                 decoration: BoxDecoration(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(
                  //                                         12,
                  //                                       ),
                  //                                   image: DecorationImage(
                  //                                     fit: BoxFit.cover,
                  //                                     opacity: 0.5,
                  //                                     image: AssetImage(
                  //                                       'assets/images/religion/islam.jpeg',
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                                 child: Column(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment
                  //                                           .center,
                  //                                   crossAxisAlignment:
                  //                                       CrossAxisAlignment
                  //                                           .center,
                  //                                   children: [
                  //                                     Text(
                  //                                       'Islámica',
                  //                                       textAlign:
                  //                                           TextAlign.center,
                  //                                       style: GoogleFonts.inter(
                  //
                  //                                         shadows: [
                  //                                           BoxShadow(
                  //                                             color:
                  //                                                 Theme.of(
                  //                                                       context,
                  //                                                     )
                  //                                                     .colorScheme
                  //                                                     .shadow,
                  //                                             blurRadius: 1,
                  //                                             offset:
                  //                                                 const Offset(
                  //                                                   0,
                  //                                                   1,
                  //                                                 ),
                  //                                           ),
                  //                                         ],
                  //                                         fontWeight:
                  //                                             FontWeight.w500,
                  //                                         color:
                  //                                             Theme.of(context)
                  //                                                 .colorScheme
                  //                                                 .background,
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           );
                  //         },
                  //         icon: Icon(
                  //           Icons.add_circle_outline,
                  //           color: Theme.of(context).colorScheme.primary,
                  //           size: 32,
                  //         ),
                  //       ),
                  //       Text(
                  //         'Agregar religión',
                  //         textAlign: TextAlign.center,
                  //         style: GoogleFonts.inter(
                  //
                  //           color: Theme.of(context).colorScheme.background,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
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
                onPressed: () => _submit(),
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
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const RegisterReligionScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
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
                  style: GoogleFonts.inter(color: Colors.blue),
                  text: "¿No encuentras tu religión? ",
                  children: [
                    TextSpan(
                      text: "Haz click aquí",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
