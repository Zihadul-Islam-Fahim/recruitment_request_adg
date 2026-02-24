class JobPostListModel {
  List<JobPosts>? jobPostList;

  JobPostListModel({this.jobPostList});

  JobPostListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      jobPostList = <JobPosts>[];
      json['data'].forEach((v) {
        jobPostList!.add(new JobPosts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jobPostList != null) {
      data['data'] = this.jobPostList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobPosts {
  int? id;
  String? companyId;
  String? jobTitle;
  String? jobCategory;
  String? jobType;
  String? vacancyCount;
  String? salaryMin;
  String? salaryMax;
  String? salaryType;
  String? experienceMinYear;
  String? experienceMaxYear;
  String? educationRequirement;
  String? jobLocation;
  String? applicationDeadline;
  String? description;
  String? benefits;
  String? urgency;
  String? status;
  String? attachments;
  String? createdAt;

  JobPosts(
      {this.id,
        this.companyId,
        this.jobTitle,
        this.jobCategory,
        this.jobType,
        this.vacancyCount,
        this.salaryMin,
        this.salaryMax,
        this.salaryType,
        this.experienceMinYear,
        this.experienceMaxYear,
        this.educationRequirement,
        this.jobLocation,
        this.applicationDeadline,
        this.description,
        this.benefits,
        this.urgency,
        this.status,
        this.attachments,
        this.createdAt});

  JobPosts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    jobTitle = json['job_title'];
    jobCategory = json['job_category'];
    jobType = json['job_type'];
    vacancyCount = json['vacancy_count'];
    salaryMin = json['salary_min'];
    salaryMax = json['salary_max'];
    salaryType = json['salary_type'];
    experienceMinYear = json['experience_min_year'];
    experienceMaxYear = json['experience_max_year'];
    educationRequirement = json['education_requirement'];
    jobLocation = json['job_location'];
    applicationDeadline = json['application_deadline'];
    description = json['description'];
    benefits = json['benefits'];
    urgency = json['urgency'];
    status = json['status'];
    attachments = json['attachments'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['job_title'] = this.jobTitle;
    data['job_category'] = this.jobCategory;
    data['job_type'] = this.jobType;
    data['vacancy_count'] = this.vacancyCount;
    data['salary_min'] = this.salaryMin;
    data['salary_max'] = this.salaryMax;
    data['salary_type'] = this.salaryType;
    data['experience_min_year'] = this.experienceMinYear;
    data['experience_max_year'] = this.experienceMaxYear;
    data['education_requirement'] = this.educationRequirement;
    data['job_location'] = this.jobLocation;
    data['application_deadline'] = this.applicationDeadline;
    data['description'] = this.description;
    data['benefits'] = this.benefits;
    data['urgency'] = this.urgency;
    data['status'] = this.status;
    data['attachments'] = this.attachments;
    data['created_at'] = this.createdAt;
    return data;
  }
}
