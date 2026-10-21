import 'package:drift/drift.dart';
import 'package:taller_2_3/local/app_database.dart';
import 'package:taller_2_3/models/product_note.dart';

class ProductNoteLocalDataSource {
  final AppDatabase db;

  ProductNoteLocalDataSource(this.db);

  ProductNote _toDomain(ProductNoteRow row) {
    return ProductNote(
      productId: row.productId,
      note: row.note,
      prioridad: row.prioridad,
      updatedAt: row.updatedAt,
      syncPending: row.pendingSync
    );
  }

  Future<ProductNote?> getNoteForProduct(int productId) async {
    final query = db.select(db.productNotes)
      ..where((t) => t.productId.equals(productId));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<void> saveNote(ProductNote note) async {
    await db
        .into(db.productNotes)
        .insertOnConflictUpdate(
          ProductNotesCompanion.insert(
            productId: Value(note.productId),
            note: note.note,
            prioridad: note.prioridad,
            updatedAt: note.updatedAt,
            pendingSync: const Value(true),
          ),
        );
  }

  Future<List<ProductNote>> getPendingNotes() async {
    final rows = await (db.select(
      db.productNotes,
    )..where((t) => t.pendingSync.equals(true))).get();

    return rows.map(_toDomain).toList();
  }

  Future<void> markSynced(int productId) async {
    await (db.update(db.productNotes)
          ..where((t) => t.productId.equals(productId)))
        .write(const ProductNotesCompanion(pendingSync: Value(false)));
  }
}
