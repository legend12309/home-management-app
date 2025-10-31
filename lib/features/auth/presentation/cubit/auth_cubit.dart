import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final user = authRepository.getCurrentAuthUser();
    if (user != null) {
      final userModel = authRepository.getCurrentUserModel();
      if (userModel != null) {
        emit(AuthAuthenticated(user: userModel));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      emit(AuthLoading());
      final credential = await authRepository.signInWithEmail(email, password);
      
      if (credential?.user != null) {
        final userModel = authRepository.getCurrentUserModel();
        if (userModel != null) {
          emit(AuthAuthenticated(user: userModel));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthError('Sign in failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    try {
      emit(AuthLoading());
      final credential = await authRepository.signUpWithEmail(email, password);
      
      if (credential?.user != null) {
        await authRepository.createUserProfile(
          uid: credential!.user!.uid,
          email: email,
          name: name,
        );
        final userModel = authRepository.getCurrentUserModel();
        if (userModel != null) {
          emit(AuthAuthenticated(user: userModel));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthError('Sign up failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      final credential = await authRepository.signInWithGoogle();
      
      if (credential?.user != null) {
        final userModel = authRepository.getCurrentUserModel();
        if (userModel != null) {
          emit(AuthAuthenticated(user: userModel));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthError('Google sign in failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> createFamily(String familyName) async {
    try {
      emit(AuthLoading());
      final user = authRepository.getCurrentAuthUser();
      
      if (user == null) {
        emit(AuthError('No user logged in'));
        return;
      }

      final family = await authRepository.createFamily(
        adminId: user.uid,
        familyName: familyName,
      );

      final userModel = authRepository.getCurrentUserModel();
      if (userModel != null) {
        emit(AuthAuthenticated(user: userModel, family: family));
        emit(RoleSelectionSuccess('admin'));
      } else {
        emit(AuthError('Failed to update user'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> joinFamily(String inviteCode) async {
    try {
      emit(AuthLoading());
      final user = authRepository.getCurrentAuthUser();
      
      if (user == null) {
        emit(AuthError('No user logged in'));
        return;
      }

      await authRepository.joinFamily(
        userId: user.uid,
        inviteCode: inviteCode,
      );

      emit(RoleSelectionSuccess('member'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

