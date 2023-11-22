class Question {
  int? id;
  String? type;
  String? question;
  int? points;
  List<Options>? options;
  List<String>? answer;

  Question(
      {this.id,
        this.type,
        this.question,
        this.points,
        this.options,
        this.answer});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    question = json['question'];
    points = json['points'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    answer = json['answer'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['question'] = question;
    data['points'] = points;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    data['answer'] = answer;
    return data;
  }
}

class Options {
  String? id;
  String? text;

  Options({this.id, this.text});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    return data;
  }
}
