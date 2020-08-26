import 'package:bookapp/provider/auth_provider.dart';
import 'package:bookapp/provider/author_provider.dart';
import 'package:bookapp/provider/book_provider.dart';
import 'package:bookapp/provider/categories_provider.dart';
import 'package:bookapp/provider/user_provider.dart';
import './views/home/screens/first_screen.dart';
import 'package:bookapp/theme/theme_color.dart';
import 'package:bookapp/views/author/screen/author_books_screen.dart';
import 'package:bookapp/views/author/screen/author_screen.dart';
import 'package:bookapp/views/book/screen/add_book.dart';
import 'package:bookapp/views/book/screen/books_notes.dart';
import 'package:bookapp/views/book/screen/watch_add_screen.dart';
import 'package:bookapp/views/categories/screen/categories.dart';
import 'package:bookapp/views/categories/screen/categories_detail.dart';
import 'package:bookapp/views/explore/screens/choose_interest.dart';
import 'package:bookapp/views/home/screens/auth_screen.dart';
import 'package:bookapp/views/home/screens/search_screen.dart';
import 'package:bookapp/views/home/screens/splash_screen.dart';
import 'package:bookapp/views/profile_settings/screens/feedback.dart';
import 'package:bookapp/views/profile_settings/screens/settings/settings_screen.dart';
import 'package:bookapp/views/profile_settings/screens/subscription.dart';
import 'package:bookapp/views/profile_settings/screens/user_profile.dart';
import 'package:bookapp/views/tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: BookProvider()),
        ChangeNotifierProvider.value(value: AuthorProvider()),
        ChangeNotifierProvider.value(value: CategoryProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.purple,
              textTheme: ThemeData.light().textTheme.copyWith(
                    body1: TextStyle(color: ThemeColors.color1, fontSize: 15),
                    title: TextStyle(
                        fontSize: 20,
                        color: ThemeColors.color1,
                        fontWeight: FontWeight.bold),
                  )),
          home: SplashScreen(),
          routes: {
            FirstScreen.routeName: (ctx) => FirstScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            TabScreen.routeName: (ctx) => TabScreen(),
            AuthorScreen.routeName: (ctx) => AuthorScreen(),
            CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
            CategoriesDetailsScreen.routeName: (ctx) =>
                // ignore: missing_required_param
                CategoriesDetailsScreen(),
            ChooseInterest.routeName: (ctx) => ChooseInterest(),
            SubscriptionScreen.routeName: (ctx) => SubscriptionScreen(),
            FeedbackScreen.routeName: (ctx) => FeedbackScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            // ignore: missing_required_param
            WatchAddScreen.routeName: (ctx) => WatchAddScreen(),
            // ignore: missing_required_param
            AuthorBooks.routeName: (ctx) => AuthorBooks(),
            BooksNotes.routeName: (ctx) => BooksNotes(),
            UserProfile.routeName: (ctx) => UserProfile(),
            AddBook.routeName: (ctx) => AddBook(),
          },
        ),
      ),
    );
  }
}
