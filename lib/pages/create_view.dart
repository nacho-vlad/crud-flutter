import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crud/model/crud.dart';
import 'package:crud/repo/crud_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

class CreateView extends StatefulWidget {
  final CRUDProject? crud;

  const CreateView({super.key, this.crud});

  @override
  State<StatefulWidget> createState() => CreateViewState();
}
const double _kItemExtent = 32.0;


class CreateViewState extends State<CreateView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  DateTime endDate = DateTime.now();
  late int hours=0;
  late int weekType=0;

  @override
  void initState() {
    super.initState();
    if (widget.crud != null) {
      nameController.text = widget.crud!.name;
      descriptionController.text = widget.crud!.description;
      courseController.text = widget.crud!.course;
      setState(() {
        endDate = widget.crud!.endDate;
        hours = widget.crud!.hours;
      });
    }
  }

  void create(ProjectList repo) async {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        courseController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Error"),
          content: const Text("All fields required"),
          actions: [
            CupertinoDialogAction(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }
    if (widget.crud == null) {
      final prefs = await SharedPreferences.getInstance();
      repo.cruds = [
        ...repo.cruds,
        CRUDProject(
          nameController.text,
          courseController.text,
          descriptionController.text,
          endDate,
          hours,
        ),
      ];
    } else {
      widget.crud!.name = nameController.text;
      widget.crud!.course = courseController.text;
      widget.crud!.description = descriptionController.text;
      widget.crud!.endDate = endDate;
      widget.crud!.hours = hours;
      repo.cruds = [...repo.cruds];
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<ProjectList>(context);

    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text(widget.crud == null ? 'Create' : "Edit"),
            )
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        CupertinoTextField(
                          placeholder: "Name",
                          controller: nameController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CupertinoTextField(
                          placeholder: "Course",
                          controller: courseController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CupertinoTextField(
                          placeholder: "Description",
                          controller: descriptionController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Finished on'),
                        CupertinoButton(
                          onPressed: () => _showDialog(
                            CupertinoDatePicker(
                              initialDateTime: endDate,
                              mode: CupertinoDatePickerMode.date,
                              use24hFormat: true,
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() => endDate = newTime);
                              },
                            ),
                          ),
                          child: Text(
                            '${endDate.day} ${endDate.month}',
                            style: const TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                        const Text('Hours'),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _showDialog(
                            NumberPicker(
                              value: hours,
                              minValue: 0,
                              maxValue: 100,
                              step: 1,
                              haptics: true,
                              onChanged: (value) => setState(() => hours = value),
                            ),
                          ),
                          child: Text(
                            "${hours}",
                            style: const TextStyle(
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              CupertinoButton.filled(
                child: Text(
                  widget.crud == null ? 'Create' : "Edit",
                  style: const TextStyle(color: CupertinoColors.white),
                ),
                onPressed: () {
                  create(repo);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }
}
