import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo_impl.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo_impl.dart';
import 'package:fruit_hub/core/services/data_service.dart';
import 'package:fruit_hub/core/services/firebase_auth_service.dart';
import 'package:fruit_hub/core/services/firestore_service.dart';
import 'package:fruit_hub/core/services/subabase_services.dart';
import 'package:fruit_hub/features/auth/data/repos/auth_repo_impl.dart';
import 'package:fruit_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGitIt() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  //getIt.registerSingleton<DatabaseService>(FireStoreService());
  if (!GetIt.I.isRegistered<DatabaseService>()) {
    GetIt.I.registerSingleton<DatabaseService>(SupabaseService());
  }
  GetIt.I.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseServices: getIt<DatabaseService>(),
    ),
  );
  GetIt.I.registerSingleton<ProductsRepo>(
    ProductsRepoImpl(getIt<DatabaseService>()),
  );
  getIt.registerSingleton<OrderRepo>(OrderRepoImpl(getIt<DatabaseService>()));
}
