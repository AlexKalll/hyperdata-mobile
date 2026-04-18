
class Dataset {
  final String id;
  final String? textDataset;
  final String? filePath;
  final List<String>? rejectionReasons;
  final String? comment;

  Dataset({
    required this.id,
    this.textDataset,
    this.filePath,
    this.rejectionReasons,
    this.comment,
  });

  factory Dataset.fromJson(Map<String, dynamic> json) {
    return Dataset(
      id: json['id'] as String,
      textDataset: json['text_data_set'] as String?,
      filePath: json['file_path'] as String?,
      rejectionReasons: (json['rejectionReasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      comment: json['comment'] as String?,
    );
  }
}