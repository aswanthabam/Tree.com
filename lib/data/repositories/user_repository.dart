import 'package:either_dart/either.dart';

import '../datasources/user_data_source.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserDataSource _dataSource;

  UserRepository(this._dataSource);

  Future<Either<TokenData, String>> register(
      String email, String name, String password) async {
    return await _dataSource.register(email, name, password);
  }

  Future<Either<TokenData, String>> login(String email, String password) async {
    return await _dataSource.login(email, password);
  }
}
