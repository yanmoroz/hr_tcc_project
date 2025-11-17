import '../../../../core/base_types/base_repository.dart';
import '../../../../core/base_types/result.dart';
import '../../domain/domain.dart';
import '../data.dart';

class CommentRepositoryImpl with BaseRepository implements CommentRepository {
  final CommentRemoteDataSource _remoteDataSource;

  CommentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Comment>>> getNewsComments(int newsId) async {
    final result = await _remoteDataSource.getNewsComments(newsId);
    return result.map(
      (response) => response.comments.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<Result<List<Comment>>> getDiscountComments(int discountId) async {
    final result = await _remoteDataSource.getDiscountComments(discountId);
    return result.map(
      (response) => response.comments.map((model) => model.toDomain()).toList(),
    );
  }

  @override
  Future<Result<Comment>> addNewsComment({
    required int newsId,
    required String content,
    int? parent,
    List<int>? attachments,
  }) async {
    final request = AddCommentRequest(
      parent: parent,
      content: content,
      attachments: attachments,
    );
    final result = await _remoteDataSource.addNewsComment(newsId, request);
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<Comment>> addDiscountComment({
    required int discountId,
    required String content,
    int? parent,
    List<int>? attachments,
  }) async {
    final request = AddCommentRequest(
      parent: parent,
      content: content,
      attachments: attachments,
    );
    final result = await _remoteDataSource.addDiscountComment(
      discountId,
      request,
    );
    return result.map((model) => model.toDomain());
  }

  @override
  Future<Result<List<int>>> deleteNewsComment({
    required int newsId,
    required int commentId,
  }) async {
    final result = await _remoteDataSource.deleteNewsComment(newsId, commentId);
    return result.map((response) => response.removedIds);
  }

  @override
  Future<Result<List<int>>> deleteDiscountComment({
    required int discountId,
    required int commentId,
  }) async {
    final result = await _remoteDataSource.deleteDiscountComment(
      discountId,
      commentId,
    );
    return result.map((response) => response.removedIds);
  }

  @override
  Future<Result<bool>> toggleDiscountCommentLike(
    int discountId,
    int commentId,
  ) async {
    return await _remoteDataSource.toggleDiscountCommentLike(
      discountId,
      commentId,
    );
  }

  @override
  Future<Result<bool>> toggleNewsCommentLike(int newsId, int commentId) async {
    return await _remoteDataSource.toggleNewsCommentLike(newsId, commentId);
  }
}
