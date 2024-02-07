import 'package:allaboutclubs/logic/models/club.dart';
import 'package:allaboutclubs/logic/repositories/clubs_repository.dart';
import 'package:allaboutclubs/main.dart';
import 'package:allaboutclubs/pages/error_page.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final totalTitlesProvider = FutureProvider<int>((ref) async {
  final cancelToken = CancelToken();

  final repository = ref.watch(repositoryProvider);
  final totalTitles = await repository.getTotalTitles(cancelToken: cancelToken);

  return totalTitles;
});

class ClubDetailPage extends ConsumerWidget {
  const ClubDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubId = ref.watch(selectedClubId);

    return ref.watch(getClubProvider(clubId)).when(
        data: (club) => Scaffold(
              appBar: AppBar(
                title: Text(club.name),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.go('/');
                  },
                ),
              ),
              body: Center(
                  child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 5),
                    width: double.infinity,
                    color: Colors.black87,
                    child: Column(
                      children: [
                        Image.network(
                          club.image,
                          height: 150,
                          width: 150,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.hide_image_outlined,
                              size: 150,
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'countries.${club.country}'.tr(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'the_club'.tr(),
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: club.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                TextSpan(
                                    text: 'from_has_a_value'.tr(args: [
                                  'countries.${club.country}'.tr(),
                                  club.value.toString()
                                ])),
                              ]),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ref.watch(totalTitlesProvider).when(
                            data: (totalTitles) => RichText(
                                    text: TextSpan(
                                        text:
                                            'has_so_far'.tr(args: [club.name]),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        children: <TextSpan>[
                                      TextSpan(
                                          text: 'comparison'.tr(args: [
                                            plural(
                                                'titles', club.europeanTitles),
                                            plural('titles', totalTitles)
                                          ]),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                      TextSpan(text: 'at_european_level'.tr()),
                                    ])),
                            error: (Object error, StackTrace stackTrace) =>
                                Container(),
                            loading: () => Container()),
                      ],
                    ),
                  )
                ],
              )),
            ),
        error: (err, sta) => ErrorPage(ex: err as Exception),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
