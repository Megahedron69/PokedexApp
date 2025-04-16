import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/core/auth/auth_service.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/core/utils/ToastHelper.dart';
import 'package:new_app/presentation/widgets/ListViewBuildWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/providers/pokemon.providers.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearching = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void toggleSearchBar() {
    setState(() {
      isSearching = !isSearching;
    });
  }

  void navigBut() {
    if (!context.mounted) return;
    context.go("/details/Pikachu");
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListViewBuildWidget(),
      extendBodyBehindAppBar: true,
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
