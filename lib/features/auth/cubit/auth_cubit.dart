import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/auth/cubit/auth_state.dart';
import 'package:news_app/features/auth/repo/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepo _authRepo = AuthRepo();

  Future<void> login(String email, String password) async {
    if (isClosed) return;
    emit(AuthLoading()); 
    try {
      final userModel = await _authRepo.login(email, password);
      if (!isClosed) {
        emit(Authenticated(userId: userModel!.id));
      }
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(errorMessage: 'email or password is incorrect, please try again.'));
      }
    }
  }

  Future<void> signUp(String email, String password) async {
    if (isClosed) return;
    emit(AuthLoading());
    try {
      final userModel = await _authRepo.signUp(email, password);
      if (!isClosed) {
        emit(Authenticated(userId: userModel!.id));
      }
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> logout() async {
    if (isClosed) return;
    emit(AuthLoading());
    try {
      await _authRepo.logout();
      if (!isClosed) {
        emit(Unauthenticated());
      }
    } catch (e) {
      if (!isClosed) {
        emit(AuthError(errorMessage: e.toString()));
      }
    }
  }
}
