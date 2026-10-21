class ProductNote {
  final int productId;
  final String note;
  final int prioridad;
  final DateTime updatedAt;
  final bool syncPending; 

  const ProductNote({
    required this.productId,
    required this.note,
    required this.prioridad,
    required this.updatedAt,
    required this.syncPending
  });

  factory ProductNote.fromJson(Map<String,dynamic> json) {
    return ProductNote(
    productId: json['product_id'] as int, 
    note: json['note'], 
    prioridad: json['prioridad'] as int, 
    updatedAt: DateTime.parse(json['updated_at']),
    syncPending: json['sync_ending'] as bool
    );
  }

  Map<String,dynamic> toJson() => {
    'product_id':productId,
    'note':note,
    'prioridad':prioridad,
    'updated_at':updatedAt.toIso8601String(),
    'sync_pending': syncPending
  };
}