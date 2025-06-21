import 'dart:convert'; // Untuk mengelola data JSON
import 'package:http/http.dart' as http; // Untuk melakukan permintaan HTTP
import 'package:shared_preferences/shared_preferences.dart'; // Untuk menyimpan token
import '../models/article.dart'; // Import model Article
import '../models/user.dart'; // Import model User

class ApiService {
  // Base URL API kita, diambil dari dokumentasi
  static const String _baseUrl = 'https://rest-api-berita.vercel.app/api/v1'; 
  // Variabel untuk menyimpan token autentikasi (JWT)
  static String? _token;

  // --- Fungsi untuk mengelola Token ---

  // Mendapatkan token dari memori atau penyimpanan lokal
  static Future<String?> getToken() async {
    if (_token != null) return _token; // Jika sudah ada di memori, langsung pakai
    final prefs = await SharedPreferences.getInstance(); // Ambil instance SharedPreferences
    _token = prefs.getString('jwt_token'); // Coba ambil token dari penyimpanan lokal
    return _token;
  }

  // Menyimpan token ke penyimpanan lokal
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    _token = token; // Simpan juga di memori
  }

  // Menghapus token dari penyimpanan lokal (untuk Logout)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    _token = null;
  }

  // --- Fungsi Bantuan untuk Header Permintaan HTTP ---

  // Membuat header default untuk setiap permintaan API
  static Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json', // Memberitahu server bahwa kita mengirim JSON
    };
    if (requireAuth) { // Jika permintaan ini butuh autentikasi
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token'; // Menambahkan token JWT ke header
      } else {
        // Jika token tidak ada padahal butuh autentikasi, lempar error
        throw Exception('Autentikasi diperlukan. Silakan login kembali.');
      }
    }
    return headers;
  }

  // --- Endpoint Autentikasi (Login & Registrasi) ---

  // Fungsi untuk Mendaftar Pengguna Baru
  static Future<User> registerUser({
    required String email,
    required String password,
    required String name,
    String? title,
    String? avatar,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/register'); 
    final response = await http.post(
      url,
      headers: await _getHeaders(), // Tidak butuh autentikasi untuk register
      body: json.encode({ // Mengubah data Dart ke JSON string
        'email': email,
        'password': password,
        'name': name,
        'title': title,
        'avatar': avatar,
      }),
    );

    if (response.statusCode == 201) { // 201 Created berarti sukses
      final data = json.decode(response.body)['data']; // Mengurai JSON respons
      await saveToken(data['token']); // Menyimpan token yang diterima
      return User.fromJson(data['user']); // Mengembalikan objek User
    } else {
      // Jika gagal, ambil pesan error dari respons API
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal mendaftar: $error');
    }
  }

  // Fungsi untuk Login Pengguna
  static Future<User> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/login'); 
    final response = await http.post(
      url,
      headers: await _getHeaders(), // Tidak butuh autentikasi untuk login
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) { // 200 OK berarti sukses
      final data = json.decode(response.body)['data'];
      await saveToken(data['token']); // Menyimpan token yang diterima
      return User.fromJson(data['user']);
    } else {
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal login: $error');
    }
  }

  // --- Endpoint Artikel ---

  // Fungsi untuk Mendapatkan Semua Artikel
  static Future<List<Article>> getAllArticles({
    int page = 1,
    int limit = 10,
    String? category,
  }) async {
    Uri url;
    if (category != null && category.isNotEmpty) {
      url = Uri.parse('$_baseUrl/news?page=$page&limit=$limit&category=$category'); 
    } else {
      url = Uri.parse('$_baseUrl/news?page=$page&limit=$limit'); 
    }

    final response = await http.get(url, headers: await _getHeaders()); // Tidak butuh autentikasi untuk mendapatkan semua artikel

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['articles'] as List; 
      return data.map((json) => Article.fromJson(json)).toList(); // Mengubah List JSON menjadi List Article
    } else {
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal memuat artikel: $error');
    }
  }

  // Fungsi untuk Mendapatkan Artikel Trending
  static Future<List<Article>> getTrendingArticles({
    int page = 1,
    int limit = 5,
  }) async {
    final url = Uri.parse('$_baseUrl/news/trending?page=$page&limit=$limit'); 
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['articles'] as List; 
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal memuat artikel trending: $error');
    }
  }

  // Fungsi untuk Mendapatkan Artikel Berdasarkan ID
  static Future<Article> getArticleById(String id) async {
    final url = Uri.parse('$_baseUrl/news/$id'); 
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      // API respons untuk single article kadang dibungkus dalam array
      final data = json.decode(response.body)['data']['articles'][0]; 
      return Article.fromJson(data);
    } else {
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal memuat detail artikel: $error');
    }
  }

  // --- Endpoint Bookmark ---

  // Fungsi untuk Menyimpan Artikel ke Bookmark
  static Future<void> saveBookmark(String articleId) async {
    final url = Uri.parse('$_baseUrl/news/$articleId/bookmark'); 
    final response = await http.post(url, headers: await _getHeaders(requireAuth: true)); // Membutuhkan autentikasi

    if (response.statusCode != 201) { // 201 Created berarti sukses untuk bookmark
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal menyimpan bookmark: $error');
    }
  }

  // Fungsi untuk Menghapus Artikel dari Bookmark
  static Future<void> removeBookmark(String articleId) async {
    final url = Uri.parse('$_baseUrl/news/$articleId/bookmark'); 
    final response = await http.delete(url, headers: await _getHeaders(requireAuth: true)); // Membutuhkan autentikasi

    if (response.statusCode != 200) { // 200 OK berarti sukses untuk hapus
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal menghapus bookmark: $error');
    }
  }

  // Fungsi untuk Mendapatkan Daftar Artikel yang Dibookmark
  static Future<List<Article>> getSavedArticles() async {
    final url = Uri.parse('$_baseUrl/news/bookmarks/list'); 
    final response = await http.get(url, headers: await _getHeaders(requireAuth: true)); // Membutuhkan autentikasi

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['articles'] as List; 
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal memuat artikel yang dibookmark: $error');
    }
  }

  // Fungsi untuk Mengecek Status Bookmark Artikel
  static Future<bool> checkBookmarkStatus(String articleId) async {
    final url = Uri.parse('$_baseUrl/news/$articleId/bookmark'); 
    final response = await http.get(url, headers: await _getHeaders(requireAuth: true)); // Membutuhkan autentikasi

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']; 
      return data['isSaved'];
    } else if (response.statusCode == 404) { // 404 Not Found mungkin berarti tidak dibookmark
      return false;
    } else {
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal memeriksa status bookmark: $error');
    }
  }

  // --- Endpoint untuk Admin/User (Opsional jika Anda ingin membuat artikel sendiri) ---

  // Fungsi untuk Membuat Artikel (Membutuhkan Autentikasi)
  static Future<void> createArticle({
    required String title,
    required String category,
    required String readTime,
    required String imageUrl,
    required List<String> tags,
    required String content,
    bool isTrending = false,
  }) async {
    final url = Uri.parse('$_baseUrl/news'); 
    final response = await http.post(
      url,
      headers: await _getHeaders(requireAuth: true),
      body: json.encode({
        'title': title,
        'category': category,
        'readTime': readTime,
        'imageUrl': imageUrl,
        'isTrending': isTrending,
        'tags': tags,
        'content': content,
      }),
    );

    if (response.statusCode != 201) {
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal membuat artikel: $error');
    }
  }

  // Fungsi untuk Memperbarui Artikel (Membutuhkan Autentikasi)
  static Future<void> updateArticle(
    String articleId, {
    String? title,
    String? category,
    String? readTime,
    String? imageUrl,
    List<String>? tags,
    String? content,
    bool? isTrending,
  }) async {
    final url = Uri.parse('$_baseUrl/news/$articleId'); 
    final response = await http.put(
      url,
      headers: await _getHeaders(requireAuth: true),
      body: json.encode({
        if (title != null) 'title': title,
        if (category != null) 'category': category,
        if (readTime != null) 'readTime': readTime,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (tags != null) 'tags': tags,
        if (content != null) 'content': content,
        if (isTrending != null) 'isTrending': isTrending,
      }),
    );

    if (response.statusCode != 200) {
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal memperbarui artikel: $error');
    }
  }

  // Fungsi untuk Menghapus Artikel (Membutuhkan Autentikasi)
  static Future<void> deleteArticle(String articleId) async {
    final url = Uri.parse('$_baseUrl/news/$articleId'); 
    final response = await http.delete(url, headers: await _getHeaders(requireAuth: true));

    if (response.statusCode != 200) {
      final error = json.decode(response.body)['message'];
      throw Exception('Gagal menghapus artikel: $error');
    }
  }
}