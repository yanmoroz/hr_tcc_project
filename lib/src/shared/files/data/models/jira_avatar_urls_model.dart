import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'jira_avatar_urls_model.freezed.dart';
part 'jira_avatar_urls_model.g.dart';

@freezed
abstract class JiraAvatarUrlsModel with _$JiraAvatarUrlsModel {
  const factory JiraAvatarUrlsModel({
    @JsonKey(name: '48x48') String? size48,
    @JsonKey(name: '24x24') String? size24,
    @JsonKey(name: '16x16') String? size16,
    @JsonKey(name: '32x32') String? size32,
  }) = _JiraAvatarUrlsModel;

  factory JiraAvatarUrlsModel.fromJson(Map<String, dynamic> json) =>
      _$JiraAvatarUrlsModelFromJson(json);
}

extension JiraAvatarUrlsModelX on JiraAvatarUrlsModel {
  JiraAvatarUrls toDomain() {
    return JiraAvatarUrls(
      size48: size48,
      size24: size24,
      size16: size16,
      size32: size32,
    );
  }
}
