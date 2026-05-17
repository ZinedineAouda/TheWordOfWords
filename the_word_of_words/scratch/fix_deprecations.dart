import 'dart:io';

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('lib directory not found');
    return;
  }

  libDir.listSync(recursive: true).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = entity.readAsStringSync();
      if (content.contains('.withOpacity(')) {
        print('Updating ${entity.path}');
        // Replace .withOpacity(x) with .withValues(alpha: x)
        // This handles cases like .withOpacity(0.5) and .withOpacity(varName)
        String newContent = content.replaceAllMapped(
          RegExp(r'\.withOpacity\((.*?)\)'),
          (match) => '.withValues(alpha: ${match.group(1)})',
        );
        entity.writeAsStringSync(newContent);
      }
    }
  });
  print('Done updating withOpacity to withValues');
}
