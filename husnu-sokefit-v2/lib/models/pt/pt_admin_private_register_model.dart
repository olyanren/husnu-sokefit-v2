class PrivateAdminPrivateRegisterModel {
  int id;
  String account;
  int totalDays;
  int availableDays;

  PrivateAdminPrivateRegisterModel(
      {this.id, this.account, this.totalDays, this.availableDays});

  PrivateAdminPrivateRegisterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String?int.parse(json['id']):json['id'];
    account = json['account'];
    totalDays = int.parse(json['total_days']);
    availableDays =json['available_days'] is String? int.parse(json['available_days']):json['available_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['account'] = this.account;
    data['total_days'] = this.totalDays;
    data['available_days'] = this.availableDays;
    return data;
  }
}