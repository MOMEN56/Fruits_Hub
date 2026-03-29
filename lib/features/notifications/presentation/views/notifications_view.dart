import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/connectivity/connection_service.dart';
import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/core/services/get_it_services.dart';
import 'package:fruit_hub/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/notifications/data/services/notifications_service.dart';
import 'package:fruit_hub/features/notifications/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:fruit_hub/features/notifications/presentation/views/widgets/notifications_view_body.dart';
import 'package:fruit_hub/generated/l10n.dart';

class NotificationsViewArgs {
  const NotificationsViewArgs({this.highlightedOrderId});

  final String? highlightedOrderId;
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({
    super.key,
    this.args = const NotificationsViewArgs(),
  });

  static const routeName = 'notifications-view';
  final NotificationsViewArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(
        NotificationsService(connectionService: getIt<ConnectionService>()),
        getIt<CurrentUserService>(),
      ),
      child: Scaffold(
        appBar: buildAppBar(
          context,
          title: S.of(context).notifications,
          showNotification: false,
        ),
        body: NotificationsViewBody(args: args),
      ),
    );
  }
}
