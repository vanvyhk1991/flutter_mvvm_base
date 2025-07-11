import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../data/models/product_model.dart';

part 'product_api_service.g.dart';

@RestApi()
abstract class ProductApiService {
  factory ProductApiService(Dio dio, {String baseUrl}) = _ProductApiService;

  @GET('/products')
  Future<List<Product>> getProducts();
}