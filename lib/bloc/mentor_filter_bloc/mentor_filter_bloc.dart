import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/constants/strings.dart';

import '../../presentation/search/models/mentor_model.dart';
import 'mentor_filter_event.dart';
import 'mentor_filter_state.dart';

class MentorFilterBloc extends Bloc<MentorFilterEvent, MentorFilterState> {
  final List<MentorModel> allMentors;
  MentorFilterBloc(this.allMentors) : super(MentorFilterState(AppData.mentors)) {

    on<ApplyFiltersEvent>((event, emit) {
      List<MentorModel> data = allMentors;


      if (event.minPrice != null && event.maxPrice != null) {
        data = data.where((m) =>
        m.price >= event.minPrice! && m.price <= event.maxPrice!).toList();
      }

      if (event.minRate != null) {
        data = data.where((m) => m.rate >= event.minRate!).toList();
      }

      if (event.status != null) {
        data = data.where((m) => m.status == event.status).toList();
      }

      if (event.track != null) {
        data = data.where((m) => m.track == event.track).toList();
      }

      if (event.skill != null && event.skill!.isNotEmpty) {
        data = data.where((m) =>
            m.skills.any((s) => s.toLowerCase().contains(event.skill!.toLowerCase()))
        ).toList();
      }

      emit(MentorFilterState(data));
    });

    on<ResetFiltersEvent>((event, emit) {
      emit(MentorFilterState(AppData.mentors));
    });

    on<SearchMentorEvent>((event, emit) {
      final query = event.query.trim().toLowerCase();

      if (query.isEmpty) {
        emit(MentorFilterState(allMentors));
        return;
      }

      List<MentorModel> result;


      if (query.length == 1) {
        result = allMentors.where((m) {
          final name = m.name.toLowerCase();
          return name.startsWith(query);
        }).toList();
      }

      else {
        result = allMentors.where((m) {
          final name = m.name.toLowerCase();
          final track = m.track.toLowerCase();
          final skills = m.skills.map((s) => s.toLowerCase()).toList();

          return
            name.contains(query) ||
                track == query ||
                skills.contains(query);
        }).toList();
      }

      emit(MentorFilterState(result));
    });

    on<SortMentorEvent>((event, emit) {
      final sorted = List<MentorModel>.from(state.filteredList);

      switch(event.type) {
        case SortType.priceLowToHigh :
          sorted.sort((a, b) => a.price.compareTo(b.price));
          break;

        case SortType.priceHighToLow :
          sorted.sort((a, b) => b.price.compareTo(a.price));
          break;

        case SortType.nameAZ :
          sorted.sort((a, b) => a.name.compareTo(b.name));
          break;

        case SortType.nameZA :
          sorted.sort((a, b) => b.name.compareTo(a.name));
          break;

        case SortType.rateHigh :
          sorted.sort((a, b) => b.rate.compareTo(a.rate));
          break;
      }

      emit(MentorFilterState(sorted));
    });
  }
}