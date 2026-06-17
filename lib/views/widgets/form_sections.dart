import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../main.dart';
import '../../models/resume_data.dart';

class FormSectionsWidget extends StatefulWidget {
  const FormSectionsWidget({super.key});

  @override
  State<FormSectionsWidget> createState() => _FormSectionsWidgetState();
}

class _FormSectionsWidgetState extends State<FormSectionsWidget> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: resumeProvider,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            PersonalInfoSection(),
            SizedBox(height: 12),
            WorkExperienceSection(),
            SizedBox(height: 12),
            EducationSection(),
            SizedBox(height: 12),
            ProjectsSection(),
            SizedBox(height: 12),
            SkillsSection(),
            SizedBox(height: 12),
            CertificationsSection(),
            SizedBox(height: 12),
            LanguagesSection(),
            SizedBox(height: 12),
            AchievementsSection(),
            SizedBox(height: 12),
            SocialLinksSection(),
            SizedBox(height: 32),
          ],
        );
      },
    );
  }
}

// ==========================================
// PERSONAL INFORMATION SECTION
// ==========================================
class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({super.key});

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  late TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    final info = resumeProvider.resumeData.personalInfo;
    _nameController = TextEditingController(text: info.name);
    _titleController = TextEditingController(text: info.title);
    _emailController = TextEditingController(text: info.email);
    _phoneController = TextEditingController(text: info.phone);
    _locationController = TextEditingController(text: info.location);
    _websiteController = TextEditingController(text: info.website);
    _summaryController = TextEditingController(text: info.summary);

    resumeProvider.addListener(_syncFromProvider);
  }

  void _syncFromProvider() {
    if (!mounted) return;
    final info = resumeProvider.resumeData.personalInfo;
    if (_nameController.text != info.name) _nameController.text = info.name;
    if (_titleController.text != info.title) _titleController.text = info.title;
    if (_emailController.text != info.email) _emailController.text = info.email;
    if (_phoneController.text != info.phone) _phoneController.text = info.phone;
    if (_locationController.text != info.location) _locationController.text = info.location;
    if (_websiteController.text != info.website) _websiteController.text = info.website;
    if (_summaryController.text != info.summary) _summaryController.text = info.summary;
    setState(() {}); // Rebuild image preview
  }

  @override
  void dispose() {
    resumeProvider.removeListener(_syncFromProvider);
    _nameController.dispose();
    _titleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();
        resumeProvider.updatePersonalInfo(photoBytes: bytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final personalInfo = resumeProvider.resumeData.personalInfo;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(Icons.person, color: theme.colorScheme.primary),
        title: const Text(
          'Personal Information',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Image Picker Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      backgroundImage: personalInfo.photoBytes != null
                          ? MemoryImage(personalInfo.photoBytes!)
                          : null,
                      child: personalInfo.photoBytes == null
                          ? Icon(Icons.person, size: 35, color: theme.colorScheme.primary)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                          label: const Text('Upload Photo'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ).copyWith(
                            side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
                              final isHovered = states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed);
                              return BorderSide(
                                color: theme.colorScheme.primary.withValues(alpha: isHovered ? 1.0 : 0.4),
                                width: 1.5,
                              );
                            }),
                            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                              final isDark = theme.brightness == Brightness.dark;
                              if (states.contains(WidgetState.hovered)) {
                                return theme.colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.08);
                              }
                              if (states.contains(WidgetState.pressed)) {
                                return theme.colorScheme.primary.withValues(alpha: isDark ? 0.25 : 0.15);
                              }
                              return Colors.transparent;
                            }),
                            overlayColor: WidgetStateProperty.all(
                              theme.colorScheme.primary.withValues(alpha: 0.05),
                            ),
                          ),
                        ),
                        if (personalInfo.photoBytes != null)
                          TextButton(
                            onPressed: () {
                              resumeProvider.updatePersonalInfo(clearPhoto: true);
                            },
                            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                            child: const Text('Remove Photo'),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(_nameController, 'Full Name', 'e.g. Alex Morgan', (val) => resumeProvider.updatePersonalInfo(name: val)),
                const SizedBox(height: 12),
                _buildTextField(_titleController, 'Professional Title', 'e.g. Lead Flutter Developer', (val) => resumeProvider.updatePersonalInfo(title: val)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_emailController, 'Email Address', 'e.g. alex@example.com', (val) => resumeProvider.updatePersonalInfo(email: val), 1, TextInputType.emailAddress)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(_phoneController, 'Phone Number', 'e.g. +1 (555) 019-2834', (val) => resumeProvider.updatePersonalInfo(phone: val), 1, TextInputType.phone)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_locationController, 'Location', 'e.g. San Francisco, CA', (val) => resumeProvider.updatePersonalInfo(location: val))),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(_websiteController, 'Website / Portfolio', 'e.g. https://alexm.dev', (val) => resumeProvider.updatePersonalInfo(website: val), 1, TextInputType.url)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(_summaryController, 'Professional Summary', 'Write a short intro summarizing your strengths...', (val) => resumeProvider.updatePersonalInfo(summary: val), 4),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// WORK EXPERIENCE SECTION
