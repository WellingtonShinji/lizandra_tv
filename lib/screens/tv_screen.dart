import 'package:flutter/material.dart';
import '../models/channel.dart';
import '../services/m3u_service.dart';
import 'player_screen.dart';

class TVScreen extends StatefulWidget {
  const TVScreen({super.key});

  @override
  State<TVScreen> createState() => _TVScreenState();
}

class _TVScreenState extends State<TVScreen> {
  final String m3uUrl =
      'https://va67.eu/get.php?username=VictorRian&password=14072650534&type=m3u_plus&output=ts';

  final M3UService service = M3UService();

  late Future<List<Channel>> channels;

  @override
  void initState() {
    super.initState();
    channels = _loadChannels();
  }

  /// Carrega apenas canais de TV (não VOD)
  Future<List<Channel>> _loadChannels() async {
    final all = await service.loadFromUrl(m3uUrl);

    return all.where((c) {
      final group = c.group.toLowerCase();
      final name = c.name.toLowerCase();

      // Filtra filmes/VOD e deixa apenas TV aberta/canais
      if (group.contains('movie') ||
          group.contains('filme') ||
          group.contains('vod') ||
          group.contains('cinema') ||
          name.contains('1080p') ||
          name.contains('720p') ||
          name.contains('bluray')) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Channel>>(
        future: channels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum canal encontrado',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final list = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // ideal para Android TV
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.0, // quadrado para logos de canais
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final channel = list[index];

              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(url: channel.url),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: channel.logo.isNotEmpty
                            ? Image.network(
                                channel.logo,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) =>
                                    _channelFallback(),
                              )
                            : _channelFallback(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      channel.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _channelFallback() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[900],
      child: const Center(
        child: Icon(
          Icons.tv,
          size: 48,
          color: Colors.white70,
        ),
      ),
    );
  }
}
