import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Kisan Mitra'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'\"BEEJ SE BAZAR TAK\"'**
  String get appTagline;

  /// No description provided for @appSmartFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Smart Fertilizer Finder'**
  String get appSmartFertilizer;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Your Role'**
  String get selectRole;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @selectRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your role to continue'**
  String get selectRoleSubtitle;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help? '**
  String get needHelp;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @contactSupportEmail.
  ///
  /// In en, this message translates to:
  /// **'Email: support@kisanmitra.com'**
  String get contactSupportEmail;

  /// No description provided for @contactSupportPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone: +91 1800-XXX-XXXX'**
  String get contactSupportPhone;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @farmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get farmer;

  /// No description provided for @farmerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search fertilizers and find stores'**
  String get farmerSubtitle;

  /// No description provided for @storeOwner.
  ///
  /// In en, this message translates to:
  /// **'Store Owner'**
  String get storeOwner;

  /// No description provided for @storeOwnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage inventory and prices'**
  String get storeOwnerSubtitle;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @adminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify stores and manage system'**
  String get adminSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to find nearby fertilizer stores\neasily'**
  String get loginSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @invalidRole.
  ///
  /// In en, this message translates to:
  /// **'Invalid role. Please use the correct login.'**
  String get invalidRole;

  /// No description provided for @userDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'User data not found'**
  String get userDataNotFound;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String anErrorOccurred(String error);

  /// No description provided for @failedToCreateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to create profile. Please try again.'**
  String get failedToCreateProfile;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed'**
  String get googleSignInFailed;

  /// No description provided for @googleAccountDifferentRole.
  ///
  /// In en, this message translates to:
  /// **'This Google account is registered with a different role.'**
  String get googleAccountDifferentRole;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register to access fertilizer recommendations and nearby stores'**
  String get signupSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @village.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get village;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a reset link'**
  String get forgotPasswordSubtitle;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Reset email sent! Check your inbox.'**
  String get emailSent;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @advisory.
  ///
  /// In en, this message translates to:
  /// **'Advisory'**
  String get advisory;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String homeGreeting(String name);

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the best fertilizers near you'**
  String get homeSubtitle;

  /// No description provided for @searchFertilizers.
  ///
  /// In en, this message translates to:
  /// **'Search Fertilizers'**
  String get searchFertilizers;

  /// No description provided for @findNearbyStores.
  ///
  /// In en, this message translates to:
  /// **'Find Nearby Stores'**
  String get findNearbyStores;

  /// No description provided for @precisionAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Precision Advisory'**
  String get precisionAdvisory;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @storeLogin.
  ///
  /// In en, this message translates to:
  /// **'Store Login'**
  String get storeLogin;

  /// No description provided for @storeLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to manage your fertilizer inventory\nand track orders.'**
  String get storeLoginSubtitle;

  /// No description provided for @storeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Store Registration'**
  String get storeRegistration;

  /// No description provided for @registerStore.
  ///
  /// In en, this message translates to:
  /// **'Register Store'**
  String get registerStore;

  /// No description provided for @adminLogin.
  ///
  /// In en, this message translates to:
  /// **'Admin Login'**
  String get adminLogin;

  /// No description provided for @adminLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access the control panel to manage users and\nstores.'**
  String get adminLoginSubtitle;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get errorInvalidEmail;

  /// No description provided for @errorPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorPasswordTooShort;

  /// No description provided for @errorFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errorFieldRequired;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordMismatch;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @fertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get fertilizer;

  /// No description provided for @fertilizers.
  ///
  /// In en, this message translates to:
  /// **'Fertilizers'**
  String get fertilizers;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @stores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores;

  /// No description provided for @crop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get crop;

  /// No description provided for @crops.
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get crops;

  /// No description provided for @soil.
  ///
  /// In en, this message translates to:
  /// **'Soil'**
  String get soil;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @field.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get field;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @firebaseInitFailed.
  ///
  /// In en, this message translates to:
  /// **'Firebase initialization failed'**
  String get firebaseInitFailed;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreated;

  /// No description provided for @signupFailed.
  ///
  /// In en, this message translates to:
  /// **'Signup failed'**
  String get signupFailed;

  /// No description provided for @forgotPasswordSubtitleAlt.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email and we\'ll send reset instructions.'**
  String get forgotPasswordSubtitleAlt;

  /// No description provided for @fertilizerSearch.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Search'**
  String get fertilizerSearch;

  /// No description provided for @fertilizerSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find nearby stores with\nbest price'**
  String get fertilizerSearchSubtitle;

  /// No description provided for @fertilizerAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Advisory'**
  String get fertilizerAdvisory;

  /// No description provided for @fertilizerAdvisorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get crop-wise fertilizer\nguidance'**
  String get fertilizerAdvisorySubtitle;

  /// No description provided for @soilHealthCheck.
  ///
  /// In en, this message translates to:
  /// **'Soil Health Check'**
  String get soilHealthCheck;

  /// No description provided for @soilHealthCheckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book your sample test\ntoday'**
  String get soilHealthCheckSubtitle;

  /// No description provided for @farmerInfo.
  ///
  /// In en, this message translates to:
  /// **'Farmer Info'**
  String get farmerInfo;

  /// No description provided for @soilDetails.
  ///
  /// In en, this message translates to:
  /// **'Soil Details'**
  String get soilDetails;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @villageAddress.
  ///
  /// In en, this message translates to:
  /// **'Village / Address'**
  String get villageAddress;

  /// No description provided for @pinCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pin Code'**
  String get pinCodeLabel;

  /// No description provided for @pinCodeHint.
  ///
  /// In en, this message translates to:
  /// **'6-digit pin code'**
  String get pinCodeHint;

  /// No description provided for @pinCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Pin code is required'**
  String get pinCodeRequired;

  /// No description provided for @invalidPinCode.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit pin code'**
  String get invalidPinCode;

  /// No description provided for @farmAreaAcres.
  ///
  /// In en, this message translates to:
  /// **'Farm Area (Acres)'**
  String get farmAreaAcres;

  /// No description provided for @farmAreaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2.5'**
  String get farmAreaHint;

  /// No description provided for @farmAreaRequired.
  ///
  /// In en, this message translates to:
  /// **'Farm area required'**
  String get farmAreaRequired;

  /// No description provided for @soilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get soilType;

  /// No description provided for @selectSoilType.
  ///
  /// In en, this message translates to:
  /// **'Select soil type'**
  String get selectSoilType;

  /// No description provided for @prevCropGrown.
  ///
  /// In en, this message translates to:
  /// **'Previous Crop Grown'**
  String get prevCropGrown;

  /// No description provided for @prevCropHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Wheat, Soybean'**
  String get prevCropHint;

  /// No description provided for @waterSource.
  ///
  /// In en, this message translates to:
  /// **'Water Source'**
  String get waterSource;

  /// No description provided for @selectWaterSource.
  ///
  /// In en, this message translates to:
  /// **'Select water source'**
  String get selectWaterSource;

  /// No description provided for @irrigationType.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Type'**
  String get irrigationType;

  /// No description provided for @selectIrrigationType.
  ///
  /// In en, this message translates to:
  /// **'Select irrigation type'**
  String get selectIrrigationType;

  /// No description provided for @collectionLocation.
  ///
  /// In en, this message translates to:
  /// **'Collection & Location'**
  String get collectionLocation;

  /// No description provided for @sampleCollectionDate.
  ///
  /// In en, this message translates to:
  /// **'Sample Collection Date'**
  String get sampleCollectionDate;

  /// No description provided for @chooseADate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get chooseADate;

  /// No description provided for @captureLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap to capture location'**
  String get captureLocation;

  /// No description provided for @gpsLocationCaptured.
  ///
  /// In en, this message translates to:
  /// **'GPS Location captured!'**
  String get gpsLocationCaptured;

  /// No description provided for @reviewDetails.
  ///
  /// In en, this message translates to:
  /// **'Review Your Details'**
  String get reviewDetails;

  /// No description provided for @farmerInformation.
  ///
  /// In en, this message translates to:
  /// **'Farmer Information'**
  String get farmerInformation;

  /// No description provided for @soilFarmDetails.
  ///
  /// In en, this message translates to:
  /// **'Soil & Farm Details'**
  String get soilFarmDetails;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @notesSpecialRequests.
  ///
  /// In en, this message translates to:
  /// **'Notes / Special Requests'**
  String get notesSpecialRequests;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Any specific tests or concerns...'**
  String get notesHint;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmed;

  /// No description provided for @bookingSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your soil health check has been scheduled.\nWe will contact you at {phone}\nfor sample collection.'**
  String bookingSuccessMessage(String phone);

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @submitBooking.
  ///
  /// In en, this message translates to:
  /// **'Submit Booking'**
  String get submitBooking;

  /// No description provided for @waterBorewell.
  ///
  /// In en, this message translates to:
  /// **'Borewell'**
  String get waterBorewell;

  /// No description provided for @waterCanal.
  ///
  /// In en, this message translates to:
  /// **'Canal'**
  String get waterCanal;

  /// No description provided for @waterRainFed.
  ///
  /// In en, this message translates to:
  /// **'Rain-fed'**
  String get waterRainFed;

  /// No description provided for @waterRiver.
  ///
  /// In en, this message translates to:
  /// **'River'**
  String get waterRiver;

  /// No description provided for @waterTank.
  ///
  /// In en, this message translates to:
  /// **'Tank / Pond'**
  String get waterTank;

  /// No description provided for @waterOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get waterOther;

  /// No description provided for @irrDrip.
  ///
  /// In en, this message translates to:
  /// **'Drip'**
  String get irrDrip;

  /// No description provided for @irrSprinkler.
  ///
  /// In en, this message translates to:
  /// **'Sprinkler'**
  String get irrSprinkler;

  /// No description provided for @irrFlood.
  ///
  /// In en, this message translates to:
  /// **'Flood / Surface'**
  String get irrFlood;

  /// No description provided for @irrFurrow.
  ///
  /// In en, this message translates to:
  /// **'Furrow'**
  String get irrFurrow;

  /// No description provided for @irrNone.
  ///
  /// In en, this message translates to:
  /// **'None (Rain-fed)'**
  String get irrNone;

  /// No description provided for @gpsLocation.
  ///
  /// In en, this message translates to:
  /// **'GPS Location'**
  String get gpsLocation;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage your\nprofile'**
  String get profileSubtitle;

  /// No description provided for @welcomeFarmer.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Farmer'**
  String get welcomeFarmer;

  /// No description provided for @welcomeName.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeName(String name);

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Farmer Account'**
  String get signupTitle;

  /// No description provided for @storeRegistrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2: Let\'s set up your store account'**
  String get storeRegistrationSubtitle;

  /// No description provided for @storeProfile.
  ///
  /// In en, this message translates to:
  /// **'Store Profile'**
  String get storeProfile;

  /// No description provided for @storeProfileStep2.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Location & Verification'**
  String get storeProfileStep2;

  /// No description provided for @storeRegisterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Store registered successfully! Awaiting verification.'**
  String get storeRegisterSuccess;

  /// No description provided for @storeDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Store data not found'**
  String get storeDataNotFound;

  /// No description provided for @noStoreAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a store account? '**
  String get noStoreAccount;

  /// No description provided for @authenticationDetails.
  ///
  /// In en, this message translates to:
  /// **'AUTHENTICATION DETAILS'**
  String get authenticationDetails;

  /// No description provided for @storeInformation.
  ///
  /// In en, this message translates to:
  /// **'STORE INFORMATION'**
  String get storeInformation;

  /// No description provided for @storeName.
  ///
  /// In en, this message translates to:
  /// **'Store Name'**
  String get storeName;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get ownerName;

  /// No description provided for @enterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Enter your business name'**
  String get enterBusinessName;

  /// No description provided for @enterOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Full name of proprietor'**
  String get enterOwnerName;

  /// No description provided for @storeAddress.
  ///
  /// In en, this message translates to:
  /// **'Store Address'**
  String get storeAddress;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select your state'**
  String get selectState;

  /// No description provided for @cityDistrict.
  ///
  /// In en, this message translates to:
  /// **'City / District'**
  String get cityDistrict;

  /// No description provided for @villageArea.
  ///
  /// In en, this message translates to:
  /// **'Village / Area'**
  String get villageArea;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get enterCity;

  /// No description provided for @enterVillage.
  ///
  /// In en, this message translates to:
  /// **'Enter village'**
  String get enterVillage;

  /// No description provided for @fertilizerLicense.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer License No.'**
  String get fertilizerLicense;

  /// No description provided for @mapPinInstruction.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to pin your store location'**
  String get mapPinInstruction;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use My Location'**
  String get useMyLocation;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @pleaseSelectState.
  ///
  /// In en, this message translates to:
  /// **'Please select a state'**
  String get pleaseSelectState;

  /// No description provided for @pleaseSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select location on map'**
  String get pleaseSelectLocation;

  /// No description provided for @failedCreateStoreProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to create store profile'**
  String get failedCreateStoreProfile;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsername;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @wrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong username/password'**
  String get wrongCredentials;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @storeDashboard.
  ///
  /// In en, this message translates to:
  /// **'Store Dashboard'**
  String get storeDashboard;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED'**
  String get verified;

  /// No description provided for @inventoryManagement.
  ///
  /// In en, this message translates to:
  /// **'INVENTORY MANAGEMENT'**
  String get inventoryManagement;

  /// No description provided for @updatePriceStock.
  ///
  /// In en, this message translates to:
  /// **'Update Price & Stock'**
  String get updatePriceStock;

  /// No description provided for @storeLocation.
  ///
  /// In en, this message translates to:
  /// **'Store Location'**
  String get storeLocation;

  /// No description provided for @noFertilizersInventory.
  ///
  /// In en, this message translates to:
  /// **'No fertilizers in inventory'**
  String get noFertilizersInventory;

  /// No description provided for @errorLoadingInventory.
  ///
  /// In en, this message translates to:
  /// **'Error loading inventory'**
  String get errorLoadingInventory;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'IN STOCK'**
  String get inStock;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'LOW STOCK'**
  String get lowStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'OUT OF STOCK'**
  String get outOfStock;

  /// No description provided for @stockBags.
  ///
  /// In en, this message translates to:
  /// **'STOCK (BAGS)'**
  String get stockBags;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @enterValidNumbers.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid numbers'**
  String get enterValidNumbers;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'APP SETTINGS'**
  String get appSettings;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'PERSONAL DETAILS'**
  String get personalDetails;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @searched.
  ///
  /// In en, this message translates to:
  /// **'Searched'**
  String get searched;

  /// No description provided for @visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get visits;

  /// No description provided for @refreshingProfile.
  ///
  /// In en, this message translates to:
  /// **'Refreshing profile...'**
  String get refreshingProfile;

  /// No description provided for @seeNearbyStores.
  ///
  /// In en, this message translates to:
  /// **'See nearby stores in Search tab'**
  String get seeNearbyStores;

  /// No description provided for @profileImageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile image updated!'**
  String get profileImageUpdated;

  /// No description provided for @imageUploadCancelled.
  ///
  /// In en, this message translates to:
  /// **'Image upload cancelled'**
  String get imageUploadCancelled;

  /// No description provided for @fertilizerAdvisoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Advisory'**
  String get fertilizerAdvisoryTitle;

  /// No description provided for @selectCrop.
  ///
  /// In en, this message translates to:
  /// **'Select Crop'**
  String get selectCrop;

  /// No description provided for @landSize.
  ///
  /// In en, this message translates to:
  /// **'Land Size (acres)'**
  String get landSize;

  /// No description provided for @getAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Get Advisory'**
  String get getAdvisory;

  /// No description provided for @soilHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Health Check'**
  String get soilHealthTitle;

  /// No description provided for @bookTest.
  ///
  /// In en, this message translates to:
  /// **'Book Test'**
  String get bookTest;

  /// No description provided for @nearbyStores.
  ///
  /// In en, this message translates to:
  /// **'Nearby Stores'**
  String get nearbyStores;

  /// No description provided for @findNearbyStoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find nearby stores for best prices'**
  String get findNearbyStoreSubtitle;

  /// No description provided for @searchFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Search Fertilizer'**
  String get searchFertilizer;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'Email: support@kisanmitra.com'**
  String get supportEmail;

  /// No description provided for @supportPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone: +91 1800-XXX-XXXX'**
  String get supportPhone;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterYourUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterYourUsername;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @tapToAdjust.
  ///
  /// In en, this message translates to:
  /// **'Tap to adjust location'**
  String get tapToAdjust;

  /// No description provided for @tapMapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap on map to select your store location'**
  String get tapMapToSelect;

  /// No description provided for @verificationDetails.
  ///
  /// In en, this message translates to:
  /// **'Verification Details'**
  String get verificationDetails;

  /// No description provided for @backToStep1.
  ///
  /// In en, this message translates to:
  /// **'Back to Step 1'**
  String get backToStep1;

  /// No description provided for @errorInvalidLicense.
  ///
  /// In en, this message translates to:
  /// **'Invalid license number'**
  String get errorInvalidLicense;

  /// No description provided for @enterLicenseNo.
  ///
  /// In en, this message translates to:
  /// **'Enter 15-digit GST or License No.'**
  String get enterLicenseNo;

  /// No description provided for @enterLicenseInfo.
  ///
  /// In en, this message translates to:
  /// **'Enter your GST number or store license for verification'**
  String get enterLicenseInfo;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'store@example.com'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get passwordHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+91 00000 00000'**
  String get phoneHint;

  /// No description provided for @nextSteps.
  ///
  /// In en, this message translates to:
  /// **'Next Steps:'**
  String get nextSteps;

  /// No description provided for @stepCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'1. Check your email inbox'**
  String get stepCheckEmail;

  /// No description provided for @stepClickLink.
  ///
  /// In en, this message translates to:
  /// **'2. Click the reset password link'**
  String get stepClickLink;

  /// No description provided for @stepCreatePassword.
  ///
  /// In en, this message translates to:
  /// **'3. Create a new password'**
  String get stepCreatePassword;

  /// No description provided for @stepLoginNew.
  ///
  /// In en, this message translates to:
  /// **'4. Login with your new password'**
  String get stepLoginNew;

  /// No description provided for @didntReceiveEmail.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive email? Try again'**
  String get didntReceiveEmail;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get nameHint;

  /// No description provided for @emailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailAddressHint;

  /// No description provided for @createPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPasswordHint;

  /// No description provided for @statisticsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Statistics updated!'**
  String get statisticsUpdated;

  /// No description provided for @refreshStatistics.
  ///
  /// In en, this message translates to:
  /// **'Refresh Statistics'**
  String get refreshStatistics;

  /// No description provided for @fertilizersListed.
  ///
  /// In en, this message translates to:
  /// **'FERTILIZERS\nLISTED'**
  String get fertilizersListed;

  /// No description provided for @activeStock.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE\nSTOCK'**
  String get activeStock;

  /// No description provided for @farmerViews.
  ///
  /// In en, this message translates to:
  /// **'FARMER\nVIEWS'**
  String get farmerViews;

  /// No description provided for @coordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinates'**
  String get coordinates;

  /// No description provided for @editStoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Store Details'**
  String get editStoreDetails;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @unableToLoadMap.
  ///
  /// In en, this message translates to:
  /// **'Unable to load map'**
  String get unableToLoadMap;

  /// No description provided for @latLngPreview.
  ///
  /// In en, this message translates to:
  /// **'LAT: {lat} • LNG: {lng}'**
  String latLngPreview(String lat, String lng);

  /// No description provided for @addressPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'ADDRESS PREVIEW'**
  String get addressPreviewLabel;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(String error);

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'SAVING...'**
  String get saving;

  /// No description provided for @updatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updatedSuccessfully;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @confirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPasswordHint;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordLengthError;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordIncorrect;

  /// No description provided for @passwordWeak.
  ///
  /// In en, this message translates to:
  /// **'New password is too weak'**
  String get passwordWeak;

  /// No description provided for @recentLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in again to change password'**
  String get recentLoginRequired;

  /// No description provided for @newPasswordDifferent.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from current password'**
  String get newPasswordDifferent;

  /// No description provided for @failedToChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get failedToChangePassword;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load store profile'**
  String get failedToLoadProfile;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {error}'**
  String errorLoadingProfile(String error);

  /// No description provided for @storeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Store name is required'**
  String get storeNameRequired;

  /// No description provided for @ownerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Owner name is required'**
  String get ownerNameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneLengthError.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10 digits'**
  String get phoneLengthError;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @enterAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter complete address'**
  String get enterAddressHint;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get removeImage;

  /// No description provided for @failedToUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get failedToUploadImage;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get emailUs;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get callUs;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqs;

  /// No description provided for @faq1Q.
  ///
  /// In en, this message translates to:
  /// **'How do I add new fertilizers?'**
  String get faq1Q;

  /// No description provided for @faq1A.
  ///
  /// In en, this message translates to:
  /// **'As a store owner, you cannot create new fertilizers. Admin adds the master list of fertilizers. You can only manage the stock and price of existing fertilizers in your inventory.'**
  String get faq1A;

  /// No description provided for @faq2Q.
  ///
  /// In en, this message translates to:
  /// **'How do I update my store location?'**
  String get faq2Q;

  /// No description provided for @faq2A.
  ///
  /// In en, this message translates to:
  /// **'Go to Store Dashboard > Location. You can tap on the map to set your precise location or use the \"Use Current Location\" button.'**
  String get faq2A;

  /// No description provided for @faq3Q.
  ///
  /// In en, this message translates to:
  /// **'How can I change my password?'**
  String get faq3Q;

  /// No description provided for @faq3A.
  ///
  /// In en, this message translates to:
  /// **'Go to Store Profile > Change Password. Enter your current password and the new password to update it.'**
  String get faq3A;

  /// No description provided for @faq4Q.
  ///
  /// In en, this message translates to:
  /// **'Why is my store not verified yet?'**
  String get faq4Q;

  /// No description provided for @faq4A.
  ///
  /// In en, this message translates to:
  /// **'Verification usually takes 24-48 hours. Admin verifies details manually. Ensure your profile information is complete.'**
  String get faq4A;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @noContentAvailable.
  ///
  /// In en, this message translates to:
  /// **'No content available.'**
  String get noContentAvailable;

  /// No description provided for @lessThan1Min.
  ///
  /// In en, this message translates to:
  /// **'Less than 1 min'**
  String get lessThan1Min;

  /// No description provided for @minUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minUnit;

  /// No description provided for @hrUnit.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get hrUnit;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @currentWeather.
  ///
  /// In en, this message translates to:
  /// **'Current Weather'**
  String get currentWeather;

  /// No description provided for @seedling.
  ///
  /// In en, this message translates to:
  /// **'Seedling'**
  String get seedling;

  /// No description provided for @vegetative.
  ///
  /// In en, this message translates to:
  /// **'Vegetative'**
  String get vegetative;

  /// No description provided for @flowering.
  ///
  /// In en, this message translates to:
  /// **'Flowering'**
  String get flowering;

  /// No description provided for @fruiting.
  ///
  /// In en, this message translates to:
  /// **'Fruiting'**
  String get fruiting;

  /// No description provided for @fieldSize.
  ///
  /// In en, this message translates to:
  /// **'Field Size'**
  String get fieldSize;

  /// No description provided for @acres.
  ///
  /// In en, this message translates to:
  /// **'Acres'**
  String get acres;

  /// No description provided for @soilHealth.
  ///
  /// In en, this message translates to:
  /// **'Soil Health'**
  String get soilHealth;

  /// No description provided for @cropIssues.
  ///
  /// In en, this message translates to:
  /// **'Crop Issues'**
  String get cropIssues;

  /// No description provided for @selectGrowthStage.
  ///
  /// In en, this message translates to:
  /// **'Select Growth Stage'**
  String get selectGrowthStage;

  /// No description provided for @selectCropIssue.
  ///
  /// In en, this message translates to:
  /// **'Select Crop Issue'**
  String get selectCropIssue;

  /// No description provided for @calculateAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Calculate Advisory'**
  String get calculateAdvisory;

  /// No description provided for @pleaseSelectACropAbove.
  ///
  /// In en, this message translates to:
  /// **'Please select a crop above to proceed'**
  String get pleaseSelectACropAbove;

  /// No description provided for @cropPaddyRice.
  ///
  /// In en, this message translates to:
  /// **'Paddy (Rice)'**
  String get cropPaddyRice;

  /// No description provided for @cropWheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get cropWheat;

  /// No description provided for @cropJowarSorghum.
  ///
  /// In en, this message translates to:
  /// **'Jowar (Sorghum)'**
  String get cropJowarSorghum;

  /// No description provided for @cropBajraPearlMillet.
  ///
  /// In en, this message translates to:
  /// **'Bajra (Pearl Millet)'**
  String get cropBajraPearlMillet;

  /// No description provided for @cropMaizeCorn.
  ///
  /// In en, this message translates to:
  /// **'Maize (Corn)'**
  String get cropMaizeCorn;

  /// No description provided for @cropRagiFingerMillet.
  ///
  /// In en, this message translates to:
  /// **'Ragi (Finger Millet)'**
  String get cropRagiFingerMillet;

  /// No description provided for @cropBarley.
  ///
  /// In en, this message translates to:
  /// **'Barley'**
  String get cropBarley;

  /// No description provided for @cropOats.
  ///
  /// In en, this message translates to:
  /// **'Oats'**
  String get cropOats;

  /// No description provided for @cropTurPigeonPea.
  ///
  /// In en, this message translates to:
  /// **'Tur (Pigeon Pea)'**
  String get cropTurPigeonPea;

  /// No description provided for @cropMoongGreenGram.
  ///
  /// In en, this message translates to:
  /// **'Moong (Green Gram)'**
  String get cropMoongGreenGram;

  /// No description provided for @cropUradBlackGram.
  ///
  /// In en, this message translates to:
  /// **'Urad (Black Gram)'**
  String get cropUradBlackGram;

  /// No description provided for @cropChickpeaGram.
  ///
  /// In en, this message translates to:
  /// **'Chickpea (Gram)'**
  String get cropChickpeaGram;

  /// No description provided for @cropMasoorRedLentil.
  ///
  /// In en, this message translates to:
  /// **'Masoor (Red Lentil)'**
  String get cropMasoorRedLentil;

  /// No description provided for @cropCowpeaLobia.
  ///
  /// In en, this message translates to:
  /// **'Cowpea (Lobia)'**
  String get cropCowpeaLobia;

  /// No description provided for @cropHorseGramKulthi.
  ///
  /// In en, this message translates to:
  /// **'Horse Gram (Kulthi)'**
  String get cropHorseGramKulthi;

  /// No description provided for @cropSoybean.
  ///
  /// In en, this message translates to:
  /// **'Soybean'**
  String get cropSoybean;

  /// No description provided for @cropGroundnutPeanut.
  ///
  /// In en, this message translates to:
  /// **'Groundnut (Peanut)'**
  String get cropGroundnutPeanut;

  /// No description provided for @cropSunflower.
  ///
  /// In en, this message translates to:
  /// **'Sunflower'**
  String get cropSunflower;

  /// No description provided for @cropMustardRapeseed.
  ///
  /// In en, this message translates to:
  /// **'Mustard (Rapeseed)'**
  String get cropMustardRapeseed;

  /// No description provided for @cropSesameTil.
  ///
  /// In en, this message translates to:
  /// **'Sesame (Til)'**
  String get cropSesameTil;

  /// No description provided for @cropLinseedFlax.
  ///
  /// In en, this message translates to:
  /// **'Linseed (Flax)'**
  String get cropLinseedFlax;

  /// No description provided for @cropCastor.
  ///
  /// In en, this message translates to:
  /// **'Castor'**
  String get cropCastor;

  /// No description provided for @cropSafflower.
  ///
  /// In en, this message translates to:
  /// **'Safflower'**
  String get cropSafflower;

  /// No description provided for @cropCotton.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get cropCotton;

  /// No description provided for @cropSugarcane.
  ///
  /// In en, this message translates to:
  /// **'Sugarcane'**
  String get cropSugarcane;

  /// No description provided for @cropJute.
  ///
  /// In en, this message translates to:
  /// **'Jute'**
  String get cropJute;

  /// No description provided for @cropTobacco.
  ///
  /// In en, this message translates to:
  /// **'Tobacco'**
  String get cropTobacco;

  /// No description provided for @cropTomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get cropTomato;

  /// No description provided for @cropOnion.
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get cropOnion;

  /// No description provided for @cropPotato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get cropPotato;

  /// No description provided for @cropBrinjalEggplant.
  ///
  /// In en, this message translates to:
  /// **'Brinjal (Eggplant)'**
  String get cropBrinjalEggplant;

  /// No description provided for @cropOkraBhindi.
  ///
  /// In en, this message translates to:
  /// **'Okra (Bhindi)'**
  String get cropOkraBhindi;

  /// No description provided for @cropChiliHotPepper.
  ///
  /// In en, this message translates to:
  /// **'Chili (Hot Pepper)'**
  String get cropChiliHotPepper;

  /// No description provided for @cropCapsicumBellPepper.
  ///
  /// In en, this message translates to:
  /// **'Capsicum (Bell Pepper)'**
  String get cropCapsicumBellPepper;

  /// No description provided for @cropCauliflower.
  ///
  /// In en, this message translates to:
  /// **'Cauliflower'**
  String get cropCauliflower;

  /// No description provided for @cropCabbage.
  ///
  /// In en, this message translates to:
  /// **'Cabbage'**
  String get cropCabbage;

  /// No description provided for @cropCucumber.
  ///
  /// In en, this message translates to:
  /// **'Cucumber'**
  String get cropCucumber;

  /// No description provided for @cropBitterGourdKarela.
  ///
  /// In en, this message translates to:
  /// **'Bitter Gourd (Karela)'**
  String get cropBitterGourdKarela;

  /// No description provided for @cropBottleGourdLauki.
  ///
  /// In en, this message translates to:
  /// **'Bottle Gourd (Lauki)'**
  String get cropBottleGourdLauki;

  /// No description provided for @cropPumpkin.
  ///
  /// In en, this message translates to:
  /// **'Pumpkin'**
  String get cropPumpkin;

  /// No description provided for @cropWatermelon.
  ///
  /// In en, this message translates to:
  /// **'Watermelon'**
  String get cropWatermelon;

  /// No description provided for @cropMuskmelonKharbooj.
  ///
  /// In en, this message translates to:
  /// **'Muskmelon (Kharbooj)'**
  String get cropMuskmelonKharbooj;

  /// No description provided for @cropGarlic.
  ///
  /// In en, this message translates to:
  /// **'Garlic'**
  String get cropGarlic;

  /// No description provided for @cropSpinachPalak.
  ///
  /// In en, this message translates to:
  /// **'Spinach (Palak)'**
  String get cropSpinachPalak;

  /// No description provided for @cropFenugreekMethi.
  ///
  /// In en, this message translates to:
  /// **'Fenugreek (Methi)'**
  String get cropFenugreekMethi;

  /// No description provided for @cropCarrot.
  ///
  /// In en, this message translates to:
  /// **'Carrot'**
  String get cropCarrot;

  /// No description provided for @cropRadishMooli.
  ///
  /// In en, this message translates to:
  /// **'Radish (Mooli)'**
  String get cropRadishMooli;

  /// No description provided for @cropMango.
  ///
  /// In en, this message translates to:
  /// **'Mango'**
  String get cropMango;

  /// No description provided for @cropBanana.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get cropBanana;

  /// No description provided for @cropGrapes.
  ///
  /// In en, this message translates to:
  /// **'Grapes'**
  String get cropGrapes;

  /// No description provided for @cropPomegranate.
  ///
  /// In en, this message translates to:
  /// **'Pomegranate'**
  String get cropPomegranate;

  /// No description provided for @cropOrangeNagpur.
  ///
  /// In en, this message translates to:
  /// **'Orange (Nagpur)'**
  String get cropOrangeNagpur;

  /// No description provided for @cropPapaya.
  ///
  /// In en, this message translates to:
  /// **'Papaya'**
  String get cropPapaya;

  /// No description provided for @cropGuava.
  ///
  /// In en, this message translates to:
  /// **'Guava'**
  String get cropGuava;

  /// No description provided for @cropCoconut.
  ///
  /// In en, this message translates to:
  /// **'Coconut'**
  String get cropCoconut;

  /// No description provided for @cropCustardAppleSitaphal.
  ///
  /// In en, this message translates to:
  /// **'Custard Apple (Sitaphal)'**
  String get cropCustardAppleSitaphal;

  /// No description provided for @cropLemon.
  ///
  /// In en, this message translates to:
  /// **'Lemon'**
  String get cropLemon;

  /// No description provided for @cropStrawberry.
  ///
  /// In en, this message translates to:
  /// **'Strawberry'**
  String get cropStrawberry;

  /// No description provided for @cropFigAnjeer.
  ///
  /// In en, this message translates to:
  /// **'Fig (Anjeer)'**
  String get cropFigAnjeer;

  /// No description provided for @cropSweetLimeMosambi.
  ///
  /// In en, this message translates to:
  /// **'Sweet Lime (Mosambi)'**
  String get cropSweetLimeMosambi;

  /// No description provided for @cropJackfruit.
  ///
  /// In en, this message translates to:
  /// **'Jackfruit'**
  String get cropJackfruit;

  /// No description provided for @cropSapodillaChiku.
  ///
  /// In en, this message translates to:
  /// **'Sapodilla (Chiku)'**
  String get cropSapodillaChiku;

  /// No description provided for @cropTurmericHaldi.
  ///
  /// In en, this message translates to:
  /// **'Turmeric (Haldi)'**
  String get cropTurmericHaldi;

  /// No description provided for @cropGingerAdrak.
  ///
  /// In en, this message translates to:
  /// **'Ginger (Adrak)'**
  String get cropGingerAdrak;

  /// No description provided for @cropCorianderDhaniya.
  ///
  /// In en, this message translates to:
  /// **'Coriander (Dhaniya)'**
  String get cropCorianderDhaniya;

  /// No description provided for @cropCuminJeera.
  ///
  /// In en, this message translates to:
  /// **'Cumin (Jeera)'**
  String get cropCuminJeera;

  /// No description provided for @cropFennelSaunf.
  ///
  /// In en, this message translates to:
  /// **'Fennel (Saunf)'**
  String get cropFennelSaunf;

  /// No description provided for @cropCardamomElaichi.
  ///
  /// In en, this message translates to:
  /// **'Cardamom (Elaichi)'**
  String get cropCardamomElaichi;

  /// No description provided for @cropPepperKaliMirch.
  ///
  /// In en, this message translates to:
  /// **'Pepper (Kali Mirch)'**
  String get cropPepperKaliMirch;

  /// No description provided for @cropTea.
  ///
  /// In en, this message translates to:
  /// **'Tea'**
  String get cropTea;

  /// No description provided for @cropCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get cropCoffee;

  /// No description provided for @cropRubber.
  ///
  /// In en, this message translates to:
  /// **'Rubber'**
  String get cropRubber;

  /// No description provided for @cropSweetPotato.
  ///
  /// In en, this message translates to:
  /// **'Sweet Potato'**
  String get cropSweetPotato;

  /// No description provided for @cropTapiocaCassava.
  ///
  /// In en, this message translates to:
  /// **'Tapioca (Cassava)'**
  String get cropTapiocaCassava;

  /// No description provided for @cropColocasiaArbi.
  ///
  /// In en, this message translates to:
  /// **'Colocasia (Arbi)'**
  String get cropColocasiaArbi;

  /// No description provided for @cropLucerneAlfalfa.
  ///
  /// In en, this message translates to:
  /// **'Lucerne (Alfalfa)'**
  String get cropLucerneAlfalfa;

  /// No description provided for @cropBerseemClover.
  ///
  /// In en, this message translates to:
  /// **'Berseem Clover'**
  String get cropBerseemClover;

  /// No description provided for @cropNapierGrass.
  ///
  /// In en, this message translates to:
  /// **'Napier Grass'**
  String get cropNapierGrass;

  /// No description provided for @cropMarigold.
  ///
  /// In en, this message translates to:
  /// **'Marigold'**
  String get cropMarigold;

  /// No description provided for @cropRose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get cropRose;

  /// No description provided for @cropJasmineMogra.
  ///
  /// In en, this message translates to:
  /// **'Jasmine (Mogra)'**
  String get cropJasmineMogra;

  /// No description provided for @cropChrysanthemum.
  ///
  /// In en, this message translates to:
  /// **'Chrysanthemum'**
  String get cropChrysanthemum;

  /// No description provided for @cropTuberoseRajnigandha.
  ///
  /// In en, this message translates to:
  /// **'Tuberose (Rajnigandha)'**
  String get cropTuberoseRajnigandha;

  /// No description provided for @cropFrenchBeans.
  ///
  /// In en, this message translates to:
  /// **'French Beans'**
  String get cropFrenchBeans;

  /// No description provided for @cropPeasMatar.
  ///
  /// In en, this message translates to:
  /// **'Peas (Matar)'**
  String get cropPeasMatar;

  /// No description provided for @cropBeetroot.
  ///
  /// In en, this message translates to:
  /// **'Beetroot'**
  String get cropBeetroot;

  /// No description provided for @cropTurnipShalgam.
  ///
  /// In en, this message translates to:
  /// **'Turnip (Shalgam)'**
  String get cropTurnipShalgam;

  /// No description provided for @cropDrumstickMoringa.
  ///
  /// In en, this message translates to:
  /// **'Drumstick (Moringa)'**
  String get cropDrumstickMoringa;

  /// No description provided for @cropSnakeGourd.
  ///
  /// In en, this message translates to:
  /// **'Snake Gourd'**
  String get cropSnakeGourd;

  /// No description provided for @cropSpongeGourdTurai.
  ///
  /// In en, this message translates to:
  /// **'Sponge Gourd (Turai)'**
  String get cropSpongeGourdTurai;

  /// No description provided for @cropRidgeGourdTorai.
  ///
  /// In en, this message translates to:
  /// **'Ridge Gourd (Torai)'**
  String get cropRidgeGourdTorai;

  /// No description provided for @cropLettuce.
  ///
  /// In en, this message translates to:
  /// **'Lettuce'**
  String get cropLettuce;

  /// No description provided for @cropSweetCorn.
  ///
  /// In en, this message translates to:
  /// **'Sweet Corn'**
  String get cropSweetCorn;

  /// No description provided for @cropApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get cropApple;

  /// No description provided for @cropPineapple.
  ///
  /// In en, this message translates to:
  /// **'Pineapple'**
  String get cropPineapple;

  /// No description provided for @cropAvocado.
  ///
  /// In en, this message translates to:
  /// **'Avocado'**
  String get cropAvocado;

  /// No description provided for @cropAloeVera.
  ///
  /// In en, this message translates to:
  /// **'Aloe Vera'**
  String get cropAloeVera;

  /// No description provided for @cropStevia.
  ///
  /// In en, this message translates to:
  /// **'Stevia'**
  String get cropStevia;

  /// No description provided for @cropAshwagandha.
  ///
  /// In en, this message translates to:
  /// **'Ashwagandha'**
  String get cropAshwagandha;

  /// No description provided for @transplanting.
  ///
  /// In en, this message translates to:
  /// **'Transplanting'**
  String get transplanting;

  /// No description provided for @tillering.
  ///
  /// In en, this message translates to:
  /// **'Tillering'**
  String get tillering;

  /// No description provided for @panicleInitiation.
  ///
  /// In en, this message translates to:
  /// **'Panicle Initiation'**
  String get panicleInitiation;

  /// No description provided for @panicleEmergence.
  ///
  /// In en, this message translates to:
  /// **'Panicle Emergence'**
  String get panicleEmergence;

  /// No description provided for @jointing.
  ///
  /// In en, this message translates to:
  /// **'Jointing'**
  String get jointing;

  /// No description provided for @booting.
  ///
  /// In en, this message translates to:
  /// **'Booting'**
  String get booting;

  /// No description provided for @grainFill.
  ///
  /// In en, this message translates to:
  /// **'Grain Fill'**
  String get grainFill;

  /// No description provided for @kneeHigh.
  ///
  /// In en, this message translates to:
  /// **'Knee High'**
  String get kneeHigh;

  /// No description provided for @tasseling.
  ///
  /// In en, this message translates to:
  /// **'Tasseling'**
  String get tasseling;

  /// No description provided for @silking.
  ///
  /// In en, this message translates to:
  /// **'Silking'**
  String get silking;

  /// No description provided for @dough.
  ///
  /// In en, this message translates to:
  /// **'Dough'**
  String get dough;

  /// No description provided for @podDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Pod Development'**
  String get podDevelopment;

  /// No description provided for @germination.
  ///
  /// In en, this message translates to:
  /// **'Germination'**
  String get germination;

  /// No description provided for @selectedCrop.
  ///
  /// In en, this message translates to:
  /// **'Selected Crop'**
  String get selectedCrop;

  /// No description provided for @irrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get irrigation;

  /// No description provided for @micronutrients.
  ///
  /// In en, this message translates to:
  /// **'Micronutrients'**
  String get micronutrients;

  /// No description provided for @organicAlternatives.
  ///
  /// In en, this message translates to:
  /// **'Organic Alternatives'**
  String get organicAlternatives;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @maturity.
  ///
  /// In en, this message translates to:
  /// **'Maturity'**
  String get maturity;

  /// No description provided for @failedToLoadCrops.
  ///
  /// In en, this message translates to:
  /// **'Failed to load crops'**
  String get failedToLoadCrops;

  /// No description provided for @hectares.
  ///
  /// In en, this message translates to:
  /// **'Hectares'**
  String get hectares;

  /// No description provided for @soilLoamy.
  ///
  /// In en, this message translates to:
  /// **'Loamy'**
  String get soilLoamy;

  /// No description provided for @soilClay.
  ///
  /// In en, this message translates to:
  /// **'Clay'**
  String get soilClay;

  /// No description provided for @soilSandy.
  ///
  /// In en, this message translates to:
  /// **'Sandy'**
  String get soilSandy;

  /// No description provided for @soilBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get soilBlack;

  /// No description provided for @soilRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get soilRed;

  /// No description provided for @soilAlluvial.
  ///
  /// In en, this message translates to:
  /// **'Alluvial'**
  String get soilAlluvial;

  /// No description provided for @soilSaline.
  ///
  /// In en, this message translates to:
  /// **'Saline'**
  String get soilSaline;

  /// No description provided for @issueYellowLeaves.
  ///
  /// In en, this message translates to:
  /// **'Yellow leaves'**
  String get issueYellowLeaves;

  /// No description provided for @issueStuntedGrowth.
  ///
  /// In en, this message translates to:
  /// **'Stunted growth'**
  String get issueStuntedGrowth;

  /// No description provided for @issuePestAttack.
  ///
  /// In en, this message translates to:
  /// **'Pest attack'**
  String get issuePestAttack;

  /// No description provided for @issueFungalDisease.
  ///
  /// In en, this message translates to:
  /// **'Fungal disease'**
  String get issueFungalDisease;

  /// No description provided for @issueWilting.
  ///
  /// In en, this message translates to:
  /// **'Wilting'**
  String get issueWilting;

  /// No description provided for @issueLowYield.
  ///
  /// In en, this message translates to:
  /// **'Low yield'**
  String get issueLowYield;

  /// No description provided for @rainExpectedWarning.
  ///
  /// In en, this message translates to:
  /// **'Rain expected! Consider delaying fertilizer application.'**
  String get rainExpectedWarning;

  /// No description provided for @totalEstimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Total Est. Cost: ₹{cost}'**
  String totalEstimatedCost(String cost);

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @kgPerAcre.
  ///
  /// In en, this message translates to:
  /// **'kg/acre'**
  String get kgPerAcre;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// No description provided for @timing.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get timing;

  /// No description provided for @precautionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Precautions:'**
  String get precautionsLabel;

  /// No description provided for @rainProbabilityAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount}% Rain'**
  String rainProbabilityAmount(String amount);

  /// No description provided for @budDifferentiation.
  ///
  /// In en, this message translates to:
  /// **'Bud Differentiation'**
  String get budDifferentiation;

  /// No description provided for @fruitSet.
  ///
  /// In en, this message translates to:
  /// **'Fruit Set'**
  String get fruitSet;

  /// No description provided for @fruitDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Fruit Development'**
  String get fruitDevelopment;

  /// No description provided for @flowerBud.
  ///
  /// In en, this message translates to:
  /// **'Flower Bud'**
  String get flowerBud;

  /// No description provided for @juvenile.
  ///
  /// In en, this message translates to:
  /// **'Juvenile'**
  String get juvenile;

  /// No description provided for @bearing.
  ///
  /// In en, this message translates to:
  /// **'Bearing'**
  String get bearing;

  /// No description provided for @fullProduction.
  ///
  /// In en, this message translates to:
  /// **'Full Production'**
  String get fullProduction;

  /// No description provided for @shootEmergence.
  ///
  /// In en, this message translates to:
  /// **'Shoot Emergence'**
  String get shootEmergence;

  /// No description provided for @rhizomeDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Rhizome Development'**
  String get rhizomeDevelopment;

  /// No description provided for @capsuleDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Capsule Development'**
  String get capsuleDevelopment;

  /// No description provided for @nursery.
  ///
  /// In en, this message translates to:
  /// **'Nursery'**
  String get nursery;

  /// No description provided for @plucking.
  ///
  /// In en, this message translates to:
  /// **'Plucking'**
  String get plucking;

  /// No description provided for @youngPlantation.
  ///
  /// In en, this message translates to:
  /// **'Young Plantation'**
  String get youngPlantation;

  /// No description provided for @fullBearing.
  ///
  /// In en, this message translates to:
  /// **'Full Bearing'**
  String get fullBearing;

  /// No description provided for @immature.
  ///
  /// In en, this message translates to:
  /// **'Immature'**
  String get immature;

  /// No description provided for @tapping.
  ///
  /// In en, this message translates to:
  /// **'Tapping'**
  String get tapping;

  /// No description provided for @tuberDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Tuber Development'**
  String get tuberDevelopment;

  /// No description provided for @cormDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Corm Development'**
  String get cormDevelopment;

  /// No description provided for @cutting.
  ///
  /// In en, this message translates to:
  /// **'Cutting'**
  String get cutting;

  /// No description provided for @bud.
  ///
  /// In en, this message translates to:
  /// **'Bud'**
  String get bud;

  /// No description provided for @establishment.
  ///
  /// In en, this message translates to:
  /// **'Establishment'**
  String get establishment;

  /// No description provided for @budInitiation.
  ///
  /// In en, this message translates to:
  /// **'Bud Initiation'**
  String get budInitiation;

  /// No description provided for @spikeEmergence.
  ///
  /// In en, this message translates to:
  /// **'Spike Emergence'**
  String get spikeEmergence;

  /// No description provided for @podFill.
  ///
  /// In en, this message translates to:
  /// **'Pod Fill'**
  String get podFill;

  /// No description provided for @rootDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Root Development'**
  String get rootDevelopment;

  /// No description provided for @rootSwelling.
  ///
  /// In en, this message translates to:
  /// **'Root Swelling'**
  String get rootSwelling;

  /// No description provided for @budBreak.
  ///
  /// In en, this message translates to:
  /// **'Bud Break'**
  String get budBreak;

  /// No description provided for @flowerInduction.
  ///
  /// In en, this message translates to:
  /// **'Flower Induction'**
  String get flowerInduction;

  /// No description provided for @cropBajraMillet.
  ///
  /// In en, this message translates to:
  /// **'Bajra (Pearl Millet)'**
  String get cropBajraMillet;

  /// No description provided for @fertUrea.
  ///
  /// In en, this message translates to:
  /// **'Urea'**
  String get fertUrea;

  /// No description provided for @fertDAP.
  ///
  /// In en, this message translates to:
  /// **'DAP (Di-Ammonium Phosphate)'**
  String get fertDAP;

  /// No description provided for @fertMOP.
  ///
  /// In en, this message translates to:
  /// **'MOP (Muriate of Potash)'**
  String get fertMOP;

  /// No description provided for @fertTSP.
  ///
  /// In en, this message translates to:
  /// **'TSP (Triple Super Phosphate)'**
  String get fertTSP;

  /// No description provided for @fertSSP.
  ///
  /// In en, this message translates to:
  /// **'SSP (Single Super Phosphate)'**
  String get fertSSP;

  /// No description provided for @fertCAN.
  ///
  /// In en, this message translates to:
  /// **'CAN (Calcium Ammonium Nitrate)'**
  String get fertCAN;

  /// No description provided for @fertSOP.
  ///
  /// In en, this message translates to:
  /// **'SOP (Sulphate of Potash)'**
  String get fertSOP;

  /// No description provided for @fertNPK19.
  ///
  /// In en, this message translates to:
  /// **'Specialty Soluble NPK (19:19:19)'**
  String get fertNPK19;

  /// No description provided for @fertGrowthPromoter.
  ///
  /// In en, this message translates to:
  /// **'Growth Promoter (Seaweed Extract)'**
  String get fertGrowthPromoter;

  /// No description provided for @methodBroadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get methodBroadcast;

  /// No description provided for @methodTopDressing.
  ///
  /// In en, this message translates to:
  /// **'Top Dressing'**
  String get methodTopDressing;

  /// No description provided for @methodSoilPlacement.
  ///
  /// In en, this message translates to:
  /// **'Soil Placement (Drilling)'**
  String get methodSoilPlacement;

  /// No description provided for @methodFoliarSpray.
  ///
  /// In en, this message translates to:
  /// **'Foliar Spray'**
  String get methodFoliarSpray;

  /// No description provided for @timeBasalEarly.
  ///
  /// In en, this message translates to:
  /// **'Basal / Early Stage'**
  String get timeBasalEarly;

  /// No description provided for @timeSplit3Doses.
  ///
  /// In en, this message translates to:
  /// **'Split into 3 doses (Sowing, 30 DAS, 60 DAS)'**
  String get timeSplit3Doses;

  /// No description provided for @timeSplit2Doses.
  ///
  /// In en, this message translates to:
  /// **'Split dose: 1/2 now, 1/2 later'**
  String get timeSplit2Doses;

  /// No description provided for @timeBasalSowing.
  ///
  /// In en, this message translates to:
  /// **'Basal (At Sowing)'**
  String get timeBasalSowing;

  /// No description provided for @timeEvening.
  ///
  /// In en, this message translates to:
  /// **'Best applied in evening'**
  String get timeEvening;

  /// No description provided for @adviceNormalIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Normal irrigation schedule recommended.'**
  String get adviceNormalIrrigation;

  /// No description provided for @adviceRainWarning.
  ///
  /// In en, this message translates to:
  /// **'Heavy rain expected. Delay irrigation and fertilizer application to prevent leaching.'**
  String get adviceRainWarning;

  /// No description provided for @adviceHeatWarning.
  ///
  /// In en, this message translates to:
  /// **'High temperature detected. Ensure adequate soil moisture before applying fertilizers to avoid scorching.'**
  String get adviceHeatWarning;

  /// No description provided for @precHighRain.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL: Heavy rain forecast. DELAY application.'**
  String get precHighRain;

  /// No description provided for @precAcidicSoil.
  ///
  /// In en, this message translates to:
  /// **'Contains Calcium which helps neutralize acidity.'**
  String get precAcidicSoil;

  /// No description provided for @precLeafCoverage.
  ///
  /// In en, this message translates to:
  /// **'Ensure good leaf coverage.'**
  String get precLeafCoverage;

  /// No description provided for @precMixWater.
  ///
  /// In en, this message translates to:
  /// **'Mix well with water.'**
  String get precMixWater;

  /// No description provided for @orgFYM.
  ///
  /// In en, this message translates to:
  /// **'Farm Yard Manure (FYM): 2-3 tons/acre'**
  String get orgFYM;

  /// No description provided for @orgVermicompost.
  ///
  /// In en, this message translates to:
  /// **'Vermicompost: 500 kg/acre'**
  String get orgVermicompost;

  /// No description provided for @orgGreenManure.
  ///
  /// In en, this message translates to:
  /// **'Green Manure (Sesbania) to improve water retention'**
  String get orgGreenManure;

  /// No description provided for @orgBioFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Bio-fertilizers (Azotobacter/PSB) to boost growth'**
  String get orgBioFertilizer;

  /// No description provided for @microZinc.
  ///
  /// In en, this message translates to:
  /// **'Zinc Sulphate (10 kg/acre) - Zinc Deficiency Check'**
  String get microZinc;

  /// No description provided for @microIron.
  ///
  /// In en, this message translates to:
  /// **'Ferrous Sulphate Spray - Iron Deficiency Check'**
  String get microIron;

  /// No description provided for @microZincPaddy.
  ///
  /// In en, this message translates to:
  /// **'Zinc is critical for Paddy. Ensure basal application.'**
  String get microZincPaddy;

  /// No description provided for @nitrogen.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N)'**
  String get nitrogen;

  /// No description provided for @phosphorus.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus (P)'**
  String get phosphorus;

  /// No description provided for @potassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium (K)'**
  String get potassium;

  /// No description provided for @phLevel.
  ///
  /// In en, this message translates to:
  /// **'Soil pH'**
  String get phLevel;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @soilLaterite.
  ///
  /// In en, this message translates to:
  /// **'Laterite'**
  String get soilLaterite;

  /// No description provided for @soilPeaty.
  ///
  /// In en, this message translates to:
  /// **'Peaty'**
  String get soilPeaty;

  /// No description provided for @soilArid.
  ///
  /// In en, this message translates to:
  /// **'Arid (Desert)'**
  String get soilArid;

  /// No description provided for @smartSoilAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'Smart Soil Analyzer'**
  String get smartSoilAnalyzer;

  /// No description provided for @smartSoilAnalyzerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Analyze soil using\nsmartphone microphone'**
  String get smartSoilAnalyzerSubtitle;

  /// No description provided for @soilRecordInstruction.
  ///
  /// In en, this message translates to:
  /// **'Insert a metal rod into the soil and tap it gently. Hold your phone close to capture the sound.'**
  String get soilRecordInstruction;

  /// No description provided for @soilStepInsert.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get soilStepInsert;

  /// No description provided for @soilStepTap.
  ///
  /// In en, this message translates to:
  /// **'Tap'**
  String get soilStepTap;

  /// No description provided for @soilStepRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get soilStepRecord;

  /// No description provided for @soilTapToRecord.
  ///
  /// In en, this message translates to:
  /// **'Tap to start recording'**
  String get soilTapToRecord;

  /// No description provided for @soilTapToStop.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop'**
  String get soilTapToStop;

  /// No description provided for @soilProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get soilProcessing;

  /// No description provided for @soilKeepRecording.
  ///
  /// In en, this message translates to:
  /// **'Keep recording...'**
  String get soilKeepRecording;

  /// No description provided for @soilCanStopNow.
  ///
  /// In en, this message translates to:
  /// **'You can stop now'**
  String get soilCanStopNow;

  /// No description provided for @soilAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing Soil...'**
  String get soilAnalyzing;

  /// No description provided for @soilAnalyzingSubtext.
  ///
  /// In en, this message translates to:
  /// **'Extracting audio features and generating soil analysis. This may take a moment.'**
  String get soilAnalyzingSubtext;

  /// No description provided for @soilResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Analysis Results'**
  String get soilResultsTitle;

  /// No description provided for @soilAnalysisResults.
  ///
  /// In en, this message translates to:
  /// **'Soil Analysis'**
  String get soilAnalysisResults;

  /// No description provided for @soilMoistureLabel.
  ///
  /// In en, this message translates to:
  /// **'Moisture'**
  String get soilMoistureLabel;

  /// No description provided for @soilMoistureLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get soilMoistureLow;

  /// No description provided for @soilMoistureMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get soilMoistureMedium;

  /// No description provided for @soilMoistureHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get soilMoistureHigh;

  /// No description provided for @soilDensityLabel.
  ///
  /// In en, this message translates to:
  /// **'Density'**
  String get soilDensityLabel;

  /// No description provided for @soilDensityLoose.
  ///
  /// In en, this message translates to:
  /// **'Loose'**
  String get soilDensityLoose;

  /// No description provided for @soilDensityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get soilDensityMedium;

  /// No description provided for @soilDensityCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get soilDensityCompact;

  /// No description provided for @soilCompactionLabel.
  ///
  /// In en, this message translates to:
  /// **'Compaction Level'**
  String get soilCompactionLabel;

  /// No description provided for @soilConfidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Analysis Confidence'**
  String get soilConfidenceLabel;

  /// No description provided for @soilWeatherContext.
  ///
  /// In en, this message translates to:
  /// **'Weather Context'**
  String get soilWeatherContext;

  /// No description provided for @soilWarnings.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get soilWarnings;

  /// No description provided for @soilFertilizerPlan.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Recommendations'**
  String get soilFertilizerPlan;

  /// No description provided for @soilIrrigationAdvice.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Advice'**
  String get soilIrrigationAdvice;

  /// No description provided for @soilAnalyzeAgain.
  ///
  /// In en, this message translates to:
  /// **'Analyze Again'**
  String get soilAnalyzeAgain;

  /// No description provided for @soilErrorMicPermission.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required. Please grant access in your device settings and try again.'**
  String get soilErrorMicPermission;

  /// No description provided for @soilErrorTooShort.
  ///
  /// In en, this message translates to:
  /// **'Recording too short. Please record for at least 5 seconds.'**
  String get soilErrorTooShort;

  /// No description provided for @soilErrorNoSignal.
  ///
  /// In en, this message translates to:
  /// **'No clear signal detected. Please ensure you are tapping the metal rod near the microphone.'**
  String get soilErrorNoSignal;

  /// No description provided for @soilErrorGeneral.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong during analysis. Please try again.'**
  String get soilErrorGeneral;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
