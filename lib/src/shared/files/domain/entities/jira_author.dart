import 'package:freezed_annotation/freezed_annotation.dart';

import 'jira_avatar_urls.dart';

part 'jira_author.freezed.dart';

@freezed
sealed class JiraAuthor with _$JiraAuthor {
  const factory JiraAuthor({
    required String self,
    required String name,
    required String key,
    String? emailAddress,
    JiraAvatarUrls? avatarUrls,
    required String displayName,
    required bool active,
    String? timeZone,
  }) = _JiraAuthor;
}
