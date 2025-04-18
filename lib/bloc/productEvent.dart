abstract class ProductEvent {}

class FetchProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;
  SearchProducts(this.query);
}

class LoadMoreProducts extends ProductEvent {}
