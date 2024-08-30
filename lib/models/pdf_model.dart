class PdfModel {
  final int id;
  final String filePath;
  final int pageNumber;
  final DateTime lastSeen;
  final String? networkUrl;

  PdfModel({
    required this.id,
    required this.filePath,
    required this.pageNumber,
    required this.lastSeen,
    this.networkUrl,
  });
  factory PdfModel.fromJson(Map<String, dynamic> json) {
    return PdfModel(
      id: json['id'],
      filePath: json['filePath'] ?? '',
      pageNumber: json['pageNumber'] ?? 0,
      lastSeen: DateTime.parse(json['lastSeen']),
      networkUrl: json['networkUrl'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'pageNumber': pageNumber,
      'lastSeen': lastSeen.toIso8601String(),
      'networkUrl': networkUrl,
    };
  }

  @override
  String toString() {
    return 'PdfModel(id: $id, filePath: $filePath, pageNumber: $pageNumber, lastSeen: $lastSeen, networkUrl: $networkUrl)';
  }

  PdfModel copyWith({
    int? id,
    String? filePath,
    int? pageNumber,
    DateTime? lastSeen,
    String? networkUrl,
  }) {
    return PdfModel(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      pageNumber: pageNumber ?? this.pageNumber,
      lastSeen: lastSeen ?? this.lastSeen,
      networkUrl: networkUrl ?? this.networkUrl,
    );
  }
}
