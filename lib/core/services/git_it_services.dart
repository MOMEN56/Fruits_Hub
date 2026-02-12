import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo_impl.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo_impl.dart';
import 'package:fruit_hub/core/services/database_services.dart';
import 'package:fruit_hub/core/services/firebase_auth_service.dart';
import 'package:fruit_hub/core/services/firestore_service.dart';
import 'package:fruit_hub/features/auth/data/repos/auth_repo_impl.dart';
import 'package:fruit_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGitIt() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseServices>(FirestoreService());
  GetIt.I.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseServices: getIt<DatabaseServices>(),
    ),
  );
  GetIt.I.registerSingleton<ProductsRepo>(
    ProductsRepoImpl(getIt<DatabaseServices>()),
  );
  getIt.registerSingleton<OrderRepo>(OrderRepoImpl(getIt<DatabaseServices>()));
}
