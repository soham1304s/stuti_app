import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Story {
  final String authorName;
  final String content;
  final DateTime timestamp;

  Story({required this.authorName, required this.content, required this.timestamp});

  Map<String, dynamic> toJson() => {
    'authorName': authorName,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      authorName: json['authorName'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class StoryServerService extends ChangeNotifier {
  HttpServer? _server;
  Story? _myStory;
  int _port = 8081;

  final Map<String, Story> _peerStories = {};

  Story? get myStory => _myStory;
  Map<String, Story> get peerStories => Map.unmodifiable(_peerStories);
  bool get isRunning => _server != null;

  StoryServerService() {
    // Seed a mock story for demonstration purposes
    mockDiscoverMeshStory('192.168.1.104', 'Alex Monroe', 'Exploring the mountains! No internet here, just mesh vibes.');
    mockDiscoverMeshStory('192.168.1.105', 'Maya Patel', 'Found a great local coffee shop.');
  }

  Future<void> startServer(String authorName) async {
    if (_server != null) return;
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, _port);
      debugPrint("P2P Story Server running on port $_port");
      
      _server!.listen((HttpRequest request) {
        if (request.uri.path == '/story') {
          if (_myStory != null) {
            request.response
              ..statusCode = HttpStatus.ok
              ..headers.contentType = ContentType.json
              ..write(jsonEncode(_myStory!.toJson()))
              ..close();
          } else {
            request.response
              ..statusCode = HttpStatus.notFound
              ..write("No story posted")
              ..close();
          }
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..close();
        }
      });
    } catch (e) {
      debugPrint("Failed to start P2P story server: $e");
    }
  }

  void postStory(String authorName, String content) {
    _myStory = Story(
      authorName: authorName,
      content: content,
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  // In a production LAN environment, you would use mDNS/Bonjour or 
  // BLE Advertisements to discover peer IPs. 
  // For this implementation, we can fetch from a known IP or mock the discovery.
  Future<void> fetchPeerStory(String peerIp) async {
    try {
      final client = HttpClient();
      final request = await client.get(peerIp, _port, '/story');
      final response = await request.close();
      
      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final storyMap = jsonDecode(responseBody);
        final story = Story.fromJson(storyMap);
        _peerStories[peerIp] = story;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Failed to fetch story from $peerIp: $e");
    }
  }

  // Mock discovering a story over the local mesh network
  void mockDiscoverMeshStory(String peerId, String name, String content) {
    _peerStories[peerId] = Story(
      authorName: name,
      content: content,
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _server?.close(force: true);
    super.dispose();
  }
}
