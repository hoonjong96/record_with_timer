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

  List<String> titleList = []; // ListView title add List
  List<String> subTitleIndex = []; // ListView subtitle add List

  // Dialog 텍스트 컨트롤러
  var titleController = TextEditingController();

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
                        fontFamily: 'tmonsori'),
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
                      setState(() {
                        startTimerBtn();
                      });
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton(
                      child: Icon(Icons.stop_circle),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        setState(() {
                          timer.cancel();
                        });
                      },
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton(
                      child: Icon(Icons.restart_alt),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        setState(() {
                          resetTimerBtn();
                        });
                      },
                    )),
                Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton(
                      child: Icon(Icons.save),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        setState(() {
                          showPerformanceDialog(context);
                        });
                        timer.cancel();
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
                        titleList[index],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${subTitleIndex[index]}'),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showPerformanceDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('기록하기'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: '무엇을 하셨나요?'),
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
                  titleList.add(titleController.text);
                  subTitleIndex.add('${hour}시${min}분${second}초');
                  Navigator.pop(context);
                  setState(() {});
                  titleController.clear();
                  resetTimerBtn();
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
    setState(() {
      timer.cancel();
      second = 0;
      min = 0;
    });
  }
} //end of Stateful
