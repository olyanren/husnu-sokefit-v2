import 'package:sokefit/models/pt/private_score_model.dart';

class PrivateUserSummaryModel {
  String registerDate;
  int lastDayCount;
  String coach;
  int totalDays;
  int remainingDayCount;
  int cancelledDayCount;
  int availableDayCount;
  int absentDayCount;
  int latestPaidPrice;
  int totalPaidPrice;
  List<PrivateScoreModel> scores;

  PrivateUserSummaryModel(
      {this.registerDate,
        this.lastDayCount,
        this.coach,
        this.totalDays,
        this.remainingDayCount,
        this.cancelledDayCount,
        this.availableDayCount,
        this.absentDayCount,
        this.latestPaidPrice,
        this.totalPaidPrice,
        this.scores});

  PrivateUserSummaryModel.fromJson(Map<String, dynamic> json) {
    registerDate = json['registerDate'];
    lastDayCount = json['lastDayCount'];
    coach = json['coach'];
    totalDays = json['totalDays'];
    remainingDayCount = json['remainingDayCount'];
    cancelledDayCount = json['cancelledDayCount'];
    availableDayCount = json['availableDayCount'];
    absentDayCount = json['absentDayCount'];
    latestPaidPrice = json['latestPaidPrice'];
    totalPaidPrice = json['totalPaidPrice'];
    if (json['scores'] != null) {
      scores = new List<PrivateScoreModel>();
      json['scores'].forEach((v) {
        scores.add(new PrivateScoreModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['registerDate'] = this.registerDate;
    data['lastDayCount'] = this.lastDayCount;
    data['coach'] = this.coach;
    data['totalDays'] = this.totalDays;
    data['remainingDayCount'] = this.remainingDayCount;
    data['cancelledDayCount'] = this.cancelledDayCount;
    data['availableDayCount'] = this.availableDayCount;
    data['absentDayCount'] = this.absentDayCount;
    data['latestPaidPrice'] = this.latestPaidPrice;
    data['totalPaidPrice'] = this.totalPaidPrice;
    if (this.scores != null) {
      data['scores'] = this.scores.map((v) => v.toJson()).toList();
    }
    return data;
  }
}