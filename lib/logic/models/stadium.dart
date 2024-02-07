class Stadium {
  final int size;
  final String name;

  Stadium({required this.size, required this.name});

  factory Stadium.fromJson(Map<String, dynamic> json) {
    return Stadium(
      size: json['size'],
      name: json['name'],
    );
  }
}
