import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/channel.dart';
import '../services/m3u_service.dart';
import 'player_screen.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final String m3uUrl =
      'https://va67.eu/get.php?username=VictorRian&password=14072650534&type=m3u_plus&output=ts';

  final M3UService service = M3UService();
  late Future<List<Channel>> movies;

  @override
  void initState() {
    super.initState();
    movies = _loadMovies();
  }

  /// Carrega apenas FILMES / VOD
  Future<List<Channel>> _loadMovies() async {
    final all = await service.loadFromUrl(m3uUrl);

    return all.where((c) {
      final group = c.group.toLowerCase();
      final name = c.name.toLowerCase();

      return group.contains('movie') ||
          group.contains('filme') ||
          group.contains('vod') ||
          group.contains('cinema') ||
          name.contains('1080p') ||
          name.contains('720p') ||
          name.contains('bluray');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Filmes'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Channel>>(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum filme encontrado',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final list = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Android TV
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.65,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final movie = list[index];

              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(url: movie.url),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: movie.logo.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: movie.logo,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                placeholder: (_, __) => Container(
                                  color: Colors.grey[900],
                                ),
                                errorWidget: (_, __, ___) =>
                                    _posterFallback(),
                              )
                            : _posterFallback(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movie.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _posterFallback() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(
          Icons.movie,
          size: 48,
          color: Colors.white70,
        ),
      ),
    );
  }
}
