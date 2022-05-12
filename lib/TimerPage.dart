import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


/** 2022.05.08 code design: jongdroid
 * [최근수정] 2022.05.12 오후11:00 jongdroid
 * 타이머 시작, 정지, 초기화 함수가 있다.
 * 저장 아이콘을 통해 Dialog를 호출하여 입력받은 텍스트를 ListView로 나열한다.
 */

class MainTimer extends StatefulWidget {
  const MainTimer({Key? key}) : super(key: key);

  @override
  State<MainTimer> createState() => _MainTimerState();
}

class _MainTimerState extends State<MainTimer> {
  late Timer timer;
  var second = 0; //타이머의 초
  var min = 0; // 분
  var hour = 0; // 시간

  List<String> titleList = []; // title add ListTile
  List<String> subTitleList = []; // subtitle add ListTile
  var titleController = TextEditingController(); // textfield Controller for titleList, titleList it's get from user

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '오늘을 기록해보는건 어떨까요.',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    'image/note.png',
                    width: 30,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'image/hourglass.png',
                    height: 75,
                  ),
                  Text(
                    '$hour시',
                    style: TextStyle(fontSize: 45),
                  ),
                  Text(
                    '$min분',
                    style: TextStyle(fontSize: 45),
                  ),
                  Text(
                    '$second초',
                    style: TextStyle(fontSize: 45),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                    child: Icon(Icons.start),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {
                        startTimerBtn();
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton(
                      child: Icon(Icons.stop_circle),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        timer.cancel();
                      },
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton(
                      child: Icon(Icons.restart_alt), // timer reset
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        resetTimerBtn();
                      },
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton(
                      child: Icon(Icons.save), // timer save btn
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        showDialogGetTitleText(context);
                        timer.cancel(); // 저장 버튼을 눌렀을때도 타이머를 중단할 수 있도록 한다.
                        setState(() {});
                      },
                    )),
              ],
            ),
            Container(
                height: 300,
                child: ListView.builder(
                  itemCount: titleList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        titleList[index], // titleList는 emptyList이며, TextField를 통해 입력받은 텍스트를 저장한다.
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(subTitleList[index]), // emptyList, show hour,min,second from Timer
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showDialogGetTitleText(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('기록해보세요.'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: '오늘 무엇을 하셨나요?'),
                    controller: titleController,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  titleController.text = '';
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  titleList.add(titleController.text);  // TextField에 작성한 데이터 add to titleList
                  subTitleList.add('${hour}시${min}분${second}초'); // 타이머 시간도 함께 기록하기 위해 hour, min, second add to subTitleList
                  Navigator.pop(context); // 저장을 완료하고 Dialog창을 닫는다.
                  titleController.clear(); // titleController에 담겨있는 텍스트 clear
                  resetTimerBtn();
                  setState(() {});  // [주의]setState 내부에 함수가 들어갈 수 없음
                },
              ),
            ],
          );
        });
  }

  void startTimerBtn() {
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        second++;
        if (second == 60) {
          second = 0;
          min++;
        }
        if (min == 60) {
          min = 0;
          hour++;
        }
      });
    });
  }

  void resetTimerBtn() {
    timer.cancel();
    setState(() {
      second = 0;
      min = 0;
    });
  }
} //end of Stateful
