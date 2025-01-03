import 'dart:ui' show Color;

Color getColorByIndex(int index) {
  const List<Color> colorPalette = [
    Color(0xFFC96868), // Red shade
    Color(0xFFFFBB70), // Peach shade
    Color(0xFFB5C18E), // Green shade
    Color(0xFFCFEFFC), // Light Blue shade
    Color(0xFF5A72A0), // Blue shade
    Color(0xFFDDBCFF), // Lavender shade
    Color(0xFFFCCFCF), // Pink shade
    Color(0xFFD9D9D9), // Light Gray shade
    Color(0xFF545454), // Dark Gray shade
    Color(0xFFB28F65), // Brown shade
  ];
  assert((0 <= index) && (index < colorPalette.length));
  return colorPalette.elementAt(index);
}
