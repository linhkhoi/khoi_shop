import 'package:flutter/material.dart';
import 'package:khoi_shop/models/cart_attr.dart';
import 'package:khoi_shop/models/favs_attr.dart';

class FavsProvider with ChangeNotifier{
  Map<String, FavsAttr> _favsItems = {};

  Map<String, FavsAttr> get getFavsItems {
    return {..._favsItems};
  }

  void addAndRemoveFromFavs(String id, String title, double price, String imageUrl){
    if(_favsItems.containsKey(id)){
      _favsItems.remove(id);
    } else {
      _favsItems.putIfAbsent(id, () => FavsAttr(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          imageUrl: imageUrl
      )
      );
    }
    notifyListeners();
  }

  void removeItem(String productId){
    _favsItems.remove(productId);
    notifyListeners();
  }

  void clearFavs(){
    _favsItems.clear();
    notifyListeners();
  }
}