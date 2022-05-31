import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChallengesModel extends Equatable {
  final String title;
  final String image;
  final bool popular;

  const ChallengesModel({
    required this.title,
    required this.image,
    required this.popular,
  });

  @override
  List<Object?> get props => [title];

  static ChallengesModel fromSnapshot(DocumentSnapshot snap) {
    ChallengesModel categoryModel = ChallengesModel(
      title: snap['title'],
      image: snap['image'],
      popular: snap['popular'],
    );
    return categoryModel;
  }
}
