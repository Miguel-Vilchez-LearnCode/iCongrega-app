import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/ui/screens/events/register_preview_step.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:icongrega/theme/app_colors.dart';

class RegisterThreeStep extends StatefulWidget {
  const RegisterThreeStep({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.type,
    required this.location,
    required this.day,
    required this.mon,
    required this.time,
    required this.address,
    required this.reference,
  });

  final String title;
  final String description;
  final File? image;
  final int type;
  final int location;
  final int day;
  final String mon;
  final String time;
  final String address;
  final String reference;

  @override
  State<RegisterThreeStep> createState() => _RegisterThreeStepState();
}

class _RegisterThreeStepState extends State<RegisterThreeStep> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _featureController = TextEditingController();
  final TextEditingController _organizerNameController =
      TextEditingController();
  final TextEditingController _organizerRoleController =
      TextEditingController();

  // Datos dinámicos
  List<String> labels = [];
  List<_Features> features = [];
  List<_Organizer> organizers = [];

  // Lista de opciones predefinidas
  final List<Map<String, String>> opcionesPredefinidas = [
    // Generales
    {"name": "Servicio de Adoración", "icon": "church_outlined"},
    {"name": "Culto Especial", "icon": "event_outlined"},
    {"name": "Vigilia", "icon": "nights_stay_outlined"},
    {"name": "Campaña Evangelística", "icon": "public_outlined"},
    {"name": "Retiro Espiritual", "icon": "terrain_outlined"},
    {"name": "Conferencia o Congreso", "icon": "mic_outlined"},
    {"name": "Taller o Seminario", "icon": "school_outlined"},
    {"name": "Aniversario de Iglesia", "icon": "cake_outlined"},
    {"name": "Concierto Cristiano", "icon": "music_note_outlined"},
    {"name": "Bautizos", "icon": "waves_outlined"},
    {"name": "Santa Cena", "icon": "restaurant_outlined"},
    {"name": "Servicio Juvenil", "icon": "group_outlined"},
    {"name": "Escuela Dominical", "icon": "menu_book_outlined"},
    {"name": "Campamento", "icon": "hiking_outlined"},

    // Espirituales
    {"name": "Oración", "icon": "self_improvement_outlined"},
    {"name": "Alabanza y Adoración", "icon": "music_video_outlined"},
    {"name": "Testimonios", "icon": "record_voice_over_outlined"},
    {"name": "Predicación", "icon": "campaign_outlined"},
    {"name": "Lectura Bíblica", "icon": "auto_stories_outlined"},
    {"name": "Intercesión", "icon": "favorite_outlined"},
    {"name": "Sanidad y Milagros", "icon": "healing_outlined"},
    {"name": "Ministración", "icon": "volunteer_activism_outlined"},

    // Enfoque del evento
    {"name": "Evento para Jóvenes", "icon": "emoji_people_outlined"},
    {"name": "Evento para Niños", "icon": "child_friendly_outlined"},
    {"name": "Evento Familiar", "icon": "family_restroom_outlined"},
    {"name": "Evento de Mujeres", "icon": "female_outlined"},
    {"name": "Evento de Hombres", "icon": "male_outlined"},
    {"name": "Evento de Liderazgo", "icon": "leaderboard_outlined"},
    {"name": "Evento Misionero", "icon": "travel_explore_outlined"},
    {"name": "Evento Comunitario", "icon": "diversity_3_outlined"},

    // Actividades complementarias
    {"name": "Proyección de Películas", "icon": "movie_outlined"},
    {"name": "Teatro Cristiano", "icon": "theater_comedy_outlined"},
    {"name": "Danza o Coreografía", "icon": "groups_2_outlined"},
    {"name": "Taller de Música", "icon": "piano_outlined"},
    {"name": "Exposición o Feria", "icon": "storefront_outlined"},
    {"name": "Actividades Deportivas", "icon": "sports_soccer_outlined"},
    {"name": "Concurso Bíblico", "icon": "emoji_events_outlined"},
    {"name": "Comida o Refrigerio", "icon": "local_dining_outlined"},

    // Logísticos
    {"name": "Evento Presencial", "icon": "place_outlined"},
    {"name": "Evento en Línea", "icon": "videocam_outlined"},
    {"name": "Entrada Libre", "icon": "door_open_outlined"},
    {"name": "Requiere Registro", "icon": "how_to_reg_outlined"},
    {"name": "Entrada con Costo", "icon": "payments_outlined"},
    {"name": "Estacionamiento Disponible", "icon": "local_parking_outlined"},
    {"name": "Transporte Disponible", "icon": "directions_bus_outlined"},
    {"name": "Accesible para Discapacitados", "icon": "accessible_outlined"},
    {"name": "Guardería Disponible", "icon": "crib_outlined"},
  ];

  void _addEtiqueta(String value) {
    if (value.trim().isEmpty) return;
    setState(() {
      labels.add(value.trim());
    });
    _tagController.clear();
  }

  void _addCaracteristicaFromSelection({
    required String name,
    required String icon,
  }) {
    if (features.any((o) => o.name == name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Característica ya agregada',
            style: TextStyle(color: AppColors.botLight),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    } else if (features.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Solo puedes agregar 3 características como máximo',
            style: TextStyle(color: AppColors.botLight),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    } else {
      setState(() {
        features.add(_Features(name: name, icon: icon));
      });
    }
  }

  void _addOrganizerFromSelection({
    required String name,
    required String role,
    required String imageUrl,
  }) {
    if (organizers.any((o) => o.name == name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Organizador ya agregado',
            style: TextStyle(color: AppColors.botLight),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    } else {
      setState(() {
        organizers.add(_Organizer(name: name, role: role, imageUrl: imageUrl));
      });
    }
  }

  bool get _isFormValid {
    return features.isNotEmpty && organizers.isNotEmpty;
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
  void dispose() {
    _tagController.dispose();
    _featureController.dispose();
    _organizerNameController.dispose();
    _organizerRoleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "3 de 3",
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
              'Datos Extras',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),

            // form etiquetas
            Text(
              'Etiquetas',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),
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
              child: TextField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: "Escribe una etiqueta",
                  hintStyle: TextStyle(color: AppColors.neutralMidLight),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) {
                  _addEtiqueta(value);
                },
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: labels
                  .map(
                    (e) => Chip(
                      label: Text(
                        e,
                        style: TextStyle(color: AppColors.botDark),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          labels.remove(e);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 16),

            // form caracteristicas
            Text(
              'Características del Evento',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 2,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Container(
                  width: 70,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: AppColors.primaryLight,
                          size: 32,
                        ),
                        onPressed: () {
                          if (features.length >= 3) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Solo puedes agregar 3 características como máximo',
                                  style: TextStyle(color: AppColors.botLight),
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                              ),
                            );
                            return;
                          } else {
                            showModalBottomSheet<void>(
                              showDragHandle: true,
                              isScrollControlled: true,
                              useRootNavigator: true,
                              context: context,
                              builder: (BuildContext context) {
                                String searchQuery = '';
                                return StatefulBuilder(
                                  builder: (context, setModalState) {
                                    final filtered = opcionesPredefinidas
                                        .where(
                                          (e) =>
                                              e['name']!.toLowerCase().contains(
                                                searchQuery.toLowerCase(),
                                              ),
                                        )
                                        .toList();
                                    return FractionallySizedBox(
                                      heightFactor: 0.85,
                                      child: AnimatedPadding(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
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
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Text(
                                                'Selecciona una Característica',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Inter',
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.background,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 12),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                decoration: BoxDecoration(
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
                                                    suffixIcon: Icon(
                                                      Icons.search_outlined,
                                                      color: AppColors
                                                          .neutralMidLight,
                                                    ),
                                                    hintText: 'Buscar',
                                                    hintStyle: TextStyle(
                                                      color: AppColors
                                                          .neutralMidLight,
                                                    ),
                                                    filled: true,
                                                    fillColor: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainer,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    setModalState(() {
                                                      searchQuery = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Expanded(
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Wrap(
                                                          spacing: 2,
                                                          runSpacing: 12,
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          children: filtered
                                                              .map(
                                                                (
                                                                  item,
                                                                ) => GestureDetector(
                                                                  onTap: () {
                                                                    _addCaracteristicaFromSelection(
                                                                      icon:
                                                                          item['icon']!,
                                                                      name:
                                                                          item['name']!,
                                                                    );
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop();
                                                                  },
                                                                  child: SizedBox(
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
                                                                          padding: EdgeInsets.all(
                                                                            12,
                                                                          ),
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
                                                                            borderRadius: BorderRadius.circular(
                                                                              24,
                                                                            ),
                                                                          ),
                                                                          child: Icon(
                                                                            _getIconData(
                                                                              item['icon']!,
                                                                            ),
                                                                            color: Theme.of(
                                                                              context,
                                                                            ).colorScheme.primary,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          item['name']!,
                                                                          style: GoogleFonts.inter(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                AppColors.neutralMidDark,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                      Text(
                        'Agregar',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                ...features.map(
                  (o) => SizedBox(
                    width: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.shadow,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                _getIconData(o.icon),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Positioned(
                              right: -12,
                              top: -12,
                              child: IconButton(
                                icon: Icon(Icons.close, size: 12),
                                style: IconButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.surface,
                                  padding: const EdgeInsets.all(0),
                                  minimumSize: const Size(16, 16),
                                ),
                                onPressed: () {
                                  setState(() {
                                    features.remove(o);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          textAlign: TextAlign.center,
                          o.name,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.neutralMidDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // form Encargados
            Text(
              'Encargados del Evento',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                Container(
                  width: 80,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: AppColors.primaryLight,
                          size: 32,
                        ),
                        onPressed: () {
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
                                      MediaQuery.of(context).viewInsets.bottom +
                                      36,
                                ),
                                child: SafeArea(
                                  top: false,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Selecciona un Organizador',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Inter',
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.background,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 12),
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                                  color:
                                                      AppColors.neutralMidLight,
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
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Wrap(
                                            direction: Axis.horizontal,
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            children: [
                                              // widgets seleccion de organizadores
                                              GestureDetector(
                                                onTap: () {
                                                  _addOrganizerFromSelection(
                                                    name: 'Joaquin',
                                                    role: 'Pastor',
                                                    imageUrl:
                                                        'https://coworkingfy.com/wp-content/uploads/2024/08/que-es-un-perfil-profesional-2.jpg',
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
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
                                                        width: double.infinity,
                                                        height: 80,
                                                        padding: EdgeInsets.all(
                                                          12,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                              "https://coworkingfy.com/wp-content/uploads/2024/08/que-es-un-perfil-profesional-2.jpg",
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                50,
                                                              ),
                                                        ),
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'Joaquin',
                                                        style: GoogleFonts.inter(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                        ),
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'Pastor',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .neutralMidDark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _addOrganizerFromSelection(
                                                    name: 'Monica',
                                                    role: 'Lider de Jovenes',
                                                    imageUrl:
                                                        'https://www.seoptimer.com/storage/images/2014/08/selfie.jpg',
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
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
                                                        width: double.infinity,
                                                        height: 80,
                                                        padding: EdgeInsets.all(
                                                          12,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                              "https://www.seoptimer.com/storage/images/2014/08/selfie.jpg",
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                50,
                                                              ),
                                                        ),
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'Monica',
                                                        style: GoogleFonts.inter(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                        ),
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'Lider de Jovenes',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .neutralMidDark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _addOrganizerFromSelection(
                                                    name: 'Guillermo',
                                                    role:
                                                        'Coordinador de ujieres',
                                                    imageUrl:
                                                        'https://img.freepik.com/fotos-premium/selfie-facial-sonrisa-hombre-negocios-persona-que-toma-foto-memoria-feliz-carrera-redes-sociales-foto-perfil-retrato-empresario-profesional-o-asiatico-singapur-cargo_590464-183436.jpg',
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
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
                                                        width: double.infinity,
                                                        height: 80,
                                                        padding: EdgeInsets.all(
                                                          12,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            image: NetworkImage(
                                                              "https://img.freepik.com/fotos-premium/selfie-facial-sonrisa-hombre-negocios-persona-que-toma-foto-memoria-feliz-carrera-redes-sociales-foto-perfil-retrato-empresario-profesional-o-asiatico-singapur-cargo_590464-183436.jpg",
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                50,
                                                              ),
                                                        ),
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'Guillermo',
                                                        style: GoogleFonts.inter(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                        ),
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'Coordinador de ujieres',
                                                        style: GoogleFonts.inter(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .neutralMidDark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Text(
                        'Agregar',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                ...organizers.map(
                  (o) => SizedBox(
                    width: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image:
                                    o.imageUrl != null && o.imageUrl!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(o.imageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                            Positioned(
                              right: -12,
                              top: -12,
                              child: IconButton(
                                icon: Icon(Icons.close, size: 12),
                                style: IconButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.surface,
                                  padding: const EdgeInsets.all(0),
                                  minimumSize: const Size(16, 16),
                                ),
                                onPressed: () {
                                  setState(() {
                                    organizers.remove(o);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          o.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                        Text(
                          o.role,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.neutralMidDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),
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
              child: Row(
                mainAxisSize: MainAxisSize.max,
                spacing: 12,
                children: [
                  Expanded(
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
                        "Retroceder",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isFormValid
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RegisterPreviewStep(
                                    title: widget.title,
                                    description: widget.description,
                                    image: widget.image,
                                    type: widget.type,
                                    // location: widget.location,
                                    day: widget.day.toString(),
                                    mon: widget.mon,
                                    time: widget.time,
                                    address: widget.address,
                                    reference: widget.reference,
                                    labels: labels,
                                    features: features
                                        .map(
                                          (e) => {
                                            'name': e.name,
                                            'icon': e.icon,
                                          },
                                        )
                                        .toList(),
                                    organizers: organizers
                                        .map(
                                          (e) => {
                                            'name': e.name,
                                            'role': e.role,
                                            'imageUrl': e.imageUrl ?? '',
                                          },
                                        )
                                        .toList(),
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainer,
                        foregroundColor: _isFormValid
                            ? Colors.black87
                            : AppColors.neutralMidLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Previsualizar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Organizer {
  final String name;
  final String role;
  final String? imageUrl;

  _Organizer({required this.name, required this.role, this.imageUrl});
}

class _Features {
  final String name;
  final String icon;

  _Features({required this.name, required this.icon});
}
