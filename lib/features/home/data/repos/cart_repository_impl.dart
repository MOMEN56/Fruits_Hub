import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/features/home/data/data_sources/cart_local_data_source.dart';
import 'package:fruit_hub/features/home/data/data_sources/cart_remote_data_source.dart';
import 'package:fruit_hub/features/home/data/serializers/cart_serializer.dart';
import 'package:fruit_hub/features/home/domain/entites/cart_entity.dart';
import 'package:fruit_hub/features/home/domain/repos/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({
    required CartLocalDataSource localDataSource,
    required CartRemoteDataSource remoteDataSource,
    required CartSerializer serializer,
    required CurrentUserService currentUserService,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _serializer = serializer,
       _currentUserService = currentUserService;

  final CartLocalDataSource _localDataSource;
  final CartRemoteDataSource _remoteDataSource;
  final CartSerializer _serializer;
  final CurrentUserService _currentUserService;

  @override
  Future<CartEntity> loadCart() async {
    final rawLocalCart = await _localDataSource.readRaw();
    final userId = _currentUserService.getCurrentUserId();

    if (userId != null && userId.isNotEmpty) {
      final rawRemote = await _remoteDataSource.fetchRaw(userId);

      if (rawRemote != null) {
        final trimmedRemote = rawRemote.trim();
        if (trimmedRemote.isEmpty) {
          if (rawLocalCart.isNotEmpty) {
            await _localDataSource.clear();
          }
          return CartEntity([]);
        }

        final remoteCart = _serializer.decode(trimmedRemote);
        if (remoteCart != null) {
          await _localDataSource.writeRaw(trimmedRemote);
          return remoteCart;
        }

        if (rawLocalCart.isNotEmpty) {
          final localCart = _serializer.decode(rawLocalCart);
          if (localCart != null) {
            await _remoteDataSource.saveRaw(userId, rawLocalCart);
            return localCart;
          }
        }

        await _remoteDataSource.saveRaw(userId, '');
        await _localDataSource.clear();
        return CartEntity([]);
      }

      if (rawLocalCart.isNotEmpty) {
        final localCart = _serializer.decode(rawLocalCart);
        if (localCart != null) {
          await _remoteDataSource.saveRaw(userId, rawLocalCart);
          return localCart;
        }
        await _localDataSource.clear();
      }
      return CartEntity([]);
    }

    if (rawLocalCart.isEmpty) return CartEntity([]);
    final localCart = _serializer.decode(rawLocalCart);
    if (localCart == null) {
      await _localDataSource.clear();
      return CartEntity([]);
    }
    return localCart;
  }

  @override
  Future<void> saveCart(CartEntity cartEntity) async {
    final raw = _serializer.encode(cartEntity);
    await _localDataSource.writeRaw(raw);

    final userId = _currentUserService.getCurrentUserId();
    if (userId != null && userId.isNotEmpty) {
      await _remoteDataSource.saveRaw(userId, raw);
    }
  }

  @override
  Future<void> clearCart() async {
    await _localDataSource.clear();
    final userId = _currentUserService.getCurrentUserId();
    if (userId != null && userId.isNotEmpty) {
      await _remoteDataSource.saveRaw(userId, '');
    }
  }
}
