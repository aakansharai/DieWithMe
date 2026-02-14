import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'chat_room_screen.dart';
import '../services/supabase_service.dart';

class BatteryGateScreen extends StatefulWidget {
  const BatteryGateScreen({super.key});

  @override
  State<BatteryGateScreen> createState() => _BatteryGateScreenState();
}

class _BatteryGateScreenState extends State<BatteryGateScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = 100;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkBattery();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _checkBattery());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkBattery() async {
    final level = await _battery.batteryLevel;
    if (mounted) {
      setState(() {
        _batteryLevel = level;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDying = _batteryLevel <= 95;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_batteryLevel%',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: isDying ? Colors.red : Colors.grey[800],
                shadows: isDying
                    ? [const Shadow(color: Colors.redAccent, blurRadius: 20)]
                    : [],
              ),
            ),
            const SizedBox(height: 20),
            if (isDying) ...[
              Text(
                'WELCOME TO THE VOID',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  letterSpacing: 4,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              _NeonButton(
                text: 'ENTER',
                onPressed: () async {
                  final room = await SupabaseService.getOrCreateRoom();
                  if (!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(roomId: room.id),
                    ),
                  );
                },
              ),
            ] else ...[
              Text(
                'GO DIE ALONE',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey[600],
                  letterSpacing: 4,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'RETURN WHEN YOU ARE FRAIL',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey[800],
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _NeonButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.jetBrainsMono(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
