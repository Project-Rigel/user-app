//// Embedded Maps

class Option {
  String value;
  String detail;
  bool correct;

  Option({this.correct, this.value, this.detail});
  Option.fromMap(Map data) {
    value = data['value'];
    detail = data['detail'] ?? '';
    correct = data['correct'];
  }
}

class Question {
  String text;
  List<Option> options;
  Question({this.options, this.text});

  Question.fromMap(Map data) {
    text = data['text'] ?? '';
    options =
        (data['options'] as List ?? []).map((v) => Option.fromMap(v)).toList();
  }
}

///// Database Collections

class Quiz {
  String id;
  String title;
  String description;
  String video;
  String topic;
  List<Question> questions;

  Quiz(
      {this.title,
      this.questions,
      this.video,
      this.description,
      this.id,
      this.topic});

  factory Quiz.fromMap(Map data) {
    return Quiz(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        topic: data['topic'] ?? '',
        description: data['description'] ?? '',
        video: data['video'] ?? '',
        questions: (data['questions'] as List ?? [])
            .map((v) => Question.fromMap(v))
            .toList());
  }
}

class Bussiness {
  final String id;
  final String name;
  final String description;
  final String mail;
  final String phone;
  final String img;
  final List<String> categories;

  Bussiness(
      {this.id,
      this.name,
      this.description,
      this.phone,
      this.mail,
      this.img,
      this.categories});

  factory Bussiness.fromMap(Map data) {
    return Bussiness(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      mail: data['mail'] ?? '',
      phone: data['mail'] ?? '',
      img: data['img'] ?? 'default.png',
      categories: List.from(data['categories']),
    );
  }
}

class Report {
  String uid;
  int total;
  dynamic topics;

  Report({this.uid, this.topics, this.total});

  factory Report.fromMap(Map data) {
    return Report(
      uid: data['uid'],
      total: data['total'] ?? 0,
      topics: data['topics'] ?? {},
    );
  }
}
