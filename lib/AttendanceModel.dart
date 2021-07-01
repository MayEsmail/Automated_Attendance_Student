class AttendanceModel {
  final String course;
  final int percentage;

  AttendanceModel({
    required this.course,
    required this.percentage,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      course: json['title'],
      percentage: json['id'],
    );
  }
}
