import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/core/helper_fun/build_snack_bar.dart';
import 'package:fruit_hub/core/products_cubit/cubit/products_cubit.dart';
import 'package:fruit_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruit_hub/core/services/app_navigation_service.dart';
import 'package:fruit_hub/core/services/get_it_services.dart';
import 'package:fruit_hub/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub/features/best_selling/presentation/view/widgets/best_selling_view_body.dart';
import 'package:fruit_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruit_hub/features/home/presentation/views/main_view.dart';
import 'package:fruit_hub/generated/l10n.dart';

class BestSellingViewArgs {
  const BestSellingViewArgs({required this.cartCubit});

  final CartCubit cartCubit;
}

class BestSellingView extends StatelessWidget {
  const BestSellingView({super.key});

  static const routeName = 'BestSellingView';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(getIt.get<ProductsRepo>()),
      child: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent != true) return;

          if (state is CartItemAdded) {
            final l10n = S.of(context);
            buildSnackBar(
              context,
              l10n.productAddedToCart,
              type: AppSnackBarType.success,
              title: l10n.addSuccessTitle,
              actionLabel: l10n.cart,
              onAction: () {
                AppNavigationService.setMainViewTab(MainView.cartViewIndex);
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              duration: const Duration(seconds: 3),
            );
          }
        },
        child: Scaffold(
          appBar: buildAppBar(
            context,
            title: S.of(context).mostSelling,
            onBackPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
                return;
              }
              Navigator.of(
                context,
              ).pushReplacementNamed(MainView.routeName, arguments: 0);
            },
          ),
          body: const BestSellingViewBody(),
        ),
      ),
    );
  }
}
