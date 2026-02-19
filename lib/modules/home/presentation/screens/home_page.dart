library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_pwa/config/app_navigator.dart';
import 'package:mini_project_pwa/config/theme/app_colors.dart';
import 'package:mini_project_pwa/core/utils/extensions/build_context_extensions.dart';
import 'package:mini_project_pwa/core/utils/extensions/color_extensions.dart';
import 'package:mini_project_pwa/core/utils/extensions/string_extensions.dart';
import 'package:mini_project_pwa/core/widgets/common_app_bar.dart';
import 'package:mini_project_pwa/core/widgets/optimized_image.dart';
import 'package:mini_project_pwa/modules/cart/presentation/widgets/cart_action_widget.dart';
import 'package:mini_project_pwa/modules/cart/presentation/widgets/cart_icon_widget.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_bloc.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_event.dart';
import 'package:mini_project_pwa/modules/home/presentation/bloc/home_state.dart';

part 'widgets/product_grid.dart';
part 'widgets/filter_sheet.dart';
part 'widgets/search_filter_header.dart';

/// Home page that displays a simple counter using [HomeBloc].
///
/// This widget is part of the presentation layer and demonstrates
/// how to connect a BLoC to a screen without any data layer calls.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Flutter PWA",
        centerTitle: true,
        actions: [CartIconWidget(), SizedBox(width: 8)],
      ),
      body: Column(
        children: [
          _SearchFilterHeader(),
          Expanded(child: _ProductGrid()),
        ],
      ),
    );
  }
}
