// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) {
  print(json['locationDefinition']);
  return Note(title: json['title'] as String,  
              text: json['text'] as String, 
              id: json['id'] as int, 
              created: json['created'] as String, 
              location_id: json['location_id'] as int,
              locationDefinition: json['locationDefinition'] as int,
              is_folder: json['is_folder'] as int, 
              list_index: json['list_index'] as int, 
              color: json['color'] as String
          );
    
}

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'created': instance.created,
      'color': instance.color,
      'location_id': instance.location_id,
      'locationDefinition': instance.locationDefinition,
      'is_folder': instance.is_folder,
      'list_index': instance.list_index
    };
