import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../sharde/Compenents/component.dart';
import '../../sharde/cubit/cubit.dart';
import '../../sharde/cubit/states.dart';

class donetasksscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit ,AppStates>(
      listener: (context , state){},
      builder: (context , state){

        var tasks = AppCubit.get(context).doneTasks;

        return tasksbuilder(
          tasks: tasks,
        );
      },
    );
  }
}
