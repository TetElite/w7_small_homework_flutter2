import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/songs/song.dart';
import '../../../states/settings_state.dart';
import '../../../theme/theme.dart';
import '../view_model/home_view_model.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    HomeViewModel viewModel = context.watch<HomeViewModel>();
    AppSettingsState settingsState = context.read<AppSettingsState>();

    return Container(
      color: settingsState.theme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text("Home", style: AppTextStyles.heading),

          const SizedBox(height: 24),

          Expanded(
            child: ListView(
              children: [
                // --- Section 1: Your recent songs ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Your recent songs",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),

                if (viewModel.recentSongs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No recent songs yet."),
                  )
                else
                  ...viewModel.recentSongs.map(
                    (song) => SongTile(
                      song: song,
                      isPlaying: viewModel.isPlaying(song),
                      onTap: () => viewModel.play(song),
                      onStop: () => viewModel.stop(),
                    ),
                  ),

                const SizedBox(height: 16),

                // --- Section 2: Recommended songs ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "You might also like",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),

                if (viewModel.recommendedSongs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No recommendations yet."),
                  )
                else
                  ...viewModel.recommendedSongs.map(
                    (song) => SongTile(
                      song: song,
                      isPlaying: viewModel.isPlaying(song),
                      onTap: () => viewModel.play(song),
                      onStop: () => viewModel.stop(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onTap,
    required this.onStop,
  });

  final Song song;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(song.title),
      trailing: isPlaying
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("playing", style: TextStyle(color: Colors.amber)),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: onStop, child: const Text("STOP")),
              ],
            )
          : null,
    );
  }
}
