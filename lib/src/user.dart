class User {
  String email;
  String password;
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
}
