import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';
import 'package:fruit_hub/core/utils/app_text_styles.dart';
import 'package:fruit_hub/features/admin/orders/data/services/orders_service.dart';
import 'package:fruit_hub/features/admin/orders/domain/entities/dashboard_order_entity.dart';
import 'package:fruit_hub/features/admin/orders/presentation/manager/fetch_order/fetch_orders_cubit.dart';
import 'package:fruit_hub/features/admin/orders/presentation/manager/update_order/update_order_cubit.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  static const routeName = 'orders-dashboard-view';

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  late final OrdersService _ordersService;

  @override
  void initState() {
    super.initState();
    _ordersService = OrdersService();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FetchOrdersCubit(_ordersService)..fetchOrders(),
        ),
        BlocProvider(create: (_) => UpdateOrderCubit(_ordersService)),
      ],
      child: const _OrdersViewBody(),
    );
  }
}

class _OrdersViewBody extends StatefulWidget {
  const _OrdersViewBody();

  @override
  State<_OrdersViewBody> createState() => _OrdersViewBodyState();
}

class _OrdersViewBodyState extends State<_OrdersViewBody> {
  static const List<String> _statusFilters = <String>[
    'all',
    'pending',
    'accepted',
    'delivered',
    'cancelled',
  ];

  String _selectedFilter = _statusFilters.first;
  final Set<String> _updatingOrderKeys = <String>{};

  Future<void> _refreshOrders() async {
    await context.read<FetchOrdersCubit>().fetchOrders();
  }

  void _handleOrderUpdateState(UpdateOrderState state) {
    if (!mounted) {
      return;
    }

    if (state is UpdateOrderLoading) {
      setState(() {
        _updatingOrderKeys.add(state.orderKey);
      });
      return;
    }

    if (state is UpdateOrderSuccess) {
      setState(() {
        _updatingOrderKeys.remove(state.orderKey);
      });
      buildSnackBar(
        context,
        'Order updated to ${_statusLabel(state.nextStatus)}',
        type: AppSnackBarType.success,
        title: 'Updated',
      );
      context.read<FetchOrdersCubit>().fetchOrders();
      return;
    }

    if (state is UpdateOrderFailure) {
      setState(() {
        _updatingOrderKeys.remove(state.orderKey);
      });
      buildSnackBar(context, state.errorMessage);
    }
  }

  List<UserOrdersGroupEntity> _applyStatusFilter(
    List<UserOrdersGroupEntity> groups,
  ) {
    if (_selectedFilter == 'all') {
      return groups;
    }
    return groups
        .map((group) => group.filterByStatus(_selectedFilter))
        .where((group) => group.orders.isNotEmpty)
        .toList();
  }

  _OrdersMetrics _buildMetrics(List<UserOrdersGroupEntity> groups) {
    var totalOrders = 0;
    var pendingOrders = 0;
    var acceptedOrders = 0;
    var deliveredOrders = 0;
    var cancelledOrders = 0;

    for (final group in groups) {
      totalOrders += group.orders.length;
      for (final order in group.orders) {
        switch (order.status) {
          case 'pending':
            pendingOrders++;
            break;
          case 'accepted':
            acceptedOrders++;
            break;
          case 'delivered':
            deliveredOrders++;
            break;
          case 'cancelled':
            cancelledOrders++;
            break;
          default:
            break;
        }
      }
    }

    return _OrdersMetrics(
      totalOrders: totalOrders,
      pendingOrders: pendingOrders,
      acceptedOrders: acceptedOrders,
      deliveredOrders: deliveredOrders,
      cancelledOrders: cancelledOrders,
    );
  }

  List<_OrderAction> _buildActions(String status) {
    if (status == 'pending') {
      return const <_OrderAction>[
        _OrderAction(label: 'Accept', nextStatus: 'accepted'),
        _OrderAction(label: 'Cancel', nextStatus: 'cancelled'),
      ];
    }
    if (status == 'accepted') {
      return const <_OrderAction>[
        _OrderAction(label: 'Delivered', nextStatus: 'delivered'),
        _OrderAction(label: 'Cancel', nextStatus: 'cancelled'),
      ];
    }
    return const <_OrderAction>[];
  }

