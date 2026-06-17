import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/resume_data.dart';

class ResumeProvider extends ChangeNotifier {
  ResumeData _resumeData = ResumeData.empty();

  ResumeData get resumeData => _resumeData;

  // Personal Info Methods
  void updatePersonalInfo({
    String? name,
    String? title,
    String? email,
    String? phone,
    String? location,
    String? summary,
    String? website,
    Uint8List? photoBytes,
    bool clearPhoto = false,
  }) {
    _resumeData = _resumeData.copyWith(
      personalInfo: _resumeData.personalInfo.copyWith(
        name: name,
        title: title,
        email: email,
        phone: phone,
        location: location,
        summary: summary,
        website: website,
        photoBytes: photoBytes,
        clearPhoto: clearPhoto,
      ),
    );
    notifyListeners();
  }

  // Education Methods
  void addEducation(Education education) {
    final List<Education> list = List.from(_resumeData.education)..add(education);
    _resumeData = _resumeData.copyWith(education: list);
    notifyListeners();
  }

  void updateEducation(int index, Education education) {
    if (index >= 0 && index < _resumeData.education.length) {
      final List<Education> list = List.from(_resumeData.education);
      list[index] = education;
      _resumeData = _resumeData.copyWith(education: list);
      notifyListeners();
    }
  }

  void removeEducation(int index) {
    if (index >= 0 && index < _resumeData.education.length) {
      final List<Education> list = List.from(_resumeData.education)..removeAt(index);
      _resumeData = _resumeData.copyWith(education: list);
      notifyListeners();
    }
  }

  // Work Experience Methods
  void addWorkExperience(WorkExperience work) {
    final List<WorkExperience> list = List.from(_resumeData.workExperience)..add(work);
    _resumeData = _resumeData.copyWith(workExperience: list);
    notifyListeners();
  }

  void updateWorkExperience(int index, WorkExperience work) {
    if (index >= 0 && index < _resumeData.workExperience.length) {
      final List<WorkExperience> list = List.from(_resumeData.workExperience);
      list[index] = work;
      _resumeData = _resumeData.copyWith(workExperience: list);
      notifyListeners();
    }
  }

  void removeWorkExperience(int index) {
    if (index >= 0 && index < _resumeData.workExperience.length) {
      final List<WorkExperience> list = List.from(_resumeData.workExperience)..removeAt(index);
      _resumeData = _resumeData.copyWith(workExperience: list);
      notifyListeners();
    }
  }

  // Project Methods
  void addProject(Project project) {
    final List<Project> list = List.from(_resumeData.projects)..add(project);
    _resumeData = _resumeData.copyWith(projects: list);
    notifyListeners();
  }

  void updateProject(int index, Project project) {
    if (index >= 0 && index < _resumeData.projects.length) {
      final List<Project> list = List.from(_resumeData.projects);
      list[index] = project;
      _resumeData = _resumeData.copyWith(projects: list);
      notifyListeners();
    }
  }

  void removeProject(int index) {
    if (index >= 0 && index < _resumeData.projects.length) {
      final List<Project> list = List.from(_resumeData.projects)..removeAt(index);
      _resumeData = _resumeData.copyWith(projects: list);
      notifyListeners();
    }
  }

  // Skill Methods
  void addSkillCategory(Skill skill) {
    final List<Skill> list = List.from(_resumeData.skills)..add(skill);
    _resumeData = _resumeData.copyWith(skills: list);
    notifyListeners();
  }

  void updateSkillCategory(int index, Skill skill) {
    if (index >= 0 && index < _resumeData.skills.length) {
      final List<Skill> list = List.from(_resumeData.skills);
      list[index] = skill;
      _resumeData = _resumeData.copyWith(skills: list);
      notifyListeners();
    }
  }

  void removeSkillCategory(int index) {
    if (index >= 0 && index < _resumeData.skills.length) {
      final List<Skill> list = List.from(_resumeData.skills)..removeAt(index);
      _resumeData = _resumeData.copyWith(skills: list);
      notifyListeners();
    }
  }

  // Certification Methods
  void addCertification(Certification cert) {
    final List<Certification> list = List.from(_resumeData.certifications)..add(cert);
    _resumeData = _resumeData.copyWith(certifications: list);
    notifyListeners();
  }

