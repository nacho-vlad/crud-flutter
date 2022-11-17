import 'package:flutter/cupertino.dart';

import '../model/crud.dart';

class ProjectList extends ChangeNotifier{
  List<CRUDProject> _cruds = [];

  List<CRUDProject> get cruds => _cruds;

  set cruds(List<CRUDProject> cruds){
    _cruds = cruds;
    notifyListeners();
  }
}