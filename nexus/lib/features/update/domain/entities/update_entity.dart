class UpdateEntity {
  final int build;
  final String version;
  
  final String sha256;
  final String downloadUrl;

  final DateTime createdAt;

  const new({
    required this.build,
    required this.sha256,
    required this.version,
    required this.createdAt,
    required this.downloadUrl,
  });
}