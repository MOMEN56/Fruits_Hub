import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/features/home/presentation/views/main_view.dart';
import 'package:fruit_hub/features/notifications/presentation/manger/notifications_cubit/notifications_cubit.dart';
import 'package:fruit_hub/features/notifications/presentation/manger/notifications_cubit/notifications_state.dart';
import 'package:fruit_hub/features/notifications/presentation/views/notifications_view.dart';
import 'package:fruit_hub/features/notifications/presentation/views/widgets/highlighted_order_banner.dart';
import 'package:fruit_hub/features/notifications/presentation/views/widgets/notification_card.dart';
import 'package:fruit_hub/features/notifications/presentation/views/widgets/notifications_error_state.dart';
import 'package:fruit_hub/generated/l10n.dart';

class NotificationsViewBody extends StatefulWidget {
  const NotificationsViewBody({super.key, required this.args});

  final NotificationsViewArgs args;

  @override
  State<NotificationsViewBody> createState() => _NotificationsViewBodyState();
}

class _NotificationsViewBodyState extends State<NotificationsViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if ((widget.args.highlightedOrderId ?? '').trim().isNotEmpty)
            HighlightedOrderBanner(
              orderId: widget.args.highlightedOrderId!.trim(),
            ),
          Expanded(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state is NotificationsLoading ||
                    state is NotificationsInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is NotificationsUnauthenticated) {
                  return Center(child: Text(state.message));
                }
                if (state is NotificationsFailure) {
                  return NotificationsErrorState(
                    message: state.message,
                    onRetry: () => context.read<NotificationsCubit>().refresh(),
                  );
                }
                if (state is NotificationsSuccess) {
                  if (state.notifications.isEmpty) {
                    return Center(child: Text(S.of(context).noNotificationsCurrently));
                  }
                  return RefreshIndicator(
                    onRefresh: () => context.read<NotificationsCubit>().refresh(),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      itemCount: state.notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, index) {
                        final notification = state.notifications[index];
                        return NotificationCard(
                          notification: notification,
                          onTap: () => context
                              .read<NotificationsCubit>()
                              .markAsRead(notificationId: notification.id),
                          onOpenOrders:
                              notification.orderId == null ? null : _openOrdersTab,
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openOrdersTab() {
    Navigator.pushNamed(context, MainView.routeName, arguments: 3);
  }
}
