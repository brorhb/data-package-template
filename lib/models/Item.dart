class Item {
  int id;
  String title;

  Item({this.id, this.title});

  factory Item.fromJson(Map<String, dynamic> json) =>
      Item(id: json["id"], title: json["title"] ?? "");

  Map<String, dynamic> toJson() {
    return {"id": id, "title": title};
  }
}
