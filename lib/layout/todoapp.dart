import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Modules/Archived/Archived.dart';
import 'package:todo/Modules/Done_Tasks/Tasks.dart';
import 'package:todo/Modules/new_Tasks/Done_tasks.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:todo/sharde/cubit/cubit.dart';
import 'package:todo/sharde/cubit/states.dart';

import '../sharde/Compenents/constances.dart';
class Home extends StatelessWidget {
  var scfldkey = GlobalKey<ScaffoldState>();
  var formkey= GlobalKey<FormState>();
  var ctrl=TextEditingController();
  var ctrltm=TextEditingController();
  var ctrldate=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..crtDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
         listener: (BuildContext context,AppStates state){
           if(state is appInsertDBStates){
             Navigator.pop(context);
           }
         },
        builder:(BuildContext context,AppStates state) {
           AppCubit cb =AppCubit.get(context);
           return Scaffold(
             key: scfldkey,
             appBar: AppBar(
               title: Text(cb.titles[cb.indexed]),
             ),
             body: ConditionalBuilder(
               condition: state is! appGetDBLoadingStates,
               builder: (context) => cb.screens[cb.indexed],
               fallback:(context) => Center(child: CircularProgressIndicator(),),
             ),
             floatingActionButton: FloatingActionButton(
               onPressed: () {
                 if(cb.isBottomShow){
                   if(formkey.currentState!.validate()){
                     cb.insertinotDB(title: ctrl.text, time: ctrltm.text, date: ctrldate.text);
                   }
                 }else {
                   scfldkey.currentState?.showBottomSheet(
                       elevation: 50.0,
                           (context) =>
                           Container(
                             color: Colors.white,
                             padding: EdgeInsets.all(10.0),
                             child: Form(
                               key: formkey,
                               child: Column(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   TextFormField(
                                     keyboardType: TextInputType.text,
                                     controller: ctrl,
                                     validator:(value){
                                       if(value!.isEmpty){
                                         return 'text is not be empty';
                                       }
                                       return null;
                                     } ,
                                     decoration: InputDecoration(
                                       border: OutlineInputBorder(),
                                       prefix: Icon(Icons.title),
                                       label:Text("Task text"),
                                     ),
                                   ),
                                   SizedBox(height: 15.0),
                                   TextFormField(
                                     onTap: (){
                                       showTimePicker(context: context,
                                           initialTime: TimeOfDay.now()).then((value){
                                         ctrltm.text=value!.format(context).toString();
                                       }
                                       );
                                     },
                                     keyboardType: TextInputType.datetime,
                                     controller: ctrltm,
                                     validator:(value){
                                       if(value!.isEmpty){
                                         return 'timing is not be empty';
                                       }
                                       return null;
                                     } ,
                                     decoration: InputDecoration(
                                       border: OutlineInputBorder(),
                                       prefix: Icon(Icons.access_time_filled),
                                       label:Text("Task Time"),
                                     ),
                                   ),
                                   SizedBox(height: 15.0),
                                   TextFormField(
                                     onTap: (){
                                       showDatePicker(context: context,
                                           initialDate: DateTime.now(),
                                           firstDate: DateTime.now(),
                                           lastDate: DateTime.parse('2022-12-12')).then((value)
                                       {
                                         ctrldate.text=DateFormat.yMMMd().format(value!);
                                       });
                                     },
                                     keyboardType: TextInputType.datetime,
                                     controller: ctrldate,
                                     validator:(value){
                                       if(value!.isEmpty){
                                         return 'date is not be empty';
                                       }
                                       return null;
                                     } ,
                                     decoration: InputDecoration(
                                       border: OutlineInputBorder(),
                                       prefix: Icon(Icons.calendar_today),
                                       label:Text("Task Date"),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           )

                   ).closed.then((value){
                     cb.changeBottomCheteState(isShow: false, icon: Icons.edit);
                   });
                   cb.changeBottomCheteState(isShow: true, icon: Icons.add);
                 }
               }, child: Icon(cb.iconed),
             ),
             bottomNavigationBar: BottomNavigationBar(
               type: BottomNavigationBarType.fixed,
               currentIndex: cb.indexed,
               onTap: (index) {
                 cb.changeIndex(index);
               },
               items: [
                 BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Done'),
                 BottomNavigationBarItem(
                     icon: Icon(Icons.check_circle_outline_outlined), label: 'Task'),
                 BottomNavigationBarItem(
                     icon: Icon(Icons.archive_outlined), label: 'Archived'),
               ],
             ),
           );
        },
      ),
    );
  }
}
