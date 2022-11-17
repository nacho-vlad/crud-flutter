
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CRUDProject{
  final int id = UniqueKey().hashCode;
  String name;
  String description;
  String course;
  DateTime endDate;
  int hours;

  CRUDProject(this.name, this.description, this.course, this.endDate, this.hours);
}