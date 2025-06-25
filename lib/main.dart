import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeeper/screens/note_list.dart';
import 'package:notekeeper/state_management/note/note_bloc.dart';
import 'package:notekeeper/state_management/note_list/note_list_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  NoteListCubit _noteListCubit = NoteListCubit();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _noteListCubit),
        BlocProvider(create: (context) => NoteBloc(_noteListCubit)),
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
