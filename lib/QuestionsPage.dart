import 'package:assignment/database.dart' as database;
import 'package:assignment/question.dart';
import 'package:flutter/material.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key}) : super(key: key);
  
  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  late Question currentQuestion;
  List<Question> allQuestions =[];
  var currentIndex = 0;
  var singleSelect=true;
  bool isLast=false;
  List<List<String>> allAnswers =[];
  List<String> selectedAnswers =[];
  var freeTxtController=TextEditingController();
  @override
  void initState() {
    for (var question in database.allQuestions) {
      allQuestions.add(Question.fromJson(question));
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _initializeVariables();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(onTap:(){
          selectedAnswers=[];
          if(currentIndex>0)currentIndex--;
          setState(() {});
        },child: Icon(Icons.arrow_back_rounded,color: database.titleColor,)),
        centerTitle: true,
        title: Text(currentQuestion.type!.toUpperCase()),
        titleTextStyle: TextStyle(color: database.titleColor, fontWeight: FontWeight.w500,fontSize: 17),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color:database.titleColor),
                borderRadius: BorderRadius.circular(3)
              ),
              child: Text(
                currentQuestion.question!,
                textAlign: TextAlign.center,
                style:  TextStyle(color: database.titleColor,),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${currentIndex+1} of ${allQuestions.length}',style: const TextStyle(color: Color(0xffDC0032),fontWeight: FontWeight.w700),),
                if(!singleSelect)  Text('*one or more correct answers',style: TextStyle(color: database.titleColor),)
              ],
            ),
            const SizedBox(height: 20,),
            if(currentQuestion.type=='free-text') TextField(
              controller: freeTxtController,
              style: TextStyle(color: database.titleColor),
              decoration: InputDecoration(
                labelText: "Write you answer here..",
                labelStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: OutlineInputBorder(borderSide: BorderSide(color: database.titleColor))
              ),
            ),
            ...currentQuestion.options!.map((e) => Column(
              children: [
                optionCard(e.id!,e.text!,selectedAnswers.contains(e.id)),
                const SizedBox(height: 15,)
              ],
            )).toList(),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: _savePressed,
                    style: ButtonStyle(
                      surfaceTintColor: const MaterialStatePropertyAll(Colors.white),
                      backgroundColor: !isLast?MaterialStatePropertyAll(database.titleColor):null,
                      shape: MaterialStatePropertyAll(isLast?RoundedRectangleBorder(side: const BorderSide(color: Colors.grey),borderRadius: BorderRadius.circular(3)):RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLast?"Save & Finish":"Save & Next",style: TextStyle(color: isLast?database.titleColor:Colors.white),),
                  ],
                )),
                const SizedBox(height: 10,),
                ElevatedButton(
                    onPressed: (){},
                    style: ButtonStyle(
                      surfaceTintColor: const MaterialStatePropertyAll(Colors.white),
                      backgroundColor: const MaterialStatePropertyAll(Color(0xffDC0032)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)))
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Quit Assignment",style: TextStyle(color:Colors.white),),
                  ],
                )),
                const SizedBox(height: 20,)
              ],

            ))

          ],
        ),

      ),
    );
  }
  Widget optionCard(String optionId , String option,bool selected) {
    return StatefulBuilder(
        builder: (context, setOptionState) {
          return InkWell(
            onTap: (){
              if(allAnswers.length>=currentIndex+1){
                allAnswers.removeAt(currentIndex);
                allAnswers.insert(currentIndex, selectedAnswers);
              }else {
                allAnswers.add(selectedAnswers);
              }
             if (!selectedAnswers.contains(optionId)){
                if (singleSelect) {
                  selectedAnswers.clear();
                  setState(() {});
                }
                selectedAnswers.add(optionId);
             }
              selected=!selected;
              setOptionState(() {});
            },
            child: Card(
              elevation: 3,
              color: selected?const Color(0xff536883):Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 10),
                child: Row(
                  children: [
                    if(!selected) Text('$optionId.'),
                    Expanded(child: Text(option,style: TextStyle(color: selected?Colors.white:Colors.black),textAlign: TextAlign.center,)),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  void _initializeVariables() {
    currentQuestion = allQuestions[currentIndex];
    isLast= currentIndex+1 == allQuestions.length;
    if(currentQuestion.type=='multiple-select'){
      singleSelect=false;
    }else{
      singleSelect=true;
    }
    selectedAnswers = allAnswers.elementAtOrNull(currentIndex)??[];
    if(currentQuestion.type=='free-text'){
      freeTxtController.text=selectedAnswers.isNotEmpty?selectedAnswers.first:"";
    }
  }

  void _savePressed(){
    if(currentQuestion.type=='free-text'){
      selectedAnswers.add(freeTxtController.text);
      freeTxtController=TextEditingController();
    }
    if(allAnswers.length>=currentIndex+1){
      allAnswers.removeAt(currentIndex);
      allAnswers.insert(currentIndex, selectedAnswers);
    }else {
      allAnswers.add(selectedAnswers);
    }
    selectedAnswers=[];
    if(!isLast){
      currentIndex++;
      setState(() {

      });
    }
  }
}
