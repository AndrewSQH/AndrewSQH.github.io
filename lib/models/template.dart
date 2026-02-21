class Template {
  final String id;
  final String name;
  final String borderColor;
  final String backgroundColor;
  final double borderWidth;
  final double borderRadius;
  final String filterName;
  final String? imagePath;

  Template({
    required this.id,
    required this.name,
    required this.borderColor,
    required this.backgroundColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.filterName,
    this.imagePath,
  });

  factory Template.fromMap(Map<String, dynamic> map) {
    return Template(
      id: map['id'] as String,
      name: map['name'] as String,
      borderColor: map['borderColor'] as String,
      backgroundColor: map['backgroundColor'] as String,
      borderWidth: map['borderWidth'] as double,
      borderRadius: map['borderRadius'] as double,
      filterName: map['filterName'] as String,
      imagePath: map['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'borderColor': borderColor,
      'backgroundColor': backgroundColor,
      'borderWidth': borderWidth,
      'borderRadius': borderRadius,
      'filterName': filterName,
      'imagePath': imagePath,
    };
  }
}
