import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/ui/widgets/app_bar.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class EditChurchProfileScreen extends StatefulWidget {
  const EditChurchProfileScreen({super.key});

  @override
  State<EditChurchProfileScreen> createState() => _EditChurchProfileScreenState();
}

class _EditChurchProfileScreenState extends State<EditChurchProfileScreen> {
  File? _paymentProof;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _locationController = TextEditingController(text: 'Av. Bolivar, CC El Dorado - local 10, Santa Barbara - Zulia');
  final TextEditingController _nameController = TextEditingController(text: 'Obra Cristiana Puerta al Cielo');
  final TextEditingController _descriptionController = TextEditingController(text: 'Comunidad de fe que promueve el encuentro con Dios a travez de la busqueda de la verdad bíblica y su aplicacion en nuestras vidas. Fundada en 2001.');
  final TextEditingController _religionController = TextEditingController(text: 'Cristiana');

  // Controllers and data for organizer search in the bottom sheet
  final TextEditingController _organizerSearchController = TextEditingController();
  final TextEditingController _organizerRoleController = TextEditingController();
  final FocusNode _organizerFocusNode = FocusNode();

  // Simple mock people list (replace with your real data source)
  final List<Map<String, String>> _people = [
    {
      'name': 'Joaquin',
      'role': 'Pastor',
      'imageUrl': 'https://coworkingfy.com/wp-content/uploads/2024/08/que-es-un-perfil-profesional-2.jpg',
    },
    {
      'name': 'María Rodríguez',
      'role': 'Líder de Alabanza',
      'imageUrl': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'name': 'Carlos Pérez',
      'role': 'Diácono',
      'imageUrl': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
  ];

  List<Map<String, String>> _filteredPeople = [];
  Map<String, String>? _selectedPerson;

  List<Map<String, String>> _computeFilteredPeople(String query) {
    final q = query.toLowerCase();
    final addedNames = organizers.map((o) => o.name.toLowerCase()).toSet();
    return _people.where((p) {
      final name = p['name']!.toLowerCase();
      final matches = q.isEmpty ? true : name.contains(q);
      final notAdded = !addedNames.contains(name);
      return matches && notAdded;
    }).toList();
  }

  List<_Organizer> organizers = [
    _Organizer(
      name: 'María Rodríguez',
      role: 'Líder de Alabanza',
      imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    ),
    _Organizer(
      name: 'Carlos Pérez',
      role: 'Diácono',
      imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    ),
  ];

  void _addOrganizerFromSelection({
    required String name,
    required String role,
    required String imageUrl,
  }) {
    if (organizers.any((o) => o.name == name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ya es parte del equipo',
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

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChange);
    _descriptionController.addListener(_onFormChange);
  // initialize filtered people excluding already added organizers
  _filteredPeople = _computeFilteredPeople('');
    _organizerFocusNode.addListener(() {
      setState(() {});
    });
  }

  void _onFormChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChange);
    _descriptionController.removeListener(_onFormChange);
    _organizerSearchController.dispose();
    _organizerRoleController.dispose();
    _organizerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: "Editar Perfil de Iglesia",
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
            // form nombre
            Text(
              'Nombre de la Institución',
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
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Escribe el Nombre de la Institución",
                  hintStyle: TextStyle(color: AppColors.neutralMidDark),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // form descripcion
            Text(
              'Descripción',
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
                controller: _descriptionController,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: "Describe a la Institución",
                  hintStyle: TextStyle(color: AppColors.neutralMidDark),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // form imagen
            Text(
              'Foto de Perfil',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
                color: Theme.of(context).colorScheme.background,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: EdgeInsets.all(24),
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
                  image: _paymentProof != null
                      ? DecorationImage(
                          image: FileImage(_paymentProof!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        )
                      : DecorationImage(
                          image: NetworkImage('https://thumbs.dreamstime.com/b/una-biblia-abierta-con-el-cielo-y-fondo-de-las-puertas-peras-libro-biblias-celestial-perilla-333311086.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: _paymentProof != null
                            ? Colors.white
                            : AppColors.primaryLight,
                        size: 32,
                      ),
                      onPressed: () async {
                        final XFile? picked = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picked != null) {
                          setState(() {
                            _paymentProof = File(picked.path);
                          });
                        }
                      },
                    ),
                    Text(
                      'Adjuntar',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Religion',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: AppColors.neutralMidDark,
                  ),
                  textAlign: TextAlign.left,
                ),
                Icon(Icons.contact_support, size: 18,color: Theme.of(context).colorScheme.secondary,)
              ],
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
                controller: _religionController,
                decoration: InputDecoration(
                  enabled: false,
                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                  suffixIconColor: AppColors.neutralMidDark,
                  hintText: "Selecciona una Religion",
                  hintStyle: TextStyle(color: AppColors.neutralMidDark),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Ubicación',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: AppColors.neutralMidDark,
                  ),
                  textAlign: TextAlign.left,
                ),
                Icon(Icons.contact_support, size: 18,color: Theme.of(context).colorScheme.secondary,)
              ],
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
                controller: _locationController,
                decoration: InputDecoration(
                  enabled: false,
                  hintText: "Escribe una Ubicacion",
                  hintStyle: TextStyle(color: AppColors.neutralMidDark),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Nuestro Equipo',
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
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Buscar persona',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Inter',
                                              color: Theme.of(context).colorScheme.background,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 12),

