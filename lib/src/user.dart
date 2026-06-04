class User {
  String email;
  String password;
  double rating;
  String firstname;
  String lastname;
  String middlename;
  int age;
  String phone;
  String country;
  String city;
  String companyName;
  String job;
  String instituteName;
  String startDate;
  String endDate;

  User({
    required this.email,
    required this.password,
    this.rating = 0,
    this.firstname = '',
    this.lastname = '',
    this.middlename = '',
    this.age = 0,
    this.phone = '',
    this.country = '',
    this.city = '',
    this.companyName = '',
    this.job = '',
    this.instituteName = '',
    this.startDate = '',
    this.endDate = '',
  });

  // Setters
  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void setFirstName(String firstname) {
    this.firstname = firstname;
  }

  void setLastName(String lastname) {
    this.lastname = lastname;
  }

  void setMiddleName(String middlename) {
    this.middlename = middlename;
  }

  void setAge(int age) {
    this.age = age;
  }

  void setPhone(String phone) {
    this.phone = phone;
  }

  void setCountry(String country) {
    this.country = country;
  }

  void setCity(String city) {
    this.city = city;
  }

  void setCompanyName(String companyName) {
    this.companyName = companyName;
  }

  void setJob(String job) {
    this.job = job;
  }

  void setInstituteName(String instituteName) {
    this.instituteName = instituteName;
  }

  void setStartDate(String startDate) {
    this.startDate = startDate;
  }

  void setEndDate(String endDate) {
    this.endDate = endDate;
  }

  void setRating(double rating) {
    this.rating = rating;
  }

  // Print details
  void printDetails() {
    print('Email: $email');
    print('Password: $password');
    print('First Name: $firstname');
    print('Middle Name: $middlename');
    print('Last Name: $lastname');
    print('Age: $age');
    print('Phone: $phone');
    print('Location: $country');
    print('City: $city');
    print('Company Name: $companyName');
    print('Job: $job');
    print('Institute Name: $instituteName');
    print('Start Date: $startDate');
    print('End Date: $endDate');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'rating': rating,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      'age': age.toString(),
      'phone': phone,
      'country': country,
      'city': city,
      'company_name': companyName,
      'job': job,
      'edu_name': instituteName,
      'start_year': startDate,
      'end_year': endDate,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        password: '',
        rating: json['rating'] != null ? (json['rating']).toDouble() : 0,
        firstname: json['first_name'],
        middlename: json['middle_name'] ?? '',
        lastname: json['last_name'],
        age: json['age'],
        phone: json['phone'],
        instituteName: json['edu_name'] ?? '',
        startDate: json['start_year'] ?? '',
        endDate: json['end_year'] ?? '',
        companyName: json['company_name'] ?? '',
        job: json['jobs'] ?? '',
        country: json['country'],
        city: json['city']);
  }
}

class Attendee {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  bool isParticipate;

  Attendee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.isParticipate = false,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      isParticipate: json['isParticipated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
    };
  }
}
