class Dog {
  int? id;
  String name;
  String breed;

  Dog({this.id, required this.name, required this.breed});

  factory Dog.fromJson(Map<String, dynamic> json) => Dog(
        id: json['id'],
        name: json['name'],
        breed: json['breed'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'breed': breed,
      };
}
