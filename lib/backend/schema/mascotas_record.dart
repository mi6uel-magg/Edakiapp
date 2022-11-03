import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'mascotas_record.g.dart';

abstract class MascotasRecord
    implements Built<MascotasRecord, MascotasRecordBuilder> {
  static Serializer<MascotasRecord> get serializer =>
      _$mascotasRecordSerializer;

  String? get nombre;

  String? get raza;

  String? get especie;

  String? get color;

  String? get foto;

  String? get sexo;

  String? get nacimiento;

  String? get dueno;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  DocumentReference get parentReference => reference.parent.parent!;

  static void _initializeBuilder(MascotasRecordBuilder builder) => builder
    ..nombre = ''
    ..raza = ''
    ..especie = ''
    ..color = ''
    ..foto = ''
    ..sexo = ''
    ..nacimiento = ''
    ..dueno = '';

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('mascotas')
          : FirebaseFirestore.instance.collectionGroup('mascotas');

  static DocumentReference createDoc(DocumentReference parent) =>
      parent.collection('mascotas').doc();

  static Stream<MascotasRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<MascotasRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  MascotasRecord._();
  factory MascotasRecord([void Function(MascotasRecordBuilder) updates]) =
      _$MascotasRecord;

  static MascotasRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createMascotasRecordData({
  String? nombre,
  String? raza,
  String? especie,
  String? color,
  String? foto,
  String? sexo,
  String? nacimiento,
  String? dueno,
}) {
  final firestoreData = serializers.toFirestore(
    MascotasRecord.serializer,
    MascotasRecord(
      (m) => m
        ..nombre = nombre
        ..raza = raza
        ..especie = especie
        ..color = color
        ..foto = foto
        ..sexo = sexo
        ..nacimiento = nacimiento
        ..dueno = dueno,
    ),
  );

  return firestoreData;
}
