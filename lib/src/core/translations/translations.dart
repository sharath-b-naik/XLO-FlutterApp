import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final localeProvider = Provider<Locale>((ref) => ref.watch(_localeProvider));
// final _localeProvider = StateProvider<Locale>((ref) => AppLocalizations.supportedLocales.first);

class AppLocalizations {
  static setLocale(BuildContext context, WidgetRef ref, [Locale? locale]) {
    context.setLocale(locale ?? context.locale);
    // ref.read(_localeProvider.notifier).state = locale ?? context.locale;
  }

  static List<Locale> get supportedLocales => [
        const Locale('en', 'US'),
        const Locale('hi', 'IN'),
        const Locale('kn', 'IN'),
      ];

  static String get sellProduct => "sell_product";
  static String get selectImages => "select_images";
  static String get required => "required";
  static String get productName => "product_name";
  static String get enterProductName => "enter_product_name";
  static String get category => "category";
  static String get selectCategory => "select_category";
  static String get description => "description";
  static String get enterDescription => "enter_description";
  static String get price => "price";
  static String get enterPrice => "enter_price";
  static String get moreDetails => "more_details";
  static String get addInfo => "add_info";
  static String get type => "type";
  static String get value => "value";
  static String get isUsedProduct => "is_used_product";
  static String get sell => "sell";
  static String get createAccount => "create_account";
  static String get login => "login";
  static String get phoneNumber => "phone_number";
  static String get password => "password";
  static String get confirmPassword => "confirm_password";
  static String get alreadyHaveAccount => "already_have_account";
  static String get dontHaveAccount => "dont_have_account";
  static String get changePassword => "change_password";
  static String get oldPassword => "old_password";
  static String get enterOldPassword => "enter_old_password";
  static String get newPassword => "new_password";
  static String get enterNewPassword => "enter_new_password";
  static String get confirmNewPassword => "confirm_new_password";
  static String get enterNewPasswordAgain => "enter_new_password_again";
  static String get chats => "chats";
  static String get search => "search";
  static String get noChats => "no_chats";
  static String get noMessages => "no_messages";
  static String get today => "today";
  static String get yesterday => "yesterday";
  static String get typeMessage => "type_message";
  static String get contact => "contact";
  static String get contactDetails => "contact_details";
  static String get categories => "categories";
  static String get viewAll => "view_all";
  static String get neww => "new";
  static String get searchFavoriteProducts => "search_favorite_products";
  static String get featuredProducts => "featured_products";
  static String get electronicsAppliances => "electronics_appliances";
  static String get fashionAccessories => "fashion_accessories";
  static String get sportsOutdoors => "sports_outdoors";
  static String get vehicles => "vehicles";
  static String get furniture => "furniture";
  static String get healthBeauty => "health_beauty";
  static String get petsAnimals => "pets_animals";
  static String get booksEducation => "books_education";
  static String get babyKids => "baby_kids";
  static String get toolsDIY => "tools_diy";
  static String get musicalInstruments => "musical_instruments";
  static String get antiquesVintage => "antiques_vintage";
  static String get craftsHandmade => "crafts_handmade";
  static String get foodConsumer => "food_consumer";
  static String get industrialEquipment => "industrial_equipment";
  static String get properties => "properties";
  static String get miscellaneous => "miscellaneous";
  static String get home => "home";
  static String get myAds => "my_ads";
  static String get profile => "profile";
  static String get myProducts => "my_products";
  static String get favourites => "favourites";
  static String get noAdsFound => "no_ads_found";
  static String get noFavourites => "no_favourites";
  static String get used => "used";
  static String get privacyPolicy => "privacy_policy";
  static String get fullName => "full_name";
  static String get enterFullName => "enter_full_name";
  static String get email => "email";
  static String get enterEmailAddress => "enter_email_address";
  static String get enterPhoneNumber => "enter_phone_number";
  static String get update => "update";
  static String get unknown => "unknown";
  static String get account => "account";
  static String get editProfile => "edit_profile";
  static String get language => "language";
  static String get general => "general";
  static String get support => "support";
  static String get more => "more";
  static String get referEarn => "refer_earn";
  static String get logout => "logout";
  static String get deleteAccount => "delete_account";
  static String get noProductsInCategory => "no_products_in_category";
  static String get noProductSpecification => "no_product_specification";
  static String get delete => "delete";
  static String get edit => "edit";
  static String get chat => "chat";
  static String get buyNow => "buy_now";
}
