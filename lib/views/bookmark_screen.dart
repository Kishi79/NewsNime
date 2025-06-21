import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'utils/helper.dart';
import 'widgets/custom_form_field.dart';
import '../services/api_service.dart';
import '../models/article.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<List<Article>>? _bookmarkedArticlesFuture;

  @override
  void initState() {
    super.initState();
    _bookmarkedArticlesFuture = ApiService.getSavedArticles();
  }

  Future<void> _refreshBookmarks() async {
    setState(() {
      _bookmarkedArticlesFuture = ApiService.getSavedArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cWhite,
        elevation: 0,
        leading: Image.asset(
          'assets/images/news logo.png',
          width: 36.w,
          fit: BoxFit.contain,
        ),
        title: Text(
          'NewsStream',
          style: headline4.copyWith(color: cPrimary, fontWeight: bold),
        ),
      ),
      backgroundColor: cWhite,
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vsSmall,
            Text('Bookmark', style: headline3.copyWith(fontWeight: semibold)),
            vsTiny,
            CustomFormField(
              hintText: 'Cari',
              controller: searchController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              suffixIcon: const Icon(Icons.search),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pencarian tidak boleh kosong';
                }
                return null;
              },
            ),
            vsSmall,
            Expanded(
              child: FutureBuilder<List<Article>>(
                future: _bookmarkedArticlesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error memuat bookmark: ${snapshot.error}. Silakan login.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Belum ada berita yang di-bookmark.'),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: _refreshBookmarks,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final article = snapshot.data![index];
                          return Card(
                            elevation: 0,
                            color: cWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      article.imageUrl,
                                      width: 100.w,
                                      height: 100.h,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.asset(
                                          'assets/images/placeholder.png',
                                          width: 100.w,
                                          height: 100.h,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title,
                                          style: subtitle1.copyWith(
                                            fontWeight: semibold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        vsTiny,
                                        Text(
                                          '${article.category}, ${article.author.name}',
                                          style: caption,
                                        ),
                                        vsTiny,
                                        Text(
                                          article.publishedAt,
                                          style: caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.bookmark),
                                    onPressed: () async {
                                      try {
                                        await ApiService.removeBookmark(
                                          article.id,
                                        );
                                        ScaffoldMessenger.of(
                                          // ignore: use_build_context_synchronously
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Bookmark dihapus.'),
                                          ),
                                        );
                                        _refreshBookmarks();
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          // ignore: use_build_context_synchronously
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Gagal menghapus bookmark: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
