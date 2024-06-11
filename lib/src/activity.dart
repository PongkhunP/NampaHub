
class Activity {
  String? title;
  String? description;
  List<String>? goals;
  String? contactEmail;
  String? activityType;
  DateTime? startRegisDate;
  DateTime? endRegisDate;
  DateTime? eventDate;
  String? activityImage;
  String? eventLocation;
  String? meetLocation;
  double? maxDonation;
  int? participants;
  double? attendFee;
  double? budget;
  List<ActivityReward>? rewards;
  List<ActivityExpense>? expenses;

  Activity({
    this.title,
    this.description,
    this.goals,
    this.contactEmail,
    this.activityType,
    this.startRegisDate,
    this.endRegisDate,
    this.eventDate,
    this.activityImage,
    this.eventLocation,
    this.meetLocation,
    this.maxDonation,
    this.participants,
    this.attendFee,
    this.budget,
    this.rewards,
    this.expenses,
  });

  void setTitle(String title) => this.title = title;
  void setDescription(String description) => this.description = description;
  void setGoals(List<String> goals) => this.goals = goals;
  void setContactEmail(String contactEmail) => this.contactEmail = contactEmail;
  void setStartRegisDate(DateTime startRegisDate) =>
      this.startRegisDate = startRegisDate;
  void setEndRegisDate(DateTime endRegisDate) =>
      this.endRegisDate = endRegisDate;
  void setEventDate(DateTime eventDate) => this.eventDate = eventDate;
  void setActivityImage(String activityImage) =>
      this.activityImage = activityImage;
  void setEventLocation(String eventLocation) =>
      this.eventLocation = eventLocation;
  void setMeetLocation(String meetLocation) => this.meetLocation = meetLocation;
  void setMaxDonation(double maxDonation) => this.maxDonation = maxDonation;
  void setParticipants(int participants) => this.participants = participants;
  void setAttendFee(double attendFee) => this.attendFee = attendFee;
  void setBudget(double budget) => this.budget = budget;
  void setRewards(List<ActivityReward> rewards) => this.rewards = rewards;
  void setExpenses(List<ActivityExpense> expenses) => this.expenses = expenses;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'goals': goals,
      'contact_email': contactEmail,
      'start_regis_date': startRegisDate?.toIso8601String(),
      'end_regis_date': endRegisDate?.toIso8601String(),
      'event_date': eventDate?.toIso8601String(),
      'activity_image': activityImage,
      'event_location': eventLocation,
      'meet_location': meetLocation,
      'max_donation': maxDonation,
      'participants': participants,
      'attend_fee': attendFee,
      'budget': budget,
      'rewards': rewards?.map((reward) => reward.toJson()).toList(),
      'expenses': expenses?.map((expense) => expense.toJson()).toList(),
    };
  }

  void printDetails() {
    print('Title: $title');
    print('Description: $description');
    print('Goals: ${goals?.join(", ")}');
    print('Contact Email: $contactEmail');
    print('Start Registration Date: $startRegisDate');
    print('End Registration Date: $endRegisDate');
    print('Event Date: $eventDate');
    print('Activity Image: $activityImage');
    print('Event Location: $eventLocation');
    print('Meet Location: $meetLocation');
    print('Max Donation: $maxDonation');
    print('Participants: $participants');
    print('Attend Fee: $attendFee');
    print('Budget: $budget');
    print('Rewards:');
    rewards?.forEach((reward) => reward.printDetails());
    print('Expenses:');
    expenses?.forEach((expense) => expense.printDetails());
  }
}

class ActivityReward {
  String? name;
  String? rewardImage;
  String? description;

  ActivityReward({
    this.name,
    this.rewardImage,
    this.description,
  });

  void setName(String name) => this.name = name;
  void setRewardImage(String rewardImage) => this.rewardImage = rewardImage;
  void setDescription(String description) => this.description = description;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'reward_image': rewardImage,
      'description': description,
    };
  }

  void printDetails() {
    print('Reward Name: $name');
    print('Reward Image: $rewardImage');
    print('Description: $description');
  }
}

class ActivityExpense {
  String? name;
  String? expense;

  ActivityExpense({
    this.name,
    this.expense,
  });

  void setName(String name) => this.name = name;
  void setExpense(String expense) => this.expense = expense;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'expense': expense,
    };
  }

  void printDetails() {
    print('Expense Name: $name');
    print('Expense: $expense');
  }
}
