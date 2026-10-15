import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/users_model.dart';

class UsersRepository {
  final ApiClient _client;

  UsersRepository(this._client);

  Future<List<UserModel>> listAsync() async {
    final dynamic jsonResponse = await _client.get(ApiConstants.users);

    if (jsonResponse is! List) {
      throw Exception('El formato de la respuesta no es una lista');
    }

    return jsonResponse
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
