// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_local_variable, avoid_single_cascade_in_expression_statements, unused_element, use_build_context_synchronously
import 'package:flutter/cupertino.dart';

import '../@types/Entity.type.dart';

class DeleteActionSheet extends StatelessWidget {
  final Entity entity;
  final Function() onRefresh;
  const DeleteActionSheet(
      {super.key, required this.entity, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('Confirmation'),
      message: Text(
          'Are you sure you want to delete? \n ${entity.issuer} (${entity.title})'),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            entity.delete();
            onRefresh();
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
    );
  }
}
