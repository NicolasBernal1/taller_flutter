
class Product {
  final int id;
  final String nombre;
  final String categoria;
  final int precio;
  final String imagePath;

  Product({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.imagePath
  });

  factory Product.fromJson(Map<String,dynamic> json) {
    return Product(
    id: json['id'],
    nombre: json['nombre'],
    categoria: json['categoria'], 
    precio: json['precio'], 
    imagePath: json['image_path']
    );
  }
}
