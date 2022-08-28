import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/sharde/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Modules/Archived/Archived.dart';
import '../../Modules/Done_Tasks/Tasks.dart';
import '../../Modules/new_Tasks/Done_tasks.dart';
import 'package:todo/sharde/cubit/cubit.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(appInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int indexed = 0;
  List<Widget> screens = [
    Tasksscreen(),
    donetasksscreen(),
    Archivedscreen(),
  ];
  List<String> titles = [
    'Tasks screen',
    'Done screen',
    'Archived screen',
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(int index) {
    indexed = index;
    emit(appChangeNavBarState());
  }

  var database;
  void crtDatabase() {
    openDatabase('tdo.db', version: 1, onCreate: (dtb, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE mutable(id INTEGER PRIMARY KEY,title TEXT,time TEXT,date TEXT,status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((er) {
        print('error when creating table ${er}');
      });
    }, onOpen: (database) {
      getDataFromDB(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(appCreateDBStates());
    });
  }

  insertinotDB({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO mutable(title,time , date, status) VALUES("${title}","${time}","${date}","new")')
          .then((value) {
        emit(appInsertDBStates());
        getDataFromDB(database);
        print('$value inserted successfully');
      }).catchError((err) {
        print('not inserted ${err.toString()}');
      });
      await null;
    });
  }

  void getDataFromDB(database){
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(appGetDBLoadingStates());
    database.rawQuery('SELECT * FROM mutable').then((value) {
      value.forEach((element){
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else
           archivedTasks.add(element);
      });
    });
  }

  bool isBottomShow = false;
  IconData iconed = Icons.edit;

  void changeBottomCheteState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomShow = isShow;
    iconed = icon;
    emit(appChangeBottomSheetState());
  }

  void UpdateDB({
    required String status,
    required int id,
  }) async {
    database
        .rawUpdate('UPDATE mutable SET status = ? WHERE id = ?', ['$status', id]).then((value){
            getDataFromDB(database);
            emit(appUpdateDBStates());
    });
  }
  void deleteFromDB({
    required int id,
  }) async {
    database
        .rawDelete('DELETE FROM mutable WHERE id = ?', [id]).then((value){
      getDataFromDB(database);
      emit(appDeleteDBStates());
    });
  }
}
