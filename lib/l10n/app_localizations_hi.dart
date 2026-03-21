// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'किसान मित्र';

  @override
  String get appTagline => '\"बीज से बाज़ार तक\"';

  @override
  String get appSmartFertilizer => 'स्मार्ट उर्वरक खोजक';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get languageChanged => 'भाषा सफलतापूर्वक बदली गई';

  @override
  String get selectRole => 'अपनी भूमिका चुनें';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है';

  @override
  String get selectRoleSubtitle => 'जारी रखने के लिए अपनी भूमिका चुनें';

  @override
  String get needHelp => 'मदद चाहिए? ';

  @override
  String get contactSupport => 'सहायता से संपर्क करें';

  @override
  String get contactSupportEmail => 'ईमेल: support@kisanmitra.com';

  @override
  String get contactSupportPhone => 'फ़ोन: +91 1800-XXX-XXXX';

  @override
  String get close => 'बंद करें';

  @override
  String get farmer => 'किसान';

  @override
  String get farmerSubtitle => 'उर्वरक खोजें और दुकानें ढूंढें';

  @override
  String get storeOwner => 'दुकान मालिक';

  @override
  String get storeOwnerSubtitle => 'इन्वेंटरी और कीमतें प्रबंधित करें';

  @override
  String get admin => 'एडमिन';

  @override
  String get adminSubtitle => 'दुकानें सत्यापित करें और सिस्टम प्रबंधित करें';

  @override
  String get login => 'लॉगिन';

  @override
  String get loginSubtitle => 'नज़दीकी उर्वरक दुकानें खोजने के लिए\nलॉगिन करें';

  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get password => 'पासवर्ड';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get or => 'या';

  @override
  String get signInWithGoogle => 'Google से साइन इन करें';

  @override
  String get createNewAccount => 'नया खाता बनाएं';

  @override
  String get invalidRole => 'अमान्य भूमिका। कृपया सही लॉगिन का उपयोग करें।';

  @override
  String get userDataNotFound => 'उपयोगकर्ता डेटा नहीं मिला';

  @override
  String anErrorOccurred(String error) {
    return 'एक त्रुटि हुई: $error';
  }

  @override
  String get failedToCreateProfile =>
      'प्रोफ़ाइल बनाने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get googleSignInFailed => 'Google साइन-इन विफल';

  @override
  String get googleAccountDifferentRole =>
      'यह Google खाता एक अलग भूमिका के साथ पंजीकृत है।';

  @override
  String get loginFailed => 'लॉगिन विफल';

  @override
  String get signup => 'साइन अप';

  @override
  String get signUp => 'साइन अप';

  @override
  String get signupSubtitle =>
      'उर्वरक तक पहुंचने के लिए पंजीकरण करें और नज़दीकी दुकानें खोजें';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है? ';

  @override
  String get signIn => 'साइन इन';

  @override
  String get phone => 'फ़ोन नंबर';

  @override
  String get state => 'राज्य';

  @override
  String get city => 'शहर';

  @override
  String get village => 'गाँव';

  @override
  String get register => 'पंजीकरण करें';

  @override
  String get forgotPasswordTitle => 'पासवर्ड भूल गए';

  @override
  String get forgotPasswordSubtitle =>
      'रीसेट लिंक प्राप्त करने के लिए अपना ईमेल दर्ज करें';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get emailSent => 'रीसेट ईमेल भेजा गया! अपना इनबॉक्स देखें।';

  @override
  String get backToLogin => 'लॉगिन पर वापस जाएं';

  @override
  String get home => 'होम';

  @override
  String get search => 'खोजें';

  @override
  String get advisory => 'सलाह';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String homeGreeting(String name) {
    return 'नमस्ते, $name!';
  }

  @override
  String get homeSubtitle => 'अपने आस-पास सबसे अच्छे उर्वरक खोजें';

  @override
  String get searchFertilizers => 'उर्वरक खोजें';

  @override
  String get findNearbyStores => 'नज़दीकी दुकानें खोजें';

  @override
  String get precisionAdvisory => 'सटीक सलाह';

  @override
  String get myProfile => 'मेरी प्रोफ़ाइल';

  @override
  String get quickActions => 'त्वरित क्रियाएं';

  @override
  String get recentActivity => 'हालिया गतिविधि';

  @override
  String get noRecentActivity => 'कोई हालिया गतिविधि नहीं';

  @override
  String get storeLogin => 'दुकान लॉगिन';

  @override
  String get storeLoginSubtitle =>
      'अपनी खाद सूची प्रबंधित करने के\nलिए लॉगिन करें।';

  @override
  String get storeRegistration => 'दुकान पंजीकरण';

  @override
  String get registerStore => 'दुकान पंजीकृत करें';

  @override
  String get adminLogin => 'एडमिन लॉगिन';

  @override
  String get adminLoginSubtitle =>
      'उपयोगकर्ताओं और दुकानों को प्रबंधित करने\nके लिए नियंत्रण पैनल एक्सेस करें।';

  @override
  String get adminDashboard => 'एडमिन डैशबोर्ड';

  @override
  String get errorInvalidEmail => 'कृपया एक वैध ईमेल दर्ज करें';

  @override
  String get errorPasswordTooShort =>
      'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get errorFieldRequired => 'यह फ़ील्ड आवश्यक है';

  @override
  String get errorPasswordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get continueText => 'जारी रखें';

  @override
  String get submit => 'सबमिट करें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get ok => 'ठीक है';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get update => 'अपडेट करें';

  @override
  String get back => 'पीछे';

  @override
  String get success => 'सफलता';

  @override
  String get error => 'त्रुटि';

  @override
  String get warning => 'चेतावनी';

  @override
  String get info => 'जानकारी';

  @override
  String get noDataFound => 'कोई डेटा नहीं मिला';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया';

  @override
  String get pleaseWait => 'कृपया प्रतीक्षा करें...';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get fertilizer => 'उर्वरक';

  @override
  String get fertilizers => 'उर्वरक';

  @override
  String get store => 'दुकान';

  @override
  String get stores => 'दुकानें';

  @override
  String get crop => 'फसल';

  @override
  String get crops => 'फसलें';

  @override
  String get soil => 'मिट्टी';

  @override
  String get weather => 'मौसम';

  @override
  String get field => 'खेत';

  @override
  String get location => 'स्थान';

  @override
  String get price => 'कीमत';

  @override
  String get stock => 'स्टॉक';

  @override
  String get quantity => 'मात्रा';

  @override
  String get distance => 'दूरी';

  @override
  String get rating => 'रेटिंग';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get viewDetails => 'विवरण देखें';

  @override
  String get seeMore => 'और देखें';

  @override
  String get learnMore => 'अधिक जानें';

  @override
  String get helpSupport => 'सहायता';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get about => 'के बारे में';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get logoutConfirm => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get firebaseInitFailed => 'Firebase प्रारंभीकरण विफल';

  @override
  String get noInternetConnection => 'कोई इंटरनेट कनेक्शन नहीं';

  @override
  String get accountCreated => 'खाता सफलतापूर्वक बनाया गया!';

  @override
  String get signupFailed => 'साइनअप विफल';

  @override
  String get forgotPasswordSubtitleAlt =>
      'अपना पंजीकृत ईमेल दर्ज करें, हम रीसेट निर्देश भेजेंगे।';

  @override
  String get fertilizerSearch => 'उर्वरक खोज';

  @override
  String get fertilizerSearchSubtitle =>
      'सर्वोत्तम कीमत के साथ\nनज़दीकी दुकानें खोजें';

  @override
  String get fertilizerAdvisory => 'उर्वरक सलाह';

  @override
  String get fertilizerAdvisorySubtitle =>
      'फसल-वार उर्वरक\nमार्गदर्शन प्राप्त करें';

  @override
  String get soilHealthCheck => 'मिट्टी स्वास्थ्य जांच';

  @override
  String get soilHealthCheckSubtitle => 'आज अपना नमूना परीक्षण\nबुक करें';

  @override
  String get farmerInfo => 'किसान की जानकारी';

  @override
  String get soilDetails => 'मिट्टी का विवरण';

  @override
  String get review => 'समीक्षा';

  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get villageAddress => 'गाँव / पता';

  @override
  String get pinCodeLabel => 'पिन कोड';

  @override
  String get pinCodeHint => '६-अंकी पिन कोड';

  @override
  String get pinCodeRequired => 'पिन कोड आवश्यक है';

  @override
  String get invalidPinCode => '६-अंकी पिन कोड दर्ज करें';

  @override
  String get farmAreaAcres => 'खेत का क्षेत्रफल (एकड़)';

  @override
  String get farmAreaHint => 'उदा. २.५';

  @override
  String get farmAreaRequired => 'खेत का क्षेत्रफल आवश्यक है';

  @override
  String get soilType => 'मिट्टी का प्रकार';

  @override
  String get selectSoilType => 'मिट्टी का प्रकार चुनें';

  @override
  String get prevCropGrown => 'पिछली उगाई गई फसल';

  @override
  String get prevCropHint => 'उदा. गेहूँ, सोयाबीन';

  @override
  String get waterSource => 'पानी का स्रोत';

  @override
  String get selectWaterSource => 'पानी का स्रोत चुनें';

  @override
  String get irrigationType => 'सिंचाई का प्रकार';

  @override
  String get selectIrrigationType => 'सिंचाई का प्रकार चुनें';

  @override
  String get collectionLocation => 'संग्रह और स्थान';

  @override
  String get sampleCollectionDate => 'नमूना संग्रह की तिथि';

  @override
  String get chooseADate => 'तिथि चुनें';

  @override
  String get captureLocation => 'स्थान कैप्चर करने के लिए टैप करें';

  @override
  String get gpsLocationCaptured => 'GPS स्थान कैप्चर किया गया!';

  @override
  String get reviewDetails => 'अपने विवरण की समीक्षा करें';

  @override
  String get farmerInformation => 'किसान की जानकारी';

  @override
  String get soilFarmDetails => 'मिट्टी और खेत का विवरण';

  @override
  String get additionalNotes => 'अतिरिक्त नोट्स';

  @override
  String get notesSpecialRequests => 'नोट्स / विशेष अनुरोध';

  @override
  String get notesHint => 'कोई विशिष्ट परीक्षण या चिंताएं...';

  @override
  String get bookingConfirmed => 'बुकिंग की पुष्टि हो गई!';

  @override
  String bookingSuccessMessage(String phone) {
    return 'आपकी मिट्टी स्वास्थ्य जांच निर्धारित कर दी गई है।\nनमूना संग्रह के लिए हम आपसे $phone\nपर संपर्क करेंगे।';
  }

  @override
  String get backToHome => 'होम पर वापस जाएं';

  @override
  String get submitBooking => 'बुकिंग सबमिट करें';

  @override
  String get waterBorewell => 'बोरवेल';

  @override
  String get waterCanal => 'नहर';

  @override
  String get waterRainFed => 'वर्षा आधारित';

  @override
  String get waterRiver => 'नदी';

  @override
  String get waterTank => 'टैंक / तालाब';

  @override
  String get waterOther => 'अन्य';

  @override
  String get irrDrip => 'ड्रिप (टपक सिंचाई)';

  @override
  String get irrSprinkler => 'फव्वारा (स्प्रिंकलर)';

  @override
  String get irrFlood => 'बाढ़ / सतह सिंचाई';

  @override
  String get irrFurrow => 'नाली सिंचाई';

  @override
  String get irrNone => 'कोई नहीं (वर्षा आधारित)';

  @override
  String get gpsLocation => 'GPS स्थान';

  @override
  String get profileSubtitle => 'अपनी प्रोफ़ाइल देखें और प्रबंधित करें';

  @override
  String get welcomeFarmer => 'स्वागत है, किसान';

  @override
  String welcomeName(String name) {
    return 'स्वागत है, $name';
  }

  @override
  String get signupTitle => 'किसान खाता बनाएं';

  @override
  String get storeRegistrationSubtitle => 'चरण 1 / 2: अपनी दुकान खाता सेट करें';

  @override
  String get storeProfile => 'दुकान प्रोफ़ाइल';

  @override
  String get storeProfileStep2 => 'चरण 2: स्थान और सत्यापन';

  @override
  String get storeRegisterSuccess =>
      'दुकान सफलतापूर्वक पंजीकृत! सत्यापन की प्रतीक्षा है।';

  @override
  String get storeDataNotFound => 'दुकान डेटा नहीं मिला';

  @override
  String get noStoreAccount => 'कोई दुकान खाता नहीं? ';

  @override
  String get authenticationDetails => 'प्रमाणीकरण विवरण';

  @override
  String get storeInformation => 'दुकान जानकारी';

  @override
  String get storeName => 'दुकान का नाम';

  @override
  String get ownerName => 'मालिक का नाम';

  @override
  String get enterBusinessName => 'व्यापार का नाम दर्ज करें';

  @override
  String get enterOwnerName => 'मालिक का पूरा नाम';

  @override
  String get storeAddress => 'दुकान का पता';

  @override
  String get selectState => 'अपना राज्य चुनें';

  @override
  String get cityDistrict => 'शहर / जिला';

  @override
  String get villageArea => 'गाँव / क्षेत्र';

  @override
  String get enterCity => 'शहर दर्ज करें';

  @override
  String get enterVillage => 'गाँव दर्ज करें';

  @override
  String get fertilizerLicense => 'उर्वरक लाइसेंस नं।';

  @override
  String get mapPinInstruction =>
      'मानचित्र पर टैप करके अपनी दुकान का स्थान पिन करें';

  @override
  String get useMyLocation => 'मेरा स्थान उपयोग करें';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get pleaseSelectState => 'कृपया एक राज्य चुनें';

  @override
  String get pleaseSelectLocation => 'कृपया मानचित्र पर स्थान चुनें';

  @override
  String get failedCreateStoreProfile => 'दुकान प्रोफ़ाइल बनाने में विफल';

  @override
  String get username => 'उपयोगकर्ता नाम';

  @override
  String get enterUsername => 'उपयोगकर्ता नाम दर्ज करें';

  @override
  String get usernameRequired => 'उपयोगकर्ता नाम आवश्यक है';

  @override
  String get wrongCredentials => 'गलत उपयोगकर्ता नाम/पासवर्ड';

  @override
  String get enterPassword => 'अपना पासवर्ड दर्ज करें';

  @override
  String get storeDashboard => 'दुकान डैशबोर्ड';

  @override
  String get verified => 'सत्यापित';

  @override
  String get inventoryManagement => 'सूची प्रबंधन';

  @override
  String get updatePriceStock => 'मूल्य और स्टॉक अपडेट करें';

  @override
  String get storeLocation => 'दुकान स्थान';

  @override
  String get noFertilizersInventory => 'सूची में कोई उर्वरक नहीं';

  @override
  String get errorLoadingInventory => 'सूची लोड करने में त्रुटि';

  @override
  String get inStock => 'स्टॉक में';

  @override
  String get lowStock => 'कम स्टॉक';

  @override
  String get outOfStock => 'स्टॉक खत्म';

  @override
  String get stockBags => 'स्टॉक (बैग)';

  @override
  String get saveChanges => 'बदलाव सहेजें';

  @override
  String get enterValidNumbers => 'कृपया वैध संख्याएं दर्ज करें';

  @override
  String get appSettings => 'ऐप सेटिंग';

  @override
  String get personalDetails => 'व्यक्तिगत विवरण';

  @override
  String get language => 'भाषा';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get aboutApp => 'ऐप के बारे में';

  @override
  String get email => 'ईमेल';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get searched => 'खोजे';

  @override
  String get visits => 'दौरे';

  @override
  String get refreshingProfile => 'प्रोफ़ाइल रीफ्रेश हो रही है...';

  @override
  String get seeNearbyStores => 'खोज टैब में नजदीकी दुकानें देखें';

  @override
  String get profileImageUpdated => 'प्रोफ़ाइल छवि अपडेट हुई!';

  @override
  String get imageUploadCancelled => 'छवि अपलोड रद्द हुई';

  @override
  String get fertilizerAdvisoryTitle => 'उर्वरक सलाह';

  @override
  String get selectCrop => 'फसल चुनें';

  @override
  String get landSize => 'भूमि आकार (एकड़)';

  @override
  String get getAdvisory => 'सलाह प्राप्त करें';

  @override
  String get soilHealthTitle => 'मिट्टी स्वास्थ्य जांच';

  @override
  String get bookTest => 'परीक्षण बुक करें';

  @override
  String get nearbyStores => 'नजदीकी दुकानें';

  @override
  String get findNearbyStoreSubtitle =>
      'सर्वोत्तम कीमत पर नज़दीकी दुकानें खोजें';

  @override
  String get searchFertilizer => 'उर्वरक खोजें';

  @override
  String get supportEmail => 'ईमेल: support@kisanmitra.com';

  @override
  String get supportPhone => 'फोन: +91 1800-XXX-XXXX';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get enterYourUsername => 'उपयोगकर्ता नाम दर्ज करें';

  @override
  String get errorOccurred => 'एक त्रुटि हुई';

  @override
  String get next => 'अगला';

  @override
  String get tapToAdjust => 'स्थान समायोजित करने के लिए टैप करें';

  @override
  String get tapMapToSelect =>
      'अपनी दुकान का स्थान चुनने के लिए मानचित्र पर टैप करें';

  @override
  String get verificationDetails => 'सत्यापन विवरण';

  @override
  String get backToStep1 => 'चरण 1 पर वापस जाएं';

  @override
  String get errorInvalidLicense => 'अमान्य लाइसेंस नंबर';

  @override
  String get enterLicenseNo => '15-अंकीय GST या लाइसेंस नंबर दर्ज करें';

  @override
  String get enterLicenseInfo =>
      'सत्यापन के लिए अपना जीएसटी नंबर या स्टोर लाइसेंस दर्ज करें';

  @override
  String get emailHint => 'store@example.com';

  @override
  String get passwordHint => 'एक मजबूत पासवर्ड बनाएं';

  @override
  String get phoneHint => '+91 00000 00000';

  @override
  String get nextSteps => 'अगले कदम:';

  @override
  String get stepCheckEmail => '1. अपना ईमेल इनबॉक्स देखें';

  @override
  String get stepClickLink => '2. पासवर्ड रीसेट लिंक पर क्लिक करें';

  @override
  String get stepCreatePassword => '3. नया पासवर्ड बनाएं';

  @override
  String get stepLoginNew => '4. अपने नए पासवर्ड के साथ लॉगिन करें';

  @override
  String get didntReceiveEmail => 'ईमेल प्राप्त नहीं हुआ? पुनः प्रयास करें';

  @override
  String get nameHint => 'पूरा नाम';

  @override
  String get emailAddressHint => 'name@example.com';

  @override
  String get createPasswordHint => 'एक पासवर्ड बनाएं';

  @override
  String get statisticsUpdated => 'सांख्यिकी अपडेट की गई!';

  @override
  String get refreshStatistics => 'सांख्यिकी रीफ्रेश करें';

  @override
  String get fertilizersListed => 'सूचीबद्ध\nउर्वरक';

  @override
  String get activeStock => 'सक्रिय\nस्टॉक';

  @override
  String get farmerViews => 'किसान\nदृश्य';

  @override
  String get coordinates => 'निर्देशांक';

  @override
  String get editStoreDetails => 'स्टोर विवरण संपादित करें';

  @override
  String get confirmLogout => 'लॉगआउट की पुष्टि करें';

  @override
  String get unableToLoadMap => 'नक्शा लोड करने में असमर्थ';

  @override
  String latLngPreview(String lat, String lng) {
    return 'अक्षांश: $lat • देशांतर: $lng';
  }

  @override
  String get addressPreviewLabel => 'पता पूर्वावलोकन';

  @override
  String get profileNotFound => 'प्रोफ़ाइल नहीं मिली';

  @override
  String errorPrefix(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get saving => 'सहेज रहे हैं...';

  @override
  String get updatedSuccessfully => 'सफलतापूर्वक अपडेट किया गया';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmNewPassword => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get enterCurrentPassword => 'वर्तमान पासवर्ड दर्ज करें';

  @override
  String get enterNewPassword => 'नया पासवर्ड दर्ज करें';

  @override
  String get confirmNewPasswordHint => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get passwordLengthError => 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get currentPasswordIncorrect => 'वर्तमान पासवर्ड गलत है';

  @override
  String get passwordWeak => 'नया पासवर्ड बहुत कमजोर है';

  @override
  String get recentLoginRequired =>
      'पासवर्ड बदलने के लिए कृपया पुन: लॉगिन करें';

  @override
  String get newPasswordDifferent =>
      'नया पासवर्ड वर्तमान पासवर्ड से अलग होना चाहिए';

  @override
  String get failedToChangePassword => 'पासवर्ड बदलने में विफल';

  @override
  String get failedToLoadProfile => 'स्टोर प्रोफ़ाइल लोड करने में विफल';

  @override
  String errorLoadingProfile(String error) {
    return 'प्रोफ़ाइल लोड करने में त्रुटि: $error';
  }

  @override
  String get storeNameRequired => 'स्टोर का नाम आवश्यक है';

  @override
  String get ownerNameRequired => 'मालिक का नाम आवश्यक है';

  @override
  String get phoneRequired => 'फ़ोन नंबर आवश्यक है';

  @override
  String get phoneLengthError => 'फ़ोन नंबर 10 अंकों का होना चाहिए';

  @override
  String get addressRequired => 'पता आवश्यक है';

  @override
  String get enterAddressHint => 'पूरा पता दर्ज करें';

  @override
  String get removeImage => 'छवि हटाएं';

  @override
  String get failedToUploadImage => 'छवि अपलोड करने में विफल';

  @override
  String get failedToUpdateProfile => 'प्रोफ़ाइल अपडेट करने में विफल';

  @override
  String get emailUs => 'हमें ईमेल करें';

  @override
  String get callUs => 'हमें कॉल करें';

  @override
  String get faqs => 'अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get faq1Q => 'मैं नए उर्वरक कैसे जोड़ूं?';

  @override
  String get faq1A =>
      'एक स्टोर मालिक के रूप में, आप नए उर्वरक नहीं बना सकते। व्यवस्थापक उर्वरकों की मुख्य सूची जोड़ता है। आप केवल अपनी सूची में मौजूदा उर्वरकों के स्टॉक और कीमत का प्रबंधन कर सकते हैं।';

  @override
  String get faq2Q => 'मैं अपना स्टोर स्थान कैसे अपडेट करूं?';

  @override
  String get faq2A =>
      'स्टोर डैशबोर्ड > स्थान पर जाएं। आप अपना सटीक स्थान सेट करने के लिए मानचित्र पर टैप कर सकते हैं या \"वर्तमान स्थान का उपयोग करें\" बटन का उपयोग कर सकते हैं।';

  @override
  String get faq3Q => 'मैं अपना पासवर्ड कैसे बदल सकता हूँ?';

  @override
  String get faq3A =>
      'स्टोर प्रोफाइल > पासवर्ड बदलें पर जाएं। इसे अपडेट करने के लिए अपना वर्तमान पासवर्ड और नया पासवर्ड दर्ज करें।';

  @override
  String get faq4Q => 'मेरा स्टोर अभी तक सत्यापित क्यों नहीं हुआ है?';

  @override
  String get faq4A =>
      'सत्यापन में आमतौर पर 24-48 घंटे लगते हैं। व्यवस्थापक विवरणों को मैन्युअल रूप से सत्यापित करता है। सुनिश्चित करें कि आपकी प्रोफ़ाइल जानकारी पूर्ण है।';

  @override
  String get sendFeedback => 'प्रतिक्रिया भेजें';

  @override
  String get noContentAvailable => 'कोई सामग्री उपलब्ध नहीं है।';

  @override
  String get lessThan1Min => '1 मिनट से कम';

  @override
  String get minUnit => 'मिनट';

  @override
  String get hrUnit => 'घंटा';

  @override
  String get editProfile => 'प्रोफाइल संपादित करें';

  @override
  String get currentWeather => 'वर्तमान मौसम';

  @override
  String get seedling => 'पौध रोपण';

  @override
  String get vegetative => 'वनस्पति';

  @override
  String get flowering => 'फूल आना';

  @override
  String get fruiting => 'फलन';

  @override
  String get fieldSize => 'खेत का आकार';

  @override
  String get acres => 'एकड़';

  @override
  String get soilHealth => 'मिट्टी का स्वास्थ्य';

  @override
  String get cropIssues => 'फसल की समस्याएं';

  @override
  String get selectGrowthStage => 'वृद्धि अवस्था चुनें';

  @override
  String get selectCropIssue => 'फसल की समस्या चुनें';

  @override
  String get calculateAdvisory => 'सलाह की गणना करें';

  @override
  String get pleaseSelectACropAbove =>
      'आगे बढ़ने के लिए कृपया ऊपर एक फसल चुनें';

  @override
  String get cropPaddyRice => 'धान (चावल)';

  @override
  String get cropWheat => 'गेहूं';

  @override
  String get cropJowarSorghum => 'ज्वार (सोरघम)';

  @override
  String get cropBajraPearlMillet => 'बाजरा';

  @override
  String get cropMaizeCorn => 'मक्का (कॉर्न)';

  @override
  String get cropRagiFingerMillet => 'रागी';

  @override
  String get cropBarley => 'जौ';

  @override
  String get cropOats => 'जई';

  @override
  String get cropTurPigeonPea => 'अरहर (तूर)';

  @override
  String get cropMoongGreenGram => 'मूँग';

  @override
  String get cropUradBlackGram => 'उड़द';

  @override
  String get cropChickpeaGram => 'चना';

  @override
  String get cropMasoorRedLentil => 'मसूर';

  @override
  String get cropCowpeaLobia => 'लोबिया';

  @override
  String get cropHorseGramKulthi => 'कुलथी';

  @override
  String get cropSoybean => 'सोयाबीन';

  @override
  String get cropGroundnutPeanut => 'मूँगफली';

  @override
  String get cropSunflower => 'सूरजमुखी';

  @override
  String get cropMustardRapeseed => 'सरसों';

  @override
  String get cropSesameTil => 'तिल';

  @override
  String get cropLinseedFlax => 'अलसी';

  @override
  String get cropCastor => 'अरंडी';

  @override
  String get cropSafflower => 'कुसुम';

  @override
  String get cropCotton => 'कपास';

  @override
  String get cropSugarcane => 'गन्ना';

  @override
  String get cropJute => 'जूट';

  @override
  String get cropTobacco => 'तंबाकू';

  @override
  String get cropTomato => 'टमाटर';

  @override
  String get cropOnion => 'प्याज';

  @override
  String get cropPotato => 'आलू';

  @override
  String get cropBrinjalEggplant => 'बैंगन';

  @override
  String get cropOkraBhindi => 'भिंडी';

  @override
  String get cropChiliHotPepper => 'मिर्च';

  @override
  String get cropCapsicumBellPepper => 'शिमला मिर्च';

  @override
  String get cropCauliflower => 'फूलगोभी';

  @override
  String get cropCabbage => 'पत्तागोभी';

  @override
  String get cropCucumber => 'खीरा';

  @override
  String get cropBitterGourdKarela => 'करेला';

  @override
  String get cropBottleGourdLauki => 'लौकी';

  @override
  String get cropPumpkin => 'कद्दू';

  @override
  String get cropWatermelon => 'तरबूज';

  @override
  String get cropMuskmelonKharbooj => 'खरबूजा';

  @override
  String get cropGarlic => 'लहसुन';

  @override
  String get cropSpinachPalak => 'पालक';

  @override
  String get cropFenugreekMethi => 'मेथी';

  @override
  String get cropCarrot => 'गाजर';

  @override
  String get cropRadishMooli => 'मूली';

  @override
  String get cropMango => 'आम';

  @override
  String get cropBanana => 'केला';

  @override
  String get cropGrapes => 'अंगूर';

  @override
  String get cropPomegranate => 'अनार';

  @override
  String get cropOrangeNagpur => 'संतरा';

  @override
  String get cropPapaya => 'पपीता';

  @override
  String get cropGuava => 'अमरूद';

  @override
  String get cropCoconut => 'नारियल';

  @override
  String get cropCustardAppleSitaphal => 'शरीफा (सीताफल)';

  @override
  String get cropLemon => 'नींबू';

  @override
  String get cropStrawberry => 'स्ट्रॉबेरी';

  @override
  String get cropFigAnjeer => 'अंजीर';

  @override
  String get cropSweetLimeMosambi => 'मौसंबी';

  @override
  String get cropJackfruit => 'कटहल';

  @override
  String get cropSapodillaChiku => 'चीकू';

  @override
  String get cropTurmericHaldi => 'हल्दी';

  @override
  String get cropGingerAdrak => 'अदरक';

  @override
  String get cropCorianderDhaniya => 'धनिया';

  @override
  String get cropCuminJeera => 'जीरा';

  @override
  String get cropFennelSaunf => 'सौंफ';

  @override
  String get cropCardamomElaichi => 'इलायची';

  @override
  String get cropPepperKaliMirch => 'काली मिर्च';

  @override
  String get cropTea => 'चाय';

  @override
  String get cropCoffee => 'कॉफी';

  @override
  String get cropRubber => 'रबर';

  @override
  String get cropSweetPotato => 'शकरकंद';

  @override
  String get cropTapiocaCassava => 'टैपियोका (साबूदाना)';

  @override
  String get cropColocasiaArbi => 'अरबी';

  @override
  String get cropLucerneAlfalfa => 'अल्फाल्फा';

  @override
  String get cropBerseemClover => 'बरसीम';

  @override
  String get cropNapierGrass => 'नेपियर घास';

  @override
  String get cropMarigold => 'गेंदा';

  @override
  String get cropRose => 'गुलाब';

  @override
  String get cropJasmineMogra => 'मोगरा';

  @override
  String get cropChrysanthemum => 'गुलदाउदी';

  @override
  String get cropTuberoseRajnigandha => 'रजनीगंधा';

  @override
  String get cropFrenchBeans => 'फ्रेंच बीन्स';

  @override
  String get cropPeasMatar => 'मटर';

  @override
  String get cropBeetroot => 'चुकंदर';

  @override
  String get cropTurnipShalgam => 'शलजम';

  @override
  String get cropDrumstickMoringa => 'सहजन (मुनगा)';

  @override
  String get cropSnakeGourd => 'चिचिंडा';

  @override
  String get cropSpongeGourdTurai => 'तोरई (गिलकी)';

  @override
  String get cropRidgeGourdTorai => 'तोरई';

  @override
  String get cropLettuce => 'लेट्यूस';

  @override
  String get cropSweetCorn => 'स्वीट कॉर्न';

  @override
  String get cropApple => 'सेब';

  @override
  String get cropPineapple => 'अननास';

  @override
  String get cropAvocado => 'एवोकैडो';

  @override
  String get cropAloeVera => 'एलोवेरा';

  @override
  String get cropStevia => 'स्टीविया';

  @override
  String get cropAshwagandha => 'अश्वगंधा';

  @override
  String get transplanting => 'प्रत्यारोपण';

  @override
  String get tillering => 'कल्ले फूटना';

  @override
  String get panicleInitiation => 'बाली शुरुआत';

  @override
  String get panicleEmergence => 'बाली निकलना';

  @override
  String get jointing => 'संधि';

  @override
  String get booting => 'जूते का चरण';

  @override
  String get grainFill => 'अनाज भरना';

  @override
  String get kneeHigh => 'घुटने की ऊंचाई';

  @override
  String get tasseling => 'बालियां निकलना';

  @override
  String get silking => 'रेशम निकलना';

  @override
  String get dough => 'आटा चरण';

  @override
  String get podDevelopment => 'फली विकास';

  @override
  String get germination => 'अंकुरण';

  @override
  String get selectedCrop => 'चयनित फसल';

  @override
  String get irrigation => 'सिंचाई';

  @override
  String get micronutrients => 'सूक्ष्म पोषक तत्व';

  @override
  String get organicAlternatives => 'जैव विकल्प';

  @override
  String get all => 'सभी';

  @override
  String get maturity => 'परिपक्वता';

  @override
  String get failedToLoadCrops => 'फसलें लोड करने में विफल';

  @override
  String get hectares => 'हेक्टेयर';

  @override
  String get soilLoamy => 'दोमट';

  @override
  String get soilClay => 'चिकनी मिट्टी';

  @override
  String get soilSandy => 'बलुई मिट्टी';

  @override
  String get soilBlack => 'काली मिट्टी';

  @override
  String get soilRed => 'लाल मिट्टी';

  @override
  String get soilAlluvial => 'जलोढ़';

  @override
  String get soilSaline => 'खारी मिट्टी';

  @override
  String get issueYellowLeaves => 'पीली पत्तियां';

  @override
  String get issueStuntedGrowth => 'रुकी हुई वृद्धि';

  @override
  String get issuePestAttack => 'कीट का हमला';

  @override
  String get issueFungalDisease => 'फंगल रोग';

  @override
  String get issueWilting => 'पत्तियों का मुरझाना';

  @override
  String get issueLowYield => 'कम उपज';

  @override
  String get rainExpectedWarning =>
      'बारिश की संभावना! खाद लगाने में देरी करने पर विचार करें।';

  @override
  String totalEstimatedCost(String cost) {
    return 'कुल अनुमानित लागत: ₹$cost';
  }

  @override
  String get kg => 'किलोग्राम';

  @override
  String get kgPerAcre => 'किलोग्राम प्रति एकड़';

  @override
  String get method => 'विधि';

  @override
  String get timing => 'समय';

  @override
  String get precautionsLabel => 'सावधानियां:';

  @override
  String rainProbabilityAmount(String amount) {
    return '$amount% बारिश';
  }

  @override
  String get budDifferentiation => 'कली विभेदन';

  @override
  String get fruitSet => 'फल जमना';

  @override
  String get fruitDevelopment => 'फल विकास';

  @override
  String get flowerBud => 'पुष्प कलिका';

  @override
  String get juvenile => 'किशोर अवस्था';

  @override
  String get bearing => 'फल आना';

  @override
  String get fullProduction => 'पूर्ण उत्पादन';

  @override
  String get shootEmergence => 'अंकुर निकलना';

  @override
  String get rhizomeDevelopment => 'प्रकंद विकास';

  @override
  String get capsuleDevelopment => 'कैप्सूल विकास';

  @override
  String get nursery => 'नर्सरी';

  @override
  String get plucking => 'तुड़ाई';

  @override
  String get youngPlantation => 'युवा वृक्षारोपण';

  @override
  String get fullBearing => 'पूर्ण फलन';

  @override
  String get immature => 'अपरिपक्व';

  @override
  String get tapping => 'टैपिंग';

  @override
  String get tuberDevelopment => 'कंद विकास';

  @override
  String get cormDevelopment => 'कॉर्म विकास';

  @override
  String get cutting => 'कटाई';

  @override
  String get bud => 'कली';

  @override
  String get establishment => 'स्थापना';

  @override
  String get budInitiation => 'कली की शुरुआत';

  @override
  String get spikeEmergence => 'बाली निकलना';

  @override
  String get podFill => 'फली भरना';

  @override
  String get rootDevelopment => 'जड़ विकास';

  @override
  String get rootSwelling => 'जड़ का फूलना';

  @override
  String get budBreak => 'कली फूटना';

  @override
  String get flowerInduction => 'फूल प्रेरण';

  @override
  String get cropBajraMillet => 'बाजरा (मोती बाजरा)';

  @override
  String get fertUrea => 'यूरिया';

  @override
  String get fertDAP => 'डीएपी (डि-अमोनियम फॉस्फेट)';

  @override
  String get fertMOP => 'एमओपी (म्यूरेट ऑफ पोटाश)';

  @override
  String get fertTSP => 'टीएसपी (ट्रिपल सुपर फॉस्फेट)';

  @override
  String get fertSSP => 'एसएसपी (सिंगल सुपर फॉस्फेट)';

  @override
  String get fertCAN => 'कैन (कैल्शियम अमोनियम नाइट्रेट)';

  @override
  String get fertSOP => 'एसओपी (सल्फेट ऑफ पोटाश)';

  @override
  String get fertNPK19 => 'विशेष घुलनशील एनपीके (19:19:19)';

  @override
  String get fertGrowthPromoter => 'विकास प्रवर्तक (समुद्री शैवाल का अर्क)';

  @override
  String get methodBroadcast => 'छिड़काव (ब्रॉडकास्ट)';

  @override
  String get methodTopDressing => 'ऊपरी ड्रेसिंग (टॉप ड्रेसिंग)';

  @override
  String get methodSoilPlacement => 'मिट्टी में डालना (ड्रिलिंग)';

  @override
  String get methodFoliarSpray => 'पत्तियों पर छिड़काव (फोलियर स्प्रे)';

  @override
  String get timeBasalEarly => 'आधार / प्रारंभिक चरण';

  @override
  String get timeSplit3Doses =>
      '3 खुराकों में विभाजित करें (बुआई, 30 दिन, 60 दिन बाद)';

  @override
  String get timeSplit2Doses => 'खुराक विभाजित करें: 1/2 अभी, 1/2 बाद में';

  @override
  String get timeBasalSowing => 'आधार (बुआई के समय)';

  @override
  String get timeEvening => 'शाम को लागू करना सबसे अच्छा रहता है';

  @override
  String get adviceNormalIrrigation =>
      'सामान्य सिंचाई कार्यक्रम की सिफारिश की जाती है।';

  @override
  String get adviceRainWarning =>
      'भारी बारिश की आशंका। लीचिंग को रोकने के लिए सिंचाई और उर्वरक प्रयोग में देरी करें।';

  @override
  String get adviceHeatWarning =>
      'उच्च तापमान का पता चला। झुलसने से बचाने के लिए उर्वरक लगाने से पहले मिट्टी में पर्याप्त नमी सुनिश्चित करें।';

  @override
  String get precHighRain =>
      'गंभीर: भारी बारिश का पूर्वानुमान। प्रयोग में देरी करें।';

  @override
  String get precAcidicSoil =>
      'इसमें कैल्शियम होता है जो अम्लता को बेअसर करने में मदद करता है।';

  @override
  String get precLeafCoverage =>
      'सुनिश्चित करें कि पत्तियों पर अच्छी तरह से छिड़काव हो।';

  @override
  String get precMixWater => 'पानी में अच्छी तरह मिलाएं।';

  @override
  String get orgFYM => 'गोबर की खाद (FYM): 2-3 टन/एकड़';

  @override
  String get orgVermicompost => 'वर्मीकंपोस्ट: 500 किग्रा/एकड़';

  @override
  String get orgGreenManure =>
      'हरी खाद (सेसबानिया) जल प्रतिधारण क्षमता में सुधार के लिए';

  @override
  String get orgBioFertilizer =>
      'जैव-उर्वरक (एज़ोटोबैक्टर/पीएसबी) विकास को बढ़ावा देने के लिए';

  @override
  String get microZinc => 'जिंक सल्फेट (10 किग्रा/एकड़) - जिंक की कमी की जाँच';

  @override
  String get microIron => 'फेरस सल्फेट स्प्रे - आयरन की कमी की जाँच';

  @override
  String get microZincPaddy =>
      'धान के लिए जिंक महत्वपूर्ण है। आधार प्रयोग सुनिश्चित करें।';

  @override
  String get nitrogen => 'नाइट्रोजन (N)';

  @override
  String get phosphorus => 'फास्फोरस (P)';

  @override
  String get potassium => 'पोटेशियम (K)';

  @override
  String get phLevel => 'मिट्टी का पीएच (pH)';

  @override
  String get low => 'कम';

  @override
  String get medium => 'मध्यम';

  @override
  String get high => 'अधिक';

  @override
  String get soilLaterite => 'लैटेराइट मिट्टी';

  @override
  String get soilPeaty => 'पीठ मिट्टी';

  @override
  String get soilArid => 'शुष्क (रेगिस्तानी) मिट्टी';

  @override
  String get smartSoilAnalyzer => 'स्मार्ट मिट्टी विश्लेषक';

  @override
  String get smartSoilAnalyzerSubtitle =>
      'स्मार्टफोन माइक्रोफोन से\nमिट्टी का विश्लेषण करें';

  @override
  String get soilRecordInstruction =>
      'मिट्टी में एक धातु की छड़ डालें और धीरे से टैप करें। ध्वनि रिकॉर्ड करने के लिए फ़ोन को पास रखें।';

  @override
  String get soilStepInsert => 'डालें';

  @override
  String get soilStepTap => 'टैप करें';

  @override
  String get soilStepRecord => 'रिकॉर्ड';

  @override
  String get soilTapToRecord => 'रिकॉर्ड शुरू करने के लिए टैप करें';

  @override
  String get soilTapToStop => 'रोकने के लिए टैप करें';

  @override
  String get soilProcessing => 'प्रोसेसिंग...';

  @override
  String get soilKeepRecording => 'रिकॉर्डिंग जारी रखें...';

  @override
  String get soilCanStopNow => 'अब आप रोक सकते हैं';

  @override
  String get soilAnalyzing => 'मिट्टी का विश्लेषण हो रहा है...';

  @override
  String get soilAnalyzingSubtext =>
      'ऑडियो विशेषताएं निकाली जा रही हैं और मिट्टी का विश्लेषण किया जा रहा है। कुछ समय लग सकता है।';

  @override
  String get soilResultsTitle => 'मिट्टी विश्लेषण परिणाम';

  @override
  String get soilAnalysisResults => 'मिट्टी विश्लेषण';

  @override
  String get soilMoistureLabel => 'नमी';

  @override
  String get soilMoistureLow => 'कम';

  @override
  String get soilMoistureMedium => 'मध्यम';

  @override
  String get soilMoistureHigh => 'अधिक';

  @override
  String get soilDensityLabel => 'घनत्व';

  @override
  String get soilDensityLoose => 'ढीली';

  @override
  String get soilDensityMedium => 'मध्यम';

  @override
  String get soilDensityCompact => 'सघन';

  @override
  String get soilCompactionLabel => 'संघनन स्तर';

  @override
  String get soilConfidenceLabel => 'विश्लेषण विश्वसनीयता';

  @override
  String get soilWeatherContext => 'मौसम संदर्भ';

  @override
  String get soilWarnings => 'चेतावनियाँ';

  @override
  String get soilFertilizerPlan => 'उर्वरक सिफारिशें';

  @override
  String get soilIrrigationAdvice => 'सिंचाई सलाह';

  @override
  String get soilAnalyzeAgain => 'फिर से विश्लेषण करें';

  @override
  String get soilErrorMicPermission =>
      'माइक्रोफोन अनुमति आवश्यक है। कृपया डिवाइस सेटिंग्स में अनुमति दें और पुनः प्रयास करें।';

  @override
  String get soilErrorTooShort =>
      'रिकॉर्डिंग बहुत छोटी है। कृपया कम से कम 5 सेकंड रिकॉर्ड करें।';

  @override
  String get soilErrorNoSignal =>
      'कोई स्पष्ट संकेत नहीं मिला। कृपया सुनिश्चित करें कि आप धातु की छड़ को माइक्रोफोन के पास टैप कर रहे हैं।';

  @override
  String get soilErrorGeneral =>
      'विश्लेषण के दौरान कुछ गलत हो गया। कृपया पुनः प्रयास करें।';
}
