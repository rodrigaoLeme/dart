abstract class Data {
  Map<String, dynamic> toJson();
}

extension DataList<T extends Data> on List<T> {
  Iterable<Map<String, dynamic>> toJson() => map((p) => p.toJson());
}
