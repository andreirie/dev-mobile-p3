import 'package:cloud_firestore/cloud_firestore.dart';

class Horse {
  String? id; 
  String name;
  int age;
  String coatColor;
  String gender;
  int totalRaces;
  int? totalWins;
  int? lastVictoryDate; 
  String? image;

  Horse({
    this.id,
    required this.name,
    required this.age,
    required this.coatColor,
    required this.gender,
    required this.totalRaces,
    this.totalWins,
    this.lastVictoryDate,
    this.image,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'age': age,
      'coatColor': coatColor,
      'gender': gender,
      'totalRaces': totalRaces,
      'totalWins': totalWins, 
      'lastVictoryDate': lastVictoryDate,
      'image': image,
      'updatedAt': FieldValue.serverTimestamp(), 
    };
    return map;
  }

  factory Horse.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Documento Horse vazio!');
    }

    return Horse(
      id: snapshot.id, 
      name: data['name'] as String,
      age: data['age'] as int,
      coatColor: data['coatColor'] as String,
      gender: data['gender'] as String,
      totalRaces: data['totalRaces'] as int,
            totalWins: data['totalWins'] as int?,
      lastVictoryDate: data['lastVictoryDate'] as int?,
      image: data['image'] as String?,
    );
  }
  
  factory Horse.fromMap(String docId, Map<String, dynamic> map) {
    return Horse(
      id: docId, 
      name: map['name'] as String,
      age: map['age'] as int,
      coatColor: map['coatColor'] as String,
      gender: map['gender'] as String,
      totalRaces: map['totalRaces'] as int,
      
      totalWins: map['totalWins'] as int?,
      lastVictoryDate: map['lastVictoryDate'] as int?,
      image: map['image'] as String?,
    );
  }


  @override
  String toString() {
    return "Horse(id: $id, name: $name, age: $age, coatColor: $coatColor, gender: $gender, totalRaces: $totalRaces, totalWins: $totalWins, lastVictoryDate: $lastVictoryDate, image: $image)";
  }
}