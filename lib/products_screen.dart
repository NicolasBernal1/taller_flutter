import 'package:flutter/material.dart';
import 'package:taller_2_3/models/product.dart';
import 'package:taller_2_3/product_card.dart';
import 'package:taller_2_3/product_detail.dart';
import 'package:taller_2_3/repositories/product_note_repository.dart';
import 'package:taller_2_3/services/product_service.dart';

class ProductScreen extends StatefulWidget {
  final ProductNoteRepository noteRepository;
  const ProductScreen({super.key, required this.noteRepository});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductService _service;
  late Future<List<Product>> _futureProducts;

  void retryProductList() {
    setState(() {
      _futureProducts = _service.getProducts();
    });
  }

  @override
  void initState() {
    super.initState();
    _service = ProductService('https://dummyjson.com/c/60a6-824b-4b44-8f29');
    _futureProducts = _service.getProducts();
  }

  void openProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(
          product: product,
          noteRepository: widget.noteRepository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Catalogo de productos'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Sincronizar notas',
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await widget.noteRepository.syncPending();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<Product>>(
      future: _futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'No pudimos cargar los productos',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: retryProductList,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shop, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Todavía no hay productos disponibles',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: products.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Proximos productos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${products.length} productos disponibles',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Toca una tarjeta para ver más',
                    ),
                  ],
                ),
              );
            }
            final product = products[index - 1];

            return ProductCard(
              product: product,
              onTap: () {
                openProductDetail(product);
              }
            );
          },
        );
      },
    );
  }
}
