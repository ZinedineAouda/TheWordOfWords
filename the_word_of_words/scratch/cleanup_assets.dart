import 'dart:io';
import 'dart:convert';

void main() async {
  final gameDataPath = 'assets/data/game_data.json';
  final gameDataFile = File(gameDataPath);
  
  if (!gameDataFile.existsSync()) {
    print('Game data not found at $gameDataPath');
    return;
  }

  final content = await gameDataFile.readAsString();
  final data = json.decode(content);
  
  Set<String> usedAssets = {};

  // 1. Extract used assets from game_data.json
  void extractAssets(dynamic obj) {
    if (obj is Map) {
      if (obj.containsKey('imageAsset') && obj['imageAsset'] is String) {
        usedAssets.add(obj['imageAsset']);
      }
      if (obj.containsKey('iconAsset') && obj['iconAsset'] is String) {
        usedAssets.add(obj['iconAsset']);
      }
      for (var value in obj.values) {
        extractAssets(value);
      }
    } else if (obj is List) {
      for (var item in obj) {
        extractAssets(item);
      }
    }
  }

  extractAssets(data);
  print('Found ${usedAssets.length} used assets in game_data.json');

  // Add some known used assets that might be in code
  usedAssets.add('assets/images/world_map_bg.png');
  usedAssets.add('assets/images/store_avatars.png');
  usedAssets.add('assets/images/store_themes.png');
  usedAssets.add('assets/images/ui/cloud_banner.png');

  // 2. Clean folders
  final foldersToClean = [
    'assets/images/exercises',
    'assets/icons',
  ];

  for (final folderPath in foldersToClean) {
    final dir = Directory(folderPath);
    if (!dir.existsSync()) continue;

    print('\nCleaning folder: $folderPath');
    final files = dir.listSync();
    int deletedCount = 0;

    for (final file in files) {
      if (file is File) {
        // Normalize path for comparison
        final relativePath = file.path.replaceAll('\\', '/');
        
        // Check if file is in usedAssets (by name matching)
        bool isUsed = usedAssets.any((ua) {
          String normalizedUA = ua.replaceAll('\\', '/');
          return relativePath.contains(normalizedUA) || normalizedUA.contains(relativePath);
        });

        if (!isUsed) {
          print('Deleting unused: ${file.path}');
          file.deleteSync();
          deletedCount++;
        }
      }
    }
    print('Deleted $deletedCount unused files from $folderPath');
  }

  // 3. Specific file cleanup
  final specificFiles = [
    'assets/images/1.jpg',
    'assets/images/2.png',
  ];

  for (final path in specificFiles) {
    final file = File(path);
    if (file.existsSync()) {
      print('Deleting specific unused file: $path');
      file.deleteSync();
    }
  }

  print('\nCleanup complete!');
}
