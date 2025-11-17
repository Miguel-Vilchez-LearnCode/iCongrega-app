import 'package:flutter/material.dart';

// Unified post types for feed and detail views
enum PostType { image, video, verse }

class PostItem {
  final int? id;
  final PostType type;

  // Common metadata
  final String user;
  final String role;
  final String imageUser;
  final String imageChurch;
  final String fecha;
  final String description; // for image/video; can be empty for verse

  // Content variants
  final String? imageUrl; // for image
  final String? videoUrl; // for video
  final String? verse; // for verse
  final Color? backgroundColor; // for verse background

  // Social numbers
  final String likesText;
  final String commentsText;
  // Social flags
  final bool isLiked;

  const PostItem({
    this.id,
    required this.type,
    required this.user,
    required this.role,
    required this.imageUser,
    required this.imageChurch,
    required this.fecha,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    this.verse,
    this.backgroundColor,
    this.likesText = '0',
    this.commentsText = '0',
    this.isLiked = false,
  });
}
