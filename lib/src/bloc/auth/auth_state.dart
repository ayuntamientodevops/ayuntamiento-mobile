part of 'auth_bloc.dart';

class AuthState {
  bool uninitialized;
  bool loading;
  bool authenticated;
  bool isErrorAuth;
  String errorLogin;

  AuthState(
      {this.uninitialized = false,
      this.loading = false,
      this.authenticated = false,
      this.isErrorAuth = false,
      this.errorLogin});

  AuthState copyWith(
          {bool uninitialized,
          bool loading,
          bool authenticated,
          bool isErrorAuth,
          String errorLogin}) =>
      new AuthState(
          uninitialized: uninitialized ?? this.uninitialized,
          loading: loading ?? this.loading,
          authenticated: authenticated ?? this.authenticated,
          isErrorAuth: isErrorAuth ?? this.isErrorAuth,
          errorLogin: errorLogin ?? this.errorLogin);
}
