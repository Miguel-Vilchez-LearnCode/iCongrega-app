import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/domain/models/post_item.dart' as model;
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/screens/feed/feed_screen.dart';
import 'package:icongrega/ui/widgets/donation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:icongrega/ui/screens/feed/video_controller_manager.dart';
import 'package:icongrega/theme/theme_helpers.dart';

// Color primario ahora se obtiene del tema

class DetailPostView extends StatefulWidget {
  final model.PostItem post;
  // Controlador e inicialización que puede venir pre-cargado desde el paginador (opcional)
  final VideoPlayerController? preloadedController;
  final Future<void>? preloadedInit;

  const DetailPostView({
    super.key,
    required this.post,
    this.preloadedController,
    this.preloadedInit,
  });

  @override
  State<DetailPostView> createState() => _DetailPostViewState();
}

class _DetailPostViewState extends State<DetailPostView>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  VideoPlayerController? _videoController;
  Future<void>? _initFuture;
  bool _ownsController = false; // true si este widget creó el controller
  String?
  _managedUrl; // si pedimos el controller al manager, guardamos la url aquí

  bool _liked = false;
  int _likeCount = 0;
  bool _showHeart = false;
  bool _showDescription = true;
  double _dragDy =
      0.0; // acumulamos el desplazamiento vertical para detectar swipe
  static const double _kDescMaxHeight =
      220; // alto máximo del cuadro de descripción

  // animación del icono de play/pause que aparece encima del video
  bool _showPlayPauseIcon = false;
  IconData _playPauseIcon = Icons.pause;
  late final AnimationController _playPauseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final Animation<double> _playPauseScale = CurvedAnimation(
    parent: _playPauseCtrl,
    curve: Curves.elasticOut,
  );
  late final Animation<double> _playPauseOpacity = Tween(begin: 1.0, end: 0.0)
      .animate(
        CurvedAnimation(
          parent: _playPauseCtrl,
          curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
        ),
      );

  late final AnimationController _iconScaleCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
    lowerBound: 0.9,
    upperBound: 1.2,
    value: 1.0,
  );

  @override
  void initState() {
    super.initState();
    _likeCount = _parseCountText(widget.post.likesText) ?? 0;
    // Initialize local liked state from the PostItem
    _liked = widget.post.isLiked;
    // Registrar para pausar el video cuando la app pasa a background
    WidgetsBinding.instance.addObserver(this);

    if (widget.post.type == model.PostType.video &&
        widget.post.videoUrl != null) {
      // Si el paginador pasó un controller ya listo, lo usamos (el paginador maneja el refcount)
      if (widget.preloadedController != null) {
        _videoController = widget.preloadedController;
        _initFuture = widget.preloadedInit;
        _ownsController = false;
        // asegurar que haga loop cuando esté listo
        _initFuture?.then((_) {
          if (!mounted || _videoController == null) return;
          try {
            _videoController!.setLooping(true);
          } catch (_) {}
          setState(() {});
        });
      } else {
        // Pedimos al manager que asegure el controller y suba el contador de referencias
        final url = widget.post.videoUrl!;
        VideoControllerManager().ensureController(url);
        _managedUrl = url;
        _videoController = VideoControllerManager().controllerFor(url);
        _initFuture = VideoControllerManager().initFutureFor(url);
        _ownsController = false; // el manager se hace cargo del ciclo de vida
        _initFuture?.then((_) {
          if (!mounted) return;
          try {
            _videoController?.setLooping(true);
          } catch (_) {}
          setState(() {});
        });
      }
    }
  }

  @override
  void dispose() {
    _iconScaleCtrl.dispose();
    _playPauseCtrl.dispose();
    // Sacamos el observer del ciclo de vida
    WidgetsBinding.instance.removeObserver(this);

    // Liberar la referencia en el manager si la pedimos antes
    if (_managedUrl != null) {
      try {
        VideoControllerManager().releaseController(_managedUrl!);
      } catch (_) {}
      _managedUrl = null;
    } else if (_ownsController) {
      // por si acaso... si por alguna razón este widget era dueño del controller, lo liberamos
      try {
        _videoController?.dispose();
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DetailPostView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the post object changed, refresh local like state and counts
    if (oldWidget.post != widget.post) {
      _likeCount = _parseCountText(widget.post.likesText) ?? _likeCount;
      _liked = widget.post.isLiked;
    }
    final oldUrl = oldWidget.post.videoUrl;
    final newUrl = widget.post.videoUrl;
    // Si cambió la url del video, soltamos la vieja y pedimos la nueva al manager (o usamos la preloaded)
    if (oldUrl != newUrl) {
      // soltar el controller viejo que pedimos al manager
      if (_managedUrl != null && oldUrl != null) {
        try {
          VideoControllerManager().releaseController(_managedUrl!);
        } catch (_) {}
        _managedUrl = null;
      }

      // pedir el controller nuevo si hace falta
      if (widget.post.type == model.PostType.video && newUrl != null) {
        if (widget.preloadedController != null) {
          _videoController = widget.preloadedController;
          _initFuture = widget.preloadedInit;
          _ownsController = false;
        } else {
          VideoControllerManager().ensureController(newUrl);
          _managedUrl = newUrl;
          _videoController = VideoControllerManager().controllerFor(newUrl);
          _initFuture = VideoControllerManager().initFutureFor(newUrl);
          _ownsController = false;
          _initFuture?.then((_) {
            if (!mounted) return;
            try {
              _videoController?.setLooping(true);
            } catch (_) {}
            setState(() {});
          });
        }
      } else {
        // ya no hay video
        _videoController = null;
        _initFuture = null;
      }
      // refrescar la UI
      if (mounted) setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pausar el video cuando el widget se desactiva para evitar problemas con texturas
    try {
      if (_videoController?.value.isPlaying == true) {
        _videoController?.pause();
      }
    } catch (_) {}
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pausar cuando la app pasa a background o queda inactiva
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      try {
        if (_videoController?.value.isPlaying == true)
          _videoController?.pause();
      } catch (_) {}
    }
  }

  void _toggleLike() async {
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
      if (_likeCount < 0) _likeCount = 0;
    });
    setState(() => _showHeart = true);
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() => _showHeart = false);
  }

  void _triggerHeart() async {
    if (!mounted) return;
    setState(() => _showHeart = true);
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() => _showHeart = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // Utils
  int? _parseCountText(String s) {
    final t = s.trim().toLowerCase().replaceAll(' ', '');
    if (t.endsWith('k')) {
      final numPart = t.substring(0, t.length - 1).replaceAll(',', '.');
      final v = double.tryParse(numPart);
      if (v == null) return null;
      return (v * 1000).round();
    }
    final digits = t.replaceAll('.', '').replaceAll(',', '');
    return int.tryParse(digits);
  }

  String _formatCount(int value) {
    if (value >= 1000) {
      double k = value / 1000.0;
      String s = k.toStringAsFixed(k >= 10 ? 0 : 1).replaceAll('.', ',');
      return "$s k";
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final post = widget.post;

    return Stack(
      children: [
        if (post.type == model.PostType.image)
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Image.network(
              post.imageUrl!,
              fit: BoxFit.cover,
              height: double.infinity,
            ),
          ),
        /* 
        if (post.type == model.PostType.video)
          FutureBuilder(
            future: _initFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  _videoController!.value.isInitialized) {
                return VisibilityDetector(
                  key: Key('video_${post.videoUrl}'),
                  onVisibilityChanged: (info) {
                    final visible = info.visibleFraction > 0.6;
                    if (_videoController == null) return;
                    if (visible) {
                      if (!_videoController!.value.isPlaying) {
                        _videoController!.play();
                      }
                    } else {
                      if (_videoController!.value.isPlaying) {
                        _videoController!.pause();
                      }
                    }
                  },
                  child: VideoPlayer(_videoController!),
                );
              } else {
                return Center(child: CircularProgressIndicator(color: context.colors.AppColors.primaryLight));
              }
            },
          ),
        */
        Container(color: Colors.black.withOpacity(0.65)),

        // Imagen con doble tap
        SizedBox.expand(
          child: GestureDetector(
            onDoubleTap: () {
              _toggleLike();
              _triggerHeart();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (post.type == model.PostType.verse)
                  Container(
                    color: post.backgroundColor ?? context.colors.primary,
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 42),
                    child: Center(
                      child: Text(
                        post.verse ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: context.colors.onPrimary,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                if (post.type == model.PostType.image)
                  Image.network(post.imageUrl!, fit: BoxFit.cover),
                if (post.type == model.PostType.video)
                  FutureBuilder(
                    future: _initFuture,
                    builder: (context, snapshot) {
                      final initialized =
                          snapshot.connectionState == ConnectionState.done &&
                          _videoController?.value.isInitialized == true;
                      // Use provided thumbnail (imageUrl) as a fallback while loading
                      final thumb = post.imageUrl;

                      final aspect =
                          (_videoController?.value.aspectRatio) ?? 16 / 9;

                      return VisibilityDetector(
                        key: Key('video_${post.videoUrl}'),
                        onVisibilityChanged: (info) {
                          final visible = info.visibleFraction > 0.6;
                          if (_videoController == null) return;
                          if (visible) {
                            if (!_videoController!.value.isPlaying &&
                                initialized) {
                              _videoController!.play();
                            }
                          } else {
                            if (_videoController!.value.isPlaying) {
                              _videoController!.pause();
                            }
                          }
                        },
                        child: InkWell(
                          onTap: () {
                            if (_videoController == null) return;
                            final playing = _videoController!.value.isPlaying;
                            if (playing) {
                              _videoController!.pause();
                              _playPauseIcon = Icons.pause;
                            } else {
                              _videoController!.play();
                              _playPauseIcon = Icons.play_arrow;
                            }

                            // show animated icon overlay
                            setState(() {
                              _showPlayPauseIcon = true;
                            });
                            _playPauseCtrl.forward(from: 0.0).whenComplete(() {
                              if (!mounted) return;
                              setState(() {
                                _showPlayPauseIcon = false;
                              });
                            });
                          },
                          child: AspectRatio(
                            aspectRatio: aspect,
                            child: Stack(
                              children: [
                                // thumbnail or placeholder
                                if (thumb != null)
                                  Positioned.fill(
                                    child: Image.network(
                                      thumb,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                // video when ready
                                if (initialized && _videoController != null)
                                  Positioned.fill(
                                    child: VideoPlayer(_videoController!),
                                  ),

                                // loading indicator overlay when not initialized
                                if (!initialized)
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const CircularProgressIndicator(
                                        color: AppColors.primaryLight,
                                      ),
                                    ),
                                  ),

                                // Play/Pause animated overlay
                                if (_showPlayPauseIcon)
                                  Center(
                                    child: FadeTransition(
                                      opacity: _playPauseOpacity,
                                      child: ScaleTransition(
                                        scale: _playPauseScale,
                                        child: Icon(
                                          _playPauseIcon,
                                          size: 96,
                                          color: AppColors.botLight,
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

        // Botón de retroceso
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          child: CircleAvatar(
            backgroundColor: AppColors.light,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.dark),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),

        // Panel inferior y botones de interaccion con informacion del post
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(right: 4),
                child: Column(
                  spacing: 24,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        ScaleTransition(
                          scale: _iconScaleCtrl,
                          child: IconButton(
                            icon: Icon(
                              size: 26,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 4,
                                  color: AppColors.botDark,
                                ),
                              ],
                              _liked
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: _liked
                                  ? context.palette.dangerLight
                                  : Colors.white,
                            ),
                            onPressed: _toggleLike,
                          ),
                        ),
                        Text(
                          _formatCount(_likeCount),
                          style: GoogleFonts.inter(
                            color: AppColors.botLight,
                            fontSize: 12,
                            shadows: [
                              Shadow(color: AppColors.botDark, blurRadius: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            size: 26,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 4,
                                color: AppColors.botDark,
                              ),
                            ],
                            Icons.chat_outlined,
                            color: AppColors.botLight,
                          ),
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
                                  initialChildSize:
                                      0.8, // tamaño inicial (0 a 1)
                                  minChildSize:
                                      0.7, // tamaño mínimo (cuando se arrastra hacia abajo)
                                  maxChildSize: 0.8, // tamaño máximo
                                  builder: (context, scrollController) {
                                    return AnimatedPadding(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      curve: Curves.easeOut,
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                      ),
                                      child: SafeArea(
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 75,
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Comentarios',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Expanded(
                                                    child: ListView(
                                                      controller:
                                                          scrollController,
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
                                                          user:
                                                              'Eduardo Castro',
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
                                                          user:
                                                              'Eduardo Castro',
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
                                                          user:
                                                              'Eduardo Castro',
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
                                                      offset: const Offset(
                                                        0,
                                                        -1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                padding: const EdgeInsets.all(
                                                  14,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 45,
                                                        decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .shadow,
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                    0,
                                                                    2,
                                                                  ),
                                                            ),
                                                          ],
                                                          border: Border.all(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .outline,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                        ),
                                                        child: TextField(
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .center,
                                                          decoration: InputDecoration(
                                                            hintText:
                                                                "Mensaje...",
                                                            hintStyle:
                                                                GoogleFonts.inter(
                                                                  fontSize: 14,
                                                                  color: AppColors
                                                                      .neutralMidDark,
                                                                ),
                                                            filled: true,
                                                            fillColor:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .surfaceContainer,
                                                            contentPadding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10,
                                                                ),
                                                            border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    6,
                                                                  ),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
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
                                                        padding:
                                                            const EdgeInsets.all(
                                                              10,
                                                            ),
                                                        decoration:
                                                            BoxDecoration(
                                                              color: AppColors
                                                                  .primaryLight,
                                                              shape: BoxShape
                                                                  .circle,
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
                        Text(
                          widget.post.commentsText,
                          style: GoogleFonts.inter(
                            color: AppColors.botLight,
                            fontSize: 12,
                            shadows: [
                              Shadow(color: AppColors.botDark, blurRadius: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            size: 26,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 4,
                                color: AppColors.botDark,
                              ),
                            ],
                            Icons.share_outlined,
                            color: AppColors.botLight,
                          ),
                          onPressed: () {
                            // acción de compartir
                            Share.share(
                              widget.post.type == model.PostType.image
                                  ? widget.post.imageUrl ?? ''
                                  : widget.post.type == model.PostType.video
                                  ? widget.post.videoUrl ?? ''
                                  : widget.post.verse ?? '',
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            size: 26,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 0),
                                blurRadius: 4,
                                color: AppColors.botDark,
                              ),
                            ],
                            Icons.more_vert,
                            color: AppColors.botLight,
                          ),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  _dragDy += details.delta.dy;
                },
                onVerticalDragEnd: (details) {
                  if (_dragDy < -20) {
                    if (!_showDescription) {
                      setState(() => _showDescription = true);
                    }
                  } else if (_dragDy > 20) {
                    if (_showDescription) {
                      setState(() => _showDescription = false);
                    }
                  }
                  _dragDy = 0.0;
                },
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showDescription = !_showDescription;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: Image(
                              image: AssetImage('assets/icons/rectangle.png'),
                              width: 52,
                              height: 8,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      // Usuario
                      Container(
                        padding: EdgeInsets.only(right: 6),
                        child: ListTile(
                          horizontalTitleGap: 8,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          leading: SizedBox(
                            width: 66,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Positioned(
                                  left: 25, // el primer avatar
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.shadow,
                                          blurRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        widget.post.imageChurch,
                                      ), // avatar principal
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left:
                                      5, // el segundo avatar, un poco desplazado a la derecha
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.shadow,
                                          blurRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        widget.post.imageUser, // otra imagen
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          title: Column(
                            spacing: 0,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                transform: Matrix4.translationValues(0, 2, 0),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  widget.post.user,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.background,
                                    fontSize: 12,
                                    letterSpacing: 0,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                transform: Matrix4.translationValues(
                                  0,
                                  -0.5,
                                  0,
                                ),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  widget.post.role,
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
                          trailing: SizedBox.square(
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.background,
                                  colorBlendMode: BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Texto descripción con animación y altura máxima
                      ClipRect(
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 160),
                          curve: Curves.easeInOut,
                          child: _showDescription
                              ? ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: _kDescMaxHeight,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 2,
                                        children: [
                                          Text(
                                            widget.post.fecha,
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppColors.neutralMidDark,
                                              height: 1.4,
                                            ),
                                          ),
                                          _ExpandableText(
                                            widget.post.description,
                                            maxLines: 3,
                                            linkColor: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                            textStyle: GoogleFonts.inter(
                                              fontSize: 12,
                                              height: 1.4,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
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
    );
  }

  @override
  bool get wantKeepAlive => true;

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
                style: TextStyle(color: Colors.blue, fontSize: 12),
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
                recognizer: TapGestureRecognizer()
                  ..onTap = () => setState(() => _expanded = true),
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
