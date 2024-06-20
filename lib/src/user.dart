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

  void setRating(double rating){
    this.rating = rating;
  }




  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        password: '',
        rating: json['rating'] ?? 0, 
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
