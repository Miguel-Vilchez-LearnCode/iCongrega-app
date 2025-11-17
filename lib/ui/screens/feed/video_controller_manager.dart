// lib/video_controller_manager.dart
import 'package:video_player/video_player.dart';

class VideoControllerManager {
  VideoControllerManager._private();
  static final VideoControllerManager _instance =
      VideoControllerManager._private();
  factory VideoControllerManager() => _instance;

  final Map<String, _Entry> _cache = {};

  /// Asegura que haya un entry para la url y sube el contador en 1.
  /// Si no existía, crea el controller y lo inicializa en background.
  void ensureController(String url) {
    if (url.isEmpty) return;
    final existing = _cache[url];
    if (existing != null) {
      existing.refs++;
      return;
    }
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    final initFuture = controller.initialize().then((_) {
      try {
        controller.setLooping(true);
      } catch (_) {}
    });
    _cache[url] = _Entry(controller, initFuture, 1);
  }

  /// Prefetch: inicializa el controller pero NO sube el contador (refs = 0).
  Future<void> prefetch(String url) {
    if (url.isEmpty) return Future.value();
    final existing = _cache[url];
    if (existing != null) {
      // si existe, ya tenemos initFuture
      return existing.initFuture ?? Future.value();
    }
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    final initFuture = controller.initialize().then((_) {
      try {
        controller.setLooping(true);
      } catch (_) {}
    });
    _cache[url] = _Entry(controller, initFuture, 0);
    return initFuture;
  }

  /// Devuelve el controller (o null si aún no se creó)
  VideoPlayerController? controllerFor(String url) => _cache[url]?.controller;

  /// Devuelve el Future de inicialización (o null)
  Future<void>? initFutureFor(String url) => _cache[url]?.initFuture;

  /// Baja el contador y dispone el controller cuando llega a 0.
  void releaseController(String url) {
    final entry = _cache[url];
    if (entry == null) return;
    entry.refs--;
    if (entry.refs <= 0) {
      try {
        entry.controller.dispose();
      } catch (_) {}
      _cache.remove(url);
    }
  }

  /// Dice si el manager ya conoce la URL (para debug o logs)
  bool contains(String url) => _cache.containsKey(url);
}

class _Entry {
  final VideoPlayerController controller;
  Future<void>? initFuture;
  int refs;
  _Entry(this.controller, this.initFuture, this.refs);
}
