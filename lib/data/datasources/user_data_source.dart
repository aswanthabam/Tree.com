import 'package:either_dart/either.dart';
import 'package:tree_com/core/utils/api.dart';
import 'package:tree_com/data/models/user_model.dart';

class UserDataSource {
  final API api;

  const UserDataSource(this.api);

  Future<Either<TokenData, String>> register(
      String email, String name, String password) async {
    final response = await api.post(
        'user/register', {'email': email, 'password': password, 'name': name});
    if (response.hasError || response.data['accessToken'] == null) {
      return Right(response.message);
    }
    return Left(
        TokenData(accessToken: response.data['accessToken'], email: email));
  }

  Future<Either<TokenData, String>> login(String email, String password) async {
    final response = await api.post('user/login', {'email': email, 'password': password});
    print(response);
    if (response.hasError || response.data['accessToken'] == null) {
      return Right(response.message);
    }
    return Left(
        TokenData(accessToken: response.data['accessToken'], email: email));
  }
}
