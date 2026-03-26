import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/connectivity/connection_gate.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/core/services/get_it_services.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/home/domain/usecases/get_user_orders_use_case.dart';
import 'package:fruit_hub/features/home/presentation/cubits/user_orders/user_orders_cubit.dart';
import 'package:fruit_hub/features/home/presentation/views/order_details_view.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/orders_empty_state.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/orders_error_state.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/user_order_card.dart';
import 'package:fruit_hub/features/notifications/data/services/notifications_service.dart';
import 'package:fruit_hub/features/notifications/domain/entities/notification_entity.dart';
import 'package:fruit_hub/generated/l10n.dart';

class OrdersViewBody extends StatelessWidget {
  const OrdersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => UserOrdersCubit(
            GetUserOrdersUseCase(getIt<OrderRepo>()),
            getIt<CurrentUserService>(),
          )..loadOrders(),
      child: const _OrdersViewBodyContent(),
    );
  }
}

class _OrdersViewBodyContent extends StatefulWidget {
  const _OrdersViewBodyContent();

  @override
  State<_OrdersViewBodyContent> createState() => _OrdersViewBodyContentState();
}

class _OrdersViewBodyContentState extends State<_OrdersViewBodyContent> {
  final NotificationsService _notificationsService = NotificationsService();
  StreamSubscription<List<NotificationEntity>>? _subscription;
  String? _lastSeenOrderStatusNotificationId;

  @override
  void initState() {
    super.initState();

    final userId = getIt<CurrentUserService>().getCurrentUserId();
    if (userId == null || userId.isEmpty) return;

    _subscription = _notificationsService
        .watchNotifications(userId: userId)
        .listen((notifications) {
      if (!mounted) return;

      NotificationEntity? latestOrderStatus;
      for (final n in notifications) {
        if (n.type == 'order_status') {
          latestOrderStatus = n;
          break;
        }
      }

      if (latestOrderStatus == null) return;

      final latestId = latestOrderStatus.id.trim();
      if (latestId.isEmpty) return;

      if (latestId == _lastSeenOrderStatusNotificationId) return;
      _lastSeenOrderStatusNotificationId = latestId;

      // تحديث تلقائي لقائمة الطلبات عند وصول إشعار حالة طلب جديد.
      context.read<UserOrdersCubit>().loadOrders();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _notificationsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);
    final state = context.watch<UserOrdersCubit>().state;

    return ConnectionGate(
      hasUsableCache: state.hasUsableCache,
      onRetry: () => context.read<UserOrdersCubit>().loadOrders(),
      hideChildWhenOffline: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                const SizedBox(height: kTopPaddding),
                buildAppBar(
                  context,
                  title: S.of(context).myOrders,
                  showBackButton: false,
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserOrdersState state) {
    switch (state.status) {
      case UserOrdersStatus.initial:
      case UserOrdersStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case UserOrdersStatus.failure:
        return OrdersErrorState(
          message: state.errorMessage ?? S.of(context).errorLoadingOrders,
          onRetry: () => context.read<UserOrdersCubit>().loadOrders(),
        );
      case UserOrdersStatus.success:
        if (state.orders.isEmpty) {
          return OrdersEmptyState(
            onRefresh: () => context.read<UserOrdersCubit>().loadOrders(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<UserOrdersCubit>().loadOrders(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return UserOrderCard(
                order: order,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsView(order: order),
                    ),
                  );
                },
              );
            },
          ),
        );
    }
  }
}