// ==========================================
class WorkExperienceSection extends StatelessWidget {
  const WorkExperienceSection({super.key});

  void _showWorkDialog(BuildContext context, {int? index, WorkExperience? existingWork}) {
    final companyController = TextEditingController(text: existingWork?.company ?? '');
    final positionController = TextEditingController(text: existingWork?.position ?? '');
    final startController = TextEditingController(text: existingWork?.startDate ?? '');
    final endController = TextEditingController(text: existingWork?.endDate ?? '');
    final descController = TextEditingController(text: existingWork?.description ?? '');
    bool isCurrent = existingWork?.isCurrent ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(index == null ? 'Add Work Experience' : 'Edit Work Experience'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(companyController, 'Company Name', 'e.g. Google'),
                  const SizedBox(height: 12),
                  _buildTextField(positionController, 'Job Position', 'e.g. Software Engineer'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(startController, 'Start Date', 'e.g. Jan 2023')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: isCurrent
                            ? const SizedBox()
                            : _buildTextField(endController, 'End Date', 'e.g. Present'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('I currently work here'),
                    value: isCurrent,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (val) {
                      setDialogState(() {
                        isCurrent = val ?? false;
                        if (isCurrent) {
                          endController.text = 'Present';
                        } else {
                          endController.clear();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(descController, 'Responsibilities & Achievements', 'Bullet points describing details...', null, 4),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final work = WorkExperience(
                  company: companyController.text.trim(),
                  position: positionController.text.trim(),
                  startDate: startController.text.trim(),
                  endDate: isCurrent ? 'Present' : endController.text.trim(),
                  description: descController.text.trim(),
                  isCurrent: isCurrent,
                );
                if (index == null) {
                  resumeProvider.addWorkExperience(work);
                } else {
                  resumeProvider.updateWorkExperience(index, work);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final experiences = resumeProvider.resumeData.workExperience;

    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.work, color: theme.colorScheme.primary),
        title: const Text('Work Experience', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (experiences.isEmpty)
                  _buildEmptyState('No work experiences added yet.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: experiences.length,
                    itemBuilder: (context, index) {
                      final work = experiences[index];
                      return Card(
                        elevation: 0,
                        color: theme.scaffoldBackgroundColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(work.company, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${work.position} • ${work.startDate} - ${work.endDate}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showWorkDialog(context, index: index, existingWork: work),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => resumeProvider.removeWorkExperience(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showWorkDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Work Experience'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// EDUCATION SECTION
// ==========================================
class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  void _showEduDialog(BuildContext context, {int? index, Education? existingEdu}) {
    final schoolController = TextEditingController(text: existingEdu?.school ?? '');
    final degreeController = TextEditingController(text: existingEdu?.degree ?? '');
    final fieldController = TextEditingController(text: existingEdu?.fieldOfStudy ?? '');
    final startController = TextEditingController(text: existingEdu?.startDate ?? '');
    final endController = TextEditingController(text: existingEdu?.endDate ?? '');
    final descController = TextEditingController(text: existingEdu?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Education' : 'Edit Education'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(schoolController, 'School / Institution', 'e.g. Stanford University'),
                const SizedBox(height: 12),
                _buildTextField(degreeController, 'Degree', 'e.g. Master of Science'),
                const SizedBox(height: 12),
                _buildTextField(fieldController, 'Field of Study', 'e.g. Computer Science'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField(startController, 'Start Date', 'e.g. Sep 2018')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(endController, 'End Date', 'e.g. Jun 2020')),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(descController, 'GPA / Description / Honors', 'Honors, GPA, specializations...', null, 3),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final edu = Education(
                school: schoolController.text.trim(),
                degree: degreeController.text.trim(),
                fieldOfStudy: fieldController.text.trim(),
                startDate: startController.text.trim(),
                endDate: endController.text.trim(),
                description: descController.text.trim(),
              );
              if (index == null) {
                resumeProvider.addEducation(edu);
              } else {
                resumeProvider.updateEducation(index, edu);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final education = resumeProvider.resumeData.education;

    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.school, color: theme.colorScheme.primary),
        title: const Text('Education', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (education.isEmpty)
                  _buildEmptyState('No education history added yet.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: education.length,
                    itemBuilder: (context, index) {
                      final edu = education[index];
                      return Card(
                        elevation: 0,
                        color: theme.scaffoldBackgroundColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(edu.school, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${edu.degree} in ${edu.fieldOfStudy} • ${edu.startDate} - ${edu.endDate}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showEduDialog(context, index: index, existingEdu: edu),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => resumeProvider.removeEducation(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showEduDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Education'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PROJECTS SECTION
// ==========================================
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  void _showProjDialog(BuildContext context, {int? index, Project? existingProj}) {
    final nameController = TextEditingController(text: existingProj?.name ?? '');
    final roleController = TextEditingController(text: existingProj?.role ?? '');
    final descController = TextEditingController(text: existingProj?.description ?? '');
    final techController = TextEditingController(text: existingProj?.technologies ?? '');
    final linkController = TextEditingController(text: existingProj?.link ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Project' : 'Edit Project'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Project Name', 'e.g. TaskFlow Planner'),
                const SizedBox(height: 12),
                _buildTextField(roleController, 'Your Role', 'e.g. Lead Flutter Developer'),
                const SizedBox(height: 12),
                _buildTextField(techController, 'Technologies Used', 'e.g. Flutter, Dart, SQLite'),
                const SizedBox(height: 12),
                _buildTextField(linkController, 'Project Link (optional)', 'e.g. https://github.com/my-project'),
                const SizedBox(height: 12),
                _buildTextField(descController, 'Project Description', 'Describe what the project accomplishes...', null, 3),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final proj = Project(
                name: nameController.text.trim(),
                role: roleController.text.trim(),
                description: descController.text.trim(),
                technologies: techController.text.trim(),
                link: linkController.text.trim(),
              );
              if (index == null) {
                resumeProvider.addProject(proj);
              } else {
                resumeProvider.updateProject(index, proj);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projects = resumeProvider.resumeData.projects;

    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.architecture, color: theme.colorScheme.primary),
        title: const Text('Projects', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (projects.isEmpty)
                  _buildEmptyState('No projects added yet.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final proj = projects[index];
                      return Card(
                        elevation: 0,
                        color: theme.scaffoldBackgroundColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(proj.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Role: ${proj.role} • Tech: ${proj.technologies}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showProjDialog(context, index: index, existingProj: proj),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => resumeProvider.removeProject(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showProjDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Project'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// TECHNICAL SKILLS SECTION
// ==========================================
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  void _showSkillDialog(BuildContext context, {int? index, Skill? existingSkill}) {
    final catController = TextEditingController(text: existingSkill?.category ?? '');
    final skillsController = TextEditingController(text: existingSkill?.skills.join(', ') ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Skills Category' : 'Edit Skills Category'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(catController, 'Category Name', 'e.g. Frameworks & SDKs, Databases, Languages'),
                const SizedBox(height: 12),
                _buildTextField(skillsController, 'Skills (comma separated)', 'e.g. Flutter, React, Vue, Angular', null, 2),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final skillList = skillsController.text
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              final skill = Skill(
                category: catController.text.trim(),
                skills: skillList,
              );
              if (index == null) {
                resumeProvider.addSkillCategory(skill);
              } else {
                resumeProvider.updateSkillCategory(index, skill);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skills = resumeProvider.resumeData.skills;

    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.code, color: theme.colorScheme.primary),
        title: const Text('Technical Skills', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (skills.isEmpty)
                  _buildEmptyState('No skills added yet.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: skills.length,
                    itemBuilder: (context, index) {
                      final skill = skills[index];
                      return Card(
                        elevation: 0,
                        color: theme.scaffoldBackgroundColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(skill.category, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: skill.skills.map((s) => Chip(
                              label: Text(s, style: const TextStyle(fontSize: 11)),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            )).toList(),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showSkillDialog(context, index: index, existingSkill: skill),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => resumeProvider.removeSkillCategory(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showSkillDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Skills Category'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// CERTIFICATIONS SECTION
// ==========================================
class CertificationsSection extends StatelessWidget {
  const CertificationsSection({super.key});

  void _showCertDialog(BuildContext context, {int? index, Certification? existingCert}) {
    final nameController = TextEditingController(text: existingCert?.name ?? '');
    final orgController = TextEditingController(text: existingCert?.organization ?? '');
    final dateController = TextEditingController(text: existingCert?.issueDate ?? '');
    final idController = TextEditingController(text: existingCert?.credentialId ?? '');
    final urlController = TextEditingController(text: existingCert?.credentialUrl ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Certification' : 'Edit Certification'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Certification Name', 'e.g. Associate Cloud Engineer'),
                const SizedBox(height: 12),
                _buildTextField(orgController, 'Issuing Organization', 'e.g. Google Cloud'),
                const SizedBox(height: 12),
                _buildTextField(dateController, 'Issue Date', 'e.g. Aug 2024'),
                const SizedBox(height: 12),
                _buildTextField(idController, 'Credential ID (optional)', 'e.g. GCP-ACE-1234'),
                const SizedBox(height: 12),
                _buildTextField(urlController, 'Credential URL (optional)', 'e.g. https://credential.google.com'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final cert = Certification(
                name: nameController.text.trim(),
                organization: orgController.text.trim(),
                issueDate: dateController.text.trim(),
                credentialId: idController.text.trim(),
                credentialUrl: urlController.text.trim(),
              );
              if (index == null) {
                resumeProvider.addCertification(cert);
              } else {
                resumeProvider.updateCertification(index, cert);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final certifications = resumeProvider.resumeData.certifications;

    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.verified_user, color: theme.colorScheme.primary),
        title: const Text('Certifications', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (certifications.isEmpty)
                  _buildEmptyState('No certifications added yet.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: certifications.length,
                    itemBuilder: (context, index) {
                      final cert = certifications[index];
                      return Card(
                        elevation: 0,
                        color: theme.scaffoldBackgroundColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(cert.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${cert.organization} • ${cert.issueDate}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showCertDialog(context, index: index, existingCert: cert),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => resumeProvider.removeCertification(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showCertDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Certification'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// LANGUAGES SECTION
// ==========================================
class LanguagesSection extends StatelessWidget {
  const LanguagesSection({super.key});

  void _showLangDialog(BuildContext context, {int? index, Language? existingLang}) {
    final nameController = TextEditingController(text: existingLang?.name ?? '');
    final profController = TextEditingController(text: existingLang?.proficiency ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Language' : 'Edit Language'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, 'Language Name', 'e.g. English, French, Japanese'),
              const SizedBox(height: 12),
              _buildTextField(profController, 'Proficiency', 'e.g. Native, Fluent, Conversational'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final lang = Language(
                name: nameController.text.trim(),
                proficiency: profController.text.trim(),
              );
              if (index == null) {
                resumeProvider.addLanguage(lang);
              } else {
                resumeProvider.updateLanguage(index, lang);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languages = resumeProvider.resumeData.languages;

    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.translate, color: theme.colorScheme.primary),
        title: const Text('Languages', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (languages.isEmpty)
                  _buildEmptyState('No languages added yet.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      return Card(
                        elevation: 0,
                        color: theme.scaffoldBackgroundColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(lang.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(lang.proficiency),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showLangDialog(context, index: index, existingLang: lang),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => resumeProvider.removeLanguage(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showLangDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Language'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ACHIEVEMENTS SECTION
// ==========================================
class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  void _showAchDialog(BuildContext context, {int? index, Achievement? existingAch}) {
    final titleController = TextEditingController(text: existingAch?.title ?? '');
    final descController = TextEditingController(text: existingAch?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Achievement' : 'Edit Achievement'),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(titleController, 'Achievement Title', 'e.g. Hackathon Winner'),
              const SizedBox(height: 12),
              _buildTextField(descController, 'Achievement Description', 'Short description of the event or achievement...', null, 3),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final ach = Achievement(
                title: titleController.text.trim(),
                description: descController.text.trim(),
              );
              if (index == null) {
                resumeProvider.addAchievement(ach);
              } else {
                resumeProvider.updateAchievement(index, ach);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final achievements = resumeProvider.resumeData.achievements;

    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.emoji_events, color: theme.colorScheme.primary),
        title: const Text('Achievements', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (achievements.isEmpty)
                  _buildEmptyState('No achievements added yet.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: achievements.length,
                    itemBuilder: (context, index) {
                      final ach = achievements[index];
                      return Card(
                        elevation: 0,
                        color: theme.scaffoldBackgroundColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(ach.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(ach.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showAchDialog(context, index: index, existingAch: ach),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => resumeProvider.removeAchievement(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showAchDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Achievement'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// SOCIAL LINKS SECTION
// ==========================================
class SocialLinksSection extends StatelessWidget {
  const SocialLinksSection({super.key});

  void _showSocialDialog(BuildContext context, {int? index, SocialLink? existingSocial}) {
    final platformController = TextEditingController(text: existingSocial?.platform ?? '');
    final urlController = TextEditingController(text: existingSocial?.url ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index == null ? 'Add Social Link' : 'Edit Social Link'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(platformController, 'Platform', 'e.g. GitHub, LinkedIn, Twitter'),
              const SizedBox(height: 12),
              _buildTextField(urlController, 'Profile URL', 'e.g. https://github.com/myusername', null, 1, TextInputType.url),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final social = SocialLink(
                platform: platformController.text.trim(),
                url: urlController.text.trim(),
              );
              if (index == null) {
                resumeProvider.addSocialLink(social);
              } else {
                resumeProvider.updateSocialLink(index, social);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final socials = resumeProvider.resumeData.socialLinks;

    return Card(
      child: ExpansionTile(
        leading: Icon(Icons.link, color: theme.colorScheme.primary),
        title: const Text('Social Links', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (socials.isEmpty)
                  _buildEmptyState('No social links added yet.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: socials.length,
                    itemBuilder: (context, index) {
                      final social = socials[index];
                      return Card(
                        elevation: 0,
                        color: theme.scaffoldBackgroundColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(social.platform, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(social.url),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => _showSocialDialog(context, index: index, existingSocial: social),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                onPressed: () => resumeProvider.removeSocialLink(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _showSocialDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Social Link'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// REUSABLE HELPER UI METHODS
// ==========================================
Widget _buildTextField(
  TextEditingController controller,
  String labelText,
  String hintText, [
  Function(String)? onChanged,
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
]) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    maxLines: maxLines,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      alignLabelWithHint: maxLines > 1,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    ),
  );
}

Widget _buildEmptyState(String message) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      message,
      style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      textAlign: TextAlign.center,
    ),
  );
}
