import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/connectivity/connection_gate.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/core/helper_fun/get_user.dart';
import 'package:fruit_hub/core/repos/order_repo/order_repo.dart';
import 'package:fruit_hub/core/services/git_it_services.dart';
import 'package:fruit_hub/core/utils/responsive_layout.dart';
import 'package:fruit_hub/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/checkout/domain/entites/user_order_entity.dart';
import 'package:fruit_hub/features/home/presentation/views/order_details_view.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/orders_empty_state.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/orders_error_state.dart';
import 'package:fruit_hub/features/home/presentation/views/widgets/orders/user_order_card.dart';

class OrdersViewBody extends StatefulWidget {
  const OrdersViewBody({super.key});

  @override
  State<OrdersViewBody> createState() => _OrdersViewBodyState();
}

class _OrdersViewBodyState extends State<OrdersViewBody> {
  late Future<Either<Failure, List<UserOrderEntity>>> _ordersFuture;
  bool _hasLoadedOrders = false;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _loadOrders();
  }

  Future<Either<Failure, List<UserOrderEntity>>> _loadOrders() async {
    final result = await getIt<OrderRepo>().getUserOrders(
      userId: getUser().uId,
    );
    result.fold((_) {}, (_) => _hasLoadedOrders = true);
    return result;
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _ordersFuture = _loadOrders();
    });
    await _ordersFuture;
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);

    return ConnectionGate(
      hasUsableCache: _hasLoadedOrders,
      onRetry: _refreshOrders,
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
                  title: '\u0637\u0644\u0628\u0627\u062A\u064A',
                  showBackButton: false,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<Either<Failure, List<UserOrderEntity>>>(
                    future: _ordersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData) {
                        return OrdersErrorState(
                          message:
                              '\u062D\u062F\u062B \u062E\u0637\u0623 \u0623\u062B\u0646\u0627\u0621 \u062A\u062D\u0645\u064A\u0644 \u0627\u0644\u0637\u0644\u0628\u0627\u062A',
                          onRetry: _refreshOrders,
                        );
                      }

                      return snapshot.data!.fold(
                        (failure) => OrdersErrorState(
                          message: failure.message,
                          onRetry: _refreshOrders,
                        ),
                        (orders) {
                          if (orders.isEmpty) {
                            return OrdersEmptyState(onRefresh: _refreshOrders);
                          }

                          return RefreshIndicator(
                            onRefresh: _refreshOrders,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: orders.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final currentOrder = orders[index];
                                return UserOrderCard(
                                  order: currentOrder,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => OrderDetailsView(
                                              order: currentOrder,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
