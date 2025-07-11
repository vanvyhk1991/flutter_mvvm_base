import '../../core/base/base_view_model.dart';
import '../../data/models/product_model.dart';
import '../../domain/usecase/get_products_usecase.dart';

class ProductViewModel extends BaseViewModel {
  final GetProductsUseCase getProductsUseCase;

  ProductViewModel(this.getProductsUseCase);

  List<Product> products = [];

  Future<void> fetchProducts() async {
    setBusy(true);
    try {
      products = await getProductsUseCase();
    } catch (e) {
      setError('Failed to fetch products');
    } finally {
      setBusy(false);
    }
  }
}