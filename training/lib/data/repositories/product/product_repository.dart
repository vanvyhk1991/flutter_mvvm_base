import '../../models/product_model.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}