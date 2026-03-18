import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class S {
  const S._(this.localeName);

  static const S _arabic = S._('ar');
  static const S _english = S._('en');
  static S? _current;

  final String localeName;

  static S get current => _current ?? _arabic;

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final instance = lookup(locale);
    _current = instance;
    return SynchronousFuture(instance);
  }

  static S lookup(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return _english;
      case 'ar':
      default:
        return _arabic;
    }
  }

  static S of(BuildContext context) {
    return maybeOf(context) ?? current;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  bool get isArabic => localeName == 'ar';

  String _text(String ar, String en) => isArabic ? ar : en;

  String get currentLanguage => _text('العربية', 'English');
  String get welcomeTo => _text('مرحبًا بك في', 'Welcome to');
  String get onboardingDiscoverSubtitle => _text(
    'اكتشف تجربة تسوق فريدة مع FruitHUB. استكشف مجموعتنا الواسعة من الفواكه الطازجة الممتازة واحصل على أفضل العروض والجودة العالية.',
    'Discover a unique shopping experience with FruitHUB. Explore our wide range of premium fresh fruits and enjoy the best offers and top quality.',
  );
  String get onboardingCuratedSubtitle => _text(
    'نقدم لك أفضل الفواكه المختارة بعناية. اطلع على التفاصيل والصور والتقييمات لتتأكد من اختيار الفاكهة المثالية',
    'We bring you the finest carefully selected fruits. Browse details, photos, and ratings to make the perfect choice.',
  );
  String get searchAndShop => _text('ابحث وتسوق', 'Search and shop');
  String get skip => _text('تخط', 'Skip');
  String get startNow => _text('ابدأ الان', 'Get started');
  String get passwordHint => _text('كلمة المرور', 'Password');
  String get requiredField => _text('هذا الحقل مطلوب', 'This field is required');
  String get searchHint => _text('ابحث عن...', 'Search for...');
  String get searchTitle => _text('البحث', 'Search');
  String get infoUnavailableNow => _text(
    'عفوًا... هذه المعلومات غير متوفرة للحظة',
    'Sorry... this information is unavailable right now.',
  );
  String get sortProducts => _text('ترتيب المنتجات', 'Sort products');
  String get defaultSort => _text('الترتيب الافتراضي', 'Default sorting');
  String get priceHighToLow => _text(
    'السعر من الأعلى إلى الأقل',
    'Price from high to low',
  );
  String get priceLowToHigh => _text(
    'السعر من الأقل إلى الأعلى',
    'Price from low to high',
  );
  String get bestSellingFirst => _text(
    'الأكثر مبيعًا إلى الأقل',
    'Best selling first',
  );
  String get signIn => _text('تسجيل دخول', 'Sign in');
  String get newAccount => _text('حساب جديد', 'New account');
  String get forgotPassword => _text('نسيت كلمة المرور؟', 'Forgot password?');
  String get noAccount => _text('لا تمتلك حساب؟', "Don't have an account?");
  String get createAccount => _text('قم بإنشاء حساب', 'Create account');
  String get signInWithGoogle => _text(
    'تسجيل بواسطة جوجل',
    'Continue with Google',
  );
  String get signInWithFacebook => _text(
    'تسجيل بواسطة فيسبوك',
    'Continue with Facebook',
  );
  String get alreadyHaveAccount => _text(
    'تمتلك حساب بالفعل؟',
    'Already have an account?',
  );
  String get orLabel => _text('أو', 'Or');
  String get termsIntro => _text(
    'من خلال إنشاء حساب ، فإنك توافق على ',
    'By creating an account, you agree to ',
  );
  String get termsAndConditions => _text(
    'الشروط والأحكام',
    'Terms & Conditions',
  );
  String get relatedTo => _text('الخاصة', 'of our');
  String get us => _text('بنا', 'service');
  String get mustAcceptTerms => _text(
    'يجب الموافقة على الشروط والاحكام',
    'You must accept the terms and conditions.',
  );
  String get fullNameHint => _text('الاسم كامل', 'Full name');
  String get emailHint => _text('البريد الإلكتروني', 'Email');
  String get addressHint => _text('العنوان', 'Address');
  String get cityHint => _text('المدينه', 'City');
  String get floorApartmentHint => _text(
    'رقم الطابق , رقم الشقه ..',
    'Floor number, apartment number...',
  );
  String get phoneHint => _text('رقم الهاتف', 'Phone number');
  String get payment => _text('الدفع', 'Payment');
  String get shipping => _text('الشحن', 'Shipping');
  String get address => _text('العنوان', 'Address');
  String get next => _text('التالي', 'Next');
  String get cashOnDelivery => _text('الدفع عند الاستلام', 'Cash on delivery');
  String get cashOnDeliverySubtitle => _text(
    'التسليم من المكان',
    'Pay when the order arrives',
  );
  String get onlinePayment => _text('الدفع اونلاين', 'Online payment');
  String get onlinePaymentSubtitle => _text(
    'يرجي تحديد طريقه الدفع',
    'Please choose a payment method',
  );
  String get pleaseSelectPaymentMethod => _text(
    'يرجى تحديد طريقة الدفع',
    'Please select a payment method.',
  );
  String get deliveryAddress => _text('عنوان التوصيل', 'Delivery address');
  String get edit => _text('تعديل', 'Edit');
  String get orderSummary => _text('ملخص الطلب', 'Order summary');
  String get subtotal => _text('المجموع الفرعي :', 'Subtotal:');
  String get delivery => _text('التوصيل  :', 'Delivery:');
  String get total => _text('الكلي', 'Total');
  String get completedSuccessfully => _text('تم بنجاح !', 'Completed successfully!');
  String get trackOrder => _text('تتبع الطلب', 'Track order');
  String get home => _text('الرئيسية', 'Home');
  String get notifications => _text('الإشعارات', 'Notifications');
  String get cashLabel => _text('كاش', 'Cash');
  String get onlineLabel => _text('أونلاين', 'Online');
  String get confirmOrder => _text('تأكيد الطلب', 'Confirm order');
  String get signOut => _text('تسجيل الخروج', 'Sign out');
  String get signOutDescription => _text(
    'الخروج من الحساب الحالي',
    'Sign out of the current account',
  );
  String get perKiloSuffix => _text(' / الكيلو', ' / kg');
  String get user => _text('المستخدم', 'User');
  String get goodMorning => _text('صباح الخير !..', 'Good morning!..');
  String get noEmail => _text('لا يوجد بريد إلكتروني', 'No email available');
  String get eidOffers => _text('عروض العيد', 'Eid offers');
  String get discount25 => _text('خصم 25%', '25% discount');
  String get shopNow => _text('تسوق الان', 'Shop now');
  String get mostSelling => _text('الأكثر مبيعًا', 'Best selling');
  String get more => _text('المزيد', 'More');
  String get cart => _text('سلة التسوق', 'Cart');
  String get myOrders => _text('طلباتي', 'My orders');
  String get review => _text('المراجعة', 'Reviews');
  String get expiry => _text('الصلاحيه', 'Expiry');
  String get organic => _text('اوجانيك', 'Organic');
  String get rating => _text('التقييم', 'Rating');
  String get retry => _text('إعادة المحاولة', 'Retry');
  String get orderUpdate => _text('تحديث الطلب', 'Order update');
  String get viewOrders => _text('عرض الطلبات', 'View orders');
  String get pendingReview => _text('يتم المراجعة', 'Under review');
  String get beingPrepared => _text('يتم تحضيره', 'Being prepared');
  String get delivered => _text('تم التوصيل', 'Delivered');
  String get cancelled => _text('ملغي', 'Cancelled');
  String get newNotification => _text('لديك إشعار جديد', 'You have a new notification');
  String get now => _text('الآن', 'Now');
  String get noNotificationsCurrently => _text(
    'لا توجد إشعارات حالياً',
    'No notifications right now',
  );
  String get unauthenticatedToViewNotifications => _text(
    'سجل الدخول لعرض الإشعارات',
    'Sign in to view notifications.',
  );
  String get unableToIdentifyCurrentUser => _text(
    'تعذر تحديد المستخدم الحالي',
    'Unable to identify the current user.',
  );
  String get noOrdersYet => _text('لا توجد طلبات حتى الآن', 'No orders yet');
  String get startAddingProducts => _text(
    'ابدأ بإضافة منتجات إلى السلة ثم أكمل الطلب، وستظهر جميع طلباتك هنا.',
    'Start by adding products to the cart, then complete your order. Your orders will appear here.',
  );
  String get pullDownToRefresh => _text(
    'اسحب للأسفل للتحديث',
    'Pull down to refresh',
  );
  String get orderProducts => _text('منتجات الطلب', 'Order products');
  String get addressUnavailable => _text('العنوان غير متوفر', 'Address unavailable');
  String get shippingAddressUnavailable => _text(
    'عنوان الشحن غير متوفر',
    'Shipping address unavailable',
  );
  String get products => _text('المنتجات', 'Products');
  String get errorLoadingOrders => _text(
    'حدث خطأ أثناء تحميل الطلبات',
    'An error occurred while loading orders.',
  );
  String get paymentMethod => _text('طريقة الدفع', 'Payment method');
  String get productsCount => _text('عدد المنتجات', 'Products count');
  String get orderDate => _text('تاريخ الطلب', 'Order date');
  String get addToCart => _text('أضف إلى السلة', 'Add to cart');
  String get addSuccessTitle => _text('تمت الإضافة', 'Added');
  String get paymentError => _text(
    'حدث خطأ في عملية الدفع',
    'A payment error occurred.',
  );
  String get productAddedToCart => _text(
    'تمت إضافة المنتج للسلة',
    'The product was added to the cart.',
  );
  String get updateTitle => _text('تم التحديث', 'Updated');
  String get productRemovedFromCart => _text(
    'تم حذف المنتج من السلة',
    'The product was removed from the cart.',
  );
  String get noItemsInCart => _text(
    'لا يوجد منتجات في السلة',
    'There are no items in the cart.',
  );
  String get weakPassword => _text('الرقم السري ضعيف جداً.', 'The password is too weak.');
  String get emailAlreadyInUse => _text(
    'لقد قمت بالتسجيل مسبقاً. الرجاء تسجيل الدخول.',
    'This email is already in use. Please sign in.',
  );
  String get checkInternetConnection => _text(
    'تاكد من اتصالك بالانترنت.',
    'Please check your internet connection.',
  );
  String get genericTryAgain => _text(
    'لقد حدث خطأ ما. الرجاء المحاولة مرة اخرى.',
    'Something went wrong. Please try again.',
  );
  String get invalidCredentials => _text(
    'الرقم السري او البريد الالكتروني غير صحيح.',
    'The email or password is incorrect.',
  );
  String get noNetworkTitle => _text(
    'لا يوجد اتصال بالشبكة',
    'No network connection',
  );
  String get noNetworkMessage => _text(
    'يبدو أنك غير متصل بأي شبكة حاليًا. تحقق من الواي فاي أو بيانات الهاتف.',
    'It looks like you are not connected to any network right now. Check your Wi-Fi or mobile data.',
  );
  String get noInternetTitle => _text(
    'لا يوجد اتصال بالإنترنت',
    'No internet connection',
  );
  String get noInternetMessage => _text(
    'أنت متصل بالشبكة، لكن لا يوجد اتصال فعلي بالإنترنت في الوقت الحالي.',
    'You are connected to a network, but there is no active internet connection at the moment.',
  );
  String get titleError => _text('خطأ', 'Error');
  String get titleSuccess => _text('تم بنجاح', 'Success');
  String get newOrder => _text('طلب جديد', 'New order');
  String get customerCreatedNewOrder => _text(
    'قام عميل بإنشاء طلب جديد',
    'A customer created a new order.',
  );
  String get overallTotal => _text('الإجمالي', 'Total');

  String priceWithCurrency(String amount) {
    return _text('$amount جنيه', '$amount EGP');
  }

  String pricePerKilo(String amount) {
    return _text('$amount جنيه / الكيلو', '$amount EGP / kg');
  }

  String grams(String amount) {
    return _text('$amount جم', '$amount g');
  }

  String days(String amount) {
    return _text('$amount يوم', '$amount days');
  }

  String calories(String amount) {
    return _text('$amount كالوري', '$amount cal');
  }

  String resultsCount(int count) {
    return _text('$count نتائج', '$count results');
  }

  String cartHeader(int count) {
    return _text(
      'لديك $count منتجات في سله التسوق',
      'You have $count products in your cart',
    );
  }

  String paymentButton(String amount) {
    return _text('الدفع $amount جنيه', 'Pay $amount EGP');
  }

  String orderNumber(String orderNumber) {
    return _text('رقم الطلب: $orderNumber', 'Order number: $orderNumber');
  }

  String orderLabel(String orderId) {
    return _text('طلب #$orderId', 'Order #$orderId');
  }

  String orderDetailsTitle(String orderId) {
    return _text('تفاصيل الطلب #$orderId', 'Order details #$orderId');
  }

  String orderItemsCount(int count) {
    return _text('$count منتج', '$count items');
  }

  String addedQuantityToCart(int quantity, String productName) {
    return _text(
      'تمت إضافة $quantity من $productName إلى السلة',
      'Added $quantity of $productName to the cart.',
    );
  }

  String highlightedOrderBanner(String orderId) {
    return _text(
      'تم فتح الإشعار الخاص بالطلب رقم: $orderId',
      'Opened the notification for order: $orderId',
    );
  }

  String minutesAgo(int minutes) {
    return _text('منذ $minutes دقيقة', '$minutes minutes ago');
  }

  String hoursAgo(int hours) {
    return _text('منذ $hours ساعة', '$hours hours ago');
  }

  String daysAgo(int days) {
    return _text('منذ $days يوم', '$days days ago');
  }

  String detailsStatusLabel(String status) {
    return _text('الحالة: $status', 'Status: $status');
  }

  String codeLabel(String code) {
    return _text('كود: $code', 'Code: $code');
  }

  String quantityLabel(int quantity) {
    return _text('الكمية: $quantity', 'Quantity: $quantity');
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'en' || locale.languageCode == 'ar';
  }

  @override
  Future<S> load(Locale locale) => S.load(locale);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
