class MenuItemDTO {
  String label;
  double price;
  String imagePath;

  MenuItemDTO(
      {required this.label, required this.price, required this.imagePath});

  factory MenuItemDTO.fromJson(Map<String, dynamic> json) {
    return MenuItemDTO(
        label: json['label'],
        price: json['price'],
        imagePath: json['imagePath']);
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'price': price, 'imagePath': imagePath};
  }
}
