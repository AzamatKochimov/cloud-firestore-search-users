import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filtering_cloud_firestore/pages/add_user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/user_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  List _allResults = [];
  List _resultList = [];

  getUsers() async{
    var data = await FirebaseFirestore.instance.collection("Users").orderBy('name').get();

    setState(() {
      _allResults = data.docs;
    });
    searchUsersList();
  }

  _onSearchChanged(){
    print(_searchController.text);
    searchUsersList();
  }

  searchUsersList(){
    var showUsers =[];

    if(_searchController.text != ""){
      for(var user in _allResults){
        var name = user["name"].toString().toLowerCase();
        if(name.contains(_searchController.text.toLowerCase())){
          print(name.toString());
          showUsers.add(user);
        }
      }
    }
    else{
      showUsers = List.from(_allResults);
    }

    setState(() {
      _resultList = showUsers;
    });
  }

  @override
  void initState() {
    getUsers();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getUsers();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    var usersRef = FirebaseFirestore.instance.collection("Users");
    usersRef.orderBy('name').limit(3);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.yellow,
          elevation: 2,
          title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Users").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> users) {
                  if (users.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (users.hasData) {
                    return ListView.builder(
                      itemCount: _resultList.length,
                      itemBuilder: (context, index) {
                        final note = users.data!.docs[index];
                        return userWidget(() {
                          _editUserDialog(context, note);
                          
                        }, note);
                      },
                    );
                  }
                  return const Center(
                    child: Text(
                      "There is no note",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.yellow,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AddUser()));
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  void _editUserDialog(BuildContext context, DocumentSnapshot users) {
    TextEditingController nameController =
        TextEditingController(text: users['name']);
    TextEditingController emailController =
        TextEditingController(text: users['email']);
    TextEditingController ageController =
        TextEditingController(text: users['age']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String name = nameController.text.trim();
                String email = emailController.text.trim();
                String age = ageController.text.trim();

                if (name.isNotEmpty && email.isNotEmpty && age.isNotEmpty) {
                  try {
                    await users.reference.update({
                      'name': name,
                      'email': email,
                      'age': age,
                    });
                    Navigator.pop(context);
                  } catch (error) {
                    print('Error updating note: $error');
                  }
                }
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await users.reference.delete();
                  Navigator.pop(context);
                } catch (error) {
                  print('Error deleting note: $error');
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
