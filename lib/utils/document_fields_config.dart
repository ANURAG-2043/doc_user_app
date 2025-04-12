class DocumentFieldsConfig {
  static const Map<String, Map<String, String>> documentFields = {
    // Finance Documents
    'PAN Card': {
      'Full Name': 'Enter full name as on PAN card',
      'PAN Number': 'Enter 10-digit PAN number',
      'Date of Birth': 'DD/MM/YYYY',
      'Father\'s Name': 'Enter father\'s full name',
    },
    'Form 16': {
      'Employee Name': 'Enter full name',
      'PAN Number': 'Enter PAN number',
      'Assessment Year': 'Enter assessment year',
      'Employer Name': 'Enter employer name',
      'TAN Number': 'Enter employer\'s TAN',
    },
    'ITR Acknowledgment': {
      'Name': 'Enter full name',
      'PAN Number': 'Enter PAN number',
      'Assessment Year': 'Enter assessment year',
      'Acknowledgment Number': 'Enter acknowledgment number',
      'Filing Date': 'DD/MM/YYYY',
    },
    'Bank Statements': {
      'Account Holder Name': 'Enter account holder name',
      'Bank Name': 'Enter bank name',
      'Account Number': 'Enter account number',
      'IFSC Code': 'Enter IFSC code',
      'Statement Period': 'MM/YYYY - MM/YYYY',
    },
    'Salary Slips': {
      'Employee Name': 'Enter employee full name',
      'Employee ID': 'Enter employee ID',
      'Company Name': 'Enter company name',
      'Department': 'Enter department name',
      'Salary Month': 'MM/YYYY',
      'Basic Salary': 'Enter basic salary amount',
      'Net Salary': 'Enter net salary amount',
    },
    'Investment Certificates': {
      'Investor Name': 'Enter investor full name',
      'Investment Type': 'Enter type (MF/Stocks/Bonds etc)',
      'Investment Amount': 'Enter invested amount',
      'Certificate Number': 'Enter certificate number',
      'Investment Date': 'DD/MM/YYYY',
      'Maturity Date': 'DD/MM/YYYY',
      'Institution Name': 'Enter institution name',
    },
    'Insurance Policies': {
      'Policy Holder Name': 'Enter policy holder name',
      'Policy Number': 'Enter policy number',
      'Insurance Type': 'Enter type (Life/Health/Vehicle etc)',
      'Insurance Provider': 'Enter insurance company name',
      'Sum Insured': 'Enter sum insured amount',
      'Premium Amount': 'Enter premium amount',
      'Policy Start Date': 'DD/MM/YYYY',
      'Policy End Date': 'DD/MM/YYYY',
    },

    // Health Documents
    'Medical Records': {
      'Patient Name': 'Enter patient name',
      'Hospital/Clinic Name': 'Enter hospital/clinic name',
      'Doctor Name': 'Enter doctor name',
      'Date of Visit': 'DD/MM/YYYY',
      'Medical Record Number': 'Enter MRN',
    },
    'Vaccination Certificates': {
      'Name': 'Enter full name',
      'Vaccine Name': 'Enter vaccine name',
      'Date of Vaccination': 'DD/MM/YYYY',
      'Certificate Number': 'Enter certificate number',
      'Vaccination Center': 'Enter center name',
    },
    'Health Insurance Card': {
      'Policy Holder Name': 'Enter policy holder name',
      'Policy Number': 'Enter policy number',
      'Insurance Provider': 'Enter insurance provider name',
      'Valid Until': 'DD/MM/YYYY',
      'Member ID': 'Enter member ID',
    },
    'Lab Test Reports': {
      'Patient Name': 'Enter patient full name',
      'Lab Name': 'Enter laboratory name',
      'Test Type': 'Enter type of test',
      'Doctor Name': 'Enter referring doctor name',
      'Sample Collection Date': 'DD/MM/YYYY',
      'Report Date': 'DD/MM/YYYY',
      'Report Number': 'Enter report number',
      'Patient ID': 'Enter patient ID',
    },
    'COVID-19 Certificate': {
      'Name': 'Enter full name as per ID',
      'Certificate Number': 'Enter certificate number',
      'Test Type': 'Enter test type (RT-PCR/RAT)',
      'Sample Collection Date': 'DD/MM/YYYY',
      'Result Date': 'DD/MM/YYYY',
      'Result': 'Enter test result',
      'Testing Center': 'Enter testing center name',
      'Beneficiary ID': 'Enter beneficiary ID',
    },

    // Identity Documents
    'Aadhaar Card': {
      'Full Name': 'Enter name as on Aadhaar',
      'Aadhaar Number': 'Enter 12-digit Aadhaar number',
      'Date of Birth': 'DD/MM/YYYY',
      'Gender': 'Enter gender',
    },
    'Passport': {
      'Full Name': 'Enter name as on passport',
      'Passport Number': 'Enter passport number',
      'Date of Birth': 'DD/MM/YYYY',
      'Place of Issue': 'Enter place of issue',
      'Date of Issue': 'DD/MM/YYYY',
      'Date of Expiry': 'DD/MM/YYYY',
    },
    'Driving License': {
      'License Holder Name': 'Enter full name',
      'License Number': 'Enter license number',
      'Vehicle Classes': 'Enter vehicle classes',
      'Issuing Authority': 'Enter RTO name',
      'Valid Until': 'DD/MM/YYYY',
    },
    'Voter ID': {
      'Full Name': 'Enter full name',
      'Voter ID Number': 'Enter VoterID number',
      'Date of Birth': 'DD/MM/YYYY',
    },
    'Birth Certificate': {
      'Full Name': 'Enter full name',
      'Date of Birth': 'DD/MM/YYYY',
      'City': 'Enter city name',
      'State':' Enter state name',
    },
    'Marriage Certificate': {
      'Husband Name': 'Enter husband\'s full name',
      'Wife Name': 'Enter wife\'s full name',
      'Marriage Date': 'DD/MM/YYYY',
      'Place of Marriage': 'Enter place of marriage',
      'Registration Number': 'Enter marriage registration number',
      'Date of Issue': 'DD/MM/YYYY',
    },
    'Residence Proof': {
      'Consumer Name': 'Enter name as on bill',
      'Connection Number': 'Enter electricity connection number',
      'Service Provider': 'Enter electricity board name',
      'Address': 'Enter complete address',
      'Bill Period': 'MM/YYYY',
      'Bill Number': 'Enter electricity bill number',
    },

    // Education Documents
    'Degree Certificate': {
      'Student Name': 'Enter full name',
      'Degree Name': 'Enter degree name',
      'University': 'Enter university name',
      'Year of Passing': 'YYYY',
      'Registration Number': 'Enter registration number',
    },
    '10th Mark Sheet': {
      'Student Name': 'Enter full name',
      'Board Name': 'Enter board name',
      'Roll Number': 'Enter roll number',
      'Year of Passing': 'YYYY',
      'Percentage/CGPA': 'Enter percentage or CGPA',
    },
    '12th Mark Sheet': {
      'Student Name': 'Enter full name',
      'Board Name': 'Enter board name',
      'Roll Number': 'Enter roll number',
      'Year of Passing': 'YYYY',
      'Percentage/CGPA': 'Enter percentage or CGPA',
    },
    'Transfer Certificate':{
      'Student Name': 'Enter full name',
      'Board Name': 'Enter board name',
      'Roll Number': 'Enter roll number',
      'Year of Passing': 'YYYY',
    },
    'Migration Certificate':{
      'Student Name': 'Enter full name',
      'Board Name': 'Enter board name',
      'Roll Number': 'Enter roll number',
      'Year of Passing': 'YYYY',
    },
    'Course Completion Certificate':{
      'Student Name': 'Enter full name',
      'Course Name': 'Enter Course name',
      'Starting Date': 'Enter Start Date',
      'Completion Date': 'Enter Completion Date',
    },
    'Entrance Exam Scores': {
      'Student Name': 'Enter full name',
      'Entrance Name': 'Enter Entrance name',
      'Roll Number': 'Enter roll number',
      'Year of Exam': 'YYYY',
    }

  };

  static Map<String, String> getFieldsForDocument(String documentType) {
    return documentFields[documentType] ?? {};  // Return empty map if document type not found
  }

  // Helper method to get placeholder text for a field
  static String getPlaceholder(String documentType, String fieldName) {
    final fields = documentFields[documentType];
    return fields?[fieldName] ?? 'Enter $fieldName';
  }

  // Helper method to check if a document type exists
  static bool hasDocumentType(String documentType) {
    return documentFields.containsKey(documentType);
  }

  // Helper method to get all available document types
  static List<String> getAllDocumentTypes() {
    return documentFields.keys.toList();
  }

  // Helper method to get document types by category
  static List<String> getDocumentTypesByCategory(String category) {
    switch (category) {
      case 'Finances':
        return [
          'PAN Card',
          'Form 16',
          'ITR Acknowledgment',
          'Bank Statements',
          'Salary Slips',
          'Investment Certificates',
          'Insurance Policies',
        ];
      case 'Health':
        return [
          'Medical Records',
          'Vaccination Certificates',
          'Health Insurance Card',
          'Lab Test Reports',
          'COVID-19 Certificate',
        ];
      case 'Identity':
        return [
          'Aadhaar Card',
          'Passport',
          'Voter ID',
          'Driving License',
          'Birth Certificate',
          'Marriage Certificate',
          'Residence Proof',
        ];
      case 'Education':
        return [
          'Degree Certificate',
          '10th Mark Sheet',
          '12th Mark Sheet',
          'Transfer Certificate',
          'Migration Certificate',
          'Course Completion Certificate',
          'Entrance Exam Scores',
        ];
      default:
        return [];
    }
  }
}