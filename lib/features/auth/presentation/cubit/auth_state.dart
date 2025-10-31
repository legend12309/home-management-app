import 'package:equatable/equatable.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/family_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  final FamilyModel? family;

  const AuthAuthenticated({required this.user, this.family});

  @override
  List<Object?> get props => [user, family];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class RoleSelectionSuccess extends AuthState {
  final String role;

  const RoleSelectionSuccess(this.role);

  @override
  List<Object?> get props => [role];
}

