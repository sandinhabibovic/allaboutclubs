import 'package:allaboutclubs/logic/models/club.dart';
import 'package:allaboutclubs/pages/error_page.dart';
import 'package:allaboutclubs/go_router/go_router_provider.dart';
import 'package:allaboutclubs/logic/repositories/clubs_repository.dart';
import 'package:allaboutclubs/logic/settings.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('de'), Locale('en'), Locale('pl')],
        path: 'assets/translations',
        fallbackLocale: const Locale('de'),
        // startLocale: const Locale('en'),
        child: const ProviderScope(child: MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final router = ref.read(goRouteProvider);

      return MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF01C13B),
            foregroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF01C13B)),
          useMaterial3: true,
        ),
      );
    });
  }
}

final _getClubsProvider = FutureProvider<List<Club>>((ref) async {
  final repository = ref.watch(repositoryProvider);
  final clubs = await repository.getClubs();

  return clubs;
});

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          Consumer(builder: (context, ref, _) {
            return IconButton(
                onPressed: () {
                  ref.read(settingsChangeProvider.notifier).toggle();
                },
                icon: const Icon(Icons.filter_alt_outlined));
          })
        ],
      ),
      body: Center(
        child: Consumer(builder: (context, ref, _) {
          final clubs = ref.watch(_getClubsProvider);

          return clubs.when(
            data: (response) => ListView.separated(
              itemCount: response.length,
              itemBuilder: (context, index) {
                final club = response[index];

                return ProviderScope(
                  overrides: [selectedClubId.overrideWith((ref) => club.id)],
                  child: const ClubItem(),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(color: Colors.black);
              },
            ),
            error: ((error, stackTrace) => ErrorPage(
                  ex: error as Exception,
                  isHomePage: true,
                )),
            loading: () => const CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}

final selectedClubId = Provider<String>((ref) {
  throw UnimplementedError();
});

final getClubProvider =
    FutureProvider.autoDispose.family<Club, String>((ref, id) async {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final repository = ref.watch(repositoryProvider);
  final club = await repository.getClub(
    id,
    cancelToken: cancelToken,
  );

  ref.keepAlive();
  return club;
});

class ClubItem extends ConsumerWidget {
  const ClubItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubId = ref.watch(selectedClubId);

    return ref.watch(getClubProvider(clubId)).when(
        data: (club) => GestureDetector(
              onTap: () {
                context.go('/detail/${club.id}');
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.network(
                      club.image,
                      height: 100,
                      width: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.hide_image_outlined,
                          size: 150,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          club.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'countries.${club.country}'.tr(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(
                              'millions'.tr(args: [club.value.toString()]),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        error: (err, sta) => Container(),
        loading: () => Container());
  }
}
