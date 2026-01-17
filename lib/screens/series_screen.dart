import 'package:flutter/material.dart';
import '../models/channel.dart';
import '../services/m3u_service.dart';
import 'player_screen.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  final m3uUrl =
      'https://va67.eu/get.php?username=VictorRian&password=14072650534&type=m3u_plus&output=ts';
  final service = M3UService();
  late Future<List<Channel>> series;

  @override
  void initState() {
    super.initState();
    series = _loadSeries();
  }

  Future<List<Channel>> _loadSeries() async {
    final all = await service.loadFromUrl(m3uUrl);
    return all.where((c) {
      final g = c.group.toLowerCase();
      final u = c.url.toLowerCase();
      return g.contains('series') ||
          g.contains('serie') ||
          u.endsWith('.mp4') ||
          u.endsWith('.mkv') ||
          u.endsWith('.avi');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Séries'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Channel>>(
        future: series,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhuma série encontrada',
                    style: TextStyle(color: Colors.white)));
          }

          final list = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.65,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final serie = list[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PlayerScreen(url: serie.url)));
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: serie.logo.isNotEmpty
                            ? Image.network(
                                serie.logo,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) =>
                                    _posterFallback(),
                              )
                            : _posterFallback(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      serie.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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

  Widget _posterFallback() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(Icons.video_library, size: 48, color: Colors.white70),
      ),
    );
  }
}
