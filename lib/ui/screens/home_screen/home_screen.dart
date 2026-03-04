import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/songs/song_repository.dart';
import '../../../data/repositories/songs/user_history_repository.dart';
import '../../states/player_state.dart';
import 'view_model/home_view_model.dart';
import 'widgets/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SongRepository songRepository = context.read<SongRepository>();
    UserHistoryRepository userHistoryRepository = context
        .read<UserHistoryRepository>();
    PlayerState playerState = context.read<PlayerState>();

    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(
        songRepository: songRepository,
        userHistoryRepository: userHistoryRepository,
        playerState: playerState,
      )..init(),
      child: const HomeContent(),
    );
  }
}
