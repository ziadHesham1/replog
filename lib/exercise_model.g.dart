// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) =>
    ExerciseModel(
      bodyPart: json['bodyPart'] as String,
      equipment: json['equipment'] as String,
      gifUrl: json['gifUrl'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      target: json['target'] as String,
      secondaryMuscles: (json['secondaryMuscles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ExerciseModelToJson(ExerciseModel instance) =>
    <String, dynamic>{
      'bodyPart': instance.bodyPart,
      'equipment': instance.equipment,
      'gifUrl': instance.gifUrl,
      'id': instance.id,
      'name': instance.name,
      'target': instance.target,
      'secondaryMuscles': instance.secondaryMuscles,
      'instructions': instance.instructions,
    };
