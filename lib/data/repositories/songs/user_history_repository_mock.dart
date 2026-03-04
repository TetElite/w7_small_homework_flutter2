import 'user_history_repository.dart';

class UserHistoryRepositoryMock implements UserHistoryRepository {
  // Pre-populated with one song so the home screen shows demo data
  final List<String> _recentSongIds = ['101'];

  @override
  List<String> fetchRecentSongIds() {
    return List.unmodifiable(_recentSongIds);
  }

  @override
  void addSongId(String id) {
    // Avoid duplicates — move the song to the front if already present
    _recentSongIds.remove(id);
    _recentSongIds.insert(0, id);
  }
}
