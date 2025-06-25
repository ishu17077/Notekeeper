import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeeper/screens/note_list.dart';
import 'package:notekeeper/state_management/note/note_bloc.dart';
import 'package:notekeeper/state_management/note_list/note_list_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NoteListCubit()),
        BlocProvider(create: (context) => NoteBloc()),
      ],
      child: MaterialApp(
          title: 'NoteKeeper',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.dark,
            primaryColorDark: Colors.white,
          ),
          home: NoteList()),
    );
  }
}
