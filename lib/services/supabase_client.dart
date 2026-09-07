import 'package:supabase_flutter/supabase_flutter.dart';

/// Acceso único al cliente de Supabase en toda la app,
/// igual que tu SupabaseClient.js en React.
///
/// Se usa así en cualquier pantalla:
///   import '../../services/supabase_client.dart';
///   ...
///   final data = await supabase.from('tabla').select();
final SupabaseClient supabase = Supabase.instance.client;

/// Llama esto UNA sola vez, al inicio de main(), antes de runApp().
Future<void> inicializarSupabase() async {
  await Supabase.initialize(
    url: 'https://nnlpmcwnahjdfqhfccjj.supabase.co',
    anonKey: 'sb_publishable_3WU0ecokunMuTQMf6xWqLA_TrZVAZ7X',
  );
}