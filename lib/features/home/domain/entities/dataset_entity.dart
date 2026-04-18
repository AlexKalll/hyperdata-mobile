import 'package:leyu_mobile/features/home/data/models/dataset.dart';


class DatasetEntity {
  final String id;
  final String? textDataset;
  final String? filePath;
  final List<String> rejectionReasons;
  final String? comment;

  DatasetEntity({
    required this.id,
    this.textDataset,
    this.filePath,
    this.rejectionReasons = const [],
    this.comment,
  });

  static DatasetEntity fromModel(Dataset model) {
    return DatasetEntity(
      id: model.id,
      textDataset: model.textDataset,
      filePath: model.filePath,
      rejectionReasons: model.rejectionReasons ?? [],
      comment: model.comment,
    );
  }
}