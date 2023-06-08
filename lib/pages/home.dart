import 'package:flutter/material.dart';
import 'package:baseshop/pages/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomeState();
 }

class _HomeState extends State<Home> {
  //const Home({Key? key}) : super(key: key);
  List<String> todoList = ['Row01', 'Row02', 'Row03', 'Row04', 'Row05'];
  //late String _userTodo;
  late String _userTodo;
  //final todoList = List<String>.generate(10, (i) => 'Product $i');

  /*
  void initBase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBase();
  }
*/

  void _menuOpen(){
  Navigator.of(context).push(
    MaterialPageRoute(builder: (BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu'),),
         body: Row(
            children: [
                ElevatedButton(onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                          (Route<dynamic> route) => false);
                            }, child: const Text('Home')),
              const Padding(padding: EdgeInsets.only(left: 15)),
          const Text(('simple menu'))
    ],
  ),
);
    })
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To-do list'),centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: _menuOpen,
            )
          ],
        ),
        // implement the list view
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('items').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
           if(!snapshots.hasData) return const Text('no issue!');
           return ListView.builder(
               shrinkWrap: true,
               // the number of items in the list
               itemCount: snapshots.data?.docs.length,
               // display each item of the product list
               itemBuilder: (context, index) {
                 return Dismissible(
                   key: Key(snapshots.data?.docs[index].id as String ),
                   child: Card(
                     // In many cases, the key isn't mandatory
                     key: ValueKey(snapshots.data?.docs[index].id),
                     child: ListTile(
                       title: Text(snapshots.data?.docs[index].get('item') as String),
                       trailing: IconButton(
                         icon: const Icon(
                             Icons.delete_sweep, color: Colors.lightBlue
                                    ),
                              onPressed: () {
    FirebaseFirestore.instance.collection('items').doc(snapshots.data?.docs[index].id).delete();
                                            },
                                ),
                              ),
                            ),
                   onDismissed: (direction) {
                     FirebaseFirestore.instance.collection('items').doc(snapshots.data?.docs[index].id).delete();
                            },
                        );
                    },
                  );
                },
          ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Добавить'),
                content: TextField(
                onChanged: (String value) {
                  _userTodo = value ;
                },
              ),
              actions: [
                ElevatedButton(onPressed: () {
                  setState(() {
                    FirebaseFirestore.instance.collection('items').add({'item': _userTodo});
                    todoList.add( _userTodo );
                  });
                  Navigator.of(context).pop();
                }, child: const Text('Добаавить'))
              ],
            );
          });
        },
          child: const Icon(
            Icons.add_box,
          color: Colors.greenAccent
          ),
    ),
    );
  }
}
