import 'package:leyu_mobile/features/auth/domain/entities/dialect_entity.dart';
import 'package:leyu_mobile/features/auth/domain/entities/language_entity.dart';

import '../../../../core/utils/message.dart';
import '../repositories/base_data_repository.dart';

class BaseDataUsecase{

  final BaseDataRepository _baseDataRepository;
  BaseDataUsecase(this._baseDataRepository);

  Future<List<LanguageEntity>> getLanguages({String? searchQuery}) async {
    final result =  await _baseDataRepository.getLanguages();
    return result.fold((failure){
      showErrorMessage("Fetching languages failed: ${failure.message}");
      return [];
    }, (categories){
      return categories.map<LanguageEntity>((e) => LanguageEntity.fromModel(e)).toList();
    });
  }
  Future<List<DialectEntity>> getDialects(String languageId) async {
    final result = await _baseDataRepository.getDialects(languageId);
    return result.fold((failure){
      showErrorMessage("Fetching dialects failed: ${failure.message}");
      return [];
    }, (dialects){
      return dialects.map<DialectEntity>((e) => DialectEntity.fromModel(e)).toList();
    });
  }
}