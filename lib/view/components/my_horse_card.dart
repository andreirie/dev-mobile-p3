import 'dart:io';
import 'package:apk_p3/model/horse_model.dart';
import 'package:flutter/material.dart';

class HorseCardWidget extends StatelessWidget {
  final Horse horse;
  final VoidCallback onTap;

  const HorseCardWidget({super.key, required this.horse, required this.onTap});

  String _formatDate(int? date) {
    if (date == null || date == 0) return "N/A";
    String dateString = date.toString().padLeft(8, '0');
    if (dateString.length == 8) {
      return "${dateString.substring(0, 2)}/${dateString.substring(2, 4)}/${dateString.substring(4, 8)}";
    }
    return "Inválida";
  }

  String _calculateWinRatio(int totalWins, int totalRaces) {
    if (totalRaces == 0) {
      return "0%";
    }
    double ratio = totalWins / totalRaces;
    return "${(ratio * 100).toStringAsFixed(1)}%";
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.0, color: Colors.grey[600]),
        const SizedBox(width: 4.0),
        Flexible(
          child: Text(
            label,
            style: TextStyle(fontSize: 12.0, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required String count,
    required String label,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.0, color: Colors.brown[700]),
              const SizedBox(width: 4.0),
              Flexible(
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[900],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(horse.lastVictoryDate);
    final totalWins = horse.totalWins ?? 0;
    final winRatio = _calculateWinRatio(totalWins, horse.totalRaces);

    return Card(
      elevation: 6.0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 180.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(13.0),
                ),
                image: DecorationImage(
                  image: horse.image != null && horse.image!.isNotEmpty
                      ? FileImage(File(horse.image!))
                      : const AssetImage("assets/horse.png") as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(13.0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                child: Text(
                  horse.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: <Widget>[
                      _buildDetailChip(
                        icon: Icons.access_time,
                        label: "${horse.age} anos",
                      ),
                      _buildDetailChip(icon: Icons.pets, label: horse.gender),
                      _buildDetailChip(
                        icon: Icons.palette,
                        label: horse.coatColor,
                      ),
                    ],
                  ),
                  Divider(height: 16.0, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(
                        icon: Icons.emoji_events,
                        count: totalWins.toString(),
                        label: "Vitórias",
                      ),
                      _buildStatColumn(
                        icon: Icons.directions_run,
                        count: horse.totalRaces.toString(),
                        label: "Corridas",
                      ),
                      _buildStatColumn(
                        icon: Icons.trending_up,
                        count: winRatio,
                        label: "Taxa de Vitórias",
                      ),
                    ],
                  ),
                  Divider(height: 16.0, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14.0,
                        color: Colors.brown,
                      ),
                      const SizedBox(width: 6.0),
                      Text(
                        "Última Vitória: ",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[900],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
