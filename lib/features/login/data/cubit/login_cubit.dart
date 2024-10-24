import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task/core/helper/dio_helper.dart';
import 'package:task/core/helper/storage_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  DioHelper dioHelper = DioHelper();

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      final response = await dioHelper.post(
        'api/customer/login',
        {'username': email, 'password': password},
      );

      var data = response.data['data'][0]; // Access the data array
      String accessToken = data['access_token'];
      String refreshToken = data['refresh_token'];
      await StorageHelper.instance
          .write(key: 'accessToken', value: accessToken);
      await StorageHelper.instance
          .write(key: 'refreshToken', value: refreshToken);
      print('Access Token: $accessToken');
      print('Refresh Token: $refreshToken');

      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState());
    }
  }
}
