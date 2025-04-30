import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/core/auth/auth_service.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/core/utils/ToastHelper.dart';
import 'package:new_app/presentation/screens/HomeScreen.dart';
import 'package:new_app/presentation/screens/MyPokemons.dart';
import 'package:new_app/presentation/screens/PokeBattleScreen.dart';
import 'package:new_app/providers/pokemon.providers.dart';
import 'package:toastification/toastification.dart';

class ParentWidget extends StatefulWidget {
  const ParentWidget({Key? key}) : super(key: key);

  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool isSearching = false;
  late TextEditingController _searchController;
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );
  int maxCount = 3;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void toggleSearchBar() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> bottomBarPages = [
      HomeScreen(controller: _controller),
      const PokeBattleScreen(),
      const MyPokemons(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSearching ? context.sw * 0.7 : 40,
            curve: Curves.easeInOut,
            child:
                isSearching
                    ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          context.go('/search/$value');
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "pokeID or name",
                        filled: true,
                        suffixIcon: IconButton(
                          onPressed: toggleSearchBar,
                          icon: Icon(Icons.close),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    )
                    : IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        toggleSearchBar();
                      },
                    ),
          ),

          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: Icon(Icons.favorite),
            onPressed: () {
              context.go('/favs');
            },
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const _MoreOptionsSheet(),
              );
            },
          ),
        ],
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder:
              (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
          child:
              isSearching
                  ? const SizedBox.shrink(key: ValueKey('empty'))
                  : Wrap(
                    key: const ValueKey('pokedex'),
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      Image.asset(
                        'assets/images/pokeball.png',
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        "Pokédex",
                        style: GoogleFonts.righteous(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bottomBarPages,
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: isDark ? const Color(0xFF2B2B2B) : const Color(0xFFF2F2F2),
        notchColor: isDark ? const Color(0xFFE63946) : const Color(0xFF1D3557),
        showLabel: true,
        textOverflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        kBottomRadius: 28.0,
        showShadow: true,
        shadowElevation: 8,
        durationInMilliSeconds: 300,
        itemLabelStyle: const TextStyle(fontSize: 10),
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.catching_pokemon,
              color: Colors.grey,
            ),
            activeItem: const Icon(
              Icons.catching_pokemon,
              color: Colors.yellow,
            ),
            itemLabel: 'Pokedex',
          ),
          BottomBarItem(
            inActiveItem: const Icon(
              Icons.sports_martial_arts,
              color: Colors.grey,
            ),
            activeItem: const Icon(
              Icons.sports_martial_arts,
              color: Colors.yellow,
            ),
            itemLabel: 'Battle',
          ),
          BottomBarItem(
            inActiveItem: const Icon(Icons.backpack, color: Colors.grey),
            activeItem: const Icon(Icons.backpack, color: Colors.yellow),
            itemLabel: 'My Team',
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        kIconSize: 26.0,
      ),
    );
  }
}

class _MoreOptionsSheet extends ConsumerWidget {
  const _MoreOptionsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkMode);
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          authState.when(
            data: (user) {
              final photoUrl =
                  user?.photoURL ?? 'https://avatar.iran.liara.run/public}';
              final username = user?.displayName ?? "Trainer";

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl),
                  onBackgroundImageError: (_, __) {},
                ),
                title: Text(username),
              );
            },
            loading:
                () => const ListTile(
                  leading: CircleAvatar(child: CircularProgressIndicator()),
                  title: Text("Loading..."),
                ),
            error:
                (err, stack) => const ListTile(
                  leading: CircleAvatar(child: Icon(Icons.error)),
                  title: Text("Error loading user"),
                ),
          ),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: isDark,
              onChanged: (val) {
                ref.read(isDarkMode.notifier).state = val;
              },
            ),
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Use Goodbye!"),
            onTap: () async {
              try {
                await AuthService().signOut();

                showToast(
                  context: context,
                  toastType: ToastificationType.success,
                  title: "Signed Out! Pikachu used Goodbye!",
                  description: "Hope to battle again soon!",
                );

                await Future.delayed(const Duration(seconds: 2));
                if (context.mounted) {
                  context.go("/");
                }
              } catch (e) {
                showToast(
                  context: context,
                  toastType: ToastificationType.error,
                  title: "Oh no! Pokéball Jammed",
                  description: "We couldn’t sign you out. Try again!",
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
