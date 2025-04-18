import 'dart:async';

import 'package:bloc_firebase/screen/Product/productDetails.dart';
import 'package:bloc_firebase/widget/custom_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/productBloc.dart';
import '../../bloc/productEvent.dart';
import '../../bloc/productState.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController controller = ScrollController();
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<ProductBloc>().add(FetchProducts());
      }
    });
  }

  Future<void> _onRefresh() async {
    _searchController.clear();
    final bloc = context.read<ProductBloc>();
    bloc
      ..isMoreData = true
      ..lastDoc = null
      ..product.clear();
    bloc.add(FetchProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            Expanded(child: _buildProductView()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            context.read<ProductBloc>().add(FetchProducts());
          },
        )
            : null,
      ),
      onChanged: (query) {
        context.read<ProductBloc>().add(SearchProducts(query));
      },
    );
  }

  Widget _buildProductView() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductInitial || state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProductError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is ProductSuccess) {
          if (state.products.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          if (isOffline) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 40, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text('You are viewing offline data'),
                  const SizedBox(height: 20),
                  RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: controller,
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: state.products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailsPage(product: product),
                              ),
                            );
                          },
                          child: CustomCardWidget(product: product),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              controller: controller,
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: state.isFetchingMore
                  ? state.products.length + 1
                  : state.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 6,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                if (state.isFetchingMore && index == state.products.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final product = state.products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(product: product),
                      ),
                    );
                  },
                  child: CustomCardWidget(product: product),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
