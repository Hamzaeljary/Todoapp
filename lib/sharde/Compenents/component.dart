import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo/sharde/cubit/cubit.dart';

Widget buildTasksItem(Map module,context) =>  Dismissible(
  key: Key(module['id'].toString()),
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40.0,
  
          child: Text('${module['time']}'),
  
        ),
  
        SizedBox(
  
          width: 15.0,
  
        ),
  
        Expanded(
  
          child: Column(mainAxisSize: MainAxisSize.min,
  
              crossAxisAlignment: CrossAxisAlignment.start,
  
              children: [
  
            Row(
  
              children: [
  
                Text(
  
                  '${module['title']}',
  
                  style: TextStyle(
  
                      color: Colors.green,
  
                      fontWeight: FontWeight.bold,
  
                      fontSize: 18.0),
  
                ),
  
              ],
  
            ),
  
  
  
            SizedBox(height: 12.0,),
  
            Text(
                '${module['date']}',
  
                style: TextStyle(
  
                    color: Colors.grey,
  
                    fontWeight: FontWeight.bold,
  
                    fontSize: 15.0)),
  
          ]),
  
        ),
  
        SizedBox(
  
          width: 15.0,
  
        ),
  
        IconButton(onPressed: (){
  
          AppCubit.get(context).UpdateDB(status: 'done', id: module['id']);
  
        },
  
            icon: Icon(Icons.check_box,color: Colors.green,)
  
        ),
  
        IconButton(onPressed: (){
  
          AppCubit.get(context).UpdateDB(status: 'archived', id: module['id']);
  
        },
  
            icon: Icon(Icons.archive,color: Colors.black45,))
  
      ],
  
    ),
  
  ),
  onDismissed: (direction){
      AppCubit.get(context).deleteFromDB(id: module['id']);
  },
);
Widget tasksbuilder({
  required  List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder:(context) => ListView.separated(
    itemBuilder: ( context, index) => buildTasksItem(tasks[index],context) ,
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ) ,
    itemCount: tasks.length,),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,size: 100.0,color: Colors.grey,),
        Text('No Tasks Yet, Please Add Some Tasks',style: TextStyle(
            fontSize: 17.0,
            color: Colors.grey,
            fontWeight: FontWeight.bold
        ),)
      ],
    ),
  ),
);