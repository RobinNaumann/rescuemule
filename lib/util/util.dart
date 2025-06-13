String toSnakeCase(String input) {
  return input
      .replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'),
        (Match m) => '${m[1]}_${m[2]}',
      )
      .replaceAll(' ', '_')
      .toLowerCase();
}
