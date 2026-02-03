import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youpaint/utils/app_theme.dart';
import 'package:youpaint/view/home_screen.dart';
import 'package:youpaint/viewmodel/drawing_viewmodel.dart';
import 'package:youpaint/viewmodel/gallery_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DrawingViewmodel()),
        ChangeNotifierProvider(create: (_) => GalleryViewmodel()),
      ],
      child: MaterialApp(
        title: 'YouPaint',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
