import 'package:flutter/material.dart';

class Item {
  int _id;
  String _description;
  double _price;
  String _image;

  Item(this._id, this._description, this._price, this._image);

  int get ItemID => _id;

  String get ItemDescription => _description;

  double get ItemPrice => _price;

  String get ItemImage => _image;
}