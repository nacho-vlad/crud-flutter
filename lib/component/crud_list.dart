import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:crud/model/crud.dart';
import 'package:provider/provider.dart';
import 'package:crud/pages/create_view.dart';
import 'package:crud/repo/crud_repo.dart';

class CRUDList extends StatelessWidget {

  final List<CRUDProject> cruds;


  const CRUDList(this.cruds, {super.key});

  void delete(BuildContext context, ProjectList repo, CRUDProject crud) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Confirm"),
        content: const Text("Are you sure you want to delete?"),
        actions: [
          CupertinoDialogAction(
            child: const Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text("Yes"),
            onPressed: () {
              repo.cruds = repo.cruds
                  .where((s) => s.id != crud.id)
                  .toList();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<ProjectList>(context);
    return SizedBox(
      // height: 800,
      child: ListView.separated(
        itemCount: cruds.length,
        itemBuilder: (context, index) {
          final crud = cruds[index];
          return Container(
            width: 350,
            // height: 200,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            crud.name,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            child: const Icon(
                              CupertinoIcons.pencil,
                              size: 40,
                            ),
                            onTap: () => Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => ChangeNotifierProvider.value(
                                  value: repo,
                                  child: CreateView(crud: crud),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: const Icon(
                              CupertinoIcons.trash,
                              size: 40,
                            ),
                            onTap: () => delete(context, repo, crud),
                          ),
                        ],
                      ),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [

                                Text(
                                  "${crud.description}"
                                ),
                                Text(
                                    "${crud.course} - ${crud.hours} to complete"
                                ),
                                Text(
                                    "Finished on ${crud.endDate}"
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => const SizedBox(
          height: 30,
        ),
      ),
    );
  }
}