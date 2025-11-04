import 'package:hr_tcc_project/src/core/data/base_repository.dart';
import 'package:hr_tcc_project/src/core/types/result.dart';

import '../../domain/domain.dart';
import '../data.dart';

class CommentRepositoryImpl with BaseRepository implements CommentRepository {
  final CommentRemoteDataSource _remoteDataSource;

  CommentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Comment>>> getComments(int discountId) async {
    final result = await _remoteDataSource.getComments(discountId);
    return mapResult(result, (response) => response.comments.map((model) => model.toDomain()).toList());
  }

  @override
  Future<Result<Comment>> addComment({
    required int discountId,
    required String content,
    int? parent,
    List<int>? attachments,
  }) async {
    final request = AddCommentRequest(parent: parent, content: content, attachments: attachments);
    final result = await _remoteDataSource.addComment(discountId, request);
    return mapResult(result, (model) => model.toDomain());
  }

  @override
  Future<Result<List<int>>> deleteComment({required int discountId, required int commentId}) async {
    final result = await _remoteDataSource.deleteComment(discountId, commentId);
    return mapResult(result, (response) => response.removedIds);
  }
}
