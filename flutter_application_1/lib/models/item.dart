class Item {
  final String? title;
  bool? ismarked;

  Item({this.title, this.ismarked = false});
  Item.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        ismarked = map['ismarked'];

  void toggleStatus() {
    ismarked = !ismarked!;
  }

  Map<String, dynamic> toMap() => {'title': title, 'ismarked': ismarked};
}
