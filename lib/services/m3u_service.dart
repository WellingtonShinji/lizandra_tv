import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/channel.dart';

class M3UService {
  /// Carrega e parseia lista M3U a partir de uma URL
  Future<List<Channel>> loadFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar M3U');
    }

    return _parseM3U(response.body);
  }

  /// Parser simples de M3U
  List<Channel> _parseM3U(String content) {
    final List<Channel> channels = [];
    final lines = const LineSplitter().convert(content);

    String? name;
    String? logo;
    String? group;

    for (final line in lines) {
      if (line.startsWith('#EXTINF')) {
        name = _extract(line, ',');
        logo = _extractAttr(line, 'tvg-logo');
        group = _extractAttr(line, 'group-title');
      } else if (line.startsWith('http')) {
        if (name != null && group != null) {
          channels.add(
            Channel(
              name: name!,
              logo: logo ?? '',
              url: line.trim(),
              group: group ?? '',
            ),
          );
        }
        name = null;
        logo = null;
        group = null;
      }
    }

    return channels;
  }

  String _extract(String line, String separator) {
    final index = line.lastIndexOf(separator);
    return index != -1 ? line.substring(index + 1).trim() : '';
  }

  String? _extractAttr(String line, String attr) {
    final regex = RegExp('$attr="([^"]*)"');
    final match = regex.firstMatch(line);
    return match?.group(1);
  }
}
