import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:icongrega/ui/widgets/theme_toggle_widgets.dart';
import 'package:icongrega/theme/theme_helpers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _modalAcountDelete(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Confirmación",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg_pattern.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(226, 220, 38, 38),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
                        Icon(
                          Icons.cancel_outlined,
                          size: 60,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        Text(
                          "Eliminar Cuenta",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Esta acción no tiene retorno, al eliminar su cuenta perderá toda la información',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ingresar contraseña de la cuenta para confirmar',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: context.colors.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
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
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Contraseña",
                      hintStyle: TextStyle(
                        color: AppColors.neutralMidLight,
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Tiene un plazo de 30 días para revertir la eliminación, luego de ese periodo la cuenta será eliminada permanentemente',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutralMidDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.dangerHoverDark,
                            foregroundColor: context.colors.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            "Eliminar",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),
              ],
            ),
          ),
        );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Configuraciones',
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: context.colors.surface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // cambio de tema claro a oscuro con Switch
              ListTile(
                style: ListTileStyle.drawer,
                horizontalTitleGap: 8,
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                leading: Icon(
                  Icons.light_mode_outlined,
                  color: context.colors.secondary,
                ),
                title: Text(
                  overflow: TextOverflow.ellipsis,
                  'Modo Oscuro',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: const ThemeToggleSwitch(),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: context.colors.shadow,
              ),
              // cambio de tema claro, oscuro o sistema con Select
              // ListTile(
              //   style: ListTileStyle.drawer,
              //   horizontalTitleGap: 8,
              //   contentPadding: EdgeInsets.symmetric(horizontal: 0),
              //   leading: Icon(
              //     Icons.settings_brightness,
              //     color: context.colors.secondary,
              //   ),
              //   title: Text(
              //     overflow: TextOverflow.ellipsis,
              //     'Cambiar Tema',
              //     style: GoogleFonts.inter(
              //       fontWeight: FontWeight.w500,
              //       fontSize: 14,
              //       color: Theme.of(context).colorScheme.background,
              //     ),
              //     textAlign: TextAlign.left,
              //   ),
              //   trailing: const ThemeToggleButton(showLabel: true),
              // ),
              // Container(
              //   width: double.infinity,
              //   height: 1,
              //   color: context.colors.shadow,
              // ),

              // idioma
              InkWell(
                onTap: () {
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
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: SafeArea(
                          top: false,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Español',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.background,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0,
                                    vertical: 0,
                                  ),
                                  child: Divider(),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Ingles',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.background,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0,
                                    vertical: 0,
                                  ),
                                  child: Divider(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: ListTile(
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 8,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    Icons.language,
                    color: context.colors.secondary,
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'Idioma',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: context.colors.shadow,
              ),

              // notoficaciones
              InkWell(
                onTap: () {},
                child: ListTile(
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 8,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    Icons.notifications_active_outlined,
                    color: context.colors.secondary,
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'Notificaciones',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: context.colors.shadow,
              ),

              // terminos y condicones
              InkWell(
                onTap: () {},
                child: ListTile(
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 8,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    Icons.library_books_outlined,
                    color: context.colors.secondary,
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'Terminos y Condiciones',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: context.colors.shadow,
              ),

              // sobre iCongraga
              InkWell(
                onTap: () {},
                child: ListTile(
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 8,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    Icons.help_outline_rounded,
                    color: context.colors.secondary,
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'Sobre iCongrega',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: context.colors.shadow,
              ),

              // preguntas frecuentes
              InkWell(
                onTap: () {},
                child: ListTile(
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 8,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    Icons.feedback_outlined,
                    color: context.colors.secondary,
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'Preguntas Frecuentes',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: context.colors.shadow,
              ),

              // Contacto con Soporte
              InkWell(
                onTap: () {},
                child: ListTile(
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 8,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    Icons.perm_phone_msg_outlined,
                    color: context.colors.secondary,
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'Contacta con Soporte',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: context.colors.shadow,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                _modalAcountDelete(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 8,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: Icon(
                    Icons.close,
                    color: context.colors.error,
                    size: 16,
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    'Eliminar Cuenta',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: context.colors.shadow,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Version 1.0.0',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: AppColors.neutralMidDark,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
