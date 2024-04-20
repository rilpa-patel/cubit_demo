import 'package:cubit_demo/models/todo.dart';

class TodoRepository {

  Future<List<Todo>> getTodos() async{
    return [Todo(id: 1, isCompleted: false, title: "Hello Rilpa")];
  }

  Future<Todo> createtodo( {required String title,required int id}) async{
    return Todo(id: id, isCompleted: false, title: title);
  }

  Future<int> deleteTodo({required int id}) async{
    return id;
  }
 }