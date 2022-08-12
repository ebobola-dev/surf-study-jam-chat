import 'package:flutter/material.dart';

double getSmallestWidth(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return size.height > size.width ? size.width : size.height;
}
