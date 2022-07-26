// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category_model.dart';

const CATEGORY_DB = 'cetogery_database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertcategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
  Future<void> resetCategory();
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  final ValueNotifier<List<CategoryModel>> incomeCategoryList =
      ValueNotifier([]);
  final ValueNotifier<List<CategoryModel>> expenseCategoryList =
      ValueNotifier([]);

  @override
  Future<void> insertcategory(CategoryModel value) async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB);
    _categoryDb.put(value.id, value);

    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB);
    return _categoryDb.values.toList();
  }

  refreshUI() async {
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();
    final _allCategory = await getCategories();
    await Future.forEach(_allCategory, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryList.value.add(category);
      } else {
        expenseCategoryList.value.add(category);
      }
    });
    // ignore: invalid_use_of_visible_for_testing_member
    incomeCategoryList.notifyListeners();
    // ignore: invalid_use_of_visible_for_testing_member
    expenseCategoryList.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB);
    _categoryDb.delete(categoryID);
    refreshUI();
  }

  @override
  Future<void> resetCategory() async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB);
    _categoryDb.clear();
  }
}
