import 'package:flutter/material.dart';

import '../data/find_tutors_mock_data.dart';
import '../data/home_mock_data.dart';
import '../widgets/find_tutors_widgets.dart';
import '../widgets/home_widgets.dart' show HomeBottomNav;

class FindTutorsScreen extends StatefulWidget {
  const FindTutorsScreen({super.key});

  @override
  State<FindTutorsScreen> createState() => _FindTutorsScreenState();
}

class _FindTutorsScreenState extends State<FindTutorsScreen> {
  static const Color _background = Color(0xFFF7F9FF);

  String _query = '';
  bool _ratingOnly = false;
  bool _availableOnly = false;
  TutorSort _sort = TutorSort.topRated;
  PreviewMode _previewMode = PreviewMode.emptyState;

  // لإعادة بناء حقل البحث بعد الـ Reset
  Key _searchKey = UniqueKey();

  bool get _allSelected => !_ratingOnly && !_availableOnly;

  List<TutorListItem> get _results {
    final q = _query.trim().toLowerCase();

    final list = FindTutorsMockData.tutors.where((t) {
      if (_ratingOnly && t.rating < 4.0) return false;
      if (_availableOnly && !t.availableThisWeek) return false;
      if (q.isEmpty) return true;
      return t.name.toLowerCase().contains(q) ||
          t.major.toLowerCase().contains(q) ||
          t.skills.any((s) => s.toLowerCase().contains(q));
    }).toList();

    switch (_sort) {
      case TutorSort.topRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case TutorSort.mostReviewed:
        list.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
      case TutorSort.lowestPrice:
        list.sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour));
        break;
    }
    return list;
  }

  void _resetFilters() {
    setState(() {
      _query = '';
      _ratingOnly = false;
      _availableOnly = false;
      _searchKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const FindTutorsHeader(points: HomeMockData.pointsBalance),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TutorSearchBar(
                      key: _searchKey,
                      hint: FindTutorsMockData.searchHint,
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    const SizedBox(height: 12),
                    TutorFilterChips(
                      allSelected: _allSelected,
                      ratingSelected: _ratingOnly,
                      availableSelected: _availableOnly,
                      onAllTap: () => setState(() {
                        _ratingOnly = false;
                        _availableOnly = false;
                      }),
                      onRatingTap: () =>
                          setState(() => _ratingOnly = !_ratingOnly),
                      onAvailableTap: () =>
                          setState(() => _availableOnly = !_availableOnly),
                    ),
                    const SizedBox(height: 20),
                    TutorsListHeader(
                      nearbyCount: results.length,
                      sort: _sort,
                      onSortChanged: (s) => setState(() => _sort = s),
                    ),
                    const SizedBox(height: 12),
                    if (results.isEmpty)
                      TutorsEmptyState(
                        query: _query.trim().isEmpty
                            ? 'these filters'
                            : _query.trim(),
                        onReset: _resetFilters,
                      )
                    else
                      ...results.map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TutorListCard(tutor: t),
                        ),
                      ),
                    const SizedBox(height: 20),
                    PreviewStatesSection(
                      mode: _previewMode,
                      onModeChanged: (m) => setState(() => _previewMode = m),
                      emptyQuery: FindTutorsMockData.sampleEmptyQuery,
                      onReset: _resetFilters,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SafeArea(
        child: HomeBottomNav(currentIndex: 1),
      ),
    );
  }
}
