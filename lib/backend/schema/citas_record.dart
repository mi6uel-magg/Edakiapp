import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'citas_record.g.dart';

abstract class CitasRecord implements Built<CitasRecord, CitasRecordBuilder> {
  static Serializer<CitasRecord> get serializer => _$citasRecordSerializer;

  String? get hora;

  String? get servicio;

  String? get nombre;

  DateTime? get fecha;

  String? get dueno;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  DocumentReference get parentReference => reference.parent.parent!;

  static void _initializeBuilder(CitasRecordBuilder builder) => builder
    ..hora = ''
    ..servicio = ''
    ..nombre = ''
    ..dueno = '';

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('citas')
          : FirebaseFirestore.instance.collectionGroup('citas');

  static DocumentReference createDoc(DocumentReference parent) =>
      parent.collection('citas').doc();

  static Stream<CitasRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<CitasRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  CitasRecord._();
  factory CitasRecord([void Function(CitasRecordBuilder) updates]) =
      _$CitasRecord;

  static CitasRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createCitasRecordData({
  String? hora,
  String? servicio,
  String? nombre,
  DateTime? fecha,
  String? dueno,
}) {
  final firestoreData = serializers.toFirestore(
    CitasRecord.serializer,
    CitasRecord(
      (c) => c
        ..hora = hora
        ..servicio = servicio
        ..nombre = nombre
        ..fecha = fecha
        ..dueno = dueno,
    ),
  );

  return firestoreData;
}
