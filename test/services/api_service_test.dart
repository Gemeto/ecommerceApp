import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ecommerce/services/api_service.dart';
import 'package:ecommerce/models/product.dart';

import 'api_service_test.mocks.dart';

// Generate mocks by running: flutter pub run build_runner build
@GenerateMocks([http.Client])
void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    group('fetchProducts', () {
      test(
        'returns a list of products if the http call completes successfully',
        () async {
          final productsJson = '''
        [
          {"id":1,"title":"Product 1","price":10.0,"description":"Desc 1","category":"Cat 1","image":"img1.jpg"},
          {"id":2,"title":"Product 2","price":20.0,"description":"Desc 2","category":"Cat 2","image":"img2.jpg"}
        ]
        ''';
          when(
            mockClient.get(Uri.parse('https://fakestoreapi.com/products')),
          ).thenAnswer((_) async => http.Response(productsJson, 200));

          expect(await apiService.fetchProducts(), isA<List<Product>>());
          expect((await apiService.fetchProducts()).length, 2);
        },
      );

      test('throws an exception if the http call completes with an error', () {
        when(
          mockClient.get(Uri.parse('https://fakestoreapi.com/products')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(apiService.fetchProducts(), throwsException);
      });
    });

    group('fetchCategories', () {
      test(
        'returns a list of categories if the http call completes successfully',
        () async {
          final categoriesJson =
              '["electronics","jewelery","men\'s clothing","women\'s clothing"]';
          when(
            mockClient.get(
              Uri.parse('https://fakestoreapi.com/products/categories'),
            ),
          ).thenAnswer((_) async => http.Response(categoriesJson, 200));

          expect(await apiService.fetchCategories(), isA<List<String>>());
          expect((await apiService.fetchCategories()).length, 4);
        },
      );

      test('throws an exception if the http call completes with an error', () {
        when(
          mockClient.get(
            Uri.parse('https://fakestoreapi.com/products/categories'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(apiService.fetchCategories(), throwsException);
      });
    });
  });
}
