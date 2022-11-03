import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'archivo_record.g.dart';

abstract class ArchivoRecord
    implements Built<ArchivoRecord, ArchivoRecordBuilder> {
  static Serializer<ArchivoRecord> get serializer => _$archivoRecordSerializer;

  DateTime? get fecha;

  String? get hora;

  String? get servicio;

  String? get nombre;

  String? get dueno;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  DocumentReference get parentReference => reference.parent.parent!;

  static void _initializeBuilder(ArchivoRecordBuilder builder) => builder
    ..hora = ''
    ..servicio = ''
    ..nombre = ''
    ..dueno = '';

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('archivo')
          : FirebaseFirestore.instance.collectionGroup('archivo');

  static DocumentReference createDoc(DocumentReference parent) =>
      parent.collection('archivo').doc();

  static Stream<ArchivoRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<ArchivoRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  ArchivoRecord._();
  factory ArchivoRecord([void Function(ArchivoRecordBuilder) updates]) =
      _$ArchivoRecord;

  static ArchivoRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;
}

Map<String, dynamic> createArchivoRecordData({
  DateTime? fecha,
  String? hora,
  String? servicio,
  String? nombre,
  String? dueno,
}) {
  final firestoreData = serializers.toFirestore(
    ArchivoRecord.serializer,
    ArchivoRecord(
      (a) => a
        ..fecha = fecha
        ..hora = hora
        ..servicio = servicio
        ..nombre = nombre
        ..dueno = dueno,
    ),
  );

  return firestoreData;
}