                                          // Search
                                          Container(
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
                                              focusNode: _organizerFocusNode,
                                              controller: _organizerSearchController,
                                              onTap: () {
                                                // when focused, show suggestions (exclude already added)
                                                setState(() {
                                                  final q = _organizerSearchController.text;
                                                  _filteredPeople = _computeFilteredPeople(q);
                                                });
                                              },
                                              onChanged: (val) {
                                                setState(() {
                                                  _selectedPerson = null;
                          final q = val;
                          _filteredPeople = _computeFilteredPeople(q);
                                                });
                                              },
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context).colorScheme.onSurface,
                                              ),
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    Icons.search_outlined,
                                                    color: AppColors.neutralMidLight,
                                                  ),
                                                  onPressed: () {
                                                    // force filter
                                                    setState(() {
                                                        final q = _organizerSearchController.text;
                                                        _filteredPeople = _computeFilteredPeople(q);
                                                    });
                                                  },
                                                ),
                                                hintText: "Nombre",
                                                hintStyle: TextStyle(
                                                  color: AppColors.neutralMidLight,
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

                                          const SizedBox(height: 8),

                                          // Suggestions (show only when focused or typing) as a compact selectable dropdown
                                          if (_filteredPeople.isNotEmpty &&
                                              (_organizerSearchController.text.isNotEmpty || _organizerFocusNode.hasFocus))
                                            Container(
                                              margin: const EdgeInsets.only(top: 8),
                                              constraints: const BoxConstraints(maxHeight: 160),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.surface,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Theme.of(context).colorScheme.outline),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context).colorScheme.shadow,
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ListView.separated(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: _filteredPeople.length,
                                                separatorBuilder: (_, __) => const Divider(height: 1),
                                                itemBuilder: (ctx, i) {
                                                  final p = _filteredPeople[i];
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        _selectedPerson = p;
                                                        _organizerSearchController.text = p['name']!;
                                                        _filteredPeople = [];
                                                      });
                                                      FocusScope.of(context).unfocus();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                      child: Row(
                                                        children: [
                                                          if (p['imageUrl'] != null)
                                                            CircleAvatar(radius: 18, backgroundImage: NetworkImage(p['imageUrl']!))
                                                          else
                                                            const CircleAvatar(radius: 18, child: Icon(Icons.person)),
                                                          const SizedBox(width: 12),
                                                          Expanded(child: Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.w500))),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                          const SizedBox(height: 12),
                                          Text(
                                            'La persona que va a agregar, debe estar congregado en tu iglesia',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Inter',
                                              color: AppColors.neutralMidDark,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Rol de la persona',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Inter',
                                              color: Theme.of(context).colorScheme.background,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 12),
                                          // Role input
                                          Container(
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
                                              controller: _organizerRoleController,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context).colorScheme.onSurface,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "Ministro...",
                                                hintStyle: TextStyle(
                                                  color: AppColors.neutralMidLight,
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
                                          const SizedBox(height: 12),
                                          Text(
                                            'Escribe el rol que desempeña esta persona en la congregación',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Inter',
                                              color: AppColors.neutralMidDark,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Row(
                                              spacing: 12,
                                              children:[
                                                Expanded(
                                                  child: FloatingActionButton(
                                                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                                                    foregroundColor: Theme.of(context).colorScheme.background,
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('Cancelar'),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: FloatingActionButton(
                                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                                    onPressed: () {
                                                      // Require that the user selects a person from suggestions
                                                      if (_selectedPerson == null) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('Por favor selecciona una persona de la lista')),
                                                        );
                                                        return;
                                                      }

                                                      final name = _selectedPerson!['name']!.trim();
                                                      final role = _organizerRoleController.text.trim().isNotEmpty
                                                          ? _organizerRoleController.text.trim()
                                                          : (_selectedPerson!['role'] ?? 'Miembro');
                                                      final imageUrl = _selectedPerson!['imageUrl'] ?? '';

                                                      _addOrganizerFromSelection(
                                                        name: name,
                                                        role: role,
                                                        imageUrl: imageUrl,
                                                      );

                                                      // Reset search form so next open starts clean
                                                      setState(() {
                                                        _organizerSearchController.clear();
                                                        _organizerRoleController.clear();
                                                        _selectedPerson = null;
                                                        _filteredPeople = _computeFilteredPeople('');
                                                      });

                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('Guardar'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Guardar Cambios",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.botDark,
                  ),
                ),
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
