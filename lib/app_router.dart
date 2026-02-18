import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mini_project_pwa/config/constants/route_constants.dart';

import 'package:mini_project_pwa/config/environment_config.dart';

import 'package:mini_project_pwa/core/di/injection_container.dart';
import 'package:mini_project_pwa/core/services/analytics/analytics_observer.dart';
import 'package:mini_project_pwa/modules/auth/presentation/screens/login_page.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_bloc.dart';
import 'package:mini_project_pwa/modules/cart/presentation/screens/cart_page.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_bloc.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_event.dart';
import 'package:mini_project_pwa/modules/home/presentation/screens/home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_pwa/core/widgets/pdf_viewer_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.login,
    observers: _buildObservers(),
    routes: [
      GoRoute(
        path: RouteConstants.home,
        name: RouteConstants.homeName,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<HomeBloc>()..add(LoadProducts())),
            BlocProvider.value(value: context.read<CartBloc>()),
          ],
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.login,
        name: RouteConstants.loginName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteConstants.cart,
        name: RouteConstants.cartName,
        builder: (context, state) {
          final productId = state.uri.queryParameters['productId'];
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<HomeBloc>()..add(LoadProducts()),
              ),
              BlocProvider.value(value: context.read<CartBloc>()),
            ],
            child: CartPage(productId: productId),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.invoice,
        name: RouteConstants.pdfViewerName,
        builder: (context, state) {
          final invoiceId = state.pathParameters['invoiceId']!;
          return PdfBlobViewer(
            pdfUrl: "https://morth.nic.in/sites/default/files/dd12-13_0.pdf",
          );
        },
      ),
      // Deep link routes (add as needed)
      // GoRoute(
      //   path: '/users/:userId',
      //   name: 'user-detail',
      //   builder: (context, state) {
      //     final userId = state.pathParameters['userId'] ?? '';
      //     return UserDetailPage(userId: userId);
      //   },
      // ),
      // GoRoute(
      //   path: '/posts/:postId',
      //   name: 'post-detail',
      //   builder: (context, state) {
      //     final postId = state.pathParameters['postId'] ?? '';
      //     return PostDetailPage(postId: postId);
      //   },
      // ),
      // Add more deep link routes as needed
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text(state.error.toString()))),
  );

  static List<NavigatorObserver> _buildObservers() {
    final env = EnvironmentConfig.instance;

    if (!env.useFirebase || !env.enableAnalytics) {
      return [];
    }

    final AnalyticsObserverProvider provider =
        getIt<AnalyticsObserverProvider>();
    final NavigatorObserver? observer = provider.observer;

    if (observer == null) {
      return [];
    }

    return [observer];
  }
}
