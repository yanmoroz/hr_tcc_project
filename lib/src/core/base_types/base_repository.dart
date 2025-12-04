import 'package:fpdart/fpdart.dart';

import 'result.dart';

mixin BaseRepository {
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
