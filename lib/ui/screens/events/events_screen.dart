import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/events/admin_event_screen.dart';
import 'package:icongrega/ui/screens/events/detail_event_screen.dart';
import 'package:icongrega/ui/screens/events/register_one_step.dart';
import 'package:icongrega/ui/widgets/donation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  bool _isLoadingPage = false;
  bool isNotEmptyField = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Skeletonizer(
              enabled: _isLoadingPage,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 12),
                  // Search
                  Row(
                    spacing: 6,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.search_outlined,
                                  color: AppColors.neutralMidDark,
                                ),
                                onPressed: () {},
                              ),
                              hintText: "Buscar evento o iglesia",
                              hintStyle: TextStyle(
                                color: AppColors.neutralMidDark,
                                fontSize: 14,
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
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (_) => RegisterOneStep()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_circle_outline,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => AdminEventScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit_calendar_outlined,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
              
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Theme.of(context).colorScheme.shadow,
                  ),
              
                  const SizedBox(height: 12),
                  Text(
                    'Mis próximos eventos',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 18),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children: [
                        _myEventItem(
                          image:
                              'https://i.pinimg.com/736x/b2/59/1f/b2591fd93a7b89ce471860a6d89a11e1.jpg',
                          title: 'Encuentro Juvenil de las parroquias cercanas',
                          day: '23',
                          mon: 'Feb',
                          user: 'Centro Evangelico Jeh',
                          location: 'Santa Barbara del Zulia, Carlos Andres',
                          presential: true,
                        ),
                        _myEventItem(
                          image:
                              'https://www.danasvistas.com/images/igreja-de-santa-maria-de-campanha-porto--trw-90020220125.png',
                          title: 'Actividad de primicias',
                          day: '03',
                          mon: 'Jul',
                          user: 'Centro Cristiano Renuevo',
                          location: 'El Vigia - Merida',
                          live: true,
                        ),
                        _myEventItem(
                          image:
                              'https://www.shutterstock.com/image-photo/christian-worship-concert-background-people-600nw-2499500661.jpg',
                          title: 'Conferencia: La Metanoia',
                          day: '14',
                          mon: 'Nov',
                          user: 'Obra Evangelica Luz del Mundo',
                          location:
                              'Av. Bolivar, C.C. El Dorado, 2do piso, local 10.',
                          online: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
              
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Theme.of(context).colorScheme.shadow,
                  ),
              
                  const SizedBox(height: 12),
                  Text(
                    'Explorar eventos',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 12),
                  _eventItem(
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
          ),
        ),
      ),
      // BottomNavigationBar se maneja desde HomeTabs
    );
  }

  _myEventItem({
    required String title,
    required String day,
    required String mon,
    required String user,
    required String location,
    required String image,
    bool presential = false,
    bool online = false,
    bool live = false,
  }) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => DetailEventScreen(
              presential: presential,
              online: online,
              live: live,
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
        width: 310,
        height: 240,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color.fromARGB(200, 0, 0, 0),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 4,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.botLight,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  width: 50,
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
                            color: AppColors.botDark,
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
                            color: AppColors.botDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
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
                            color: AppColors.primaryLight,
                            size: 16,
                          ),
                          Flexible(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              user,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                color: AppColors.botLight,
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
                            color: AppColors.primaryLight,
                            size: 16,
                          ),
                          Flexible(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              location,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                color: AppColors.botLight,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: 0,
                    wordSpacing: 2,
                    color: AppColors.botLight,
                  ),
                ),
                SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          presential
                              ? 'Presencial'
                              : online
                              ? 'Virtual'
                              : live
                              ? 'En vivo'
                              : 'Por definir',
                          style: GoogleFonts.inter(
                            color: AppColors.botDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                        height: 24,
                        child: VerticalDivider(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.botLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Recreacion',
                          style: GoogleFonts.inter(
                            color: AppColors.botDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.botLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Jovenes',
                          style: GoogleFonts.inter(
                            color: AppColors.botDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
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
    );
  }

  _eventItem({
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      letterSpacing: 0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Row(
                      spacing: 4,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                        Expanded(
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
                  ),
                  const SizedBox(height: 8),
                  Row(
                    spacing: 8,
                    children: [
                      InkWell(
                        onTap: () {
                          _openBottomSheet(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryLight),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/icons/donacion.png",
                              width: 20,
                              height: 20,
                              color: Theme.of(context).colorScheme.background,
                              colorBlendMode: BlendMode.srcIn,
                            ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            'Marcar asistencia',
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
                                            'Ver Iglesia',
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
                                            'Reportar',
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
            ),
            Icon(Icons.chevron_right_outlined),
          ],
        ),
      ),
    );
  }
}
