class PrivateAdminSummaryModel {
  int latestDayCount;
  String latestUserFullName;
  int totalPaidPrice;
  String totalCourseCount;
  int completedCourseCount;
  int remainingCourseCount;

  PrivateAdminSummaryModel(
      {this.latestDayCount,
        this.latestUserFullName,
        this.totalPaidPrice,
        this.totalCourseCount,
        this.completedCourseCount,
        this.remainingCourseCount});

  PrivateAdminSummaryModel.fromJson(Map<String, dynamic> json) {
    latestDayCount = json['latest_day_count'];
    latestUserFullName = json['latest_user_full_name'];
    totalPaidPrice = json['total_paid_price'];
    totalCourseCount = json['total_course_count'];
    completedCourseCount = json['completed_course_count'];
    remainingCourseCount = json['remaining_course_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latest_day_count'] = this.latestDayCount;
    data['latest_user_full_name'] = this.latestUserFullName;
    data['total_paid_price'] = this.totalPaidPrice;
    data['total_course_count'] = this.totalCourseCount;
    data['completed_course_count'] = this.completedCourseCount;
    data['remaining_course_count'] = this.remainingCourseCount;
    return data;
  }
}