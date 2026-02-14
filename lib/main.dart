import 'package:diewithme/app.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Replace these with your actual Supabase project credentials
  await Supabase.initialize(
    url: 'https://xxzjgotlfkzjgieujark.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4empnb3RsZmt6amdpZXVqYXJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk1OTI2MTksImV4cCI6MjA4NTE2ODYxOX0.BDHqiEjVBjNmZIlYv0_dz8-WX6yao17hICB2MFO9fCI',
  );

  runApp(const MyApp());
}
