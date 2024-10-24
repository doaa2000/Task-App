import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task/core/helper/dio_helper.dart';
import 'package:task/features/profile/data/models/profile_model/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  DioHelper dioHelper = DioHelper();
  ProfileModel? profileModel;
  static ProfileCubit get(context) => BlocProvider.of(context);

  Future<void> getProfile() async {
    emit(ProfileLoadingState());
    try {
      final response = await dioHelper.get(
        'api/customer/get-profile',
      );
      profileModel = ProfileModel.fromJson(response.data);

      emit(ProfileSuccessState(profileModel: profileModel));
    } catch (e) {
      emit(ProfileErrorState());
    }
  }
}
