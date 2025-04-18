abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

class ProductSuccess extends ProductState {
  final List<Map<String, dynamic>> products;
  final bool isFetchingMore;
  ProductSuccess(this.products,{this.isFetchingMore = false});
}


