import 'package:freezed_annotation/freezed_annotation.dart';

part 'jira_avatar_urls.freezed.dart';

@freezed
sealed class JiraAvatarUrls with _$JiraAvatarUrls {
  const factory JiraAvatarUrls({
    String? size48,
    String? size24,
    String? size16,
    String? size32,
  }) = _JiraAvatarUrls;
}
