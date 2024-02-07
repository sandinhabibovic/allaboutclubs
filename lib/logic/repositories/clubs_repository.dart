import 'package:allaboutclubs/logic/api_service.dart';
import 'package:allaboutclubs/logic/models/club.dart';
import 'package:allaboutclubs/logic/settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider((ref) => Dio());

final repositoryProvider = Provider((ref) => ClubRepository(ref));

class ClubRepository {
  ClubRepository(this.ref);

  final Ref ref;
  final _clubCache = <String, Club>{};
  final _otherCache = <String, Object>{};
  final _path = 'https://public.allaboutapps.at/hiring/clubs.json';

  Future<List<Club>> getClubs({
    CancelToken? cancelToken,
  }) async {
    final clubs = await _get(cancelToken: cancelToken);

    for (final club in clubs) {
      _clubCache[club.id] = club;
    }

    final order = ref.watch(settingsChangeProvider).orderByName;

    order
        ? clubs.sort((a, b) => a.name.compareTo(b.name))
        : clubs.sort((a, b) => b.value.compareTo(a.value));

    return clubs;
  }

  Future<Club> getClub(
    String id, {
    CancelToken? cancelToken,
  }) async {
    if (_clubCache.containsKey(id)) {
      return _clubCache[id]!;
    }

    final clubs = await _get(cancelToken: cancelToken);

    final club = clubs.singleWhere((element) => element.id == id);

    _clubCache[club.id] = club;

    return club;
  }

  Future<int> getTotalTitles({CancelToken? cancelToken}) async {
    if (_otherCache.containsKey('titles')) {
      return _otherCache['titles'] as int? ?? 0;
    }
    final clubs = await _get(cancelToken: cancelToken);

    int totalTitles =
        clubs.fold(0, (int sum, Club club) => sum + club.europeanTitles);

    _otherCache['titles'] = totalTitles;

    return totalTitles;
  }

  Future<List<Club>> _get({CancelToken? cancelToken}) async {
    final apiService = ref.read(apiServiceProvider);

    final response =
        await apiService.fetchData(_path, cancelToken: cancelToken);

    final clubs = response.map((json) {
      return Club.fromJson(json);
    }).toList(growable: false);

    return clubs;
  }
}
