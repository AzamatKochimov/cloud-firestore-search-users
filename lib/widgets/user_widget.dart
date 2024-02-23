import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../style/app_style.dart';

Widget userWidget(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.yellow.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            doc['name'],
            style: AppStyle.mainTitle,
          ),
          const SizedBox(height: 4),
          Text(
            doc['email'],
            style: AppStyle.mainDateTitle,
          ),
          const SizedBox(height: 4),
          Text(
            doc['age'],
            style: AppStyle.mainContent,
          ),
        ],
      ),
    ),
  );
}
