import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/events/detail_event_screen.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:icongrega/ui/widgets/donation.dart';

void _openBottomSheet(BuildContext context) {
  showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    useRootNavigator: true,
    context: context,
    builder: (BuildContext context) {
      return const DonacionBottomSheet();
    },
  );
}

class AdminEventScreen extends StatefulWidget {
  const AdminEventScreen({super.key});

  @override
  State<AdminEventScreen> createState() => _AdminEventScreenState();
}

class _AdminEventScreenState extends State<AdminEventScreen> {
  int _selectedIndex = 0;

  void _onSelectTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "Administrar Eventos",
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
              'Nuestros Eventos',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _onSelectTap(0);
                  },
                  borderRadius: BorderRadius.circular(14),
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _selectedIndex == 0
                              ? Theme.of(context).colorScheme.shadow
                              : Colors.transparent,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      color: _selectedIndex == 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'Activas 3',
                      style: GoogleFonts.inter(
                        color: _selectedIndex == 0
                            ? AppColors.botDark
                            : AppColors.neutralMidDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    _onSelectTap(1);
                  },
                  borderRadius: BorderRadius.circular(14),
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _selectedIndex == 1
                              ? Theme.of(context).colorScheme.shadow
                              : Colors.transparent,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      color: _selectedIndex == 1
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'Finalizadas 7',
                      style: GoogleFonts.inter(
                        color: _selectedIndex == 1
                            ? AppColors.botDark
                            : AppColors.neutralMidDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    _onSelectTap(2);
                  },
                  borderRadius: BorderRadius.circular(14),
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _selectedIndex == 2
                              ? Theme.of(context).colorScheme.shadow
                              : Colors.transparent,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      color: _selectedIndex == 2
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      'Archivadas 23',
                      style: GoogleFonts.inter(
                        color: _selectedIndex == 2
                            ? AppColors.botDark
                            : AppColors.neutralMidDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _eventItem(
              context: context,
              title: 'Encuentro Juvenil de las parroquias cercanas',
              day: '23',
              mon: 'Feb',
              user: 'Centro Evangelico Jeh',
              location: 'Santa Barbara del Zulia, Carlos Andres',
              image:
                  'https://i.pinimg.com/736x/23/29/91/232991661ff232d71921b711ff56b20c.jpg',
              presential: true,
            ),
            _eventItem(
              context: context,
              title: 'Encuentro misionero ',
              day: '31',
              mon: 'Dic',
              user: 'Obra Evangelica Luz del Mundo',
              location: 'Klm 45, final de calle ciega',
              image:
                  'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/flyer-iglesia-design-template-a1d33cf3e7c25d7c1c0b3dc0c5925f5e_screen.jpg?ts=1636994614',
              presential: true,
            ),
            _eventItem(
              context: context,
              title: 'Evento especial de primicias ',
              day: '03',
              mon: 'Mar',
              user: 'Zarza Ardiendo',
              location: 'El Vigia, La Pedregosa',
              image:
                  'https://i.pinimg.com/736x/00/cd/61/00cd61d3ec69de612c93b1ae76714545.jpg',
              presential: true,
            ),
          ],
        ),
      ),
    );
  }

  _eventItem({
    required BuildContext context,
    required String title,
    required String day,
    required String mon,
    required String user,
    required String location,
    required String image,
    bool? presential,
    bool? online,
    bool? live,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => DetailEventScreen(
              presential: presential ?? false,
              online: online ?? false,
              live: live ?? false,
              title: title,
              day: day,
              mon: mon,
              user: user,
              location: location,
              image: image,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(14),
          border: BoxBorder.all(color: AppColors.primaryLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 270,
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      letterSpacing: 0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Row(
                    children: [
                      Row(
                        spacing: 4,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                  const Color.fromARGB(148, 0, 0, 0),
                                  BlendMode.darken,
                                ),
                                fit: BoxFit.cover,
                                image: NetworkImage(image),
                              ),
                            ),
                            width: 60,
                            height: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.botLight,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    mon,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.botLight,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 204,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4,
                              children: [
                                Row(
                                  spacing: 4,
                                  children: [
                                    Icon(
                                      Icons.account_circle_outlined,
                                      color: AppColors.infoLight,
                                      size: 16,
                                    ),
                                    Flexible(
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        user,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 4,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.infoLight,
                                      size: 16,
                                    ),
                                    Flexible(
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        location,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  spacing: 8,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryLight),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.query_stats_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // acción de compartir
                        SharePlus.instance.share(
                          ShareParams(
                            title: title,
                            subject: user,
                            text: 'Ubicacion:$location\nFecha:$day $mon',
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryLight),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
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
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              child: SafeArea(
                                top: false,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 80,
                                          ),
                                          foregroundColor: Colors.black,
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'Editar',
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
                                            horizontal: 80,
                                          ),
                                          foregroundColor: Colors.black,
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'Pausar',
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
                                            horizontal: 80,
                                          ),
                                          foregroundColor: Colors.black,
                                        ),
                                        onPressed: () {
                                          _openBottomSheet(context);
                                        },
                                        child: Text(
                                          'Donar',
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
                                            horizontal: 80,
                                          ),
                                          foregroundColor:
                                              Colors.redAccent[700],
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          'Eliminar',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.redAccent[700],
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
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryLight),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(
                          Icons.more_vert_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.chevron_right_outlined),
          ],
        ),
      ),
    );
  }
}
