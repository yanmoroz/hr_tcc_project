import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/pluralization.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../users/users.dart';
import '../../domain/domain.dart';
import '../blocs/comments_page/bloc.dart';
import '../blocs/mention/bloc.dart';
import '../controllers/mention_text_editing_controller.dart';
import '../delegates/date_header_delegate.dart';
import '../widgets/attachment_picker_bottom_sheet.dart';
import '../widgets/comment_input_bar.dart';
import '../widgets/comment_item.dart';
import '../widgets/mention_overlay.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final MentionTextEditingController _commentController =
      MentionTextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _messageKeys = {};
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final entityType = context.read<CommentsBloc>().entityType;
    final entityName = context.read<CommentsBloc>().entityName;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.grey100,
        appBar: AppBar(
          title: BlocSelector<CommentsBloc, CommentsState, int>(
            selector: (state) => state.comments.length,
            builder: (context, commentCount) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Комментарии'),
                  if (commentCount > 0)
                    Text(
                      _getCommentCountText(commentCount),
                      style: AppTypography.textRegular2.grey700,
                    )
                  else
                    SizedBox(height: 18),
                ],
              );
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(switch (entityType) {
                        CommentableEntityType.news => 'Новости «$entityName»',
                        CommentableEntityType.discount =>
                          'Льготы и можности «$entityName»',
                      }, style: AppTypography.textRegular2.grey700),
                    ),
                  ],
                ),
              ),
            ),
            // Comments list with integrated header
            Expanded(
              child: MultiBlocListener(
                listeners: [
                  // Scroll to bottom and preload images on initial data load
                  BlocListener<CommentsBloc, CommentsState>(
                    listenWhen: (previous, current) {
                      return previous.status == LoadingStatus.loading &&
                          current.status == LoadingStatus.success;
                    },
                    listener: (context, state) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollToBottomSafely();
                      });
                      // Trigger preloading of image attachments
                      context.read<CommentsBloc>().add(
                        const CommentsEvent.preloadImageAttachments(),
                      );
                    },
                  ),
                  // Scroll to bottom and preload images when a comment is successfully added
                  BlocListener<CommentsBloc, CommentsState>(
                    listenWhen: (previous, current) {
                      return previous.isAddingComment == true &&
                          current.isAddingComment == false &&
                          current.status == LoadingStatus.success &&
                          current.comments.length > previous.comments.length;
                    },
                    listener: (context, state) {
                      scrollToBottomSafely();
                      // Preload images for new comment's attachments
                      context.read<CommentsBloc>().add(
                        const CommentsEvent.preloadImageAttachments(),
                      );
                    },
                  ),
                  // Handle attachment download completion
                  BlocListener<CommentsBloc, CommentsState>(
                    listenWhen: (previous, current) {
                      return previous.downloadingAttachment !=
                              current.downloadingAttachment &&
                          current.downloadingAttachment?.status ==
                              DownloadingAttachmentStatus.success;
                    },
                    listener: (context, state) {
                      final downloading = state.downloadingAttachment;
                      final data = downloading?.data;
                      if (downloading == null || data == null) return;

                      final attachment = _findAttachmentById(
                        comments: state.comments,
                        attachmentId: downloading.attachmentId,
                      );
                      final suggestedExtension = attachment?.extension;
                      final suggestedName = attachment?.name;

                      unawaited(
                        _openBytesWithOpenFilex(
                          context,
                          bytes: data,
                          fileName: _buildSafeFileName(
                            attachmentId: downloading.attachmentId,
                            name: suggestedName,
                            extension: suggestedExtension,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                child: BlocBuilder<CommentsBloc, CommentsState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.groupedComments != current.groupedComments ||
                      previous.preloadedImages != current.preloadedImages,
                  builder: (context, state) {
                    return switch (state.status) {
                      LoadingStatus.initial => _buildLoadingState(
                        context,
                        state,
                      ),
                      LoadingStatus.loading => _buildLoadingState(
                        context,
                        state,
                      ),
                      LoadingStatus.error => _buildErrorState(context, state),
                      LoadingStatus.success => _buildLoadedState(
                        context,
                        state,
                      ),
                    };
                  },
                ),
              ),
            ),

            // Mention user list
            BlocBuilder<MentionCubit, MentionState>(
              builder: (context, mentionState) {
                if (mentionState.status == MentionStatus.idle) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: MentionOverlay(
                    users: mentionState.users,
                    isLoading: mentionState.status == MentionStatus.loading,
                    onUserSelected: _onUserSelected,
                  ),
                );
              },
            ),
            // Comment input bar
            BlocBuilder<CommentsBloc, CommentsState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status ||
                  previous.isAddingComment != current.isAddingComment ||
                  previous.replyingToComment != current.replyingToComment ||
                  previous.uploadingFiles != current.uploadingFiles,
              builder: (context, state) {
                if (state.status != LoadingStatus.success) {
                  return const SizedBox.shrink();
                }

                return CommentInputBar(
                  controller: _commentController,
                  focusNode: _inputFocusNode,
                  isAddingComment: state.isAddingComment,
                  replyingToComment: state.replyingToComment,
                  uploadingFiles: state.uploadingFiles,
                  onSend: (content, parentId) {
                    context.read<CommentsBloc>().add(
                      CommentsEvent.addComment(
                        content: content,
                        parentId: parentId,
                      ),
                    );
                  },
                  onCancelReply: () {
                    context.read<CommentsBloc>().add(
                      const CommentsEvent.cancelReply(),
                    );
                  },
                  onAttachmentTap: () => _showAttachmentPicker(context),
                  onRemoveFile: (fileId) {
                    context.read<CommentsBloc>().add(
                      CommentsEvent.removeAttachment(fileId),
                    );
                  },
                  onCancelUpload: (fileId) {
                    context.read<CommentsBloc>().add(
                      CommentsEvent.cancelAttachmentUpload(fileId),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.removeListener(_onTextChanged);
    _commentController.dispose();
    _inputFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_onTextChanged);
  }

  Future<void> jumpToMessage(int? parentId) async {
    if (parentId == null) return;
    final key = _messageKeys.putIfAbsent(parentId, () => GlobalKey());
    if (!_scrollController.hasClients) return;

    // Try immediately (in case it's already built), then do a bounded search.
    await SchedulerBinding.instance.endOfFrame;
    if (key.currentContext == null) {
      await _scrollSearchForKey(
        key,
        startOffset: _scrollController.position.maxScrollExtent,
        forward: false,
      );
    }
    if (key.currentContext == null) {
      await _scrollSearchForKey(
        key,
        startOffset: _scrollController.position.minScrollExtent,
        forward: true,
      );
    }
    if (key.currentContext == null) return;

    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.5, // center it (0 = top, 1 = bottom)
    );
  }

  Future<void> scrollToBottomSafely() async {
    if (!_scrollController.hasClients) return;

    // Content height can change after this call (images, pinned headers, keyboard).
    // Retry a few times until we're truly at the bottom.
    for (var i = 0; i < 10; i++) {
      if (!_scrollController.hasClients) return;
      await SchedulerBinding.instance.endOfFrame;
      if (!_scrollController.hasClients) return;

      final pos = _scrollController.position;
      if (pos.extentAfter <= 2.0) return; // close enough

      _scrollController.jumpTo(pos.maxScrollExtent);
      // Give layout a moment to settle before checking again.
      await Future.delayed(const Duration(milliseconds: 24));
    }
  }

  Widget _buildCommentItem(
    Comment comment,
    String? parentAuthorName,
    String? parentComment,
    bool isLastInGroup,
    Map<int, Uint8List> preloadedImages,
  ) {
    _messageKeys.putIfAbsent(comment.id, () => GlobalKey());

    return CommentItem(
      key: _messageKeys[comment.id],
      comment: comment,
      parentAuthorName: parentAuthorName,
      parentComment: parentComment,
      isLastInGroup: isLastInGroup,
      preloadedImages: preloadedImages,
      onLike: () {
        context.read<CommentsBloc>().add(
          CommentsEvent.toggleCommentLike(comment.id),
        );
      },
      onDelete: comment.editable
          ? () {
              _showDeleteDialog(context, comment.id);
            }
          : null,
      onReply: () {
        context.read<CommentsBloc>().add(CommentsEvent.startReply(comment));
        // Focus the input field after state update
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _inputFocusNode.requestFocus();
        });
      },
      onParentTap: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          jumpToMessage(comment.parent);
        });
      },
      onMentionTap: (mentionName) {
        context.go(
          Uri(
            path: '/contacts',
            queryParameters: {'search': mentionName},
          ).toString(),
        );
      },
      onAttachmentTap: (attachment) => _openAttachment(attachment),
    );
  }

  Widget _buildErrorState(BuildContext context, CommentsState state) {
    return NetworkErrorMessageWidget(
      onRetry: () =>
          context.read<CommentsBloc>().add(const CommentsEvent.loadComments()),
    );
  }

  Widget _buildLoadedState(BuildContext context, CommentsState state) {
    final commentsById = <int, Comment>{
      for (final c in state.comments) c.id: c,
    };

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Build SliverMainAxisGroups for each date group
        ...state.groupedComments.reversed.map((group) {
          return SliverMainAxisGroup(
            slivers: [
              // Date header
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: DateHeaderDelegate(date: group.date),
                ),
              ),
              // Comments list for this date
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, commentIndex) {
                    final comment = group.comments[commentIndex];
                    final isLastInGroup =
                        commentIndex == group.comments.length - 1;
                    final parent = comment.parent != null
                        ? commentsById[comment.parent!]
                        : null;
                    final parentAuthorName = parent?.author.title;
                    final parentComment = parent?.content;

                    return _buildCommentItem(
                      comment,
                      parentAuthorName,
                      parentComment,
                      isLastInGroup,
                      state.preloadedImages,
                    );
                  }, childCount: group.comments.length),
                ),
              ),
            ],
          );
        }),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context, CommentsState state) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverShimmeringList(spacing: 16, maxHeight: 100),
        ),
      ],
    );
  }

  String _buildSafeFileName({
    required int attachmentId,
    String? name,
    String? extension,
  }) {
    final sanitizedName = _sanitizeFileName(name?.trim());
    final fallbackExtension = _sanitizeExtension(extension) ?? 'png';

    if (sanitizedName == null || sanitizedName.isEmpty) {
      return 'attachment_$attachmentId.$fallbackExtension';
    }

    // If backend already provides a name with extension, keep it.
    if (sanitizedName.contains('.') && !sanitizedName.endsWith('.')) {
      return sanitizedName;
    }

    return '$sanitizedName.$fallbackExtension';
  }

  Attachment? _findAttachmentById({
    required List<Comment> comments,
    required int attachmentId,
  }) {
    for (final comment in comments) {
      final attachments = comment.attachments;
      if (attachments == null || attachments.isEmpty) continue;

      for (final attachment in attachments) {
        if (attachment.id == attachmentId) return attachment;
      }
    }
    return null;
  }

  String _getCommentCountText(int count) {
    return pluralizeRu(
      count,
      '$count комментарий',
      '$count комментария',
      '$count комментариев',
    );
  }

  bool _isImageAttachment(Attachment attachment) {
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    return imageExtensions.contains(attachment.extension.toLowerCase()) ||
        attachment.thumbnail != null;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _onTextChanged() {
    final mentionContext = _commentController.getMentionContext();
    final mentionCubit = context.read<MentionCubit>();

    if (mentionContext != null) {
      mentionCubit.searchUsers(mentionContext.query);
    } else {
      mentionCubit.clearMention();
    }
  }

  void _onUserSelected(User user) {
    final mentionContext = _commentController.getMentionContext();
    if (mentionContext != null) {
      _commentController.insertMention(user, mentionContext);
    }
    context.read<MentionCubit>().clearMention();
  }

  void _openAttachment(Attachment attachment) {
    if (_isImageAttachment(attachment)) {
      context.read<CommentsBloc>().add(
        CommentsEvent.fetchAttachment(attachment),
      );
    } else {
      _launchUrl(attachment.url);
    }
  }

  Future<void> _openBytesWithOpenFilex(
    BuildContext context, {
    required Uint8List bytes,
    required String fileName,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    final result = await OpenFilex.open(file.path);
    if (!context.mounted) return;

    if (result.type == ResultType.done) return;

    // Silent failure by default (matches existing "handle silently" approach),
    // but leave a minimal log surface via SnackBar for better debuggability.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.message.isNotEmpty
              ? result.message
              : 'Не удалось открыть файл',
        ),
      ),
    );
  }

  Future<void> _pickDocuments(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result == null || result.files.isEmpty || !context.mounted) return;

      final files = result.files
          .where((file) => file.path != null)
          .map((file) => File(file.path!))
          .where(
            (file) =>
                file.existsSync() &&
                !FileSystemEntity.isDirectorySync(file.path),
          )
          .toList();

      if (files.isNotEmpty) {
        context.read<CommentsBloc>().add(CommentsEvent.addAttachments(files));
      }
    } catch (e) {
      // Handle error silently or show a snackbar
    }
  }

  Future<void> _pickPhotos(BuildContext context) async {
    try {
      final images = await _imagePicker.pickMultiImage();
      if (images.isEmpty || !context.mounted) return;

      final files = images.map((xFile) => File(xFile.path)).toList();
      context.read<CommentsBloc>().add(CommentsEvent.addAttachments(files));
    } catch (e) {
      // Handle error silently or show a snackbar
    }
  }

  String? _sanitizeExtension(String? extension) {
    final ext = extension?.trim().toLowerCase();
    if (ext == null || ext.isEmpty) return null;
    return ext.replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  String? _sanitizeFileName(String? name) {
    if (name == null) return null;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;
    // Replace path separators + characters commonly invalid across platforms.
    final sanitized = trimmed.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '_').trim();
    return sanitized.isEmpty ? null : sanitized;
  }

  Future<void> _scrollSearchForKey(
    GlobalKey key, {
    required double startOffset,
    required bool forward,
  }) async {
    if (!_scrollController.hasClients) return;

    // Jump first, then advance in viewport-sized steps while the item builds.
    final position = _scrollController.position;
    final clampedStart = startOffset.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    _scrollController.jumpTo(clampedStart);

    // If layout is still settling, wait a frame so slivers can build children.
    await SchedulerBinding.instance.endOfFrame;
    if (key.currentContext != null || !_scrollController.hasClients) return;

    final step =
        (position.viewportDimension > 0
                ? position.viewportDimension * 0.8
                : 300.0)
            .clamp(120.0, 800.0);

    // Bounded search: enough to cover long lists, but avoids infinite loops.
    for (var i = 0; i < 60; i++) {
      if (!_scrollController.hasClients) return;
      if (key.currentContext != null) return;

      final pos = _scrollController.position;
      final next = forward ? (pos.pixels + step) : (pos.pixels - step);
      final clampedNext = next.clamp(pos.minScrollExtent, pos.maxScrollExtent);

      // Can't move further.
      if ((clampedNext - pos.pixels).abs() < 0.5) return;

      _scrollController.jumpTo(clampedNext);
      await SchedulerBinding.instance.endOfFrame;
    }
  }

  void _showAttachmentPicker(BuildContext context) {
    AttachmentPickerBottomSheet.show(
      context,
      onPickPhoto: () => _pickPhotos(context),
      onPickDocument: () => _pickDocuments(context),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, int commentId) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: 'Удалить комментарий',
      content: 'Вы уверены, что хотите удалить этот комментарий?',
      confirmText: 'Удалить',
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      context.read<CommentsBloc>().add(CommentsEvent.deleteComment(commentId));
    }
  }
}