  String _statusLabel(String status) {
    return switch (status) {
      'all' => 'All',
      'pending' => 'Pending',
      'accepted' => 'Accepted',
      'delivered' => 'Delivered',
      'cancelled' => 'Cancelled',
      _ => status,
    };
  }

  String _paymentLabel(String paymentMethod) {
    final normalized = paymentMethod.trim().toLowerCase();
    if (normalized.contains('cash')) {
      return 'Cash';
    }
    if (normalized.contains('online')) {
      return 'Online';
    }
    return paymentMethod.isEmpty ? 'Unknown' : paymentMethod;
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '--';
    }
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  Color _statusBackgroundColor(String status) {
    return switch (status) {
      'pending' => const Color(0xFFFFF4E0),
      'accepted' => const Color(0xFFE3F2FD),
      'delivered' => const Color(0xFFE8F5E9),
      'cancelled' => const Color(0xFFFFEBEE),
      _ => const Color(0xFFECEFF1),
    };
  }

  Color _statusTextColor(String status) {
    return switch (status) {
      'pending' => const Color(0xFFB26A00),
      'accepted' => const Color(0xFF1565C0),
      'delivered' => const Color(0xFF2E7D32),
      'cancelled' => const Color(0xFFC62828),
      _ => const Color(0xFF546E7A),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateOrderCubit, UpdateOrderState>(
      listener: (_, state) => _handleOrderUpdateState(state),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F8F6),
        body: BlocBuilder<FetchOrdersCubit, FetchOrdersState>(
          builder: (context, state) {
            if (state is FetchOrdersLoading || state is FetchOrdersInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FetchOrdersFailure) {
              return _OrdersErrorState(
                message: state.errorMessage,
                onRetry: () => context.read<FetchOrdersCubit>().fetchOrders(),
              );
            }

            final successState = state as FetchOrdersSuccess;
            final allGroups = successState.groupedOrders;
            final visibleGroups = _applyStatusFilter(allGroups);
            final metrics = _buildMetrics(allGroups);

            return RefreshIndicator(
              onRefresh: _refreshOrders,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                children: [
                  _OrdersHeader(
                    usersCount: allGroups.length,
                    totalOrders: metrics.totalOrders,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _MetricChip(
                        label: 'Pending',
                        value: '${metrics.pendingOrders}',
                        color: _statusTextColor('pending'),
                        backgroundColor: _statusBackgroundColor('pending'),
                      ),
                      _MetricChip(
                        label: 'Accepted',
                        value: '${metrics.acceptedOrders}',
                        color: _statusTextColor('accepted'),
                        backgroundColor: _statusBackgroundColor('accepted'),
                      ),
                      _MetricChip(
                        label: 'Delivered',
                        value: '${metrics.deliveredOrders}',
                        color: _statusTextColor('delivered'),
                        backgroundColor: _statusBackgroundColor('delivered'),
                      ),
                      _MetricChip(
                        label: 'Cancelled',
                        value: '${metrics.cancelledOrders}',
                        color: _statusTextColor('cancelled'),
                        backgroundColor: _statusBackgroundColor('cancelled'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          _statusFilters.map((status) {
                            final isSelected = status == _selectedFilter;
                            return Padding(
                              padding: const EdgeInsetsDirectional.only(end: 8),
                              child: ChoiceChip(
                                label: Text(_statusLabel(status)),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedFilter = status;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (visibleGroups.isEmpty)
                    _OrdersEmptyState(
                      filter: _selectedFilter,
                      onResetFilter: () {
                        setState(() {
                          _selectedFilter = 'all';
                        });
                      },
                    ),
                  ...visibleGroups.map((group) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _UserOrdersCard(
                        group: group,
                        statusLabel: _statusLabel,
                        statusTextColor: _statusTextColor,
                        statusBackgroundColor: _statusBackgroundColor,
                        formatDate: _formatDate,
                        paymentLabel: _paymentLabel,
                        buildActions: _buildActions,
                        updatingOrderKeys: _updatingOrderKeys,
                        onUpdateOrderStatus: (order, nextStatus) {
                          context.read<UpdateOrderCubit>().updateOrderStatus(
                            order: order,
                            nextStatus: nextStatus,
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({required this.usersCount, required this.totalOrders});

  final int usersCount;
  final int totalOrders;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.primaryColor, AppColors.lightPrimaryColor],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Orders Dashboard',
            style: TextStyles.bold19.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalOrders orders from $usersCount users',
            style: TextStyles.regular13.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyles.semiBold11.copyWith(color: color)),
          const SizedBox(width: 8),
          Text(value, style: TextStyles.bold13.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _UserOrdersCard extends StatelessWidget {
  const _UserOrdersCard({
    required this.group,
    required this.statusLabel,
    required this.statusTextColor,
    required this.statusBackgroundColor,
    required this.formatDate,
    required this.paymentLabel,
    required this.buildActions,
    required this.updatingOrderKeys,
    required this.onUpdateOrderStatus,
  });

  final UserOrdersGroupEntity group;
  final String Function(String status) statusLabel;
  final Color Function(String status) statusTextColor;
  final Color Function(String status) statusBackgroundColor;
  final String Function(DateTime? date) formatDate;
  final String Function(String paymentMethod) paymentLabel;
  final List<_OrderAction> Function(String status) buildActions;
  final Set<String> updatingOrderKeys;
  final void Function(DashboardOrderEntity order, String nextStatus)
  onUpdateOrderStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2ECE6)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFEAF4EE),
                child: Text(
                  group.avatarInitial,
                  style: TextStyles.bold13.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.displayName, style: TextStyles.bold16),
                    const SizedBox(height: 2),
                    Text(
                      group.displayEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.regular11.copyWith(
                        color: const Color(0xFF6E7B76),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${group.orders.length} orders',
                  style: TextStyles.semiBold11.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...group.orders.map((order) {
            final actions = buildActions(order.status);
            final isUpdating = updatingOrderKeys.contains(order.orderKey);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFCFB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5ECE7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Order #${order.shortOrderId}',
                          style: TextStyles.semiBold13,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusBackgroundColor(order.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusLabel(order.status),
                          style: TextStyles.semiBold11.copyWith(
                            color: statusTextColor(order.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${order.totalPrice.toStringAsFixed(2)} EGP - ${order.itemsCount} items - ${paymentLabel(order.paymentMethod)}',
                    style: TextStyles.regular13.copyWith(
                      color: const Color(0xFF53625D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(order.createdAt),
                    style: TextStyles.regular11.copyWith(
                      color: const Color(0xFF788883),
                    ),
                  ),
                  if (order.shippingAddress != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      order.shippingAddress!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.regular11.copyWith(
                        color: const Color(0xFF70807B),
                      ),
                    ),
                  ],
                  if (actions.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          actions.map((action) {
                            final isCancelAction =
                                action.nextStatus == 'cancelled';
                            return FilledButton(
                              onPressed:
                                  isUpdating
                                      ? null
                                      : () => onUpdateOrderStatus(
                                        order,
                                        action.nextStatus,
                                      ),
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    isCancelAction
                                        ? const Color(0xFFFFEBEE)
                                        : const Color(0xFFE8F5E9),
                                foregroundColor:
                                    isCancelAction
                                        ? const Color(0xFFC62828)
                                        : const Color(0xFF2E7D32),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                textStyle: TextStyles.semiBold13,
                              ),
                              child:
                                  isUpdating
                                      ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(action.label),
                            );
                          }).toList(),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _OrdersErrorState extends StatelessWidget {
  const _OrdersErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFC62828), size: 40),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.regular13.copyWith(
                color: const Color(0xFF455A64),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _OrdersEmptyState extends StatelessWidget {
  const _OrdersEmptyState({required this.filter, required this.onResetFilter});

  final String filter;
  final VoidCallback onResetFilter;

  @override
  Widget build(BuildContext context) {
    final isFiltered = filter != 'all';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDFE9E3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 36, color: Color(0xFF70807B)),
          const SizedBox(height: 8),
          Text(
            isFiltered ? 'No orders for this filter.' : 'No orders yet.',
            style: TextStyles.semiBold13,
          ),
          if (isFiltered) ...[
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: onResetFilter,
              child: const Text('Show all orders'),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrdersMetrics {
  const _OrdersMetrics({
    required this.totalOrders,
    required this.pendingOrders,
    required this.acceptedOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
  });

  final int totalOrders;
  final int pendingOrders;
  final int acceptedOrders;
  final int deliveredOrders;
  final int cancelledOrders;
}

class _OrderAction {
  const _OrderAction({required this.label, required this.nextStatus});

  final String label;
  final String nextStatus;
}
