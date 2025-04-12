class DocumentModel {
  final String name;
  final String path;
  final String folderName;

  DocumentModel({
    required this.name,
    required this.path,
    required this.folderName,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'path': path,
    'folderName': folderName,
  };

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
    name: json['name'],
    path: json['path'],
    folderName: json['folderName'],
  );
}