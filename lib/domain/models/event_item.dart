// Model for events used across the app.
// Fields derived from `register_preview_step.dart` (preview form).
class EventItem {
  final int? id;
  final String title;
  final String description;
  final String? imagePath;
  final int type;
  final String time; 
  final String day;
  final String month;     
  final String address;
  final String reference;
  final String locationImage; 
  final String user; 
  final List<String> labels;
  final List<EventFeature> features;
  final List<EventOrganizer> organizers;
  final DateTime? createdAt;

  EventItem({
    this.id,
    required this.title,
    required this.description,
    this.imagePath,
    this.type = 0,
    required this.time,
    required this.day,
    required this.month,
    required this.address,
    required this.reference,
    this.locationImage = 'assets/images/mapa.png',
    this.user = 'Iglesia',
    List<String>? labels,
    List<EventFeature>? features,
    List<EventOrganizer>? organizers,
    this.createdAt,
  })  : labels = labels ?? const [],
        features = features ?? const [],
        organizers = organizers ?? const [];

  EventItem copyWith({
    int? id,
    String? title,
    String? description,
    String? imagePath,
    int? type,
    String? time,
    String? day,
    String? month,
    String? address,
    String? reference,
    String? locationImage,
    String? user,
    List<String>? labels,
    List<EventFeature>? features,
    List<EventOrganizer>? organizers,
    DateTime? createdAt,
  }) {
    return EventItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
      time: time ?? this.time,
      day: day ?? this.day,
      month: month ?? this.month,
      address: address ?? this.address,
      reference: reference ?? this.reference,
      locationImage: locationImage ?? this.locationImage,
      user: user ?? this.user,
      labels: labels ?? List.from(this.labels),
      features: features ?? List.from(this.features),
      organizers: organizers ?? List.from(this.organizers),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory EventItem.fromMap(Map<String, dynamic> m) {
    return EventItem(
      id: m['id'] as int?,
      title: (m['title'] ?? '') as String,
      description: (m['description'] ?? '') as String,
      imagePath: m['imagePath'] as String?,
      type: (m['type'] is int) ? m['type'] as int : int.tryParse('${m['type']}') ?? 0,
      time: (m['time'] ?? '') as String,
      day: (m['day'] ?? '') as String,
      month: (m['month'] ?? m['mon'] ?? '') as String,
      address: (m['address'] ?? '') as String,
      reference: (m['reference'] ?? '') as String,
      locationImage: (m['locationImage'] ?? m['location'] ?? 'assets/images/mapa.png') as String,
      user: (m['user'] ?? 'Iglesia') as String,
      labels: (m['labels'] is List) ? List<String>.from(m['labels'] as List) : <String>[],
      features: (m['features'] is List)
          ? (m['features'] as List).map((e) => EventFeature.fromMap(Map<String, dynamic>.from(e as Map))).toList()
          : <EventFeature>[],
      organizers: (m['organizers'] is List)
          ? (m['organizers'] as List).map((e) => EventOrganizer.fromMap(Map<String, dynamic>.from(e as Map))).toList()
          : <EventOrganizer>[],
      createdAt: m['createdAt'] != null ? DateTime.tryParse(m['createdAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'type': type,
      'time': time,
      'day': day,
      'month': month,
      'address': address,
      'reference': reference,
      'locationImage': locationImage,
      'user': user,
      'labels': labels,
      'features': features.map((f) => f.toMap()).toList(),
      'organizers': organizers.map((o) => o.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() => 'EventItem(id: $id, title: $title, day: $day $month, time: $time)';
}

class EventFeature {
  final String name;
  /// icon key string used by the app to select an IconData (see register_preview_step)
  final String iconKey;

  EventFeature({required this.name, required this.iconKey});

  factory EventFeature.fromMap(Map<String, dynamic> m) {
    return EventFeature(
      name: (m['name'] ?? '') as String,
      iconKey: (m['icon'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {'name': name, 'icon': iconKey};

  @override
  String toString() => 'EventFeature(name: $name, icon: $iconKey)';
}

class EventOrganizer {
  final String name;
  final String role;
  final String? imageUrl;
  final String? imagePath;

  EventOrganizer({required this.name, required this.role, this.imageUrl, this.imagePath});

  factory EventOrganizer.fromMap(Map<String, dynamic> m) {
    return EventOrganizer(
      name: (m['name'] ?? '') as String,
      role: (m['role'] ?? '') as String,
      imageUrl: m['imageUrl'] as String?,
      imagePath: m['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'role': role,
        'imageUrl': imageUrl,
        'imagePath': imagePath,
      };

  @override
  String toString() => 'EventOrganizer(name: $name, role: $role)';
}
