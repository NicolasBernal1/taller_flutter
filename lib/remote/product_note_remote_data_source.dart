import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taller_2_3/models/product_note.dart';

class ProductNoteRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductNoteRemoteDataSource(this.firestore);

  Future<void> upsertNote(ProductNote note) async {
    await firestore
        .collection('product_notes')
        .doc(note.productId.toString())
        .set(note.toJson());
  }
}
