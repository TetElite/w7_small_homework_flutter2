import 'package:flutter/widgets.dart';

import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../data/repositories/songs/user_history_repository.dart';
import '../../../../model/songs/song.dart';
import '../../../states/player_state.dart';

class HomeViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  final UserHistoryRepository _userHistoryRepository;
  final PlayerState _playerState;

  List<Song> _recentSongs = [];
  List<Song> _recommendedSongs = [];

  HomeViewModel({
    required SongRepository songRepository,
    required UserHistoryRepository userHistoryRepository,
    required PlayerState playerState,
  })  : _songRepository = songRepository,
        _userHistoryRepository = userHistoryRepository,
        _playerState = playerState {
    _playerState.addListener(_onPlayerStateChanged);
  }

  void init() {
    _refresh();
  }

  // Called when PlayerState changes (song started or stopped)
  void _onPlayerStateChanged() {
    final currentSong = _playerState.currentSong;
    if (currentSong != null) {
      // Add the newly playing song to history
      _userHistoryRepository.addSongId(currentSong.id);
      _refresh();
    } else {
      notifyListeners();
    }
  }

  // Fetch recent IDs → convert to Song objects, then compute recommended
  void _refresh() {
    final allSongs = _songRepository.fetchSongs();
    final recentIds = _userHistoryRepository.fetchRecentSongIds();

    // Convert IDs to full Song objects (skip IDs that no longer exist)
    _recentSongs = recentIds
        .map((id) => _songRepository.fetchSongById(id))
        .whereType<Song>()
        .toList();

    // Recommended = songs NOT in the user's recent history
    final recentIdSet = recentIds.toSet();
    _recommendedSongs =
        allSongs.where((song) => !recentIdSet.contains(song.id)).toList();

    notifyListeners();
  }

  // --- Getters ---

  List<Song> get recentSongs => _recentSongs;

  List<Song> get recommendedSongs => _recommendedSongs;

  Song? get currentSong => _playerState.currentSong;

  bool isPlaying(Song song) => _playerState.currentSong == song;

  // --- User actions ---

  void play(Song song) {
    _playerState.start(song);
    // history update + notifyListeners handled in _onPlayerStateChanged
  }

  void stop() {
    _playerState.stop();
  }

  @override
  void dispose() {
    _playerState.removeListener(_onPlayerStateChanged);
    super.dispose();
  }
}
