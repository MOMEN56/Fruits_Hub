import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/connectivity/connection_gate.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/core/services/git_it_services.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/home/domain/usecases/get_user_orders_use_case.dart';
import 'package:fruit_hub/features/home/presentation/cubits/user_orders/user_orders_cubit.dart';
import 'package:fruit_hub/features/home/presentation/views/order_details_view.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/orders_empty_state.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/orders_error_state.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/user_order_card.dart';
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

class _OrdersViewBodyContent extends StatelessWidget {
  const _OrdersViewBodyContent();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);
    final state = context.watch<UserOrdersCubit>().state;

    return ConnectionGate(
      hasUsableCache: state.hasUsableCache,
      onRetry: () => context.read<UserOrdersCubit>().loadOrders(),
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
