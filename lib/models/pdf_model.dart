class PdfModel {
  final String id;
  final String filePath;
  final String fileName;
  final int pageNumber;
  final DateTime lastSeen;

  final bool isOpened;
  final String? networkUrl;

  PdfModel({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.pageNumber,
    required this.lastSeen,
    this.networkUrl,
    this.isOpened = false,
  });
  factory PdfModel.fromJson(Map<String, dynamic> json) {
    return PdfModel(
      id: json['id'] ?? '',
      filePath: json['filePath'] ?? '',
      fileName: json['fileName'] ?? '',
      pageNumber: json['pageNumber'] ?? 0,
      lastSeen: DateTime.parse(json['lastSeen']),
      networkUrl: json['networkUrl'] ?? '',
      isOpened: json['isOpened'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'fileName': fileName,
      'pageNumber': pageNumber,
      'lastSeen': lastSeen.toIso8601String(),
      'networkUrl': networkUrl,
      'isOpened': isOpened,
    };
  }

  @override
  String toString() {
    return 'PdfModel(id: $id, filePath: $filePath, pageNumber: $pageNumber, lastSeen: $lastSeen, networkUrl: $networkUrl, isOpened: $isOpened fileName: $fileName )';
  }

  PdfModel copyWith({
    String? id,
    String? filePath,
    String? fileName,
    int? pageNumber,
    DateTime? lastSeen,
    String? networkUrl,
    bool? isOpened,
  }) {
    return PdfModel(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: filePath ?? this.fileName,
      pageNumber: pageNumber ?? this.pageNumber,
      lastSeen: lastSeen ?? this.lastSeen,
      networkUrl: networkUrl ?? this.networkUrl,
      isOpened: isOpened ?? this.isOpened,
    );
  }
}
