import 'dart:io';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/widgets/donation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/domain/models/post_item.dart' as model;
import 'package:icongrega/ui/screens/feed/detail_pager_screen.dart';
import 'package:icongrega/ui/screens/feed/story_create_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:icongrega/ui/screens/feed/image_selected_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isLoadingPage = false;

  final TextEditingController _controller = TextEditingController();
  bool isNotEmptyField = false;
  final ImagePicker _picker = ImagePicker();
  late final List<model.PostItem> _posts;
  Color? _selectedColor = AppColors.primaryLight;

  @override
  void initState() {
    super.initState();
    _posts = _createPosts();
  }

  void _onColorTap(Color color) {
    setState(() {
      // Si el mismo color está activo, lo desactiva
      if (_selectedColor == color) {
        _selectedColor = color;
      } else {
        _selectedColor = color;
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    Navigator.of(
      context,
      rootNavigator: true,
    ).pop(); // cerrar bottomSheet de selección

    if (pickedFile != null) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => ImageSelectedScreen(imageFile: File(pickedFile.path)),
        ),
      );
    }
  }

  Future<void> _pickStoryImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    Navigator.of(
      context,
      rootNavigator: true,
    ).pop(); // cerrar bottomSheet de selección

    if (pickedFile != null) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => StoryCreateScreen(imageFile: File(pickedFile.path)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Historias
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 8),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // crear historia
                    _storyItem(
                      icon: Icons.add_circle_outline,
                      label: "Historia",
                      isAdd: true,
                      isView: true,
                    ),
                    SizedBox(
                      width: 10,
                      height: 50,
                      child: VerticalDivider(color: AppColors.neutralMidDark),
                    ),
                    _storyItem(
                      label: "M.M.M.",
                      imageUrl:
                          "https://i0.wp.com/mmmny.org/wp-content/uploads/2016/12/ministerios.png?resize=450%2C284&ssl=1",
                      isView: true,
                    ),
                    _storyItem(
                      label: "Luz_Mundo",
                      imageUrl:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6eL5RUT4tdMCYufPglpc8GU6qSbbIF8WbPA&s",
                      isView: true,
                    ),
                    _storyItem(
                      label: "otro",
                      imageUrl:
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTr5wHf2UcIpbr2g7wMwsiECall5ALgGjgSeg&s",
                    ),
                    _storyItem(
                      label: "Otro mas",
                      imageUrl:
                          "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/campa%C3%B1a-evangelista-el-salvador-design-template-bafd085c444276fa098c8f26fa9dddaa_screen.jpg?ts=1637040139",
                    ),
                  ],
                ),
              ),

              // Caja para publicar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Skeletonizer(
                  enabled: _isLoadingPage,
                  child: Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // text field para publicar...
                      Expanded(
                        child: Container(
                          width: 270,
                          height: 45,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: BoxBorder.all(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            controller: _controller,
                            onChanged: (String value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  isNotEmptyField = true;
                                });
                              } else {
                                setState(() {
                                  isNotEmptyField = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Escribe algo a tu comunidad...",
                              hintStyle: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.neutralMidDark,
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          child: Icon(
                            isNotEmptyField
                                ? Icons.send_rounded
                                : Icons.add_to_photos_outlined,
                            color: Colors.black,
                          ),
                          onTap: () {
                            // bottomSheet
                            if (!isNotEmptyField) {
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
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            bottom: 24.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () => _pickImage(
                                                        ImageSource.gallery,
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .add_photo_alternate_outlined,
                                                        size: 30,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Galería",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                                height: 60,
                                                child: VerticalDivider(
                                                  color: Colors.amber,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () => _pickImage(
                                                        ImageSource.camera,
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        size: 30,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Tomar Foto",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (isNotEmptyField)
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 70),
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Row(
                        spacing: 12,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // text field para publicar...
                          Expanded(
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                _colors(
                                  color: AppColors.primaryLight,
                                  active:
                                      _selectedColor == AppColors.primaryLight,
                                  context: context,
                                  onTap: () =>
                                      _onColorTap(AppColors.primaryLight),
                                ),
                                _colors(
                                  color: AppColors.dangerLight,
                                  active:
                                      _selectedColor == AppColors.dangerLight,
                                  context: context,
                                  onTap: () =>
                                      _onColorTap(AppColors.dangerLight),
                                ),
                                _colors(
                                  color: AppColors.infoLight,
                                  active: _selectedColor == AppColors.infoLight,
                                  context: context,
                                  onTap: () => _onColorTap(AppColors.infoLight),
                                ),
                                _colors(
                                  color: AppColors.neutralMidDark,
                                  active:
                                      _selectedColor ==
                                      AppColors.neutralMidDark,
                                  context: context,
                                  onTap: () =>
                                      _onColorTap(AppColors.neutralMidDark),
                                ),
                                _colors(
                                  color: AppColors.successLight,
                                  active:
                                      _selectedColor == AppColors.successLight,
                                  context: context,
                                  onTap: () =>
                                      _onColorTap(AppColors.successLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 12),

              // post
              _postItem(
                context: context,
                itemIndex: 0,
                postType: model.PostType.image,
                user: "Movimiento Misionero Mundial",
                role: "Francisco Colmenarez • Párroco",
                description:
                    "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
                imageUser:
                    "https://mmmoficial.org/mo_includes/img/publicacion/mmmoficial-oficial_mmmoficial_2019-11-11-13-09-51_1349.png",
                imageChurch:
                    "https://i0.wp.com/mmmny.org/wp-content/uploads/2016/12/ministerios.png?resize=450%2C284&ssl=1",
                fecha: "02/03/2025 - 05:16 PM",
                imageUrl:
                    "https://cdn.pixabay.com/photo/2017/03/27/15/16/man-2179326_960_720.jpg",
                likesText: "23",
                commentsText: "133",
              ),

              _postItem(
                context: context,
                itemIndex: 1,
                postType: model.PostType.video,
                user: "Movimiento Misionero Mundial",
                role: "Francisco Colmenarez • Párroco",
                description:
                    "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
                imageUser:
                    "https://mmmoficial.org/mo_includes/img/publicacion/mmmoficial-oficial_mmmoficial_2019-11-11-13-09-51_1349.png",
                imageChurch:
                    "https://i0.wp.com/mmmny.org/wp-content/uploads/2016/12/ministerios.png?resize=450%2C284&ssl=1",
                fecha: "02/03/2025 - 05:16 PM",
                videoUrl:
                    "https://media.gettyimages.com/id/1390880690/es/v%C3%ADdeo/templo-asi%C3%A1tico-de-fantas%C3%ADa-con-luces-misteriosas.mp4?s=mp4-640x640-gi&k=20&c=9WXy2qLxD5esCd23j9uwZi7EVW16b4cX8NX6lsfO2iw=",
                likesText: "321",
                commentsText: "123",
              ),

              _postItem(
                context: context,
                itemIndex: 2,
                postType: model.PostType.verse,
                user: "Obra cristiana Luz del Mundo ",
                role: "Jaime Puerta • Fundador",
                description:
                    "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
                imageUser:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6eL5RUT4tdMCYufPglpc8GU6qSbbIF8WbPA&s",
                imageChurch:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdjDP-mUKtG5VC4bBrVvnfEGdcdoN1nxkwoA&s",
                fecha: "02/03/2025 - 05:16 PM",
                verse:
                    '"Todo lo puedo en Cristo que me fortalece". (Filipenses 4:13)',
                backgroundColor: AppColors.primaryLight,
                likesText: "245",
                commentsText: "67",
              ),

              _postItem(
                context: context,
                itemIndex: 3,
                postType: model.PostType.video,
                user: "Centro Cristiano Renuevo",
                role: "Francisco Colmenares • Párroco",
                description:
                    "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
                imageUser:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg7ddYVuvul35k6x8wtmWmX7jSFwK3JkBHWQ&s",
                imageChurch:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnnyfo_Rw8WsxYjoo9kYqteJKPorGMFiyrpw&s",
                fecha: "02/03/2025 - 05:16 PM",
                videoUrl:
                    "https://media.gettyimages.com/id/1695607749/es/v%C3%ADdeo/toma-de-la-mano-apoyo-y-un-grupo-orando-juntos-por-consejer%C3%ADa-religi%C3%B3n-y-sanaci%C3%B3n-espiritual.mp4?s=mp4-640x640-gi&k=20&c=qEy_W1RN1KR-8MlCkyyck78qnxSRUbKnRzKFRMPKwrE=",
                likesText: "342",
                commentsText: "432",
              ),

              _postItem(
                context: context,
                itemIndex: 4,
                postType: model.PostType.image,
                user: "Centro Cristiano Renuevo",
                role: "Francisco Colmenares • Párroco",
                description:
                    "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
                imageUser:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg7ddYVuvul35k6x8wtmWmX7jSFwK3JkBHWQ&s",
                imageChurch:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnnyfo_Rw8WsxYjoo9kYqteJKPorGMFiyrpw&s",
                fecha: "02/03/2025 - 05:16 PM",
                imageUrl:
                    "https://cdn.pixabay.com/photo/2019/05/12/20/03/concert-4198983_640.jpg",
                likesText: "342",
                commentsText: "432",
              ),

              _postItem(
                context: context,
                itemIndex: 5,
                postType: model.PostType.video,
                user: "Iglesia Cristiana Renacer",
                role: "Pastor Miguel • Líder Juvenil",
                description:
                    "¡No te pierdas nuestro próximo evento! Únete a nosotros para una noche especial de adoración y reflexión. Trae tu Biblia y un corazón abierto.",
                imageUser:
                    "https://f.i.uol.com.br/fotografia/2025/05/06/1746544177681a263120fbe_1746544177_3x2_md.jpg",
                imageChurch:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLEYep3iyaWywX6hIkZBqxRl5h9wWu8_MhhQ&s",
                fecha: "03/03/2025 - 10:30 AM",
                videoUrl:
                    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
                likesText: "245",
                commentsText: "67",
              ),

              _postItem(
                context: context,
                itemIndex: 6,
                postType: model.PostType.video,
                user: "Iglesia Cristiana Fuente de Salvacion",
                role: "Mauricio Alfonso • Líder de Caballeros",
                description:
                    "¡No te pierdas nuestro próximo evento! Únete a nosotros para una noche especial de adoración y reflexión. Trae tu Biblia y un corazón abierto.",
                imageUser:
                    "https://f.i.uol.com.br/fotografia/2025/05/06/1746544177681a263120fbe_1746544177_3x2_md.jpg",
                imageChurch:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLEYep3iyaWywX6hIkZBqxRl5h9wWu8_MhhQ&s",
                fecha: "03/03/2025 - 10:30 AM",
                videoUrl:
                    "https://media.gettyimages.com/id/2238478148/es/v%C3%ADdeo/aerial-view-of-holy-redeemer-church-in-bray-town-center-at-sunset-historic-catholic-church.mp4?s=mp4-640x640-gi&k=20&c=ACB_pk7pqSPkYFzw2vsdeVJvheAOosM89Dyx4dAwigA=",
                likesText: "321",
                commentsText: "123",
              ),

              _postItem(
                context: context,
                itemIndex: 7,
                postType: model.PostType.verse,
                user: "Obra cristiana Luz del Mundo ",
                role: "Jaime Puerta • Fundador",
                description:
                    "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
                imageUser:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6eL5RUT4tdMCYufPglpc8GU6qSbbIF8WbPA&s",
                imageChurch:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdjDP-mUKtG5VC4bBrVvnfEGdcdoN1nxkwoA&s",
                fecha: "02/03/2025 - 05:16 PM",
                verse:
                    '"En el principio creo Dios los cielos y la tierra". (Genesis 1:1)',
                backgroundColor: AppColors.infoLight,
                likesText: "245",
                commentsText: "67",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Lista de posts para el feed y el pager tipo Reels
  List<model.PostItem> _createPosts() {
    return [
      model.PostItem(
        type: model.PostType.image,
        user: "Movimiento Misionero Mundial",
        role: "Francisco Colmenarez • Párroco",
        description:
            "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
        imageUser:
            "https://mmmoficial.org/mo_includes/img/publicacion/mmmoficial-oficial_mmmoficial_2019-11-11-13-09-51_1349.png",
        imageChurch:
            "https://i0.wp.com/mmmny.org/wp-content/uploads/2016/12/ministerios.png?resize=450%2C284&ssl=1",
        fecha: "02/03/2025 - 05:16 PM",
        imageUrl:
            "https://cdn.pixabay.com/photo/2017/03/27/15/16/man-2179326_960_720.jpg",
        likesText: "23",
        commentsText: "133",
        isLiked: false,
      ),
      model.PostItem(
        type: model.PostType.video,
        user: "Movimiento Misionero Mundial",
        role: "Francisco Colmenarez • Párroco",
        description:
            "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntosesta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
        imageUser:
            "https://mmmoficial.org/mo_includes/img/publicacion/mmmoficial-oficial_mmmoficial_2019-11-11-13-09-51_1349.png",
        imageChurch:
            "https://i0.wp.com/mmmny.org/wp-content/uploads/2016/12/ministerios.png?resize=450%2C284&ssl=1",
        fecha: "02/03/2025 - 05:16 PM",
        videoUrl:
            "https://media.gettyimages.com/id/1390880690/es/v%C3%ADdeo/templo-asi%C3%A1tico-de-fantas%C3%ADa-con-luces-misteriosas.mp4?s=mp4-640x640-gi&k=20&c=9WXy2qLxD5esCd23j9uwZi7EVW16b4cX8NX6lsfO2iw=",
        likesText: "321",
        commentsText: "123",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.verse,
        user: "Obra cristiana Luz del Mundo ",
        role: "Jaime Puerta • Fundador",
        description: "este es un Post de verso, con descripcion corta..!!",
        imageUser:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6eL5RUT4tdMCYufPglpc8GU6qSbbIF8WbPA&s",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdjDP-mUKtG5VC4bBrVvnfEGdcdoN1nxkwoA&s",
        fecha: "02/03/2025 - 05:16 PM",
        verse: '"Todo lo puedo en Cristo que me fortalece". (Filipenses 4:13)',
        backgroundColor: AppColors.primaryLight,
        likesText: "245",
        commentsText: "67",
        isLiked: false,
      ),
      model.PostItem(
        type: model.PostType.video,
        user: "Centro Cristiano Renuevo",
        role: "Francisco Colmenares • Párroco",
        description:
            "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
        imageUser:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg7ddYVuvul35k6x8wtmWmX7jSFwK3JkBHWQ&s",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnnyfo_Rw8WsxYjoo9kYqteJKPorGMFiyrpw&s",
        fecha: "02/03/2025 - 05:16 PM",
        videoUrl:
            "https://media.gettyimages.com/id/1695607749/es/v%C3%ADdeo/toma-de-la-mano-apoyo-y-un-grupo-orando-juntos-por-consejer%C3%ADa-religi%C3%B3n-y-sanaci%C3%B3n-espiritual.mp4?s=mp4-640x640-gi&k=20&c=qEy_W1RN1KR-8MlCkyyck78qnxSRUbKnRzKFRMPKwrE=",
        likesText: "342",
        commentsText: "432",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.image,
        user: "Centro Cristiano Renuevo",
        role: "Francisco Colmenares • Párroco",
        description:
            "esta es una prueba para la descripcion de un post, Hoy celebramos el encuentro mensual de jóvenes con una noche de alabanza y testimonios. Los esperamos a las 6 PM en el auditorio principal. Trae a un amigo para que celebremos juntos",
        imageUser:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg7ddYVuvul35k6x8wtmWmX7jSFwK3JkBHWQ&s",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnnyfo_Rw8WsxYjoo9kYqteJKPorGMFiyrpw&s",
        fecha: "02/03/2025 - 05:16 PM",
        imageUrl:
            "https://cdn.pixabay.com/photo/2019/05/12/20/03/concert-4198983_640.jpg",
        likesText: "342",
        commentsText: "432",
        isLiked: false,
      ),
      model.PostItem(
        type: model.PostType.video,
        user: "Iglesia Cristiana Renacer",
        role: "Pastor Miguel • Líder Juvenil",
        description:
            "¡No te pierdas nuestro próximo evento! Únete a nosotros para una noche especial de adoración y reflexión. Trae tu Biblia y un corazón abierto.",
        imageUser:
            "https://f.i.uol.com.br/fotografia/2025/05/06/1746544177681a263120fbe_1746544177_3x2_md.jpg",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLEYep3iyaWywX6hIkZBqxRl5h9wWu8_MhhQ&s",
        fecha: "03/03/2025 - 10:30 AM",
        videoUrl:
            "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
        likesText: "245",
        commentsText: "67",
        isLiked: false,
      ),
      model.PostItem(
        type: model.PostType.video,
        user: "Iglesia Cristiana Fuente de Salvacion",
        role: "Mauricio Alfonso • Líder de Caballeros",
        description:
            "¡No te pierdas nuestro próximo evento! Únete a nosotros para una noche especial de adoración y reflexión. Trae tu Biblia y un corazón abierto.",
        imageUser:
            "https://f.i.uol.com.br/fotografia/2025/05/06/1746544177681a263120fbe_1746544177_3x2_md.jpg",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLEYep3iyaWywX6hIkZBqxRl5h9wWu8_MhhQ&s",
        fecha: "03/03/2025 - 10:30 AM",
        videoUrl:
            "https://media.gettyimages.com/id/2238478148/es/v%C3%ADdeo/aerial-view-of-holy-redeemer-church-in-bray-town-center-at-sunset-historic-catholic-church.mp4?s=mp4-640x640-gi&k=20&c=ACB_pk7pqSPkYFzw2vsdeVJvheAOosM89Dyx4dAwigA=",
        likesText: "321",
        commentsText: "123",
        isLiked: true,
      ),
      model.PostItem(
        type: model.PostType.verse,
        user: "Obra cristiana Luz del Mundo ",
        role: "Jaime Puerta • Fundador",
        description: "este es un Post de verso, con descripcion corta..!!",
        imageUser:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6eL5RUT4tdMCYufPglpc8GU6qSbbIF8WbPA&s",
        imageChurch:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdjDP-mUKtG5VC4bBrVvnfEGdcdoN1nxkwoA&s",
        fecha: "02/03/2025 - 05:16 PM",
        verse:
            '"En el principio creo Dios los cielos y la tierra". (Genesis 1:1)',
        backgroundColor: AppColors.infoLight,
        likesText: "245",
        commentsText: "67",
        isLiked: true,
      ),
    ];
  }

  // Widget para historias (parametrizable con imagen)
  Widget _storyItem({
    IconData? icon,
    required String label,
    String? imageUrl,
    bool isAdd = false,
    bool isView = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Skeletonizer(
        enabled: _isLoadingPage,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isView
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.neutralMidDark,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 37,
                backgroundColor: AppColors.primaryLight,
                child: isAdd
                    ? InkWell(
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
                                  bottom: MediaQuery.of(
                                    context,
                                  ).viewInsets.bottom,
                                ),
                                child: SafeArea(
                                  top: false,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        bottom: 24.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () => _pickStoryImage(
                                                    ImageSource.gallery,
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .add_photo_alternate_outlined,
                                                    size: 30,
                                                  ),
                                                ),
                                                Text(
                                                  "Galería",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                            height: 60,
                                            child: VerticalDivider(
                                              color: Colors.amber,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () => _pickStoryImage(
                                                    ImageSource.camera,
                                                  ),
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 30,
                                                  ),
                                                ),
                                                Text(
                                                  "Tomar Foto",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                        child: Icon(
                          icon,
                          size: 36,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      )
                    : CircleAvatar(
                        radius: 37,
                        backgroundImage: NetworkImage(
                          imageUrl ?? "https://picsum.photos/100",
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.inter(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Widget para post parametrizable
  Widget _postItem({
    required BuildContext context,
    required int itemIndex,
    required String user,
    required String role,
    required String description,
    required String imageUser,
    required String imageChurch,
    required String fecha,
    required model.PostType postType,
    String? imageUrl,
    String? videoUrl,
    String? verse,
    Color? backgroundColor,
    bool showButton = false,
    String likesText = "1,2 k",
    String commentsText = "124 k",
  }) {
    final likeController = LikeButtonController();

    // Contenido del post según el tipo
    Widget postContent;
    switch (postType) {
      case model.PostType.image:
        postContent = LayoutBuilder(
          builder: (context, constraints) {
            // En el feed queremos que los posts ocupen 65% de la altura de la pantalla,
            // pero limitamos para que no queden demasiado pequeños o enormes.
            final rawH = MediaQuery.of(context).size.height * 0.65;
            final fixedH = rawH.clamp(280.0, 720.0);
            return _DoubleTapLikeImage(
              imageUrl: imageUrl!,
              height: fixedH,
              onDoubleTap: () => likeController.toggleLike(),
              onTap: () {
                final posts = _posts;
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => DetailPagerScreen(
                      posts: posts,
                      initialIndex: itemIndex,
                    ),
                  ),
                );
              },
              imageUser: imageUser,
              imageChurch: imageChurch,
              user: user,
              role: role,
              showDonationButton: true,
              description: description,
              fecha: fecha,
              likesCountText: likesText,
              commentsCountText: commentsText,
              likeController: likeController,
            );
          },
        );
        break;
      case model.PostType.video:
        postContent = LayoutBuilder(
          builder: (context, constraints) {
            // En el feed queremos que los posts ocupen 65% de la altura de la pantalla,
            // pero limitamos para que no queden demasiado pequeños o enormes.
            final rawH = MediaQuery.of(context).size.height * 0.65;
            final fixedH = rawH.clamp(280.0, 720.0);
            return _DoubleTapLikeVideo(
              videoUrl: videoUrl!,
              height: fixedH,
              onDoubleTap: () => likeController.toggleLike(),
              onTap: () {
                final posts = _posts;
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => DetailPagerScreen(
                      posts: posts,
                      initialIndex: itemIndex,
                    ),
                  ),
                );
              },
              imageUser: imageUser,
              imageChurch: imageChurch,
              user: user,
              role: role,
              showDonationButton: true,
              description: description,
              fecha: fecha,
              likesCountText: likesText,
              commentsCountText: commentsText,
              likeController: likeController,
            );
          },
        );
        break;
      case model.PostType.verse:
        postContent = InkWell(
          onDoubleTap: () => likeController.toggleLike(),
          onTap: () {
            final posts = _posts;
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) =>
                    DetailPagerScreen(posts: posts, initialIndex: itemIndex),
              ),
            );
          },
          child: Skeletonizer(
            enabled: _isLoadingPage,
            child: Container(
              color: backgroundColor ?? AppColors.primaryLight,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 56),
              child: Text(
                verse!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        );
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Usuario
        Skeletonizer(
          enabled: _isLoadingPage,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).colorScheme.shadow),
              ),
            ),
            child: ListTile(
              horizontalTitleGap: 8,
              contentPadding: EdgeInsets.only(
                right: 14,
                left: 4,
                top: 6,
                bottom: 6,
              ),
              leading: SizedBox(
                width: 66,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      left: 25,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.shadow,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(imageChurch),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.shadow,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(imageUser),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    transform: Matrix4.translationValues(0, 2, 0),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      user,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 12,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(0, -0.5, 0),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      role,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        letterSpacing: 0,
                        color: AppColors.neutralMidDark,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Row(
                spacing: 2,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox.square(
                    dimension: 24,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        _openBottomSheet(context);
                      },
                      child: Center(
                        child: Image.asset(
                          "assets/icons/donacion.png",
                          width: 22,
                          height: 22,
                          color: Theme.of(context).colorScheme.background,
                          colorBlendMode: BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  SizedBox.square(
                    dimension: 24,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
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
                                          'Ver Cuenta',
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
                                        child: Divider(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.outlineVariant,
                                        ),
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
                                        child: Divider(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.outlineVariant,
                                        ),
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
                                          'Bloquear',
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
                                        child: Divider(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.outlineVariant,
                                        ),
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
                                          'Eliminar publicación',
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
                                        child: Divider(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.outlineVariant,
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
                      child: Center(
                        child: Icon(
                          Icons.more_vert,
                          size: 24,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Contenido del post
        postContent,

        if (showButton)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Encuentro juvenil de las parroquias cercanas",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Confirmar asistencia",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Reacciones
        _reactionButton(
          likesText,
          commentsText,
          likeController: likeController,
          imageUrl: imageUrl,
          videoUrl: videoUrl,
          verse: verse,
        ),

        // Texto descripción
        Skeletonizer(
          enabled: _isLoadingPage,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                final posts = _posts;
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => DetailPagerScreen(
                      posts: posts,
                      initialIndex: itemIndex,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    fecha,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  _ExpandableText(
                    maxLines: 3,
                    description,
                    linkColor: AppColors.neutralMidDark,
                    textStyle: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.neutralMidDark,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _reactionButton(
    String likes,
    String comments, {
    LikeButtonController? likeController,
    String? imageUrl,
    String? videoUrl,
    String? verse,
  }) {
    return Skeletonizer(
      enabled: _isLoadingPage,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Like con animación y cambio de color
            LikeButtonRow(
              initialLiked: false,
              countText: likes,
              controller: likeController,
              onChanged: (liked) {
                // aqui se coloca el backend para registrar like del post
              },
            ),
            IconButton(
              icon: _iconText(Icons.comment_outlined, comments),
              onPressed: () {
                showModalBottomSheet<void>(
                  showDragHandle: true,
                  enableDrag: true,
                  context: context,
                  isScrollControlled: true,
                  useRootNavigator: true,
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.8, // tamaño inicial (0 a 1)
                      minChildSize:
                          0.7, // tamaño mínimo (cuando se arrastra hacia abajo)
                      maxChildSize: 0.8, // tamaño máximo
                      builder: (context, scrollController) {
                        return AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SafeArea(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 75),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Comentarios',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      Expanded(
                                        child: ListView(
                                          controller: scrollController,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          children: [
                                            _comment(
                                              avatar:
                                                  'https://mdbcdn.b-cdn.net/img/new/avatars/2.webp',
                                              user: 'Jose Puerta',
                                              time: '2 horas',
                                              comment:
                                                  'Este es un comentario de ejemplo',
                                              isliked: true,
                                              likes: '12',
                                            ),
                                            _comment(
                                              avatar:
                                                  'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
                                              user: 'Eduardo Castro',
                                              time: '23 seg.',
                                              comment:
                                                  '"porque de tal manera amor DIos al Mundo, que ah dado a su hijo unijenito, para que todo aquel que en el crea no se pierda.... mas tenga vida eterna"',
                                              isliked: true,
                                              likes: '780k',
                                            ),
                                            _comment(
                                              avatar:
                                                  'https://chic-content.co.uk/wp-content/uploads/2021/06/sample-avatar-002.jpg',
                                              user: 'Julia Rios',
                                              time: '2 min.',
                                              comment:
                                                  'Bendiciones a la publicacion realizada, que Dios respalde a sus sirevos.',
                                              isliked: false,
                                              likes: '152',
                                            ),
                                            _comment(
                                              avatar:
                                                  'https://mdbcdn.b-cdn.net/img/new/avatars/2.webp',
                                              user: 'Jose Puerta',
                                              time: '2 horas',
                                              comment:
                                                  'Este es un comentario de ejemplo',
                                              isliked: true,
                                              likes: '12',
                                            ),
                                            _comment(
                                              avatar:
                                                  'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
                                              user: 'Eduardo Castro',
                                              time: '23 seg.',
                                              comment:
                                                  '"porque de tal manera amor DIos al Mundo, que ah dado a su hijo unijenito, para que todo aquel que en el crea no se pierda.... mas tenga vida eterna"',
                                              isliked: true,
                                              likes: '780k',
                                            ),
                                            _comment(
                                              avatar:
                                                  'https://chic-content.co.uk/wp-content/uploads/2021/06/sample-avatar-002.jpg',
                                              user: 'Julia Rios',
                                              time: '2 min.',
                                              comment:
                                                  'Bendiciones a la publicacion realizada, que Dios respalde a sus sirevos.',
                                              isliked: false,
                                              likes: '152',
                                            ),
                                            _comment(
                                              avatar:
                                                  'https://mdbcdn.b-cdn.net/img/new/avatars/2.webp',
                                              user: 'Jose Puerta',
                                              time: '2 horas',
                                              comment:
                                                  'Este es un comentario de ejemplo',
                                              isliked: true,
                                              likes: '12',
                                            ),
                                            _comment(
                                              avatar:
                                                  'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
                                              user: 'Eduardo Castro',
                                              time: '23 seg.',
                                              comment:
                                                  '"porque de tal manera amor DIos al Mundo, que ah dado a su hijo unijenito, para que todo aquel que en el crea no se pierda.... mas tenga vida eterna"',
                                              isliked: true,
                                              likes: '780k',
                                            ),
                                            _comment(
                                              avatar:
                                                  'https://chic-content.co.uk/wp-content/uploads/2021/06/sample-avatar-002.jpg',
                                              user: 'Julia Rios',
                                              time: '2 min.',
                                              comment:
                                                  'Bendiciones a la publicacion realizada, que Dios respalde a sus sirevos.',
                                              isliked: false,
                                              likes: '152',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // textfield fijo abajo
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceVariant,
                                      border: const Border(
                                        top: BorderSide(
                                          width: 2,
                                          color: Color(0xFFE6B000),
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.shadow,
                                          blurRadius: 8,
                                          offset: const Offset(0, -1),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 45,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.shadow,
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              border: Border.all(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.outline,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: TextField(
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              decoration: InputDecoration(
                                                hintText: "Mensaje...",
                                                hintStyle: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color:
                                                      AppColors.neutralMidDark,
                                                ),
                                                filled: true,
                                                fillColor: Theme.of(
                                                  context,
                                                ).colorScheme.surfaceContainer,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10,
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            // acción al enviar mensaje
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryLight,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.send_rounded,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, size: 24),
              onPressed: () {
                // acción de compartir: usar lo que pase el llamador
                final toShare = imageUrl ?? videoUrl ?? verse ?? '';
                if (toShare.isNotEmpty) Share.share(toShare);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Icono + número (ej: likes, comentarios)
  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 6),
        Text(text, style: GoogleFonts.inter(fontSize: 14)),
      ],
    );
  }

  Widget _comment({
    required String avatar,
    required String user,
    required String time,
    required String comment,
    required bool isliked,
    required String likes,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.shadow),
        ),
      ),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(avatar),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 8,
          children: [
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
                                  padding: EdgeInsets.symmetric(horizontal: 80),
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Ver Cuenta',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
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
                                child: Divider(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 80),
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Reportar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
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
                                child: Divider(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 80),
                                  foregroundColor: Colors.redAccent[700],
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Bloquear',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent[700],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0,
                                  vertical: 0,
                                ),
                                child: Divider(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
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
              child: Text(
                user,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              time,
              textAlign: TextAlign.left,
              style: TextStyle(color: AppColors.neutralMidDark, fontSize: 12),
            ),
          ],
        ),
        subtitle: Text(comment, overflow: TextOverflow.ellipsis, maxLines: 5),
        trailing: CommentLikeButton(
          initialLiked: isliked,
          countText: likes,
          onChanged: (liked) {
            // : conectar con backend para like de comentario
          },
        ),
      ),
    );
  }
}

// Imagen con overlay de corazón para doble tap
class _DoubleTapLikeImage extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onTap;
  final String? imageUser;
  final String? imageChurch;
  final String? user;
  final String? role;
  final bool showDonationButton;
  final String? description;
  final String? fecha;
  final String? likesCountText;
  final String? commentsCountText;
  final LikeButtonController? likeController;

  const _DoubleTapLikeImage({
    required this.imageUrl,
    this.height,
    this.onDoubleTap,
    this.onTap,
    this.imageUser,
    this.imageChurch,
    this.user,
    this.role,
    this.showDonationButton = false,
    this.description,
    this.fecha,
    this.likesCountText,
    this.commentsCountText,
    this.likeController,
  });

  @override
  State<_DoubleTapLikeImage> createState() => _DoubleTapLikeImageState();
}

class _DoubleTapLikeImageState extends State<_DoubleTapLikeImage>
    with SingleTickerProviderStateMixin {
  bool _isLoadingPage = false;
  bool _showHeart = false;

  void _triggerHeart() async {
    if (!mounted) return;
    setState(() => _showHeart = true);
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() => _showHeart = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        widget.onDoubleTap?.call();
        _triggerHeart();
      },
      onTap: () {
        widget.onTap?.call();
      },
      child: Skeletonizer(
        enabled: _isLoadingPage,
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                height: widget.height,
                width: double.infinity,
              ),
              AnimatedOpacity(
                opacity: _showHeart ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: Transform.scale(
                  scale: _showHeart ? 1.0 : 0.6,
                  child: const Icon(
                    Icons.favorite,
                    color: Color.fromRGBO(213, 0, 0, 0.92),
                    size: 96,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Video con overlay de corazón para doble tap
class _DoubleTapLikeVideo extends StatefulWidget {
  final String videoUrl;
  final double? height;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onTap;
  final String? imageUser;
  final String? imageChurch;
  final String? user;
  final String? role;
  final bool showDonationButton;
  final String? description;
  final String? fecha;
  final String? likesCountText;
  final String? commentsCountText;
  final LikeButtonController? likeController;

  const _DoubleTapLikeVideo({
    required this.videoUrl,
    this.height,
    this.onDoubleTap,
    this.onTap,
    this.imageUser,
    this.imageChurch,
    this.user,
    this.role,
    this.showDonationButton = false,
    this.description,
    this.fecha,
    this.likesCountText,
    this.commentsCountText,
    this.likeController,
  });

  @override
  State<_DoubleTapLikeVideo> createState() => _DoubleTapLikeVideoState();
}

class _DoubleTapLikeVideoState extends State<_DoubleTapLikeVideo>
    with SingleTickerProviderStateMixin {
  bool _showHeart = false;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _isLoadingPage = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerHeart() async {
    if (!mounted) return;
    setState(() => _showHeart = true);
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() => _showHeart = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        widget.onDoubleTap?.call();
        _triggerHeart();
      },
      onTap: () {
        widget.onTap?.call();
      },
      child: Skeletonizer(
        enabled: _isLoadingPage,
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      _controller.value.isInitialized) {
                    return VisibilityDetector(
                      key: Key("video_${widget.videoUrl}"),
                      onVisibilityChanged: (visibilityInfo) {
                        var visiblePercentage =
                            visibilityInfo.visibleFraction * 100;

                        if (visiblePercentage > 50) {
                          if (!_controller.value.isPlaying) {
                            _controller.play();
                          }
                        } else {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          }
                        }
                      },
                      child: Builder(
                        builder: (context) {
                          final fixedH = widget.height ?? 320.0;
                          final aspect =
                              (_controller.value.isInitialized &&
                                  _controller.value.aspectRatio > 0)
                              ? _controller.value.aspectRatio
                              : 16 / 9;

                          return ClipRect(
                            child: SizedBox(
                              height: fixedH,
                              width: double.infinity,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: fixedH,
                                  width: fixedH * aspect,
                                  child: VideoPlayer(_controller),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }
                },
              ),
              AnimatedOpacity(
                opacity: _showHeart ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: Transform.scale(
                  scale: _showHeart ? 1.0 : 0.6,
                  child: const Icon(
                    Icons.favorite,
                    color: Color.fromRGBO(213, 0, 0, 0.92),
                    size: 96,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showOverlayMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.36,
      left: MediaQuery.of(context).size.width * 0.32,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green[600],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 2), () => entry.remove());
}

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

// Widgets para Likes
class LikeButtonController {
  VoidCallback? _toggle;
  void Function(bool)? _setLiked;
  bool Function()? _getLiked;

  void attach({
    VoidCallback? toggle,
    void Function(bool)? setLiked,
    bool Function()? getLiked,
  }) {
    _toggle = toggle;
    _setLiked = setLiked;
    _getLiked = getLiked;
  }

  void toggleLike() => _toggle?.call();
  void setLiked(bool value) => _setLiked?.call(value);
  bool getLiked() => _getLiked?.call() ?? false;
}

int? _parseCountToInt(String input) {
  try {
    final s = input.trim().toLowerCase();
    String unit = '';
    if (s.endsWith('k') || s.endsWith('m')) {
      unit = s.substring(s.length - 1);
    }
    final match = RegExp(r'([0-9]+([\.,][0-9]+)?)').firstMatch(s);
    if (match == null) return int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), ''));
    String numStr = match.group(1) ?? '';
    numStr = numStr.replaceAll('.', '').replaceAll(',', '.');
    final value = double.tryParse(numStr);
    if (value == null) return null;
    if (unit == 'k') return (value * 1000).round();
    if (unit == 'm') return (value * 1000000).round();
    return value.round();
  } catch (_) {
    return null;
  }
}

String _formatCount(int value) {
  if (value >= 1000000) {
    double v = value / 1000000.0;
    String s = v.toStringAsFixed(v < 10 ? 1 : 0);
    if (s.endsWith('.0')) s = s.substring(0, s.length - 2);
    return "$s M";
  }
  if (value >= 1000) {
    double v = value / 1000.0;
    String s = v.toStringAsFixed(v < 10 ? 1 : 0);
    if (s.endsWith('.0')) s = s.substring(0, s.length - 2);
    return "$s k";
  }
  return value.toString();
}

class LikeButtonRow extends StatefulWidget {
  final bool initialLiked;
  final String countText; //conteo como String
  final LikeButtonController? controller;
  final ValueChanged<bool>? onChanged;

  const LikeButtonRow({
    super.key,
    required this.initialLiked,
    required this.countText,
    this.controller,
    this.onChanged,
  });

  @override
  State<LikeButtonRow> createState() => _LikeButtonRowState();
}

class _LikeButtonRowState extends State<LikeButtonRow>
    with SingleTickerProviderStateMixin {
  late bool liked;
  late AnimationController _controller;
  int? _count; // manejar conteo local cuando sea numérico

  @override
  void initState() {
    super.initState();
    liked = widget.initialLiked;
    _count = _parseCountToInt(widget.countText);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    widget.controller?.attach(
      toggle: _externalToggle,
      setLiked: _externalSetLiked,
      getLiked: () => liked,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _externalToggle() => _toggle();
  void _externalSetLiked(bool v) {
    if (v == liked) return;
    _toggle(force: v);
  }

  void _toggle({bool? force}) {
    final newValue = force ?? !liked;
    setState(() {
      // háptica solo cuando pasa a like
      if (!liked && newValue) {
        HapticFeedback.lightImpact();
      }
      liked = newValue;
      if (_count != null) {
        _count = liked ? (_count! + 1) : (_count! - 1);
        if (_count! < 0) _count = 0;
      }
    });
    // animación estilo elasticOut
    _controller.forward(from: 0);
    widget.onChanged?.call(liked);
  }

  @override
  Widget build(BuildContext context) {
    final Color targetColor = liked
        ? const Color.fromRGBO(213, 0, 0, 1)
        : Theme.of(context).colorScheme.onSurface;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: _toggle,
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = CurvedAnimation(
                parent: _controller,
                curve: Curves.elasticOut,
              ).value;
              final effectiveScale = 1.0 + (scale * 0.25);
              return Transform.scale(
                scale: effectiveScale,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(liked),
                    size: 20,
                    color: targetColor,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          Text(
            _count != null ? _formatCount(_count!) : widget.countText,
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class CommentLikeButton extends StatefulWidget {
  final bool initialLiked;
  final String countText;
  final ValueChanged<bool>? onChanged;

  const CommentLikeButton({
    super.key,
    required this.initialLiked,
    required this.countText,
    this.onChanged,
  });

  @override
  State<CommentLikeButton> createState() => _CommentLikeButtonState();
}

class _CommentLikeButtonState extends State<CommentLikeButton>
    with SingleTickerProviderStateMixin {
  late bool liked;
  late AnimationController _controller;
  int? _count;

  @override
  void initState() {
    super.initState();
    liked = widget.initialLiked;
    _count = _parseCountToInt(widget.countText);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      liked = !liked;
      if (!liked) {
        // al quitar like, no hay háptica
      } else {
        HapticFeedback.lightImpact();
      }
      if (_count != null) {
        _count = liked ? (_count! + 1) : (_count! - 1);
        if (_count! < 0) _count = 0;
      }
    });
    _controller.forward(from: 0);
    widget.onChanged?.call(liked);
  }

  @override
  Widget build(BuildContext context) {
    final Color targetColor = liked
        ? const Color.fromRGBO(213, 0, 0, 1)
        : Colors.grey;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: _toggle,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = CurvedAnimation(
                parent: _controller,
                curve: Curves.elasticOut,
              ).value;
              final effectiveScale = 1.0 + (scale * 0.25);
              return Transform.scale(
                scale: effectiveScale,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(liked),
                    color: targetColor,
                    size: 22,
                  ),
                ),
              );
            },
          ),
          Text(_count != null ? _formatCount(_count!) : widget.countText),
        ],
      ),
    );
  }
}

// disenho item colors
Widget _colors({
  required Color color,
  required BuildContext context,
  bool active = false,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(25),
    child: Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: active
              ? Theme.of(context).colorScheme.background
              : Colors.transparent,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final Color linkColor;
  final TextStyle? textStyle;

  const _ExpandableText(
    this.text, {
    this.maxLines = 3,
    this.linkColor = Colors.black,
    this.textStyle,
  });

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final defaultStyle =
        widget.textStyle ??
        DefaultTextStyle.of(context).style.copyWith(fontSize: 14, height: 1.4);

    return LayoutBuilder(
      builder: (context, constraints) {
        final tp = TextPainter(
          text: TextSpan(text: widget.text, style: defaultStyle),
          textDirection: TextDirection.ltr,
          maxLines: widget.maxLines,
          ellipsis: '…',
        );
        tp.layout(maxWidth: constraints.maxWidth);

        final exceeds = tp.didExceedMaxLines;

        if (!exceeds || _expanded) {
          return RichText(
            text: TextSpan(
              style: defaultStyle,
              children: [
                TextSpan(text: widget.text),
                if (exceeds) const TextSpan(text: ' '),
                if (exceeds)
                  TextSpan(
                    text: 'ver menos',
                    style: defaultStyle.copyWith(
                      color: widget.linkColor,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => setState(() => _expanded = false),
                  ),
              ],
            ),
          );
        }

        final collapsedText = _truncateToFit(
          fullText: widget.text,
          maxWidth: constraints.maxWidth,
          textStyle: defaultStyle,
          maxLines: widget.maxLines,
          trailing: ' … ver más',
        );

        return RichText(
          text: TextSpan(
            style: defaultStyle,
            children: [
              TextSpan(text: collapsedText.prefix),
              const TextSpan(text: ' … '),
              TextSpan(
                text: 'ver más',
                style: defaultStyle.copyWith(
                  color: widget.linkColor,
                  fontWeight: FontWeight.w600,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
          ),
        );
      },
    );
  }

  _CollapsedPrefix _truncateToFit({
    required String fullText,
    required double maxWidth,
    required TextStyle textStyle,
    required int maxLines,
    required String trailing,
  }) {
    // Binary search the cutoff index so that text + trailing fits into maxLines
    int low = 0;
    int high = fullText.length;
    int best = 0;

    while (low <= high) {
      final mid = (low + high) >> 1;
      final tp = TextPainter(
        text: TextSpan(
          text: fullText.substring(0, mid) + trailing,
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
        maxLines: maxLines,
      );
      tp.layout(maxWidth: maxWidth);

      if (!tp.didExceedMaxLines) {
        best = mid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    final safe = best.clamp(0, fullText.length);
    // Trim ending spaces/newlines
    final prefix = fullText.substring(0, safe).replaceAll(RegExp(r"\s+$"), '');
    return _CollapsedPrefix(prefix: prefix);
  }
}

class _CollapsedPrefix {
  final String prefix;
  _CollapsedPrefix({required this.prefix});
}
