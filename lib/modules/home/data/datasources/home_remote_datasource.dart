library;
import 'package:mini_project_pwa/core/network/http_client.dart';
import 'package:mini_project_pwa/modules/home/data/models/product_item_model.dart';

import '../models/home_item_model.dart';

/// Abstract interface for remote home data source.
///
/// Responsible for fetching data required by the home feature
/// from a backend or third-party service.
abstract class HomeRemoteDataSource {
  /// Load home items from the remote source.
  ///
  /// Throws [AppException] on error.
  Future<List<HomeItemModel>> loadHomeItems();

  /// Load product items from the remote source.
  ///
  /// Throws [AppException] on error.
  Future<List<ProductItemModel>> loadProductItems();
}

/// Stub implementation of [HomeRemoteDataSource].
///
/// Replace the TODOs with real network calls (e.g. via HttpClient, Firebase).
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HttpClient client;

  HomeRemoteDataSourceImpl(this.client);

  @override
  Future<List<HomeItemModel>> loadHomeItems() async {
    // TODO: Implement real remote call.
    // For now, return an empty list so the app can run.
    return <HomeItemModel>[];
  }

  @override
  Future<List<ProductItemModel>> loadProductItems() async {
    // return fake product list.
    HttpResponse response = await client.get('/products');
    List<dynamic> data = response.data;

    List<ProductItemModel> products = data
        .map((e) => ProductItemModel.fromJson(e))
        .toList();

    return products;
  }
}
