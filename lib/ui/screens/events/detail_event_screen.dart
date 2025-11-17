import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:icongrega/ui/widgets/donation.dart';

void _openBottomSheet(BuildContext context) {
  showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return const DonacionBottomSheet();
    },
  );
}

class DetailEventScreen extends StatefulWidget {
  const DetailEventScreen({
    super.key,
    required this.title,
    required this.day,
    required this.mon,
    required this.user,
    required this.location,
    required this.image,
    required this.presential,
    required this.online,
    required this.live,
  });
  final String title;
  final String day;
  final String mon;
  final String user;
  final String location;
  final String image;
  final bool presential;
  final bool online;
  final bool live;
  @override
  State<DetailEventScreen> createState() => _DetailEventScreenState();
}

class _DetailEventScreenState extends State<DetailEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color.fromARGB(248, 0, 0, 0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // action botton
                Container(
                  margin: EdgeInsets.only(top: 120),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    spacing: 12,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Confirmar asistencia',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.botDark,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _openBottomSheet(context);
                            },
                            child: Container(
                              width: 35,
                              height: 35,
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/icons/donacion.png",
                                  width: 20,
                                  height: 20,
                                  color: AppColors.botDark,
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
                                  title: widget.title,
                                  subject: widget.user,
                                  text:
                                      'Ubicacion:${widget.location}\nFecha:${widget.day} ${widget.mon}\n${widget.presential
                                          ? 'Presencial'
                                          : widget.online
                                          ? 'Online'
                                          : widget.live
                                          ? 'En vivo'
                                          : 'No disponible'}',
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryLight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                Icons.share_outlined,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                border: Border.all(
                                  color: AppColors.primaryLight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                Icons.more_vert_outlined,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.botDark,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).colorScheme.shadow,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                style: ListTileStyle.drawer,
                                horizontalTitleGap: 8,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: Image.network(
                                    'https://image.vovworld.vn/w500/Uploaded/vovworld/ycgvpuiq/2021_07_01/nha-tho1_BECI.jpg',
                                    fit: BoxFit.cover,
                                  ).image,
                                ),
                                title: Column(
                                  spacing: 0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      transform: Matrix4.translationValues(
                                        0,
                                        1.5,
                                        0,
                                      ),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        widget.user,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.background,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      transform: Matrix4.translationValues(
                                        0,
                                        0,
                                        0,
                                      ),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        'Jose Puerta',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11,
                                          color: AppColors.neutralMidDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(horizontal: 4),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Seguir',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.background,
                                        ),
                                      ),
                                      Text(
                                        '07:30 AM - 12:00 PM',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.shadow,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  width: 50,
                                  height: 65,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          widget.day,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.background,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          widget.mon,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.background,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Descripción:',
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.background,
                                  ),
                                ),
                                Text(
                                  'descripcion del evento, con texto lo suficientemente largo para ejemplificar su contexto. descripcion del evento, con texto lo suficientemente largo para ejemplificar su contexto. descripcion del evento, con texto lo suficientemente largo para ejemplificar su contexto. descripcion del evento, con texto lo suficientemente largo para ejemplificar su contexto.',
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.neutralMidDark,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Wrap(
                                  runSpacing: 8,
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
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
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        widget.presential
                                            ? 'Presencial'
                                            : widget.online
                                            ? 'Virtual'
                                            : widget.live
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
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
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
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.shadow,
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
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
                                SizedBox(height: 12),
                                Text(
                                  'Detalles Extras:',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.background,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  spacing: 8,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.shadow,
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Icon(
                                              Icons.fastfood_outlined,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Venta de Comestibles',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.neutralMidDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.shadow,
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Icon(
                                              Icons.pets_outlined,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Zoologico de contacto',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.neutralMidDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.shadow,
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Icon(
                                              Icons.movie_outlined,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Proyeccion de peliculas',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.neutralMidDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Ubicación:',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.background,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 170,
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
                                        borderRadius: BorderRadius.circular(18),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/mapa.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 170,
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            const Color.fromARGB(188, 0, 0, 0),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            widget.location,
                                            style: GoogleFonts.inter(
                                              color: AppColors.botLight,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Organizadores:',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.background,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  spacing: 8,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 80,
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  "https://coworkingfy.com/wp-content/uploads/2024/08/que-es-un-perfil-profesional-2.jpg",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Joaquin',
                                            style: GoogleFonts.inter(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.background,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Pastor',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.neutralMidDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 80,
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  "https://www.seoptimer.com/storage/images/2014/08/selfie.jpg",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Monica',
                                            style: GoogleFonts.inter(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.background,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Lider de Jovenes',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.neutralMidDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 80,
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  "https://img.freepik.com/fotos-premium/selfie-facial-sonrisa-hombre-negocios-persona-que-toma-foto-memoria-feliz-carrera-redes-sociales-foto-perfil-retrato-empresario-profesional-o-asiatico-singapur-cargo_590464-183436.jpg",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Guillermo',
                                            style: GoogleFonts.inter(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.background,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            'Coordinador de ujieres',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.neutralMidDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 64),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color.fromARGB(190, 0, 0, 0),
                  ],
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Icon(Icons.arrow_back_ios, color: AppColors.botDark),
                      Text(
                        'Regresar',
                        style: GoogleFonts.inter(color: AppColors.botDark),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
