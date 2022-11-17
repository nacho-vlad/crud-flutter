import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:crud/component/crud_list.dart';
import 'package:crud/repo/crud_repo.dart';

class CRUDListView extends StatelessWidget{
  const CRUDListView({super.key});

  @override
  Widget build (BuildContext context){
    final repo = Provider.of<ProjectList>(context);
    return CupertinoPageScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return const<Widget> [CupertinoSliverNavigationBar(
              largeTitle: Text('CRUD Projects'),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: Column(
                children: [
                  CRUDList(repo.cruds),
                ],
              ),
            ),
          ),
    );
  }
}