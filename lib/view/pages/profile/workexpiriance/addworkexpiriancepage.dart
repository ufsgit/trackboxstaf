import 'package:breffini_staff/http/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'workexpiriancemodal.dart';

class AddWorkExperiencePage extends StatefulWidget {
  final WorkExperience? experience; // ✅ NULL = ADD, NOT NULL = EDIT

  const AddWorkExperiencePage({super.key, this.experience});

  @override
  State<AddWorkExperiencePage> createState() => _AddWorkExperiencePageState();
}

class _AddWorkExperiencePageState extends State<AddWorkExperiencePage> {
  final TextEditingController roleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController yearsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  int teacherId = 0;

  @override
  void initState() {
    super.initState();
    _loadTeacherId();

    /// ✏️ PREFILL WHEN EDITING
    if (widget.experience != null) {
      roleController.text = widget.experience!.role;
      companyController.text = widget.experience!.company;
      yearsController.text =
          widget.experience!.duration.replaceAll(" Years", "");
    }
  }

  Future<void> _loadTeacherId() async {
    final prefs = await SharedPreferences.getInstance();
    final idStr = prefs.getString('breffini_teacher_Id');
    teacherId = int.tryParse(idStr ?? '') ?? 0;
  }

  @override
  void dispose() {
    roleController.dispose();
    companyController.dispose();
    yearsController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkExperience() async {
    if (!_formKey.currentState!.validate()) return;

    if (teacherId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Teacher ID missing")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final service = TeacherProfileService();

      if (widget.experience == null) {
        /// ➕ ADD
        await service.saveExperience(
          teacherId: teacherId,
          jobRole: roleController.text.trim(),
          organizationName: companyController.text.trim(),
          yearsOfExperience: double.parse(yearsController.text.trim()),
        );
      } else {
        /// ✏️ EDIT
        await service.editExperience(
          experienceId: widget.experience!.id,
          teacherId: teacherId,
          jobRole: roleController.text.trim(),
          organizationName: companyController.text.trim(),
          yearsOfExperience: double.parse(yearsController.text.trim()),
        );
      }

      /// ✅ RETURN TRUE TO REFRESH LIST
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to save work experience"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.experience == null
              ? "Add Work Experience"
              : "Edit Work Experience",
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: "Job Role"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Enter job role" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: companyController,
                  decoration: const InputDecoration(labelText: "Organization"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Enter organization" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: yearsController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Years of Experience (eg: 5.5)",
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Enter years of experience";
                    }
                    if (double.tryParse(v) == null) {
                      return "Enter valid number";
                    }
                    return null;
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _saveWorkExperience,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
