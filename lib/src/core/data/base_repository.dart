import 'package:fpdart/fpdart.dart';

import '../exceptions/network/network_exception.dart';

/// Base repository mixin that provides common mapping utilities
/// for converting data models to domain entities.
mixin BaseRepository {
  /// Maps an Either result containing a list of models to a list of entities.
  ///
  /// Handles the conversion from `Either<NetworkException, List<TModel>>`
  /// to `Either<NetworkException, List<TEntity>>` using the provided mapper function.
  Either<NetworkException, List<TEntity>> mapResultList<TModel, TEntity>(
    Either<NetworkException, List<TModel>> result,
    TEntity Function(TModel) mapper,
  ) {
    return result.fold((failure) => Left(failure), (models) => Right(models.map((model) => mapper(model)).toList()));
  }

  /// Maps an Either result containing a single model to a single entity.
  ///
  /// Handles the conversion from `Either<NetworkException, TModel>`
  /// to `Either<NetworkException, TEntity>` using the provided mapper function.
  Either<NetworkException, TEntity> mapResult<TModel, TEntity>(
    Either<NetworkException, TModel> result,
    TEntity Function(TModel) mapper,
  ) {
    return result.fold((failure) => Left(failure), (model) => Right(mapper(model)));
  }
}
