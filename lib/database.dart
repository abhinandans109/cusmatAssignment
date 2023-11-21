import 'dart:ui';

List allQuestions = [
{"id":1, "type":"single-select", "question":"What is the largest planet in our Solar System?", "points":20, "options":[{"id":"A", "text":"Earth"}, {"id":"B", "text":"Mars"}, {"id":"C", "text":"Jupiter"}, {"id":"D", "text":"Venus"}], "answer":["C"]},
{"id":2, "type":"multiple-select", "question":"Select the programming languages from the list below", "points":20, "options":[{"id":"A", "text":"Python"}, {"id":"B", "text":"Java"}, {"id":"C", "text":"English"}], "answer":["A","B"]},
{"id":3, "type":"free-text", "question":"Briefly describe your experience with front-end development.", "points":15, "options":[], "answer":["[Your Answer]"]},
{"id":4, "type":"single-select", "question":"Is JavaScript a statically typed language?", "points":15, "options":[{"id":"A", "text":"Yes"}, {"id":"B", "text":"No"}], "answer":["B"]},
{"id":5, "type":"single-select", "question":"Which SQL statement is used to extract data from a database?", "points":15, "options":[{"id":"A", "text":"ADD"}, {"id":"B", "text":"SELECT"}, {"id":"C", "text":"CREATE"}, {"id":"D", "text":"DELETE"}], "answer":["B"]},
{"id":6, "type":"single-select", "question":"What does HTML stand for?", "points":15, "options":[{"id":"A", "text":"Hyperlinks and Text Markup Language"}, {"id":"B", "text":"Home Tool Markup Language"}, {"id":"C", "text":"Hyper Text Markup Language"}], "answer":["C"]}
];
Color titleColor = const Color(0xff0E2C53);