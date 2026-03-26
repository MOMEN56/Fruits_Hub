import 'package:fruit_hub/features/auth/domain/repos/auth_repo.dart';

class SignOutUseCase {
  const SignOutUseCase(this._authRepo);

  final AuthRepo _authRepo;

  Future<void> call() async {
    await _authRepo.signOut();
  }
}
