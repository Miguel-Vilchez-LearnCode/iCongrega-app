import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/root/home_tabs.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:icongrega/ui/widgets/donation.dart';

// void _openBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     showDragHandle: true,
//     isScrollControlled: true,
//     context: context,
//     builder: (BuildContext context) {
//       return const DonacionBottomSheet();
//     },
//   );
// }

class RegisterPreviewStep extends StatefulWidget {
  const RegisterPreviewStep({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.type,
    // required this.location,
    required this.time,
    required this.address,
    required this.reference,
    required this.day,
    required this.mon,
    // required this.user,
    required this.labels,
    required this.features,
    required this.organizers,
  });

  final String title;
  final String day;
  final int type;
  final String mon;
  final String address;
  final File? image;
  final String time;
  final String description;
  final String reference;
  final String location = "assets/images/mapa.png";
  final String user = 'Iglesia Pentecostal Unida';
  final List<String> labels;
  final List<Map<String, String>> features;
  final List<Map<String, String>> organizers;
  @override
  State<RegisterPreviewStep> createState() => _RegisterPreviewStepState();
}

class _RegisterPreviewStepState extends State<RegisterPreviewStep> {
  bool _isLoading = false;

  void _onSubmit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    // Simular un proceso de validación
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeTabs(initialIndex: 2)),
    );
  }

  IconData _getIconData(String key) {
    switch (key) {
      case 'church_outlined':
        return Icons.church_outlined;
      case 'event_outlined':
        return Icons.event_outlined;
      case 'nights_stay_outlined':
        return Icons.nights_stay_outlined;
      case 'public_outlined':
        return Icons.public_outlined;
      case 'terrain_outlined':
        return Icons.terrain_outlined;
      case 'mic_outlined':
        return Icons.mic_outlined;
      case 'school_outlined':
        return Icons.school_outlined;
      case 'cake_outlined':
        return Icons.cake_outlined;
      case 'music_note_outlined':
        return Icons.music_note_outlined;
      case 'waves_outlined':
        return Icons.waves_outlined;
      case 'restaurant_outlined':
        return Icons.restaurant_outlined;
      case 'group_outlined':
        return Icons.group_outlined;
      case 'menu_book_outlined':
        return Icons.menu_book_outlined;
      case 'hiking_outlined':
        return Icons.hiking_outlined;
      case 'self_improvement_outlined':
        return Icons.self_improvement_outlined;
      case 'music_video_outlined':
        return Icons.music_video_outlined;
      case 'record_voice_over_outlined':
        return Icons.record_voice_over_outlined;
      case 'campaign_outlined':
        return Icons.campaign_outlined;
      case 'auto_stories_outlined':
        return Icons.auto_stories_outlined;
      case 'favorite_outlined':
        return Icons.favorite_outline;
      case 'healing_outlined':
        return Icons.healing_outlined;
      case 'volunteer_activism_outlined':
        return Icons.volunteer_activism_outlined;
      case 'emoji_people_outlined':
        return Icons.emoji_people_outlined;
      case 'child_friendly_outlined':
        return Icons.child_friendly_outlined;
      case 'family_restroom_outlined':
        return Icons.family_restroom_outlined;
      case 'female_outlined':
        return Icons.female_outlined;
      case 'male_outlined':
        return Icons.male_outlined;
      case 'leaderboard_outlined':
        return Icons.leaderboard_outlined;
      case 'travel_explore_outlined':
        return Icons.travel_explore_outlined;
      case 'diversity_3_outlined':
        return Icons.diversity_3_outlined;
      case 'movie_outlined':
        return Icons.movie_outlined;
      case 'theater_comedy_outlined':
        return Icons.theater_comedy_outlined;
      case 'groups_2_outlined':
        return Icons.groups_2_outlined;
      case 'piano_outlined':
        return Icons.piano_outlined;
      case 'storefront_outlined':
        return Icons.storefront_outlined;
      case 'sports_soccer_outlined':
        return Icons.sports_soccer_outlined;
      case 'emoji_events_outlined':
        return Icons.emoji_events_outlined;
      case 'local_dining_outlined':
        return Icons.local_dining_outlined;
      case 'place_outlined':
        return Icons.place_outlined;
      case 'videocam_outlined':
        return Icons.videocam_outlined;
      case 'door_open_outlined':
        return Icons.door_front_door_outlined;
      case 'how_to_reg_outlined':
        return Icons.how_to_reg_outlined;
      case 'payments_outlined':
        return Icons.payments_outlined;
      case 'local_parking_outlined':
        return Icons.local_parking_outlined;
      case 'directions_bus_outlined':
        return Icons.directions_bus_outlined;
      case 'accessible_outlined':
        return Icons.accessible_outlined;
      case 'crib_outlined':
        return Icons.crib_outlined;
      default:
        return Icons.help_outline;
    }
  }

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
                      image: widget.image != null
                          ? FileImage(widget.image!)
                          : const NetworkImage(
                              'https://via.placeholder.com/600x400',
                            ),
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
                              // _openBottomSheet(context);
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
                              // SharePlus.instance.share(
                              //   ShareParams(
                              //     title: widget.title,
                              //     subject: widget.user,
                              //     text:
                              //         'Ubicacion:${widget.address}\nReferencia:${widget.reference}\nFecha:${widget.day} ${widget.mon}\n${widget.type == 0
                              //             ? 'Presencial'
                              //             : widget.type == 1
                              //             ? 'Virtual'
                              //             : widget.type == 2
                              //             ? 'En vivo'
                              //             : 'No disponible'}',
                              //   ),
                              // );
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
                              // showModalBottomSheet<void>(
                              //   showDragHandle: true,
                              //   isScrollControlled: true,
                              //   useRootNavigator: true,
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return AnimatedPadding(
                              //       duration: const Duration(milliseconds: 200),
                              //       curve: Curves.easeOut,
                              //       padding: EdgeInsets.only(
                              //         bottom: MediaQuery.of(
                              //           context,
                              //         ).viewInsets.bottom,
                              //       ),
                              //       child: SafeArea(
                              //         top: false,
                              //         child: SingleChildScrollView(
                              //           child: Column(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.center,
                              //             mainAxisSize: MainAxisSize.min,
                              //             children: <Widget>[
                              //               TextButton(
                              //                 style: TextButton.styleFrom(
                              //                   padding: EdgeInsets.symmetric(
                              //                     horizontal: 80,
                              //                   ),
                              //                   foregroundColor: Colors.black,
                              //                 ),
                              //                 onPressed: () {},
                              //                 child: Text(
                              //                   'Editar',
                              //                   style: GoogleFonts.inter(
                              //                     fontSize: 14,
                              //                     fontWeight: FontWeight.w700,
                              //                     color: Theme.of(
                              //                       context,
                              //                     ).colorScheme.background,
                              //                   ),
                              //                 ),
                              //               ),
                              //               Padding(
                              //                 padding:
                              //                     const EdgeInsets.symmetric(
                              //                       horizontal: 32.0,
                              //                       vertical: 0,
                              //                     ),
                              //                 child: Divider(),
                              //               ),
                              //               TextButton(
                              //                 style: TextButton.styleFrom(
                              //                   padding: EdgeInsets.symmetric(
                              //                     horizontal: 80,
                              //                   ),
                              //                   foregroundColor: Colors.black,
                              //                 ),
                              //                 onPressed: () {},
                              //                 child: Text(
                              //                   'Pausar',
                              //                   style: GoogleFonts.inter(
                              //                     fontSize: 14,
                              //                     fontWeight: FontWeight.w700,
                              //                     color: Theme.of(
                              //                       context,
                              //                     ).colorScheme.background,
                              //                   ),
                              //                 ),
                              //               ),
                              //               Padding(
                              //                 padding:
                              //                     const EdgeInsets.symmetric(
                              //                       horizontal: 32.0,
                              //                       vertical: 0,
                              //                     ),
                              //                 child: Divider(),
                              //               ),
                              //               TextButton(
                              //                 style: TextButton.styleFrom(
                              //                   padding: EdgeInsets.symmetric(
                              //                     horizontal: 80,
                              //                   ),
                              //                   foregroundColor:
                              //                       Colors.redAccent[700],
                              //                 ),
                              //                 onPressed: () {},
                              //                 child: Text(
                              //                   'Eliminar',
                              //                   style: GoogleFonts.inter(
                              //                     fontSize: 14,
                              //                     fontWeight: FontWeight.w700,
                              //                     color: Colors.redAccent[700],
                              //                   ),
                              //                 ),
                              //               ),
                              //               Padding(
                              //                 padding:
                              //                     const EdgeInsets.symmetric(
                              //                       horizontal: 32.0,
                              //                       vertical: 0,
                              //                     ),
                              //                 child: Divider(),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // );
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
                                        "a partir de las ${widget.time}",
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
                                  widget.description,
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.neutralMidDark,
                                  ),
                                ),
                                SizedBox(height: 12),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Row(
                                      spacing: 6,
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
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Text(
                                            widget.type == 0
                                                ? 'Presencial'
                                                : widget.type == 1
                                                ? 'Virtual'
                                                : widget.type == 2
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
                                        ...widget.labels.map(
                                          (label) => Container(
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
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Text(
                                              label,
                                              style: GoogleFonts.inter(
                                                color: AppColors.botDark,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 12,
                                    alignment: WrapAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: [
                                      ...widget.features.map(
                                        (f) => Container(
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
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                child: Icon(
                                                  _getIconData(f['icon']!),
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                ),
                                              ),
                                              Text(
                                                textAlign: TextAlign.center,
                                                f['name']!,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.neutralMidDark,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                if (widget.address != 'false')
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
                                if (widget.address != 'false')
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
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(widget.location),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 170,
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              const Color.fromARGB(
                                                188,
                                                0,
                                                0,
                                                0,
                                              ),
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
                                              widget.address,
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

                                if (widget.organizers.isNotEmpty)
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
                                if (widget.organizers.isNotEmpty)
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: widget.organizers
                                        .map(
                                          (o) => SizedBox(
                                            width: 90,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 80,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                50,
                                                              ),
                                                          image: DecorationImage(
                                                            image:
                                                                (o['imagePath'] !=
                                                                        null &&
                                                                    (o['imagePath']
                                                                            as String)
                                                                        .isNotEmpty)
                                                                ? FileImage(
                                                                        File(
                                                                          o['imagePath']
                                                                              as String,
                                                                        ),
                                                                      )
                                                                      as ImageProvider
                                                                : NetworkImage(
                                                                    (o['imageUrl'] ??
                                                                        ''),
                                                                  ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        o['name'] ?? '',
                                                        style: GoogleFonts.inter(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        o['role'] ?? '',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .neutralMidDark,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 145),
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
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color.fromARGB(214, 0, 0, 0),
                  ],
                ),
              ),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.botLight,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      spacing: 12,
                      children: [
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              _onSubmit(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Guardar y Crear Evento',
                              style: GoogleFonts.inter(
                                color: AppColors.botDark,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Retroceder',
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
