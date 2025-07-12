import 'package:hive/hive.dart';

part 'user_status.g.dart';

@HiveType(typeId: 10)
class UserStatus extends HiveObject {
  @HiveField(0)
  String userHash;

  @HiveField(1)
  bool hasTrialStarted;

  @HiveField(2)
  DateTime? trialStartDate;

  @HiveField(3)
  DateTime? trialEndDate;

  @HiveField(4)
  bool hasPurchased;

  @HiveField(5)
  String? purchaseToken;

  @HiveField(6)
  DateTime? purchaseDate;

  @HiveField(7)
  DateTime lastUpdated;

  @HiveField(8)
  bool isPromoUser;

  @HiveField(9)
  String? promoCode;

  UserStatus({
    required this.userHash,
    this.hasTrialStarted = false,
    this.trialStartDate,
    this.trialEndDate,
    this.hasPurchased = false,
    this.purchaseToken,
    this.purchaseDate,
    required this.lastUpdated,
    this.isPromoUser = false,
    this.promoCode,
  });

  // check trial actif
  bool get isTrialActive {
    if (!hasTrialStarted || hasPurchased || isPromoUser) return false;
    if (trialEndDate == null) return false;
    return DateTime.now().isBefore(trialEndDate!);
  }

  // check trial expired
  bool get isTrialExpired {
    if (!hasTrialStarted || hasPurchased || isPromoUser) return false;
    if (trialEndDate == null) return false;
    return DateTime.now().isAfter(trialEndDate!);
  }

  // check if user has access (purchased, promo, active trial)
  bool get hasAccess {
    return hasPurchased || isPromoUser || isTrialActive;
  }

  // check days remaining in trial
  int get daysRemainingInTrial {
    if (!isTrialActive) return 0;
    final now = DateTime.now();
    final difference = trialEndDate!.difference(now);
    return difference.inDays + (difference.inHours % 24 > 0 ? 1 : 0);
  }

  void touch() {
    lastUpdated = DateTime.now();
  }

  UserStatus copyWith({
    String? userHash,
    bool? hasTrialStarted,
    DateTime? trialStartDate,
    DateTime? trialEndDate,
    bool? hasPurchased,
    String? purchaseToken,
    DateTime? purchaseDate,
    DateTime? lastUpdated,
    bool? isPromoUser,
    String? promoCode,
  }) {
    return UserStatus(
      userHash: userHash ?? this.userHash,
      hasTrialStarted: hasTrialStarted ?? this.hasTrialStarted,
      trialStartDate: trialStartDate ?? this.trialStartDate,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      hasPurchased: hasPurchased ?? this.hasPurchased,
      purchaseToken: purchaseToken ?? this.purchaseToken,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isPromoUser: isPromoUser ?? this.isPromoUser,
      promoCode: promoCode ?? this.promoCode,
    );
  }
}
