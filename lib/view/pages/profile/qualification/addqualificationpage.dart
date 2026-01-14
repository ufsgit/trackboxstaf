import 'package:breffini_staff/http/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'qualificationmodal.dart';

class AddQualificationPage extends StatefulWidget {
  final Qualification? qualification; // null = add, not null = edit

  const AddQualificationPage({super.key, this.qualification});

  @override
  State<AddQualificationPage> createState() => _AddQualificationPageState();
}

class _AddQualificationPageState extends State<AddQualificationPage> {
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  int teacherId = 0;

  /// Full selected date
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadTeacherId();

    /// PREFILL FOR EDIT
    if (widget.qualification != null) {
      degreeController.text = widget.qualification!.degree;
      instituteController.text = widget.qualification!.institute;
      yearController.text = widget.qualification!.year;
      selectedDate = DateTime(int.parse(widget.qualification!.year), 1, 1);
    }
  }

  Future<void> _loadTeacherId() async {
    final prefs = await SharedPreferences.getInstance();
    teacherId = int.tryParse(prefs.getString('breffini_teacher_Id') ?? '') ?? 0;
  }

  /// ================= YEAR → DATE PICKER =================
  void _showYearPicker() {
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: YearPicker(
              firstDate: DateTime(1980),
              lastDate: DateTime.now(),
              selectedDate: selectedDate ?? DateTime.now(),
              onChanged: (yearDate) async {
                Navigator.pop(context);

                /// After year → open date picker
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(yearDate.year, 1, 1),
                  firstDate: DateTime(yearDate.year, 1, 1),
                  lastDate: DateTime(yearDate.year, 12, 31),
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                    yearController.text = pickedDate.year.toString();
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveQualification() async {
    if (!_formKey.currentState!.validate()) return;

    if (teacherId == 0 || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid data")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final service = TeacherProfileService();

      final passoutDate =
          "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

      if (widget.qualification == null) {
        /// ADD
        await service.saveQualification(
          teacherId: teacherId,
          courseName: degreeController.text.trim(),
          institutionName: instituteController.text.trim(),
          passoutDate: passoutDate,
        );
      } else {
        /// EDIT
        await service.editQualification(
          qualificationId: widget.qualification!.id,
          teacherId: teacherId,
          courseName: degreeController.text.trim(),
          institutionName: instituteController.text.trim(),
          passoutDate: passoutDate,
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to save qualification"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    degreeController.dispose();
    instituteController.dispose();
    yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.qualification == null
              ? "Add Qualification"
              : "Edit Qualification",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: degreeController,
                decoration: const InputDecoration(labelText: "Degree"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter degree" : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: instituteController,
                decoration: const InputDecoration(labelText: "Institute"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter institute" : null,
              ),

              const SizedBox(height: 12),

              /// SINGLE CALENDAR FIELD
              TextFormField(
                controller: yearController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Passout Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) => v == null || v.isEmpty ? "Select date" : null,
                onTap: _showYearPicker,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _saveQualification,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
