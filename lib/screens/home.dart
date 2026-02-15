import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/todo.dart';

import '../widget/todo_items.dart';

class Home extends StatefulWidget {
   Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundTodos = [];
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _foundTodos = List.from(todosList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 80),
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50,bottom: 20),
                        child: Text("All ToDos",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
                      ),
                      for( ToDo todo in _foundTodos)
                      TodoItems(todo: todo,
                      onToDoChanged:  handelTdoChange,
                        onDeleteItem: deleteTodoItem,
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey,offset: Offset(0.0,0.0),
                    blurRadius: 10.0,
                      spreadRadius: 0.0,

                    ),
                  ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    onSubmitted: (_) => _addTodoItem(),
                    decoration: InputDecoration(
                      hintText: "Add new todo item",
                      border: InputBorder.none,
                    ),
                  ),

                )),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: _addTodoItem,
                       style: ElevatedButton.styleFrom(
                         backgroundColor: tdBlue, // button color
                         foregroundColor: Colors.white, // text color
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(15),
                         ),
                         elevation: 8,
                       ),
                       child: Text(
                         "+",
                         style: TextStyle(
                           fontSize: 32,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ),
                   ),
                 )

              ],
            ),
          )
        ],
      ),

    );
  }

  void handelTdoChange(ToDo todo){
    setState(() {
      todo.isDone = !todo.isDone;
      _runFilter(_searchController.text);
    });
  }

  void deleteTodoItem(String id){
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      _runFilter(_searchController.text);
    });
  }

  void _addTodoItem(){
    String text = _todoController.text.trim();
    if(text.isEmpty) return; // don't add empty todos

    setState(() {
      final newTodo = ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: text,
      );
      todosList.insert(0, newTodo);
      _todoController.clear();
      FocusScope.of(context).unfocus();
      _runFilter(_searchController.text);
    });
  }

  @override
  void dispose(){
    _todoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget searchBox(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search,color: tdBlack,size: 20,),
            prefixIconConstraints: BoxConstraints(
              maxHeight: 20,
              minWidth: 25,
            ),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(color: tdGrey)
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = List.from(todosList);
    } else {
      results = todosList
          .where((todo) => todo.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundTodos = results;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu,color: tdBlack,size: 30,),
          Container(
            width: 40,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // 40 ka half
              child: Image.asset(
                'assets/images/zain.jpg',
                fit: BoxFit.cover,
              ),
            ),
          )

        ],
      ),
    );
  }
}
