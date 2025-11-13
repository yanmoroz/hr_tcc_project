import 'package:freezed_annotation/freezed_annotation.dart';

import 'jira_avatar_urls_model.dart';

part 'jira_author_model.freezed.dart';
part 'jira_author_model.g.dart';

/// JIRA author model
@freezed
abstract class JiraAuthorModel with _$JiraAuthorModel {
  const factory JiraAuthorModel({
    required String self,
    required String name,
    required String key,
    String? emailAddress,
    JiraAvatarUrlsModel? avatarUrls,
    required String displayName,
    required bool active,
    String? timeZone,
  }) = _JiraAuthorModel;

  factory JiraAuthorModel.fromJson(Map<String, dynamic> json) => _$JiraAuthorModelFromJson(json);
}
