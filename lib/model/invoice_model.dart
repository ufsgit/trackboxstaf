class Invoicemodel {
  int invoiceId;
  DateTime invoiceDate;
  String name;
  String position;
  String courseName;
  String paymentPeriod;
  String classHours;
  String totalAmount;
  String approvedBy;
  int userId;
  int courseId;

  Invoicemodel({
    required this.invoiceId,
    required this.invoiceDate,
    required this.name,
    required this.position,
    required this.courseName,
    required this.paymentPeriod,
    required this.classHours,
    required this.totalAmount,
    required this.approvedBy,
    required this.userId,
    required this.courseId,
  });

  factory Invoicemodel.fromJson(Map<String, dynamic> json) => Invoicemodel(
        invoiceId: json["Invoice_Id"],
        invoiceDate: DateTime.parse(json["invoice_date"]),
        name: json["name"],
        position: json["position"],
        courseName: json["course_name"],
        paymentPeriod: json["payment_period"],
        classHours: json["class_hours"],
        totalAmount: json["total_amount"],
        approvedBy: json["approved_by"],
        userId: json["user_Id"],
        courseId: json["Course_Id"],
      );

  Map<String, dynamic> toJson() => {
        "Invoice_Id": invoiceId,
        "invoice_date":
            "${invoiceDate.year.toString().padLeft(4, '0')}-${invoiceDate.month.toString().padLeft(2, '0')}-${invoiceDate.day.toString().padLeft(2, '0')}",
        "name": name,
        "position": position,
        "course_name": courseName,
        "payment_period": paymentPeriod,
        "class_hours": classHours,
        "total_amount": totalAmount,
        "approved_by": approvedBy,
        "user_Id": userId,
        "Course_Id": courseId,
      };
}
