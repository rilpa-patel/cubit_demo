import 'package:cubit_demo/models/todo.dart';
import 'package:cubit_demo/repositories/todoRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddTodoState {}

class AddTodoInitial extends AddTodoState{}

class AddTodoProgress extends AddTodoState{}

class AddTodoFailiure extends AddTodoState{
  final String errorMessage;
  AddTodoFailiure({required this.errorMessage});
}

class AddTodoSuccsess extends AddTodoState{
  final Todo todo;

  AddTodoSuccsess({required this.todo});
}

class AddTodoCubit extends Cubit<AddTodoState>{
  final TodoRepository _repository = TodoRepository();
  AddTodoCubit() : super(AddTodoInitial());

  void addtodo(String title, int id) async{

    try{
      emit(AddTodoProgress());
      emit(AddTodoSuccsess(todo: await _repository.createtodo(title: title, id: id)));

    }catch(e){
      emit(AddTodoFailiure(errorMessage: e.toString()));
    }
  }
}