  void updateCertification(int index, Certification cert) {
    if (index >= 0 && index < _resumeData.certifications.length) {
      final List<Certification> list = List.from(_resumeData.certifications);
      list[index] = cert;
      _resumeData = _resumeData.copyWith(certifications: list);
      notifyListeners();
    }
  }

  void removeCertification(int index) {
    if (index >= 0 && index < _resumeData.certifications.length) {
      final List<Certification> list = List.from(_resumeData.certifications)..removeAt(index);
      _resumeData = _resumeData.copyWith(certifications: list);
      notifyListeners();
    }
  }

  // Language Methods
  void addLanguage(Language lang) {
    final List<Language> list = List.from(_resumeData.languages)..add(lang);
    _resumeData = _resumeData.copyWith(languages: list);
    notifyListeners();
  }

  void updateLanguage(int index, Language lang) {
    if (index >= 0 && index < _resumeData.languages.length) {
      final List<Language> list = List.from(_resumeData.languages);
      list[index] = lang;
      _resumeData = _resumeData.copyWith(languages: list);
      notifyListeners();
    }
  }

  void removeLanguage(int index) {
    if (index >= 0 && index < _resumeData.languages.length) {
      final List<Language> list = List.from(_resumeData.languages)..removeAt(index);
      _resumeData = _resumeData.copyWith(languages: list);
      notifyListeners();
    }
  }

  // Achievement Methods
  void addAchievement(Achievement ach) {
    final List<Achievement> list = List.from(_resumeData.achievements)..add(ach);
    _resumeData = _resumeData.copyWith(achievements: list);
    notifyListeners();
  }

  void updateAchievement(int index, Achievement ach) {
    if (index >= 0 && index < _resumeData.achievements.length) {
      final List<Achievement> list = List.from(_resumeData.achievements);
      list[index] = ach;
      _resumeData = _resumeData.copyWith(achievements: list);
      notifyListeners();
    }
  }

  void removeAchievement(int index) {
    if (index >= 0 && index < _resumeData.achievements.length) {
      final List<Achievement> list = List.from(_resumeData.achievements)..removeAt(index);
      _resumeData = _resumeData.copyWith(achievements: list);
      notifyListeners();
    }
  }

  // Social Link Methods
  void addSocialLink(SocialLink social) {
    final List<SocialLink> list = List.from(_resumeData.socialLinks)..add(social);
    _resumeData = _resumeData.copyWith(socialLinks: list);
    notifyListeners();
  }

  void updateSocialLink(int index, SocialLink social) {
    if (index >= 0 && index < _resumeData.socialLinks.length) {
      final List<SocialLink> list = List.from(_resumeData.socialLinks);
      list[index] = social;
      _resumeData = _resumeData.copyWith(socialLinks: list);
      notifyListeners();
    }
  }

  void removeSocialLink(int index) {
    if (index >= 0 && index < _resumeData.socialLinks.length) {
      final List<SocialLink> list = List.from(_resumeData.socialLinks)..removeAt(index);
      _resumeData = _resumeData.copyWith(socialLinks: list);
      notifyListeners();
    }
  }

