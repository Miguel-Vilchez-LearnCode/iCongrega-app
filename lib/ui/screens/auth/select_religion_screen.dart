import 'package:flutter/material.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/auth/register_religion_screen.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';

class SelectReligionScreen extends StatelessWidget {
  const SelectReligionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Selecciona tu religión',
        backgroundColor: Theme.of(context).colorScheme.primary,
        // onBack: () {
        //   Navigator.of(context).pop();
        //   // O navega a otra pantalla si lo prefieres
        //   // Navigator.pushReplacement(
        //   //   context,
        //   //   MaterialPageRoute(builder: (_) => const SignUpScreen()),
        //   // );
        // },
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  color: Theme.of(context).colorScheme.background,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Puedes seleccionar más de una si aplica.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  color: Theme.of(context).colorScheme.background,
                ),
                textAlign: TextAlign.center,
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
              Wrap(
                direction: Axis.horizontal,
                spacing: 16,
                runSpacing: 16,
                children: [
                  // widgets seleccion de religion
                  Container(
                    width: 95,
                    height: 130,
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
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          opacity: 0.5,
                          image: AssetImage(
                            'assets/images/religion/pentecostal_nombre_jesus.jpg',
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Cristiana',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              shadows: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 95,
                    height: 130,
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
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          opacity: 0.5,
                          image: AssetImage(
                            'assets/images/religion/adventista.jpg',
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Adventista',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              shadows: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 95,
                    height: 130,
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
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          opacity: 0.5,
                          image: AssetImage('assets/images/religion/judia.jpg'),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Judía',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              shadows: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // widget para abrir bottomSheets
                  Container(
                    width: 95,
                    height: 130,
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
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            // bottomSheet
                            showModalBottomSheet<void>(
                              showDragHandle: true,
                              isScrollControlled: true,
                              useRootNavigator: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AnimatedPadding(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom +
                                        36,
                                  ),
                                  child: SafeArea(
                                    top: false,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          // Search
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.shadow,
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              border: Border.all(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.outline,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: TextField(
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                              ),
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    Icons.search_outlined,
                                                    color: AppColors
                                                        .neutralMidLight,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                                hintText: "Buscar",
                                                hintStyle: TextStyle(
                                                  color:
                                                      AppColors.neutralMidLight,
                                                ),
                                                filled: true,
                                                fillColor: Theme.of(
                                                  context,
                                                ).colorScheme.surfaceContainer,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Wrap(
                                            direction: Axis.horizontal,
                                            spacing: 16,
                                            runSpacing: 16,
                                            children: [
                                              // widgets seleccion de religion
                                              Container(
                                                width: 95,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainer,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.shadow,
                                                      blurRadius: 6,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      opacity: 0.5,
                                                      image: AssetImage(
                                                        'assets/images/religion/judia.jpg',
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Judía',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          shadows: [
                                                            BoxShadow(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .shadow,
                                                              blurRadius: 1,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    1,
                                                                  ),
                                                            ),
                                                          ],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 95,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainer,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.shadow,
                                                      blurRadius: 6,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      opacity: 0.5,
                                                      image: AssetImage(
                                                        'assets/images/religion/pentecostal_nombre_jesus.jpg',
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Cristiana',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          shadows: [
                                                            BoxShadow(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .shadow,
                                                              blurRadius: 1,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    1,
                                                                  ),
                                                            ),
                                                          ],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 95,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainer,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.shadow,
                                                      blurRadius: 6,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      opacity: 0.5,
                                                      image: AssetImage(
                                                        'assets/images/religion/adventista.jpg',
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Adventista',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          shadows: [
                                                            BoxShadow(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .shadow,
                                                              blurRadius: 1,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    1,
                                                                  ),
                                                            ),
                                                          ],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 95,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainer,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.shadow,
                                                      blurRadius: 6,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      opacity: 0.5,
                                                      image: AssetImage(
                                                        'assets/images/religion/islam.jpeg',
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Islámica',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          shadows: [
                                                            BoxShadow(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .shadow,
                                                              blurRadius: 1,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    1,
                                                                  ),
                                                            ),
                                                          ],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                        ),
                        Text(
                          'Agregar religión',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  "Continuar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: const TextStyle(color: Colors.blue),
                  text: "¿No encuentras tu religión? ",
                  children: [
                    TextSpan(
                      text: "Haz click aquí",
                      style: const TextStyle(
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
