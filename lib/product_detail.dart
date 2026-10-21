import 'package:flutter/material.dart';
import 'package:taller_2_3/models/product.dart';
import 'package:taller_2_3/models/product_note.dart';
import 'package:taller_2_3/repositories/product_note_repository.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final ProductNoteRepository noteRepository;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.noteRepository,
  });
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final TextEditingController _noteController = TextEditingController();
  int _prioridad = 0;

  @override
  void initState() {
    super.initState();
    _loadLocalNote();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadLocalNote() async {
    final saved = await widget.noteRepository.getNoteForProduct(
      widget.product.id,
    );
    if (!mounted || saved == null) return;

    setState(() {
      _noteController.text = saved.note;
      _prioridad = saved.prioridad;
    });
  }

  Future<void> _saveLocalNote() async {
    final note = ProductNote(
      productId: widget.product.id,
      note: _noteController.text.trim(),
      prioridad: _prioridad,
      updatedAt: DateTime.now(),
      syncPending: true,
    );

    await widget.noteRepository.saveNote(note);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("The note is saved")));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Detalles del producto'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 260),
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AspectRatio(
                          aspectRatio: 2 / 3,
                          child: Image.asset(
                            widget.product.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return ColoredBox(
                                color: colors.surfaceContainerHighest,
                                child: Center(
                                  child: Icon(
                                    Icons.shop_2_outlined,
                                    size: 72,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    widget.product.nombre,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(
                          Icons.local_movies_outlined,
                          size: 18,
                        ),
                        label: Text(widget.product.categoria),
                        side: BorderSide.none,
                        backgroundColor: colors.secondaryContainer,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "\$ ${widget.product.precio.toString()}",
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.6,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    "Notas",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nota",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: List.generate(5, ((index) {
                      final value = index + 1;
                      return ChoiceChip(
                        label: Text(value.toString()),
                        selected: _prioridad == value,
                        onSelected: (_) {
                          setState(() {
                            _prioridad = value;
                          });
                        },
                      );
                    })),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_prioridad >= 2) {
                        _saveLocalNote();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Solo se pueden guardar productos con 2 o mas de prioridad",
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Guardar nota"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
