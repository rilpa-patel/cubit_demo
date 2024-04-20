import 'package:cubit_demo/repositories/todoRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteTodoState{}

class DeleteTodoInitial extends DeleteTodoState{}

class DeleteTodoProgress extends DeleteTodoState{
  final int id;

  DeleteTodoProgress({required this.id});
}

class DeleteTodoSuccses extends DeleteTodoState{
  final int id;
  DeleteTodoSuccses({required this.id});
}

class DeleteTodoFailiar extends DeleteTodoState{
  final String errorMessage;
  DeleteTodoFailiar({required this.errorMessage});
}

class DeleteTodoCubit extends Cubit<DeleteTodoState>{
  DeleteTodoCubit() : super(DeleteTodoInitial());
  TodoRepository _todoRepository = TodoRepository();

  void deleteTodo(int id)async{
    try{
      emit(DeleteTodoProgress(
        id: id
      )); await Future.delayed(Duration(seconds: 5));
      emit(DeleteTodoSuccses(id: await _todoRepository.deleteTodo(id: id)));
    }catch(e){
      emit(DeleteTodoFailiar(errorMessage: e.toString()));
    }
  }
}