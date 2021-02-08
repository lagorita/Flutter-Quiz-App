import 'package:denemequiz/const/const.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:sqflite/sqflite.dart';

class Category {
  int id;
  String name, image;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      cMainCategoryId: id,
      cMainCategoryName: name,
      cMainCategoryImage: image
    };
    return map;
  }

  Category();

  Category.fromMap(Map<String, dynamic> map) {
    id = map[cMainCategoryId];
    name = map[cMainCategoryName];
    image = map[cMainCategoryImage];
  }
}

class CategoryProvider {
  Future<Category> getCategoryById(Database db, int id) async {
    var maps = await db.query(tableCategoryName,
        columns: [cMainCategoryId, cMainCategoryName, cMainCategoryImage],
        where: "$cMainCategoryId=?",
        whereArgs: [id]);
    if (maps.length > 0) return Category.fromMap(maps.first);
    return null;
  }

  Future<List<Category>> getCategories(Database db) async {
    var maps = await db.query(tableCategoryName,
        columns: [cMainCategoryId, cMainCategoryName, cMainCategoryImage]);
    if (maps.length > 0)
      return maps.map((category) => Category.fromMap(category)).toList();
    return null;
  }
}

class CategoryList extends StateNotifier<List<Category>> {
  CategoryList(List<Category> state) : super(state ?? []);

  void addAll(List<Category> category) {
    state.addAll(category);
  }

  void add(Category category) {
    state = [
      ...state,
      category,
    ];
  }
}
