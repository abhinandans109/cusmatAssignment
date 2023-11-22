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

  bool nextDisabled=true;
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
          freeTxtController=TextEditingController();
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
              onChanged: (s){
                selectedAnswers=[];
                selectedAnswers.add(s);
                setState(() {

                });
              },
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
                      backgroundColor: nextDisabled?null:MaterialStatePropertyAll(database.titleColor),
                      shape: MaterialStatePropertyAll(nextDisabled?RoundedRectangleBorder(side: const BorderSide(color: Colors.grey),borderRadius: BorderRadius.circular(3)):RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLast?"Save & Finish":"Save & Next",style: TextStyle(color: nextDisabled?database.titleColor:Colors.white),),
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
          return Card(
            elevation: 3,
            color: selected?const Color(0xff536883):Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3)
            ),
            child: InkWell(
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
                  }
                  selectedAnswers.add(optionId);
               }else{
                 selectedAnswers.remove(optionId);
               }
                setState(() {});
                selected=!selected;
                setOptionState(() {});
              },
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

    if(currentQuestion.type=='free-text'){
      if(freeTxtController.text.isEmpty) selectedAnswers = allAnswers.elementAtOrNull(currentIndex)??[];
      freeTxtController.text=selectedAnswers.isNotEmpty?selectedAnswers.first:"";
    }else{
      selectedAnswers = allAnswers.elementAtOrNull(currentIndex)??[];
    }
    nextDisabled = selectedAnswers.isEmpty ||(currentQuestion.type=='free-text' && freeTxtController.text.isEmpty);
  }

  void _savePressed(){
    if(isLast && !nextDisabled){
      var answers = [['C'],['A','B'],['B'],['B'],['C']];
      var tempAll = [];
      for(int i=0;i<allAnswers.length;i++){
        if(i==2)continue;
        tempAll.add(allAnswers.elementAt(i));
      }
      var correct =0;
      for(int i=0;i<answers.length;i++){
        if(answers.elementAt(i).toString()==tempAll.elementAt(i).toString()){
          correct++;
        }
      }
      var score = (((correct + 1 )/ 6) * 100).round();
      showDialog(context: context, builder: (builder)=>AlertDialog(
        title: Text('Score',style: TextStyle(fontSize: 25,color: database.titleColor),),
        content: Text('Congratulations .. you have scored $score%',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: database.titleColor),),
        actions: [TextButton(onPressed: (){Navigator.pop(builder);}, child: Text('Ok'))],

      ));
      return;
    }
    if(!nextDisabled){
      if (currentQuestion.type == 'free-text') {
        selectedAnswers.add(freeTxtController.text);
        freeTxtController = TextEditingController();
      }
      if (allAnswers.length >= currentIndex + 1) {
        allAnswers.removeAt(currentIndex);
        allAnswers.insert(currentIndex, selectedAnswers);
      } else {
        allAnswers.add(selectedAnswers);
      }
      selectedAnswers = [];
      if (!isLast) {
        currentIndex++;
        setState(() {});
      }
    }
  }
}
