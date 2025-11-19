import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:icongrega/ui/widgets/theme_toggle_widgets.dart';
import 'package:icongrega/theme/theme_helpers.dart';
import 'package:icongrega/ui/widgets/modals/delete_acount_modal.dart';

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
        return DeleteAcountModal();
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
