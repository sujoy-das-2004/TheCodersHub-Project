import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'productEvent.dart';
import 'productState.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FirebaseFirestore firestore;

  ProductBloc({required this.firestore}) : super(ProductInitial()) {
    on<FetchProducts>(_paginate);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<void> _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final snapshot = await firestore
          .collection('product')
          .where('name', isGreaterThanOrEqualTo: event.query)
          .where('name', isLessThanOrEqualTo: '${event.query}\uf8ff')
          .get();

      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {'id': doc.id, ...data};
      }).toList();

      _saveProductsToSharedPreferences(products);

      emit(ProductSuccess(products));
    } catch (e) {
      final offlineProducts = await _getOfflineProducts();
      if (offlineProducts.isNotEmpty) {
        emit(ProductSuccess(offlineProducts));
      } else {
        emit(ProductError(e.toString()));
      }
    }
  }

  bool isMoreData = true;
  bool isLoadingData = false;
  DocumentSnapshot? lastDoc;
  List<Map<String, dynamic>> product = [];
  late QuerySnapshot<Map<String, dynamic>> snapshot;

  Future<void> _paginate(FetchProducts event, Emitter<ProductState> emit) async {
    if (isMoreData) {
      final collectionRef = firestore.collection('product');
      if (lastDoc == null) {
        snapshot = await collectionRef.limit(10).get();
      } else {
        await Future.delayed(const Duration(seconds: 1));
        snapshot = await collectionRef.limit(10).startAfterDocument(lastDoc!).get();
      }

      lastDoc = snapshot.docs.last;
      product.addAll(snapshot.docs.map((e) => e.data()));

      _saveProductsToSharedPreferences(product);

      emit(ProductSuccess(product));

      if (snapshot.docs.length < 10) {
        isMoreData = false;
      }
    } else {
      print("No more data");
    }
  }

  Future<void> _saveProductsToSharedPreferences(List<Map<String, dynamic>> products) async {
    final prefs = await _prefs;
    final encodedProducts = jsonEncode(products);
    await prefs.setString('cached_products', encodedProducts);
  }

  Future<List<Map<String, dynamic>>> _getOfflineProducts() async {
    final prefs = await _prefs;
    final productsString = prefs.getString('cached_products');
    if (productsString != null) {
      final List<dynamic> productsList = jsonDecode(productsString);
      return productsList.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }
}
