class UpdateUser {
  final String id;
  final String name;
  final String email;
  final bool isActive;
  final bool confirmEmail;
  final String? activationCode;
  final String? activationCodeExpires;
  final String password;
  final int rate;
  final String role;
  final int freeHours;
  final int helpTotalHours;
  final int totalScore;
  final UserImage userImage;
  final Profile profile;
  final BlockInfo blockInfo;
  final List<SkillModel> skills;
  final List<dynamic> challenges;
  final List<dynamic> messages;
  final List<dynamic> reports;
  final List<dynamic> requests;
  final List<dynamic> feedbackGiven;
  final List<dynamic> feedbackReceived;
  final List<dynamic> mentorSuggestions;
  final String? forgetCode;
  final int warningCount;
  final List<dynamic> warnings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String track;

  UpdateUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
    required this.confirmEmail,
    this.activationCode,
    this.activationCodeExpires,
    required this.password,
    required this.rate,
    required this.role,
    required this.freeHours,
    required this.helpTotalHours,
    required this.totalScore,
    required this.userImage,
    required this.profile,
    required this.blockInfo,
    required this.skills,
    required this.challenges,
    required this.messages,
    required this.reports,
    required this.requests,
    required this.feedbackGiven,
    required this.feedbackReceived,
    required this.mentorSuggestions,
    this.forgetCode,
    required this.warningCount,
    required this.warnings,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.track,
  });

  factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(
        id: json['_id'],
        name: json['name'],
        email: json['email'],
        isActive: json['isActive'],
        confirmEmail: json['confirmEmail'],
        activationCode: json['activationCode'],
        activationCodeExpires: json['activationCodeExpires'],
        password: json['password'],
        rate: json['rate'],
        role: json['role'],
        freeHours: json['freeHours'],
        helpTotalHours: json['helpTotalHours'],
        totalScore: json['totalScore'],
        userImage: UserImage.fromJson(json['userImage']),
        profile: Profile.fromJson(json['profile']),
        blockInfo: BlockInfo.fromJson(json['blockInfo']),
        skills: List<SkillModel>.from(
            json['skills'].map((x) => SkillModel.fromJson(x))),
        challenges: json['challenges'] ?? [],
        messages: json['messages'] ?? [],
        reports: json['reports'] ?? [],
        requests: json['requests'] ?? [],
        feedbackGiven: json['feedbackGiven'] ?? [],
        feedbackReceived: json['feedbackReceived'] ?? [],
        mentorSuggestions: json['mentorSuggestions'] ?? [],
        forgetCode: json['forgetCode'],
        warningCount: json['warningCount'],
        warnings: json['warnings'] ?? [],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        v: json['__v'],
        track: json['track'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'isActive': isActive,
        'confirmEmail': confirmEmail,
        'activationCode': activationCode,
        'activationCodeExpires': activationCodeExpires,
        'password': password,
        'rate': rate,
        'role': role,
        'freeHours': freeHours,
        'helpTotalHours': helpTotalHours,
        'totalScore': totalScore,
        'userImage': userImage.toJson(),
        'profile': profile.toJson(),
        'blockInfo': blockInfo.toJson(),
        'skills': skills.map((x) => x.toJson()).toList(),
        'challenges': challenges,
        'messages': messages,
        'reports': reports,
        'requests': requests,
        'feedbackGiven': feedbackGiven,
        'feedbackReceived': feedbackReceived,
        'mentorSuggestions': mentorSuggestions,
        'forgetCode': forgetCode,
        'warningCount': warningCount,
        'warnings': warnings,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        '__v': v,
        'track': track,
      };
}

class UserImage {
  final String secureUrl;
  final String publicId;

  UserImage({required this.secureUrl, required this.publicId});

  factory UserImage.fromJson(Map<String, dynamic> json) => UserImage(
        secureUrl: json['secure_url'],
        publicId: json['public_id'],
      );

  Map<String, dynamic> toJson() => {
        'secure_url': secureUrl,
        'public_id': publicId,
      };
}

class Profile {
  final String bio;
  final String skillSummary;
  final int reputationScore;
  final String lastUpdated;

  Profile({
    required this.bio,
    required this.skillSummary,
    required this.reputationScore,
    required this.lastUpdated,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        bio: json['bio'],
        skillSummary: json['skillSummary'],
        reputationScore: json['reputationScore'],
        lastUpdated: (json['lastUpdated']),
      );

  Map<String, dynamic> toJson() => {
        'bio': bio,
        'skillSummary': skillSummary,
        'reputationScore': reputationScore,
        'lastUpdated': lastUpdated,
      };
}

class BlockInfo {
  final bool isBlocked;
  final String? blockedUntil;
  final String blockReason;

  BlockInfo(
      {required this.isBlocked, this.blockedUntil, required this.blockReason});

  factory BlockInfo.fromJson(Map<String, dynamic> json) => BlockInfo(
        isBlocked: json['isBlocked'],
        blockedUntil: json['blockedUntil'],
        blockReason: json['blockReason'],
      );

  Map<String, dynamic> toJson() => {
        'isBlocked': isBlocked,
        'blockedUntil': blockedUntil,
        'blockReason': blockReason,
      };
}

class SkillModel {
  final String skillName;
  final bool isVerified;
  final int quizScore;
  final String id;
  final DateTime addedAt;

  SkillModel(
      {required this.skillName,
      required this.isVerified,
      required this.quizScore,
      required this.id,
      required this.addedAt});

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
        skillName: json['skillName'],
        isVerified: json['isVerified'],
        quizScore: json['quizScore'],
        id: json['_id'],
        addedAt: DateTime.parse(json['addedAt']),
      );

  Map<String, dynamic> toJson() => {
        'skillName': skillName,
        'isVerified': isVerified,
        'quizScore': quizScore,
        '_id': id,
        'addedAt': addedAt.toIso8601String(),
      };
}
