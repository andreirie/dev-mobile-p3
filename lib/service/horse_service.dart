import 'package:apk_p3/model/horse_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String horseCollection = "horses";

class HorseService {
  static final HorseService _instance = HorseService.internal();
  factory HorseService() => _instance;
  HorseService.internal();

  final CollectionReference<Map<String, dynamic>> _horseCollection =
      FirebaseFirestore.instance.collection(horseCollection);

  Future<Horse> saveHorse(Horse horse) async {
    final newDoc = await _horseCollection.add(horse.toJson());

    return Horse(
      id: newDoc.id,
      name: horse.name,
      age: horse.age,
      coatColor: horse.coatColor,
      gender: horse.gender,
      totalRaces: horse.totalRaces,
      totalWins: horse.totalWins,
      lastVictoryDate: horse.lastVictoryDate,
      image: horse.image,
    );
  }

  Future<Horse?> getHorse(String id) async {
    final docSnapshot = await _horseCollection.doc(id).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      return Horse.fromFirestore(
        docSnapshot,
        null,
      );
    } else {
      return null;
    }
  }

  Stream<List<Horse>> getAllHorses() {
    return _horseCollection.orderBy('name', descending: false).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return Horse.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>,
          null,
        );
      }).toList();
    });
  }

  Future<void> updateHorse(Horse horse) async {
    if (horse.id == null) {
      throw Exception(
        "ID do Horse é necessário para atualização no Firestore.",
      );
    }

    await _horseCollection.doc(horse.id!).update(horse.toJson());
  }

  Future<void> deleteHorse(String id) async {
    await _horseCollection.doc(id).delete();
  }

  Future<List<Horse>> fetchAllHorsesOnce() async {
    final querySnapshot = await _horseCollection
        .orderBy('name', descending: false)
        .get();

    return querySnapshot.docs.map((doc) {
      return Horse.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>,
        null,
      );
    }).toList();
  }
}
