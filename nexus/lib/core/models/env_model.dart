class EnvModel {
  final bool development;
  
  final String supabaseUrl;
  final String supabaseKey;
  
  final String devSupabaseUrl;
  final String devSupabaseKey;

  const new({
    required this.development, 
    required this.supabaseUrl, 
    required this.supabaseKey, 
    required this.devSupabaseUrl, 
    required this.devSupabaseKey,
  });

  String getSupabaseUrl() {
    return development ? devSupabaseUrl : supabaseUrl;
  }
}