import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/pluralization.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../g2g/users/users.dart';
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
                    color: Colors.black.withValues(alpha: 0.1),
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
                      final data = state.downloadingAttachment?.data;
                      if (data != null) {
                        _showImageViewer(context, data);
                      }
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
    final key = _messageKeys[parentId];

    if (key?.currentContext == null) {
      // First jump near top (or bottom, depending on your UX)
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);

      await Future.delayed(const Duration(milliseconds: 50));
    }

    if (key?.currentContext == null) return;

    Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.5, // center it (0 = top, 1 = bottom)
    );
  }

  Future<void> scrollToBottomSafely() async {
    if (!_scrollController.hasClients) return;

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    await Future.delayed(const Duration(milliseconds: 50), () {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent + 300,
      );
    });
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
                    final parentAuthorName = comment.parent != null
                        ? state.comments
                              .where((c) => c.id == comment.parent)
                              .firstOrNull
                              ?.author
                              .title
                        : null;
                    final parentComment = comment.parent != null
                        ? state.comments
                              .where((c) => c.id == comment.parent)
                              .firstOrNull
                              ?.content
                        : null;

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

  void _showImageViewer(BuildContext context, Uint8List imageData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(color: Colors.black87),
            ),
            InteractiveViewer(
              child: Center(
                child: Image.memory(imageData, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
