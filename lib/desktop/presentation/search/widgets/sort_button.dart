import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

<<<<<<< HEAD
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
=======
import '../../../../shared/bloc/mentor_filter_bloc/mentor_filter_bloc.dart';
import '../../../../shared/bloc/mentor_filter_bloc/mentor_filter_event.dart';
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1

class SortButton extends StatefulWidget {
  const SortButton({super.key});

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  String? selected;
<<<<<<< HEAD

=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
  final items = [
    'Price: high to low',
    'Price: low to high',
    'Name: A to Z',
    'Name: Z to A',
    'Rate: high to low'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

<<<<<<< HEAD
    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.only(right: width * 0.03),
          ),
          value: selected,
          hint: Text(
            'sort'.tr,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
          style: Theme.of(context).textTheme.bodyMedium,
          isExpanded: true,
          items: items
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(
                      option,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          dropdownStyleData: DropdownStyleData(
            offset: const Offset(0, -5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            maxHeight: width * 0.7,
          ),
          iconStyleData: IconStyleData(
            icon: selected == null
                ? const Icon(Icons.keyboard_arrow_down_outlined)
                : const SizedBox(),
          ),
          onChanged: (value) {
            if (value == null) return;

            setState(() => selected = value);

            final bloc = context.read<UserFilterBloc>();

            switch (value) {
              case 'Price: high to low':
                bloc.add(SortUserEvent(SortType.priceLowToHigh));
                break;
              case 'Price: low to high':
                bloc.add(SortUserEvent(SortType.priceLowToHigh));
                break;
              case 'Name: A to Z':
                bloc.add(SortUserEvent(SortType.nameAZ));
                break;
              case 'Name: Z to A':
                bloc.add(SortUserEvent(SortType.nameZA));
                break;
              case 'Rate: high to low':
                bloc.add(SortUserEvent(SortType.rateHigh));
                break;
            }
          },
=======
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380), // زي Search
        child: Container(
          height: 48, // طول TextField قياسي Desktop
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.zero,
              ),
              value: selected,
              hint: Text(
                'sort'.tr,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              isExpanded: true,
              items: items
                  .map((option) => DropdownMenuItem(
                value: option,
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
                  .toList(),
              dropdownStyleData: const DropdownStyleData(
                offset: Offset(0, -5),
                maxHeight: 300,
              ),
              iconStyleData: IconStyleData(
                icon: selected == null
                    ? const Icon(Icons.keyboard_arrow_down_outlined, size: 16)
                    : const SizedBox(),
              ),
              onChanged: (value) {
                if (value == null) return;
                setState(() => selected = value);
                final bloc = context.read<MentorFilterBloc>();
                switch (value) {
                  case 'Price: high to low':
                    bloc.add(SortMentorEvent(SortType.priceHighToLow));
                    break;
                  case 'Price: low to high':
                    bloc.add(SortMentorEvent(SortType.priceLowToHigh));
                    break;
                  case 'Name: A to Z':
                    bloc.add(SortMentorEvent(SortType.nameAZ));
                    break;
                  case 'Name: Z to A':
                    bloc.add(SortMentorEvent(SortType.nameZA));
                    break;
                  case 'Rate: high to low':
                    bloc.add(SortMentorEvent(SortType.rateHigh));
                    break;
                }
              },
            ),
          ),
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        ),
      ),
    );
  }
}
<<<<<<< HEAD
=======

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
