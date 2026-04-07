class SetAvailableDates {
  final List<Dates> availableDates;

  SetAvailableDates({
    required this.availableDates,
  });

  factory SetAvailableDates.fromJson(Map<String, dynamic> json) {
    return SetAvailableDates(
      availableDates: json['availableDates'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'availableDates': availableDates,
      };
}

class Dates {
  final String date;
  final String from;
  final String to;

  Dates({
    required this.date,
    required this.from,
    required this.to,
  });

  factory Dates.fromJson(Map<String, dynamic> json) {
    return Dates(
      date: json['date'] ?? "",
      from: json['from'] ?? "",
      to: json['to'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'from': from,
        'to': to,
      };
}
