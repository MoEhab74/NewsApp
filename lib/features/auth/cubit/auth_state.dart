class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String userId;

  Authenticated({required this.userId});
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;

  AuthError({required this.errorMessage});
}
