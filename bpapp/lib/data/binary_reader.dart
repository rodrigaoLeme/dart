import 'dart:convert';
import 'dart:typed_data';

class BinaryReader {
  final ByteData data;
  final Uint8List _list;
  int _position = 0;
  final int _dataLength;

  BinaryReader(this.data)
      : _list = data.buffer.asUint8List(),
        _dataLength = data.lengthInBytes;

  int? get position => _position;

  int readInt() {
    int res = data.getInt32(_position, Endian.little);
    _position += 4;
    return res;
  }

  int readUInt() {
    int res = data.getUint32(_position, Endian.little);
    _position += 4;
    return res;
  }

  double readFloat() {
    double res = data.getFloat32(_position, Endian.little);
    _position += 4;
    return res;
  }

  int readByte() {
    return data.getUint8(_position++);
  }

  int readUShort() {
    int res = data.getUint16(_position, Endian.little);
    _position += 2;
    return res;
  }

  int readShort() {
    int res = data.getInt16(_position, Endian.little);
    _position += 2;
    return res;
  }

  void jumpBytes(int amount) {
    if (_position + amount > _dataLength) {
      throw RangeError("Out of Range");
    }

    _position += amount;
  }

  String fixedString(int length) {
    if (_position + length > _dataLength) {
      throw RangeError("Trying to read beyond the size of the book");
    }
    var res = utf8.decode(_list.sublist(_position, _position + length));
    _position += length;
    return res;
  }

  String readString() {
    return fixedString(readByte());
  }

  String readMediumString() {
    return fixedString(readShort());
  }

  String readLongString() {
    return fixedString(readInt());
  }

  void setPosition(int position) {
    _position = position;
  }

  void skip(int amount) {
    _position += amount;
  }

  Uint8List dataOfSize(int size) {
    var res = _list.sublist(_position, _position + size);

    _position += size;
    return res;
  }

  bool endOfFile() {
    return _position >= _dataLength;
  }
}
