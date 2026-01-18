import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/channel.dart';
import 'm3u_service.dart';

class ChannelRepository {
  static const _cacheKey = 'channels_cache';
  static const _cacheTimeKey = 'channels_cache_time';

  static const cacheDuration = Duration(hours: 6);

  final M3UService _service = M3UService();

  Future<List<Channel>> getAll(String url) async {
    final prefs = await SharedPreferences.getInstance();

    final cached = prefs.getString(_cacheKey);
    final cachedTime = prefs.getInt(_cacheTimeKey);

    if (cached != null && cachedTime != null) {
      final cacheDate =
          DateTime.fromMillisecondsSinceEpoch(cachedTime);

      if (DateTime.now().difference(cacheDate) < cacheDuration) {
        final List decoded = jsonDecode(cached);
        return decoded.map((e) => Channel.fromJson(e)).toList();
      }
    }

    final fresh = await _service.fetchAndParse(url);

    prefs.setString(
      _cacheKey,
      jsonEncode(fresh.map((e) => e.toJson()).toList()),
    );
    prefs.setInt(
      _cacheTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );

    return fresh;
  }

  /// FILMES
  List<Channel> movies(List<Channel> all) {
    return all.where((c) {
      final g = c.group.toLowerCase();
      final n = c.name.toLowerCase();
      return g.contains('movie') ||
          g.contains('filme') ||
          g.contains('vod') ||
          n.contains('1080p') ||
          n.contains('720p');
    }).toList();
  }

  /// TV AO VIVO
  List<Channel> tv(List<Channel> all) {
    return all.where((c) {
      final g = c.group.toLowerCase();
      return !g.contains('movie') &&
          !g.contains('serie') &&
          !g.contains('vod');
    }).toList();
  }

  /// SÉRIES
  List<Channel> series(List<Channel> all) {
    return all.where((c) {
      final g = c.group.toLowerCase();
      return g.contains('serie') || g.contains('series');
    }).toList();
  }
}
