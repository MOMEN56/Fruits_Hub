import 'package:fruit_hub/core/connectivity/connection_service.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo_impl.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo_impl.dart';
import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/core/services/data_service.dart';
import 'package:fruit_hub/core/services/firebase_auth_service.dart';
import 'package:fruit_hub/core/services/push_notification_service.dart';
import 'package:fruit_hub/core/services/supabase_services.dart';
import 'package:fruit_hub/features/auth/data/repos/auth_repo_impl.dart';
import 'package:fruit_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruit_hub/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:fruit_hub/features/checkout/data/services/order_creation_notifications_service.dart';
import 'package:fruit_hub/features/checkout/domain/usecases/add_order_use_case.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());

  if (!GetIt.I.isRegistered<DatabaseService>()) {
    GetIt.I.registerSingleton<DatabaseService>(SupabaseService());
  }
  if (!GetIt.I.isRegistered<CurrentUserService>()) {
    GetIt.I.registerSingleton<CurrentUserService>(CurrentUserService());
  }
  GetIt.I.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthService: getIt<FirebaseAuthService>(),
      databaseServices: getIt<DatabaseService>(),
      currentUserService: getIt<CurrentUserService>(),
    ),
  );
  if (!GetIt.I.isRegistered<SignOutUseCase>()) {
    GetIt.I.registerSingleton<SignOutUseCase>(
      SignOutUseCase(getIt<AuthRepo>()),
    );
  }
  GetIt.I.registerSingleton<ProductsRepo>(
    ProductsRepoImpl(getIt<DatabaseService>()),
  );
  if (!GetIt.I.isRegistered<OrderRepo>()) {
    getIt.registerSingleton<OrderRepo>(OrderRepoImpl(getIt<DatabaseService>()));
  }
  if (!GetIt.I.isRegistered<OrderCreationNotificationsService>()) {
    getIt.registerSingleton<OrderCreationNotificationsService>(
      OrderCreationNotificationsService(getIt<DatabaseService>()),
    );
  }
  if (!GetIt.I.isRegistered<AddOrderUseCase>()) {
    getIt.registerSingleton<AddOrderUseCase>(
      AddOrderUseCase(
        getIt<OrderRepo>(),
        getIt<OrderCreationNotificationsService>(),
      ),
    );
  }
  if (!GetIt.I.isRegistered<PushNotificationService>()) {
    GetIt.I.registerSingleton<PushNotificationService>(
      PushNotificationService(currentUserService: getIt<CurrentUserService>()),
    );
  }
  if (!GetIt.I.isRegistered<ConnectionService>()) {
    GetIt.I.registerSingleton<ConnectionService>(ConnectionService());
  }
}
