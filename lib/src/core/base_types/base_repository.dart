import 'package:fpdart/fpdart.dart';

import 'result.dart';

/// Base repository mixin that provides common mapping utilities
/// for converting data models to domain entities.
mixin BaseRepository {
  /// Maps a Result containing a list of models to a list of entities.
  ///
  /// Handles the conversion from `Result<List<TModel>>`
  /// to `Result<List<TEntity>>` using the provided mapper function.
  Result<List<TEntity>> mapResultList<TModel, TEntity>(
    Result<List<TModel>> result,
    TEntity Function(TModel) mapper,
  ) {
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => mapper(model)).toList()),
    );
  }
}
