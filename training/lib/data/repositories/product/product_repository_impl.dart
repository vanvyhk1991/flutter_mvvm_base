import '../../models/product_model.dart';
import '../../services/product_api_service.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService api;

  ProductRepositoryImpl(this.api);

  @override
  Future<List<Product>> getProducts() {
    return api.getProducts();
  }
}