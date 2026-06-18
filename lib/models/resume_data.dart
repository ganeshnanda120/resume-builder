import 'dart:typed_data';

class PersonalInfo {
  final String name;
  final String title;
  final String email;
  final String phone;
  final String location;
  final String summary;
  final String website;
  final Uint8List? photoBytes;

  PersonalInfo({
    required this.name,
    required this.title,
    required this.email,
    required this.phone,
    required this.location,
    required this.summary,
    required this.website,
    this.photoBytes,
  });

  PersonalInfo copyWith({
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
    return PersonalInfo(
      name: name ?? this.name,
      title: title ?? this.title,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      summary: summary ?? this.summary,
      website: website ?? this.website,
      photoBytes: clearPhoto ? null : (photoBytes ?? this.photoBytes),
    );
  }

  factory PersonalInfo.empty() {
    return PersonalInfo(
      name: '',
      title: '',
      email: '',
      phone: '',
      location: '',
      summary: '',
      website: '',
      photoBytes: null,
    );
  }
}

class Education {
  final String school;
  final String degree;
  final String fieldOfStudy;
  final String startDate;
  final String endDate;
  final String description;

  Education({
    required this.school,
    required this.degree,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  Education copyWith({
    String? school,
    String? degree,
    String? fieldOfStudy,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    return Education(
      school: school ?? this.school,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }

  factory Education.empty() {
    return Education(
      school: '',
      degree: '',
      fieldOfStudy: '',
      startDate: '',
      endDate: '',
      description: '',
    );
  }
}

class WorkExperience {
  final String company;
  final String position;
  final String startDate;
  final String endDate;
  final String description;
  final bool isCurrent;

  WorkExperience({
    required this.company,
    required this.position,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.isCurrent,
  });

  WorkExperience copyWith({
    String? company,
    String? position,
    String? startDate,
    String? endDate,
    String? description,
    bool? isCurrent,
  }) {
    return WorkExperience(
      company: company ?? this.company,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  factory WorkExperience.empty() {
    return WorkExperience(
      company: '',
      position: '',
      startDate: '',
      endDate: '',
      description: '',
      isCurrent: false,
    );
  }
}

class Project {
  final String name;
  final String role;
  final String description;
  final String technologies;
  final String link;

  Project({
    required this.name,
    required this.role,
    required this.description,
    required this.technologies,
    required this.link,
  });

  Project copyWith({
    String? name,
    String? role,
    String? description,
    String? technologies,
    String? link,
  }) {
    return Project(
      name: name ?? this.name,
      role: role ?? this.role,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      link: link ?? this.link,
    );
  }

  factory Project.empty() {
    return Project(
      name: '',
      role: '',
      description: '',
      technologies: '',
      link: '',
    );
  }
}

class Skill {
  final String category;
  final List<String> skills;
  final bool isColumn;

  Skill({
    required this.category,
    required this.skills,
    this.isColumn = false,
  });

  Skill copyWith({
    String? category,
    List<String>? skills,
    bool? isColumn,
  }) {
    return Skill(
      category: category ?? this.category,
      skills: skills ?? this.skills,
      isColumn: isColumn ?? this.isColumn,
    );
  }

  factory Skill.empty() {
    return Skill(
      category: '',
      skills: [],
      isColumn: false,
    );
  }
}

class Certification {
  final String name;
  final String organization;
  final String issueDate;
  final String credentialId;
  final String credentialUrl;

  Certification({
    required this.name,
    required this.organization,
    required this.issueDate,
    required this.credentialId,
    required this.credentialUrl,
  });

  Certification copyWith({
    String? name,
    String? organization,
    String? issueDate,
    String? credentialId,
    String? credentialUrl,
  }) {
    return Certification(
      name: name ?? this.name,
      organization: organization ?? this.organization,
      issueDate: issueDate ?? this.issueDate,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
    );
  }

  factory Certification.empty() {
    return Certification(
      name: '',
      organization: '',
      issueDate: '',
      credentialId: '',
      credentialUrl: '',
    );
  }
}

class Language {
  final String name;
  final String proficiency;

  Language({
    required this.name,
    required this.proficiency,
  });

  Language copyWith({
    String? name,
    String? proficiency,
  }) {
    return Language(
      name: name ?? this.name,
      proficiency: proficiency ?? this.proficiency,
    );
  }

  factory Language.empty() {
    return Language(
      name: '',
      proficiency: '',
    );
  }
}

class Achievement {
  final String title;
  final String description;

  Achievement({
    required this.title,
    required this.description,
  });

  Achievement copyWith({
    String? title,
    String? description,
  }) {
    return Achievement(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  factory Achievement.empty() {
    return Achievement(
      title: '',
      description: '',
    );
  }
}

class SocialLink {
  final String platform;
  final String url;

  SocialLink({
    required this.platform,
    required this.url,
  });

  SocialLink copyWith({
    String? platform,
    String? url,
  }) {
    return SocialLink(
      platform: platform ?? this.platform,
      url: url ?? this.url,
    );
  }

  factory SocialLink.empty() {
    return SocialLink(
      platform: '',
      url: '',
    );
  }
}

class ResumeData {
  final PersonalInfo personalInfo;
  final List<Education> education;
  final List<WorkExperience> workExperience;
  final List<Project> projects;
  final List<Skill> skills;
  final List<Certification> certifications;
  final List<Language> languages;
  final List<Achievement> achievements;
  final List<SocialLink> socialLinks;

  ResumeData({
    required this.personalInfo,
    required this.education,
    required this.workExperience,
    required this.projects,
    required this.skills,
    required this.certifications,
    required this.languages,
    required this.achievements,
    required this.socialLinks,
  });

  ResumeData copyWith({
    PersonalInfo? personalInfo,
    List<Education>? education,
    List<WorkExperience>? workExperience,
    List<Project>? projects,
    List<Skill>? skills,
    List<Certification>? certifications,
    List<Language>? languages,
    List<Achievement>? achievements,
    List<SocialLink>? socialLinks,
  }) {
    return ResumeData(
      personalInfo: personalInfo ?? this.personalInfo,
      education: education ?? this.education,
      workExperience: workExperience ?? this.workExperience,
      projects: projects ?? this.projects,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      achievements: achievements ?? this.achievements,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }

  factory ResumeData.empty() {
    return ResumeData(
      personalInfo: PersonalInfo.empty(),
      education: [],
      workExperience: [],
      projects: [],
      skills: [],
      certifications: [],
      languages: [],
      achievements: [],
      socialLinks: [],
    );
  }
}
