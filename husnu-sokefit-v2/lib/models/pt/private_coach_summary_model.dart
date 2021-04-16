class PrivateCoachSummaryModel {
  String latestRegisterDate;
  int latestDayCount;
  String latestUserFullName;
  int totalDays;
  int latestPaidPrice;
  int totalPaidPrice;
  String totalCourseCount;
  int completedCourseCount;
  int remainingCourseCount;

  PrivateCoachSummaryModel(
      {this.latestRegisterDate,
        this.latestDayCount,
        this.latestUserFullName,
        this.totalDays,
        this.latestPaidPrice,
        this.totalPaidPrice,
        this.totalCourseCount,
        this.completedCourseCount,
        this.remainingCourseCount});

  PrivateCoachSummaryModel.fromJson(Map<String, dynamic> json) {
    latestRegisterDate = json['latest_register_date'];
    latestDayCount = json['latest_day_count'];
    latestUserFullName = json['latest_user_full_name'];
    totalDays = json['total_days'];
    latestPaidPrice = json['latest_paid_price'];
    totalPaidPrice = json['total_paid_price'];
    totalCourseCount =  json['total_course_count'].toString();
    completedCourseCount = json['completed_course_count'];
    remainingCourseCount = json['remaining_course_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latest_register_date'] = this.latestRegisterDate;
    data['latest_day_count'] = this.latestDayCount;
    data['latest_user_full_name'] = this.latestUserFullName;
    data['total_days'] = this.totalDays;
    data['latest_paid_price'] = this.latestPaidPrice;
    data['total_paid_price'] = this.totalPaidPrice;
    data['total_course_count'] = this.totalCourseCount;
    data['completed_course_count'] = this.completedCourseCount;
    data['remaining_course_count'] = this.remainingCourseCount;
    return data;
  }
}