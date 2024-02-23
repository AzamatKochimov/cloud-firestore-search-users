import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isEmpty = false;

  void addUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String age = ageController.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && age.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('Users').add({
          'name': name,
          'age': age,
          'email': email,
        });
        Navigator.pop(context);
      } catch (error) {
        print('Error adding user: $error');
      }
    } else {
      setState(() {
        isEmpty = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text("Enter User Details"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.white24),
                hintText: 'Name',
                errorText: isEmpty ? 'Name is required' : null,
              ),
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.white24),
                hintText: 'Email',
                errorText: isEmpty ? 'Email is required' : null,
              ),
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.white24),
                hintText: 'Age',
                errorText: isEmpty ? 'Age is required' : null,
              ),
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            const SizedBox(height: 15),
            MaterialButton(
              onPressed: addUser,
              shape: const StadiumBorder(
                  side: BorderSide(width: 1, color: Colors.white70)),
              child: const Text(
                "Done",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
