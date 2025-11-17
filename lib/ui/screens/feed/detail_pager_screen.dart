// lib/ui/screens/feed/detail_pager_screen.dart
import 'package:flutter/material.dart';
import 'package:icongrega/domain/models/post_item.dart' as model;
import 'package:icongrega/ui/screens/feed/detail_post_view.dart';
import 'package:icongrega/ui/screens/feed/video_controller_manager.dart';

class DetailPagerScreen extends StatefulWidget {
  final List<model.PostItem> posts;
  final int initialIndex;

  const DetailPagerScreen({
    super.key,
    required this.posts,
    required this.initialIndex,
  });

  @override
  State<DetailPagerScreen> createState() => _DetailPagerScreenState();
}

class _DetailPagerScreenState extends State<DetailPagerScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;
  bool _isJumping = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 1.0, // Asegurar que cada página ocupe toda la pantalla
      keepPage: true, // Mantener la página actual en memoria
    );
    // Prefetch inicial del post actual y los vecinos (para que carguen antes)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchAround(_currentIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // No tiramos los controllers aquí: cada DetailPostView se encarga de avisar al manager cuando ya no lo necesita.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Cuando termina el scroll del usuario, hacemos un jump inmediato a la página más cercana
          if (notification is ScrollEndNotification && !_isJumping) {
            final metrics = notification.metrics;
            final page = metrics.pixels / metrics.viewportDimension;
            final target = page.round().clamp(0, widget.posts.length - 1);
            if (target != _currentIndex) {
              setState(() => _currentIndex = target);
              _prefetchAround(target);
            }
            _isJumping = true;
            // jumpToPage es instantáneo, sin animación
            _pageController.jumpToPage(target);
            // reset flag en el siguiente frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _isJumping = false;
            });
          }
          return false;
        },
        child: PageView.builder(
          physics:
              const _NoBallisticScrollPhysics(), // No hay animación al soltar
          controller: _pageController,
          scrollDirection: Axis.vertical,
          allowImplicitScrolling:
              true, // Permitir scroll implícito para mejor rendimiento
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
            _prefetchAround(index);
            // el manager guarda los controllers mientras los views los usen
          },
          itemCount: widget.posts.length,
          itemBuilder: (context, index) {
            final post = widget.posts[index];
            // No enviamos controllers ya listos: cada DetailPostView pedirá al manager su controller si lo necesita
            // y así aprovecha si el pager ya hizo prefetch.
            return DetailPostView(post: post);
          },
        ),
      ),
    );
  }

  void _prefetchAround(int center) {
    // Rango de prefetch: dos anteriores, actual y dos siguientes (buffer mayor)
    for (final i in [center - 2, center - 1, center, center + 1, center + 2]) {
      if (i < 0 || i >= widget.posts.length) continue;
      final p = widget.posts[i];
      if (p.type == model.PostType.image && p.imageUrl != null) {
        _precacheImage(context, p.imageUrl!);
      } else if (p.type == model.PostType.video && p.videoUrl != null) {
        // hacer prefetch por URL (esto no sube el contador de referencias)
        VideoControllerManager().prefetch(p.videoUrl!);
      }
    }
  }

  void _precacheImage(BuildContext context, String url) {
    precacheImage(NetworkImage(url), context);
  }
}

class _NoBallisticScrollPhysics extends PageScrollPhysics {
  const _NoBallisticScrollPhysics({super.parent});

  @override
  _NoBallisticScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      _NoBallisticScrollPhysics(parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // Return null to avoid any built-in ballistic animation when the user releases the drag.
    return null;
  }
}
