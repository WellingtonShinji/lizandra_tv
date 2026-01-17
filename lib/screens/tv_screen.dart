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
  final m3uUrl =
      'https://va67.eu/get.php?username=VictorRian&password=14072650534&type=m3u_plus&output=ts';
  final service = M3UService();
  late Future<List<Channel>> channels;

  @override
  void initState() {
    super.initState();
    channels = service.loadFromUrl(m3uUrl);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Channel>>(
      future: channels,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final channel = list[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PlayerScreen(url: channel.url)),
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: channel.logo.isNotEmpty
                          ? Image.network(channel.logo, fit: BoxFit.cover)
                          : Container(
                              color: Colors.grey[900],
                              child: const Center(
                                  child: Icon(Icons.tv,
                                      size: 40, color: Colors.white70)),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(channel.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12))
                ],
              ),
            );
          },
        );
      },
    );
  }
}
