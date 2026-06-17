import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/resume_data.dart';

class ResumePreviewWidget extends StatelessWidget {
  const ResumePreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: resumeProvider,
      builder: (context, _) {
        final data = resumeProvider.resumeData;

        return Container(
          color: isDark ? const Color(0xFF141416) : const Color(0xFFF1F1F4),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final parentWidth = constraints.maxWidth;
              // Reserve padding for preview edges
              final double availableWidth = parentWidth - 32.0;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SizedBox(
                    width: availableWidth < 800 ? availableWidth : 800,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 800, // Fixed logical width to ensure identical aspect ratios and wrapping
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Theme(
                            // Force a light theme context on the resume paper for printing fidelity
                            data: ThemeData.light(useMaterial3: true).copyWith(
                              colorScheme: ColorScheme.fromSeed(
                                seedColor: const Color(0xFFFF6B00),
                                primary: const Color(0xFFFF6B00),
                              ),
                            ),
                            child: Builder(
                              builder: (paperContext) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header
                                    _buildHeader(paperContext, data),
                                    const SizedBox(height: 20),

                                    // Summary
                                    if (data.personalInfo.summary.isNotEmpty) ...[
                                      _buildSectionTitle(paperContext, 'Professional Summary'),
                                      Text(
                                        data.personalInfo.summary,
                                        style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF2D3748)),
                                      ),
                                      const SizedBox(height: 16),
                                    ],

                                    // Work Experience
                                    if (data.workExperience.isNotEmpty) ...[
                                      _buildSectionTitle(paperContext, 'Work Experience'),
                                      ...data.workExperience.map((work) => _buildWorkItem(paperContext, work)),
                                      const SizedBox(height: 12),
                                    ],

                                    // Education
                                    if (data.education.isNotEmpty) ...[
                                      _buildSectionTitle(paperContext, 'Education'),
                                      ...data.education.map((edu) => _buildEducationItem(paperContext, edu)),
                                      const SizedBox(height: 12),
                                    ],

                                    // Projects
                                    if (data.projects.isNotEmpty) ...[
                                      _buildSectionTitle(paperContext, 'Projects'),
                                      ...data.projects.map((proj) => _buildProjectItem(paperContext, proj)),
                                      const SizedBox(height: 12),
                                    ],

                                    // Skills
                                    if (data.skills.isNotEmpty) ...[
                                      _buildSectionTitle(paperContext, 'Technical Skills'),
                                      ...data.skills.map((skill) => _buildSkillsItem(paperContext, skill)),
                                      const SizedBox(height: 12),
                                    ],

                                    // Grid columns for certifications, languages, achievements, socials
                                    _buildGridSections(paperContext, data),
                                  ],
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ResumeData data) {
    final theme = Theme.of(context);
    final hasPhoto = data.personalInfo.photoBytes != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5ED), // Light orange tint
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasPhoto) ...[
            Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.memory(
                data.personalInfo.photoBytes!,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 20),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.personalInfo.name.isNotEmpty ? data.personalInfo.name : 'YOUR NAME',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  data.personalInfo.title.isNotEmpty ? data.personalInfo.title : 'Professional Title',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    if (data.personalInfo.email.isNotEmpty)
                      _buildHeaderContactItem(Icons.email, data.personalInfo.email),
                    if (data.personalInfo.phone.isNotEmpty)
                      _buildHeaderContactItem(Icons.phone, data.personalInfo.phone),
                    if (data.personalInfo.location.isNotEmpty)
                      _buildHeaderContactItem(Icons.location_on, data.personalInfo.location),
                    if (data.personalInfo.website.isNotEmpty)
                      _buildHeaderContactItem(Icons.language, data.personalInfo.website),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderContactItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF718096)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: Color(0xFF4A5568)),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildWorkItem(BuildContext context, WorkExperience work) {
    final theme = Theme.of(context);
    final dateStr = '${work.startDate} - ${work.isCurrent ? "Present" : work.endDate}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                work.company.isNotEmpty ? work.company : 'Company Name',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A202C)),
              ),
              Text(
                dateStr,
                style: const TextStyle(fontSize: 12, color: Color(0xFF718096), fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            work.position.isNotEmpty ? work.position : 'Job Position',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: theme.colorScheme.primary),
          ),
          if (work.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              work.description,
              style: const TextStyle(fontSize: 12, height: 1.3, color: Color(0xFF4A5568)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEducationItem(BuildContext context, Education edu) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                edu.school.isNotEmpty ? edu.school : 'Institution Name',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A202C)),
              ),
              Text(
                '${edu.startDate} - ${edu.endDate}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF718096), fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${edu.degree} in ${edu.fieldOfStudy}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: theme.colorScheme.primary),
          ),
          if (edu.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              edu.description,
              style: const TextStyle(fontSize: 12, height: 1.3, color: Color(0xFF4A5568)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProjectItem(BuildContext context, Project proj) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                proj.name.isNotEmpty ? proj.name : 'Project Name',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A202C)),
              ),
              if (proj.link.isNotEmpty)
                Text(
                  proj.link,
                  style: TextStyle(fontSize: 11, color: theme.colorScheme.primary, decoration: TextDecoration.underline),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Role: ${proj.role.isNotEmpty ? proj.role : "Developer"} | Tech: ${proj.technologies}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF718096), fontStyle: FontStyle.italic),
          ),
          if (proj.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              proj.description,
              style: const TextStyle(fontSize: 12, height: 1.3, color: Color(0xFF4A5568)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillsItem(BuildContext context, Skill skill) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '${skill.category}:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: theme.colorScheme.primary),
            ),
          ),
          Expanded(
            child: Text(
              skill.skills.join(', '),
              style: const TextStyle(fontSize: 12, color: Color(0xFF2D3748)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridSections(BuildContext context, ResumeData data) {
    final hasCerts = data.certifications.isNotEmpty;
    final hasLangs = data.languages.isNotEmpty;
    final hasAchs = data.achievements.isNotEmpty;
    final hasSocials = data.socialLinks.isNotEmpty;

    if (!hasCerts && !hasLangs && !hasAchs && !hasSocials) {
      return const SizedBox();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Col 1
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasCerts) ...[
                _buildSectionTitle(context, 'Certifications'),
                ...data.certifications.map((cert) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cert.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1A202C)),
                      ),
                      Text(
                        '${cert.organization} | ${cert.issueDate}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF718096)),
                      ),
                      if (cert.credentialId.isNotEmpty)
                        Text(
                          'ID: ${cert.credentialId}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF718096)),
                        ),
                    ],
                  ),
                )),
              ],
              if (hasSocials) ...[
                _buildSectionTitle(context, 'Social Links'),
                ...data.socialLinks.map((social) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Text(
                        '${social.platform}: ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Theme.of(context).colorScheme.primary),
                      ),
                      Expanded(
                        child: Text(
                          social.url,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF4A5568)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Col 2
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasLangs) ...[
                _buildSectionTitle(context, 'Languages'),
                ...data.languages.map((lang) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1A202C)),
                      ),
                      Text(
                        lang.proficiency,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF718096), fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                )),
              ],
              if (hasAchs) ...[
                _buildSectionTitle(context, 'Achievements'),
                ...data.achievements.map((ach) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ach.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1A202C)),
                      ),
                      if (ach.description.isNotEmpty)
                        Text(
                          ach.description,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF718096)),
                        ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
