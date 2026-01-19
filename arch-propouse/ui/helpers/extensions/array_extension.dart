extension SafeListAccess<T> on List<T> {
  T? safeAt(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
}

extension BoolListSafeAssign on List<bool> {
  void setSafe(int index, bool value) {
    if (index >= length) {
      addAll(List.filled(index - length + 1, false));
    }
    this[index] = value;
  }
}
