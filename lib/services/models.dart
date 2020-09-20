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

class Address {
  String address;
  String ca;
  String postalCode;
  String province;

  Address({this.address, this.ca, this.postalCode, this.province});
  Address.fromMap(Map data) {
    address = data['address'];
    ca = data['ca'] ?? '';
    province = data['province'];
    postalCode = data['postalCode'];
  }
}

class Bussiness {
  final String id;
  final String name;
  final String description;
  final String mail;
  final String phone;
  final String img;
  final Address address;

  Bussiness(
      {this.id,
      this.name,
      this.description,
      this.mail,
      this.phone,
      this.img,
      this.address});

  factory Bussiness.fromMap(Map data) {
    return Bussiness(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      mail: data['mail'] ?? '',
      phone: data['phone'] ?? '',
      img: data['img'] ?? 'clock.png',
      address: Address.fromMap(data['address']),
    );
  }
}

enum Gender { male, female, undefined }

class Product {
  String description;
  int price;
  String name;
  String img;
  Gender gender;

  Product({this.description, this.price, this.name, this.img, this.gender});

  factory Product.fromMap(Map data) {
    return Product(
      description: data['description'] ?? "No description set",
      price: data['price'] ?? null,
      name: data['name'] ?? "No name set",
      img: data['img'] ??
          "https://firebasestorage.googleapis.com/v0/b/rigel-admin.appspot.com/o/userapp%2Funknown_profile.png?alt=media&token=0dfd930d-60c9-4a8c-be1b-8802f6d9685d",
      gender: data['gender'] ?? Gender.undefined,
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
