// ignore_for_file: file_names

import 'package:cubit_demo/models/todo.dart';
import 'package:cubit_demo/repositories/todoRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TodosState{}


class TodosInitial extends TodosState {}


class TodosFetchInProgress extends TodosState {}


class TodosFetchSuccess extends TodosState {
  final List<Todo> todos;

  TodosFetchSuccess({required this.todos});
}

class TodosFetchFailure extends TodosState {
  final String errorMessage;

  TodosFetchFailure({required this.errorMessage});
}


class TodosCubit extends Cubit<TodosState> {

  final TodoRepository _todoRepository = TodoRepository();

  TodosCubit() : super(TodosInitial());


  void getTodos() async{
    try {

      emit(TodosFetchInProgress());
      emit(TodosFetchSuccess(
        todos: await _todoRepository.getTodos()
      ));
      
    } catch (e) {
      emit(TodosFetchFailure(
        errorMessage: e.toString()
      ));
    }
  }

  void addTodo({required Todo addedTodo}) {
    if(state is TodosFetchSuccess) {
      List<Todo> todos = (state as TodosFetchSuccess).todos;

      todos.add(addedTodo);
      emit(TodosFetchSuccess(todos: todos));
    }
  }

  void deleteTodo({required int id}){
    if(state is TodosFetchSuccess){
      List<Todo> todos = (state as TodosFetchSuccess).todos;

      todos.removeWhere((element) => element.id == id);
      emit(TodosFetchSuccess(todos: todos));
    }
  }
}


