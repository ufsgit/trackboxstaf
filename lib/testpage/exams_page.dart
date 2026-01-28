import 'package:breffini_staff/core/utils/pref_utils.dart';
import 'package:breffini_staff/http/exam_service.dart';
import 'package:breffini_staff/model/exam_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamsScreen extends StatefulWidget {
  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  final ExamService _examService = ExamService();
  List<ExamResultResponse> _examResults = [];
  bool _isLoading = true;
  String? _errorMessage;

  // TODO: Replace this with actual API call to get teacher's students
  // This is a temporary mapping until backend creates the proper API
  // Map teacher IDs to their assigned student IDs
  final Map<String, List<int>> _teacherStudents = {
    "65": [335, 336], // Teacher ID 65's students
    // Add more teacher-student mappings as needed
  };

  @override
  void initState() {
    super.initState();
    _loadExamResults();
  }

  Future<void> _loadExamResults() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get the logged-in teacher's ID
      final teacherId = PrefUtils().getTeacherId();

      if (teacherId == '0' || teacherId.isEmpty) {
        setState(() {
          _errorMessage = "Teacher ID not found. Please login again.";
          _isLoading = false;
        });
        return;
      }

      print("DEBUG: Fetching exam results for teacher ID: $teacherId");

      // Get student IDs for this teacher
      final studentIds = _teacherStudents[teacherId] ?? [];

      if (studentIds.isEmpty) {
        setState(() {
          _errorMessage =
              "No students assigned to teacher ID $teacherId.\nPlease update the teacher-student mapping.";
          _isLoading = false;
        });
        print("DEBUG: No students found for teacher ID: $teacherId");
        return;
      }

      print(
          "DEBUG: Fetching results for ${studentIds.length} students: $studentIds");

      // Fetch exam results for all assigned students
      List<ExamResultResponse> allResults = [];
      for (int studentId in studentIds) {
        try {
          final results = await _examService.getExamResults(studentId);
          allResults.addAll(results);
          print(
              "DEBUG: Fetched ${results.length} results for student $studentId");
        } catch (e) {
          print("DEBUG: Error fetching results for student $studentId: $e");
          // Continue with other students even if one fails
        }
      }

      setState(() {
        _examResults = allResults;
        _isLoading = false;
      });

      print("DEBUG: Loaded ${allResults.length} total exam results");
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load exam results: $e";
        _isLoading = false;
      });
      print("DEBUG: Error loading exam results: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : CustomScrollView(
                  slivers: [
                    _buildAppBar(),
                    SliverToBoxAdapter(child: _buildSummaryHeader()),
                    _examResults.isEmpty
                        ? SliverFillRemaining(child: _buildEmptyState())
                        : SliverPadding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 10.h),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) =>
                                    _buildExamCard(_examResults[index]),
                                childCount: _examResults.length,
                              ),
                            ),
                          ),
                  ],
                ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF2B3674),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 16.w, bottom: 16.h),
        title: Text(
          "Exam Results",
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        background: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2B3674), Color(0xFF4318FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: -30,
              child: CircleAvatar(
                radius: 60.r,
                backgroundColor: Colors.white.withOpacity(0.05),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadExamResults,
        ),
      ],
    );
  }

  Widget _buildSummaryHeader() {
    int total = _examResults.length;
    int passed = _examResults.where((e) => e.isPassed).length;

    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          _buildSummaryItem("Total Exams", total.toString(), Icons.assignment,
              const Color(0xFF4318FF)),
          SizedBox(width: 15.w),
          _buildSummaryItem(
              "Passed", passed.toString(), Icons.check_circle, Colors.green),
          SizedBox(width: 15.w),
          _buildSummaryItem(
              "Pass %",
              total > 0
                  ? "${(passed / total * 100).toStringAsFixed(1)}%"
                  : "0%",
              Icons.trending_up,
              Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20.sp),
            SizedBox(height: 8.h),
            Text(value,
                style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: const Color(0xFF2B3674))),
            Text(title,
                style: GoogleFonts.dmSans(
                    fontSize: 10.sp, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(ExamResultResponse examResult) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showExamDetails(examResult),
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      examResult.studentFullName,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                        color: const Color(0xFF2B3674),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(examResult.isPassed),
                ],
              ),
              SizedBox(height: 12.h),
              _buildInfoRow(Icons.school_outlined, "Course",
                  examResult.courseName ?? "N/A"),
              SizedBox(height: 8.h),
              _buildInfoRow(Icons.assignment_outlined, "Exam",
                  examResult.examName ?? "N/A"),
              SizedBox(height: 8.h),
              _buildInfoRow(Icons.calendar_today_outlined, "Date",
                  examResult.formattedDate),
              SizedBox(height: 16.h),
              const Divider(color: Color(0xFFF4F7FE), height: 1),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Final Score",
                          style: GoogleFonts.dmSans(
                              fontSize: 11.sp, color: Colors.grey[500])),
                      Text(
                          "${examResult.obtainedMark} / ${examResult.totalMark}",
                          style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: const Color(0xFF2B3674))),
                    ],
                  ),
                  _buildScoreProgress(examResult.percentage),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: const Color(0xFFA3AED0)),
        SizedBox(width: 8.w),
        Text("$label: ",
            style: GoogleFonts.dmSans(
                fontSize: 12.sp, color: const Color(0xFFA3AED0))),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.dmSans(
                fontSize: 12.sp,
                color: const Color(0xFF2B3674),
                fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isPassed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isPassed ? const Color(0xFFE6F6EC) : const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        isPassed ? "PASSED" : "FAILED",
        style: GoogleFonts.dmSans(
          fontWeight: FontWeight.bold,
          fontSize: 10.sp,
          color: isPassed ? const Color(0xFF039855) : const Color(0xFFD92D20),
        ),
      ),
    );
  }

  Widget _buildScoreProgress(double percentage) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 45.r,
          height: 45.r,
          child: CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 4,
            backgroundColor: const Color(0xFFF4F7FE),
            color: percentage >= 50 ? Colors.green : Colors.red,
          ),
        ),
        Text(
          "${percentage.toInt()}%",
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
            fontSize: 11.sp,
            color: const Color(0xFF2B3674),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10)),
              ],
            ),
            child: Icon(Icons.assignment_outlined,
                size: 70.sp, color: const Color(0xFFA3AED0)),
          ),
          SizedBox(height: 24.h),
          Text(
            "No exam results yet",
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                color: const Color(0xFF2B3674)),
          ),
          SizedBox(height: 8.h),
          Text(
            "Start by assigning exams to your students.",
            style: GoogleFonts.dmSans(fontSize: 14.sp, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _loadExamResults,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4318FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text("Refresh List",
                style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              "Something went wrong",
              style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              _errorMessage!,
              style:
                  GoogleFonts.dmSans(fontSize: 14.sp, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _loadExamResults,
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B3674),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExamDetails(ExamResultResponse examResult) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        backgroundColor: Colors.white,
        title: Text(
          "Detailed Report",
          style: GoogleFonts.dmSans(
              fontWeight: FontWeight.bold, color: const Color(0xFF2B3674)),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                  Icons.person_outline, "Student", examResult.studentFullName),
              if (examResult.courseName != null)
                _buildDetailItem(
                    Icons.school_outlined, "Course", examResult.courseName!),
              if (examResult.examName != null)
                _buildDetailItem(
                    Icons.assignment_outlined, "Exam", examResult.examName!),
              _buildDetailItem(Icons.calendar_today_outlined, "Date",
                  examResult.formattedDate),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FE),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    _buildScoreRow("Total Marks", examResult.totalMark),
                    SizedBox(height: 10.h),
                    _buildScoreRow("Pass Marks", examResult.passMark),
                    SizedBox(height: 10.h),
                    _buildScoreRow("Obtained", examResult.obtainedMark,
                        isHighlight: true),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Colors.white, thickness: 2),
                    ),
                    _buildScoreRow(
                        "Result", examResult.isPassed ? "PASSED" : "FAILED",
                        color: examResult.isPassed ? Colors.green : Colors.red),
                  ],
                ),
              ),
              if (examResult.message.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Text(
                    examResult.message,
                    style: GoogleFonts.dmSans(
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close",
                style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4318FF))),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: const Color(0xFFA3AED0)),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.dmSans(
                      fontSize: 10.sp, color: const Color(0xFFA3AED0))),
              Text(value,
                  style: GoogleFonts.dmSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B3674))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, String value,
      {bool isHighlight = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 13.sp, color: const Color(0xFF2B3674))),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: isHighlight ? 16.sp : 14.sp,
            fontWeight: FontWeight.bold,
            color: color ?? const Color(0xFF4318FF),
          ),
        ),
      ],
    );
  }
}
