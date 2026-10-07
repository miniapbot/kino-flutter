import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const KinoGoWebViewApp());
}

class KinoGoWebViewApp extends StatelessWidget {
  const KinoGoWebViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinoGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF17212B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF17212B),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const KinoGoWebViewScreen(),
    );
  }
}

class KinoGoWebViewScreen extends StatefulWidget {
  const KinoGoWebViewScreen({super.key});

  @override
  State<KinoGoWebViewScreen> createState() => _KinoGoWebViewScreenState();
}

class _KinoGoWebViewScreenState extends State<KinoGoWebViewScreen> {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF17212B))
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      )
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress;
            });
          },
          onPageStarted: (String url) {
            debugPrint('Страница начала загрузку: $url');
            setState(() {
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            debugPrint('Страница загружена: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView Error: ${error.description}');
            setState(() {
              _hasError = true;
              _errorMessage = error.description;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    // Загружаем сайт с задержкой, чтобы WebView успел инициализироваться
    Future.delayed(const Duration(milliseconds: 300), () {
      _loadSite();
    });
  }

  void _loadSite() {
    _controller.loadRequest(
      Uri.parse('https://kino.lazerok.site'),
      headers: {'Cache-Control': 'no-cache'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KinoGo'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadSite),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loadingProgress < 100 && !_hasError)
            LinearProgressIndicator(
              value: _loadingProgress / 100,
              backgroundColor: Colors.transparent,
              color: const Color(0xFF5EB5F7),
            ),
          if (_hasError)
            Container(
              color: const Color(0xFF17212B),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFF5EB5F7),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Не удалось загрузить сайт',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Color(0xFF8B9AAD),
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadSite,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Повторить'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5EB5F7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
