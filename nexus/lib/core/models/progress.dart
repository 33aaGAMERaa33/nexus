class Progress {
  final int count;
  final int total;
  double get progress => count / total;

  const new({
    required this.count, 
    required this.total,
  });
}