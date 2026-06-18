import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume_data.dart';

class PdfGenerator {
  static final PdfColor primaryColor = PdfColor.fromHex('#FF6B00');
  static final PdfColor darkColor = PdfColor.fromHex('#1A1A1A');
  static final PdfColor greyColor = PdfColor.fromHex('#555555');
  static final PdfColor lightGreyColor = PdfColor.fromHex('#F5F5F5');
  static final PdfColor orangeTint = PdfColor.fromHex('#FFF5ED');

  static Future<Uint8List> generatePdf(ResumeData data) async {
    final pdf = pw.Document(
      title: '${data.personalInfo.name.isNotEmpty ? data.personalInfo.name : "Resume"}_Resume',
      author: 'Digital Heroes Resume Builder',
    );

    // Load fonts. Try Google Fonts (Inter) via the printing package.
    // If offline, fallback to standard Helvetica.
    pw.Font fontRegular = pw.Font.helvetica();
    pw.Font fontBold = pw.Font.helveticaBold();
    pw.Font fontItalic = pw.Font.helveticaOblique();

    try {
      fontRegular = await PdfGoogleFonts.interRegular();
      fontBold = await PdfGoogleFonts.interBold();
      fontItalic = await PdfGoogleFonts.interItalic();
    } catch (e) {
      // Offline fallback: Helvetica is built into PDF engines
    }

    final pw.ThemeData theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      italic: fontItalic,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header Section
            _buildHeader(data),
            pw.SizedBox(height: 16),

            // Main Body: Double column layout simulated using flexible blocks
            // Note: Since MultiPage can't easily break complex cross-column rows,
            // we will stack them in a single column with distinct, beautifully padded sections.
            // This is clean, robust, and translates perfectly to standard A4 printing.

            if (data.personalInfo.summary.isNotEmpty) ...[
              _buildSectionTitle('Professional Summary'),
              pw.Paragraph(
                text: data.personalInfo.summary,
                style: pw.TextStyle(color: darkColor, fontSize: 10),
              ),
              pw.SizedBox(height: 12),
            ],

            if (data.workExperience.isNotEmpty) ...[
              _buildSectionTitle('Work Experience'),
              for (var work in data.workExperience) ...[
                _buildWorkItem(work),
                pw.SizedBox(height: 8),
              ],
              pw.SizedBox(height: 12),
            ],

            if (data.education.isNotEmpty) ...[
              _buildSectionTitle('Education'),
              for (var edu in data.education) ...[
                _buildEducationItem(edu),
                pw.SizedBox(height: 8),
              ],
              pw.SizedBox(height: 12),
            ],

            if (data.projects.isNotEmpty) ...[
              _buildSectionTitle('Projects'),
              for (var proj in data.projects) ...[
                _buildProjectItem(proj),
                pw.SizedBox(height: 8),
              ],
              pw.SizedBox(height: 12),
            ],

            if (data.skills.isNotEmpty) ...[
              _buildSectionTitle('Technical Skills'),
              _buildSkillsSection(data.skills),
              pw.SizedBox(height: 12),
            ],

            // Secondary info: certifications, achievements, languages in side-by-side grids
            _buildGridSections(data),
          ];
        },
        footer: (pw.Context context) {
          if (context.pagesCount <= 1) {
            return pw.SizedBox();
          }
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 20),
            padding: const pw.EdgeInsets.only(top: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.TextStyle(color: greyColor, fontSize: 8),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(ResumeData data) {
    final hasPhoto = data.personalInfo.photoBytes != null;
    
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: orangeTint,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Profile Photo
          if (hasPhoto) ...[
            pw.ClipOval(
              child: pw.Container(
                width: 65,
                height: 65,
                child: pw.Image(
                  pw.MemoryImage(data.personalInfo.photoBytes!),
                  fit: pw.BoxFit.cover,
                ),
              ),
            ),
            pw.SizedBox(width: 16),
          ],
          // Name and Details
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  data.personalInfo.name.isNotEmpty ? data.personalInfo.name : 'YOUR NAME',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                pw.Text(
                  data.personalInfo.title.isNotEmpty ? data.personalInfo.title : 'Professional Title',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: darkColor,
                  ),
                ),
                pw.SizedBox(height: 6),
                // Contact Details grid
                pw.Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    if (data.personalInfo.email.isNotEmpty)
                      _buildHeaderContactItem('Email: ${data.personalInfo.email}'),
                    if (data.personalInfo.phone.isNotEmpty)
                      _buildHeaderContactItem('Phone: ${data.personalInfo.phone}'),
                    if (data.personalInfo.location.isNotEmpty)
                      _buildHeaderContactItem('Loc: ${data.personalInfo.location}'),
                    if (data.personalInfo.website.isNotEmpty)
                      _buildHeaderContactItem('Web: ${data.personalInfo.website}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildHeaderContactItem(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(color: greyColor, fontSize: 8),
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: primaryColor,
            letterSpacing: 0.5,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Container(
          height: 1.5,
          color: primaryColor,
        ),
        pw.SizedBox(height: 6),
      ],
    );
  }

  static pw.Widget _buildWorkItem(WorkExperience work) {
    final String dateStr = '${work.startDate} - ${work.isCurrent ? "Present" : work.endDate}';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              work.company.isNotEmpty ? work.company : 'Company Name',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: darkColor),
            ),
            pw.Text(
              dateStr,
              style: pw.TextStyle(fontSize: 9, color: greyColor, fontStyle: pw.FontStyle.italic),
            ),
          ],
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          work.position.isNotEmpty ? work.position : 'Job Position',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: primaryColor),
        ),
        if (work.description.isNotEmpty) ...[
          pw.SizedBox(height: 3),
          pw.Text(
            work.description,
            style: pw.TextStyle(color: darkColor, fontSize: 9),
          ),
        ],
      ],
    );
  }

  static pw.Widget _buildEducationItem(Education edu) {
    final String dateStr = '${edu.startDate} - ${edu.endDate}';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              edu.school.isNotEmpty ? edu.school : 'Institution Name',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: darkColor),
            ),
            pw.Text(
              dateStr,
              style: pw.TextStyle(fontSize: 9, color: greyColor, fontStyle: pw.FontStyle.italic),
            ),
          ],
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          '${edu.degree} in ${edu.fieldOfStudy}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: primaryColor),
        ),
        if (edu.description.isNotEmpty) ...[
          pw.SizedBox(height: 3),
          pw.Text(
            edu.description,
            style: pw.TextStyle(color: darkColor, fontSize: 9),
          ),
        ],
      ],
    );
  }

  static pw.Widget _buildProjectItem(Project proj) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              proj.name.isNotEmpty ? proj.name : 'Project Name',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: darkColor),
            ),
            if (proj.link.isNotEmpty)
              pw.Text(
                proj.link,
                style: pw.TextStyle(fontSize: 8, color: primaryColor, decoration: pw.TextDecoration.underline),
              ),
          ],
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          'Role: ${proj.role.isNotEmpty ? proj.role : "Developer"} | Tech: ${proj.technologies}',
          style: pw.TextStyle(fontSize: 8, color: greyColor, fontStyle: pw.FontStyle.italic),
        ),
        if (proj.description.isNotEmpty) ...[
          pw.SizedBox(height: 3),
          pw.Text(
            proj.description,
            style: pw.TextStyle(color: darkColor, fontSize: 9),
          ),
        ],
      ],
    );
  }

  static pw.Widget _buildSkillsSection(List<Skill> skills) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (var skill in skills) ...[
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (skill.category.isNotEmpty) ...[
                pw.SizedBox(
                  width: 120,
                  child: pw.Text(
                    '${skill.category}:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: primaryColor),
                  ),
                ),
              ],
              pw.Expanded(
                child: skill.isColumn
                    ? pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: skill.skills.map((s) => pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('• ', style: pw.TextStyle(color: darkColor, fontSize: 9)),
                            pw.Expanded(
                              child: pw.Text(s, style: pw.TextStyle(color: darkColor, fontSize: 9)),
                            ),
                          ],
                        )).toList(),
                      )
                    : pw.Text(
                        skill.skills.join(', '),
                        style: pw.TextStyle(color: darkColor, fontSize: 9),
                      ),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
        ]
      ],
    );
  }

  static pw.Widget _buildGridSections(ResumeData data) {
    // Determine which secondary sections are populated
    final hasCerts = data.certifications.isNotEmpty;
    final hasLangs = data.languages.isNotEmpty;
    final hasAchs = data.achievements.isNotEmpty;
    final hasSocials = data.socialLinks.isNotEmpty;

    if (!hasCerts && !hasLangs && !hasAchs && !hasSocials) {
      return pw.SizedBox();
    }

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Column 1
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (hasCerts) ...[
                _buildSectionTitle('Certifications'),
                for (var cert in data.certifications) ...[
                  pw.Text(
                    cert.name,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: darkColor),
                  ),
                  pw.Text(
                    '${cert.organization} | ${cert.issueDate}',
                    style: pw.TextStyle(fontSize: 8, color: greyColor),
                  ),
                  if (cert.credentialId.isNotEmpty)
                    pw.Text(
                      'ID: ${cert.credentialId}',
                      style: pw.TextStyle(fontSize: 8, color: greyColor),
                    ),
                  pw.SizedBox(height: 6),
                ],
              ],
              if (hasSocials) ...[
                _buildSectionTitle('Social Links'),
                for (var social in data.socialLinks) ...[
                  pw.Row(
                    children: [
                      pw.Text(
                        '${social.platform}: ',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: primaryColor),
                      ),
                      pw.Text(
                        social.url,
                        style: pw.TextStyle(fontSize: 8, color: darkColor),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                ],
              ],
            ],
          ),
        ),
        pw.SizedBox(width: 16),
        // Column 2
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (hasLangs) ...[
                _buildSectionTitle('Languages'),
                for (var lang in data.languages) ...[
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        lang.name,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: darkColor),
                      ),
                      pw.Text(
                        lang.proficiency,
                        style: pw.TextStyle(fontSize: 8, color: greyColor, fontStyle: pw.FontStyle.italic),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                ],
              ],
              if (hasAchs) ...[
                _buildSectionTitle('Achievements'),
                for (var ach in data.achievements) ...[
                  pw.Text(
                    ach.title,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: darkColor),
                  ),
                  if (ach.description.isNotEmpty)
                    pw.Text(
                      ach.description,
                      style: pw.TextStyle(fontSize: 8, color: greyColor),
                    ),
                  pw.SizedBox(height: 6),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  static Future<void> downloadPdf(ResumeData data) async {
    final bytes = await generatePdf(data);
    final fileName = '${data.personalInfo.name.replaceAll(RegExp(r'\s+'), '_')}_Resume.pdf';
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }
}
