import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/channel.dart';

class M3UService {
  Future<List<Channel>> loadFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar M3U');
    }
    return _parseM3U(response.body);
  }

  List<Channel> _parseM3U(String data) {
    final lines = LineSplitter.split(data).toList();
    List<Channel> channels = [];
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('#EXTINF')) {
        final info = lines[i];
        final url = lines[i + 1];
        final nameMatch = RegExp(r',(.+)$').firstMatch(info);
        final logoMatch = RegExp(r'tvg-logo="([^"]+)"').firstMatch(info);
        final groupMatch = RegExp(r'group-title="([^"]+)"').firstMatch(info);

        final name = nameMatch?.group(1) ?? 'Canal';
        final logo = logoMatch?.group(1) ?? '';
        final group = groupMatch?.group(1) ?? '';

        channels.add(Channel(name: name, logo: logo, url: url, group: group));
      }
    }
    return channels;
  }
}
