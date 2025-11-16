import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';
import 'author_model.dart';

part 'news_detail_model.freezed.dart';
part 'news_detail_model.g.dart';

@freezed
abstract class NewsDetailModel with _$NewsDetailModel {
  const factory NewsDetailModel({
    required int id,
    required String title,
    required String content,
    required DateTime createdData,
    required AuthorModel author,
    String? image,
  }) = _NewsDetailModel;

  factory NewsDetailModel.fromJson(Map<String, dynamic> json) =>
      _$NewsDetailModelFromJson(json);
}

extension NewsDetailModelX on NewsDetailModel {
  NewsDetail toDomain() => NewsDetail(
    id: id,
    title: title,
    content: content,
    createdData: createdData,
    author: author.toDomain(),
    image: image,
  );
}
