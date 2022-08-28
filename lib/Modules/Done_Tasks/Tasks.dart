import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/sharde/cubit/cubit.dart';
import 'package:todo/sharde/cubit/states.dart';
import '../../sharde/Compenents/component.dart';
import '../../sharde/Compenents/constances.dart';

class Tasksscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit ,AppStates>(
     listener: (context , state){},
      builder: (context , state){

       var tasks = AppCubit.get(context).newTasks;

        return tasksbuilder(
          tasks: tasks,
        );
      },
    );
  }
}
