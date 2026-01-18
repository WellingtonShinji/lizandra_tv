import 'package:flutter/material.dart';
import 'tv_screen.dart';
import 'movies_screen.dart';
import 'series_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),

            // LOGO
            Column(
              children: const [
                Icon(
                  Icons.live_tv,
                  size: 96,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                Text(
                  'Lizandra TV',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // MENU
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MenuCard(
                  title: 'TV',
                  icon: Icons.tv,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TVScreen(),
                      ),
                    );
                  },
                ),
                _MenuCard(
                  title: 'Filmes',
                  icon: Icons.movie,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MoviesScreen(),
                      ),
                    );
                  },
                ),
                _MenuCard(
                  title: 'Séries',
                  icon: Icons.video_library,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SeriesScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const Spacer(),

            // RODAPÉ
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Powered by MULTITEC',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 220,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 10,
                offset: Offset(0, 6),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: Colors.white),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
