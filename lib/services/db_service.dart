import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  static Future<void> addUsers(String name, String email, int age) async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");

    await users
        .add({
          'name': name,
          'email': email,
          'age': age,
        })
        .then((user) => print("User Added"))
        .catchError((error) => print("Failed to add: $error"));
  }

  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");

    QuerySnapshot querySnapshot = await users.get();
    List<Map<String, dynamic>> userList = [];

    querySnapshot.docs.forEach((doc) {
      userList.add(doc.data() as Map<String, dynamic>);
    });

    return userList;
  }

  static Future<void> updateUser(String newName, String newEmail, int newAge) async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");

    await users
        .doc('userId')
        .update({
          'name': newName,
          'email': newEmail,
          'age': newAge,
        })
        .then((value) => print("User updated successfully!"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  static Future<void> deleteUser() async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");

    await users
        .doc()
        .delete()
        .then((value) => print("User deleted successfully!"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  static Future<void> fetchUsersAboveAge(int minAge) async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");

    await users
        .where('age', isGreaterThan: minAge)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print('${doc.id} => ${doc.data()}');
      });
      // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => print("Failed to fetch users: $error"));
  }
}