  // Load sample data
  void loadSampleData() {
    _resumeData = ResumeData(
      personalInfo: PersonalInfo(
        name: 'Alex Morgan',
        title: 'Lead Full-Stack Flutter Engineer',
        email: 'alex.morgan@digitalheroes.com',
        phone: '+1 (555) 019-2834',
        location: 'San Francisco, CA',
        summary: 'Innovative and results-driven Software Engineer with 6+ years of experience specializing in cross-platform mobile and web applications using Flutter & Dart. Proven track record of leading development teams, designing scalable architectures, and delivering highly polished user interfaces. Passionate about performance optimization and creating pixel-perfect digital experiences.',
        website: 'https://alexmorgan.dev',
        photoBytes: null, // User can upload their own picture
      ),
      education: [
        Education(
          school: 'Stanford University',
          degree: 'Master of Science',
          fieldOfStudy: 'Computer Science',
          startDate: 'Sep 2018',
          endDate: 'Jun 2020',
          description: 'Specialized in Software Engineering and Human-Computer Interaction. GPA: 3.9/4.0.',
        ),
        Education(
          school: 'University of California, Berkeley',
          degree: 'Bachelor of Science',
          fieldOfStudy: 'Computer Science',
          startDate: 'Sep 2014',
          endDate: 'Jun 2018',
          description: 'Graduated with Honors. Active member of the Computer Science Undergraduate Association.',
        ),
      ],
      workExperience: [
        WorkExperience(
          company: 'Digital Heroes Co.',
          position: 'Senior Flutter Developer',
          startDate: 'Jan 2023',
          endDate: 'Present',
          description: '• Led development of a high-performance cross-platform enterprise app, reducing startup load times by 40%.\n• Designed and maintained a reusable custom design system using Material 3, improving development velocity by 25%.\n• Mentored junior developers and established code review guidelines for clean architecture and state management.',
          isCurrent: true,
        ),
        WorkExperience(
          company: 'Appify Studios',
          position: 'Mobile Software Engineer',
          startDate: 'Mar 2020',
          endDate: 'Dec 2022',
          description: '• Developed and launched 5 commercial mobile apps using Flutter and Firebase, achieving 4.8+ ratings on App Store and Google Play.\n• Implemented complex state management solutions using BLoC and Provider for highly dynamic user flows.\n• Integrated RESTful APIs, WebSockets, and OAuth2 authentication securely.',
          isCurrent: false,
        ),
      ],
      projects: [
        Project(
          name: 'TaskFlow Planner',
          role: 'Lead Developer',
          description: 'A beautiful, minimalist productivity application with offline support, local databases, and real-time statistics.',
          technologies: 'Flutter, Dart, Hive, FL Chart',
          link: 'https://github.com/alexm/taskflow',
        ),
        Project(
          name: 'E-Commerce Design System',
          role: 'Creator',
          description: 'An open-source custom Flutter package for e-commerce widgets adhering to clean UI/UX standards.',
          technologies: 'Flutter, Dart, pub.dev',
          link: 'https://pub.dev/packages/ecommerce_ui',
        ),
      ],
      skills: [
        Skill(
          category: 'Languages',
          skills: ['Dart', 'JavaScript', 'TypeScript', 'HTML5/CSS3', 'Kotlin', 'Swift'],
        ),
        Skill(
          category: 'Frameworks & Tools',
          skills: ['Flutter SDK', 'React.js', 'Node.js', 'Git/GitHub', 'Docker', 'VS Code'],
        ),
        Skill(
          category: 'Architecture & State',
          skills: ['BLoC', 'Provider/Riverpod', 'Clean Architecture', 'MVVM', 'CI/CD (GitHub Actions)'],
        ),
      ],
      certifications: [
        Certification(
          name: 'Google Certified Associate Cloud Engineer',
          organization: 'Google Cloud',
          issueDate: 'Aug 2024',
          credentialId: 'GCP-ACE-98234',
          credentialUrl: 'https://credential.google.com/98234',
        ),
        Certification(
          name: 'Flutter Certified Application Developer',
          organization: 'Android ATC',
          issueDate: 'May 2022',
          credentialId: 'ATC-FL-7721',
          credentialUrl: 'https://androidatc.com/verify',
        ),
      ],
      languages: [
        Language(name: 'English', proficiency: 'Native'),
        Language(name: 'Spanish', proficiency: 'Conversational'),
      ],
      achievements: [
        Achievement(
          title: 'Hackathon Winner',
          description: 'Won 1st place out of 50 teams at the SF Tech Innovators Hackathon for building an AI-powered local helper app.',
        ),
        Achievement(
          title: 'Open Source Contributor',
          description: 'Contributed performance optimizations and bug fixes to the official Flutter framework repository.',
        ),
      ],
      socialLinks: [
        SocialLink(platform: 'GitHub', url: 'https://github.com/alexmorgan'),
        SocialLink(platform: 'LinkedIn', url: 'https://linkedin.com/in/alexmorgan-flutter'),
      ],
    );
    notifyListeners();
  }

  // Reset data
  void resetData() {
    _resumeData = ResumeData.empty();
    notifyListeners();
  }
}
