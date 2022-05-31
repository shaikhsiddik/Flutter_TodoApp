import 'package:get/Get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controllers/task_controller.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/ui/theme.dart';
import 'package:todoapp/ui/widgets/button.dart';
import 'package:todoapp/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "9:30 PM";
  int _selectedRemind = 5;
  List<int> remindList=[
    5,
    10,
    15,
    20
  ];
  String _selectedRepeat = "None";
  List<String> repeatedList=[
    "None",
    "Daily",
    "Weekly",
    "Monthly"
  ];
  int _selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(title: "Title",hint: "Enter your title",controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your note",controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(
                icon: Icon(Icons.calendar_today_outlined,
                color: Colors.grey,),
                onPressed: () {
                  _getDateFromUser();
                },
              ),),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(title: "Start time", hint: _startTime,
                    widget: IconButton(
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ), onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                    },
                    ),
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(title: "End time", hint: _endTime,
                      widget: IconButton(
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ), onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                      },
                      ),
                    ),
                  )
                ],
              ),
              MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
              widget: DropdownButton(
                icon: Icon(Icons.keyboard_arrow_down,
                color: Colors.grey,),
                iconSize: 32,
                elevation: 4,
                style: subTitleStyle,
                underline: Container(height: 0,),
                onChanged: (String? newValue){
                  setState((){
                    _selectedRemind = int.parse(newValue!);
                  });
                },
                items:remindList.map<DropdownMenuItem<String>>((int value){
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),),
              MyInputField(title: "Repeat", hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue){
                    setState((){
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:repeatedList.map<DropdownMenuItem<String>>((String? value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString(),
                      style: TextStyle(color: Colors.grey),),
                    );
                  }).toList(),
                ),),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: ()=>_validateData())
                ],
              ),
              SizedBox(height: 18,)
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: (){
          Get.back();
        },
        child:Icon(Icons.arrow_back_ios,
            size: 20,
            color: Get.isDarkMode ? Colors.white:Colors.black),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage(
              "images/profile.png"
          ),
        ),
        SizedBox(width: 20,),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121),);
    if(_pickerDate!=null){
      setState((){
        _selectedDate = _pickerDate;
      });
    }else{
      print("something is worng");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async{
    var pickedTime =await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime==null){

    }else if(isStartTime == true){
      setState((){
        _startTime=_formatedTime;
      });
    }else if(isStartTime == false){
      setState((){
        _endTime=_formatedTime;
      });
    }
  }

  _showTimePicker(){
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_endTime.split(":")[1].split(" ")[0])));
  }

  _colorPallete(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Colors",
          style: titleStyle,),
        SizedBox(height: 8,),
        Wrap(
          children: List<Widget>.generate(3, (index){
            return GestureDetector(
              onTap: (){
                setState((){
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                  child:_selectedColor==index?Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 16,
                  ):Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _validateData(){
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      _addTaskToDb();
      Get.back();
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("Required", "All fields are required !",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: pinkClr,
      icon: Icon(Icons.warning_amber_rounded));
    }
  }

  _addTaskToDb() async {
   await _taskController.addTask(
        task:Task(
          note: _noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        ),
    );
  }
}
