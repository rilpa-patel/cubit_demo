import 'dart:math';

import 'package:cubit_demo/cubits/addTodoCubit.dart';
import 'package:cubit_demo/cubits/deleteTodoCubit.dart';
import 'package:cubit_demo/cubits/todosCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodosCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AddTodoCubit()),
            BlocProvider(create: (_) => DeleteTodoCubit())
          ],
          child: const MyHomePage(title: 'Flutter Demo Home Page')),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<TodosCubit>().getTodos();
    });
  }

  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: BlocBuilder<TodosCubit, TodosState>(builder: (context, state) {
          if (state is TodosFetchSuccess) {
            return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final todo = state.todos[index];
                  return BlocConsumer<DeleteTodoCubit, DeleteTodoState>(
                    listener: (context, deletestate) {
                      if(deletestate is DeleteTodoSuccses){
                        context.read<TodosCubit>().deleteTodo(id: deletestate.id);

                      }
                    },
                    
                    builder: (context, deletestate) {
                      return ListTile(
                        onTap: () {
                          if(deletestate is DeleteTodoProgress){
                            return;
                          }
                          context.read<DeleteTodoCubit>().deleteTodo(todo.id);  
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Todo delete...........")));
                        },
                        subtitle: Text("Completed : ${todo.isCompleted}"),
                        title: Text(todo.title),
                        trailing: (deletestate is DeleteTodoProgress) ? (deletestate.id) == todo.id ? CircularProgressIndicator()  : Icon(Icons.delete) : Icon(Icons.delete),
                      );
                    }
                  );
                });
          }
          if (state is TodosFetchFailure) {
            return Center(
              child: Column(
                children: [
                  Text(state.errorMessage),
                  TextButton(
                      onPressed: () {
                        context.read<TodosCubit>().getTodos();
                      },
                      child: Text("Retry"))
                ],
              ),
            );
          }
      
          return Center(
            child: CircularProgressIndicator(),
          );
        }),
        floatingActionButton: BlocConsumer<AddTodoCubit, AddTodoState>(
          listener: (context, state) {
            
        if (state is AddTodoSuccsess) {
          context.read<TodosCubit>().addTodo(addedTodo: state.todo);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Todo added success")));
        }
         else if(state is AddTodoFailiure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
         }
          },
          builder: (context, state) {
            print(state.toString());
            return FloatingActionButton(
              onPressed: (){
                if (state is AddTodoProgress) {
                  return;
                }
      
                context.read<AddTodoCubit>().addtodo("Hello ", Random().nextInt(5000));
              },
              tooltip: 'Increment',
              child: state is AddTodoProgress ? CircularProgressIndicator() : Icon(Icons.add),
            );
          }
        ), 
      );
  }
}
