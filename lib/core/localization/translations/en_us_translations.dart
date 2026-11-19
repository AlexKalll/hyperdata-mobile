/// English (United States) translations
const Map<String, String> enUS = {
  'home.tasks.type.image_to_text': 'Image to Text',
  'home.tasks.source_image': 'Source image',
  'home.tasks.enlarge_image': 'Enlarge image · pinch to zoom',
  'home.tasks.image_unavailable':
      'Image could not be loaded. Try again or reopen the task.',
  // ============ COMMON ============
  'common.app_name': 'Mahder',
  'common.ok': 'OK',
  'common.cancel': 'Cancel',
  'common.save': 'Save',
  'common.delete': 'Delete',
  'common.edit': 'Edit',
  'common.submit': 'Submit',
  'common.loading': 'Loading...',
  'common.error': 'Error',
  'common.success': 'Success',
  'common.yes': 'Yes',
  'common.no': 'No',
  'common.confirm': 'Confirm',
  'common.back': 'Back',
  'common.next': 'Next',
  'common.done': 'Done',
  'common.close': 'Close',
  'common.search': 'Search',
  'common.filter': 'Filter',
  'common.refresh': 'Refresh',
  'common.retry': 'Retry',
  'common.continue': 'Continue',
  'common.skip': 'Skip',
  'common.update': 'Update',
  'common.create': 'Create',
  'common.add': 'Add',
  'common.remove': 'Remove',
  'common.view': 'View',
  'common.download': 'Download',
  'common.upload': 'Upload',
  'common.send': 'Send',
  'common.receive': 'Receive',
  'common.select': 'Select',
  'common.clear': 'Clear',
  'common.reset': 'Reset',
  'common.apply': 'Apply',
  'common.discard': 'Discard',
  'common.proceed': 'Proceed',
  'common.finish': 'Finish',
  'common.start': 'Start',
  'common.stop': 'Stop',
  'common.pause': 'Pause',
  'common.resume': 'Resume',
  'common.enable': 'Enable',
  'common.disable': 'Disable',
  'common.show': 'Show',
  'common.hide': 'Hide',
  'common.select_language': 'Select Language',
  'common.more': 'More',
  'common.less': 'Less',
  'common.all': 'All',
  'common.none': 'None',
  'common.optional': 'Optional',
  'common.required': 'Required',
  'common.text': 'Text',

  // Navigation
  'common.nav.home': 'Home',
  'common.nav.tasks': 'Tasks',
  'common.nav.submission': 'Submission',

  // ============ AUTH ============
  // Login Screen
  'auth.login.title': 'Login',
  'auth.login.welcome': 'Welcome back!',
  'auth.login.subtitle': 'Enter Your phone number and password to login',
  'auth.login.phone': 'Phone Number',
  'auth.login.phone_placeholder': 'Enter your phone number',
  'auth.login.password': 'Password',
  'auth.login.password_placeholder': 'Enter your password',
  'auth.login.button': 'Login',
  'auth.login.loading': 'Logging in',
  'auth.login.forgot_password': 'Forgot Password?',
  'auth.login.no_account': "Don't have an account? ",
  'auth.login.sign_up': 'Sign up',

  // Register Screen
  'auth.register.title': 'Register',
  'auth.register.welcome': "Let's get started!",
  'auth.register.subtitle':
      'Enter Your phone number to receive a verification code',
  'auth.register.phone': 'Phone Number',
  'auth.register.phone_placeholder': 'Enter your phone number',
  'auth.register.button': 'Continue',
  'auth.register.loading': 'Continuing',
  'auth.register.have_account': 'Already have an account? ',
  'auth.register.login': 'Login',

  // OTP/Activation Screen
  'auth.otp.title': 'Verification Code',
  'auth.otp.subtitle': 'We sent a confirmation code to',
  'auth.otp.button': 'Activate account',
  'auth.otp.loading': 'Activating account',
  'auth.otp.resend': 'Resend code',
  'auth.otp.resend_timer': 'Resend code in @time',
  'auth.otp.error_invalid': 'Please enter a valid 6-digit code',

  // Forgot Password - Request OTP
  'auth.forgot_password.title': 'Reset Password',
  'auth.forgot_password.subtitle':
      'Enter your phone number to receive a verification code',
  'auth.forgot_password.phone_label': 'Phone',
  'auth.forgot_password.phone_placeholder': 'Enter your phone number',
  'auth.forgot_password.check_messages': 'Please check your messages.',
  'auth.forgot_password.no_message':
      "If you don't see any text message, please contact",
  'auth.forgot_password.support_email': 'support@lematstock.com',
  'auth.forgot_password.request_button': 'Request code',
  'auth.forgot_password.request_loading': 'Requesting code...',

  // Forgot Password - Verify OTP
  'auth.forgot_password.verify_title': 'Enter confirmation code',
  'auth.forgot_password.verify_subtitle': 'A 6-digit code was sent to',
  'auth.forgot_password.verify_button': 'Verify',
  'auth.forgot_password.verify_loading': 'Verifying...',

  // Forgot Password - Reset Password
  'auth.forgot_password.reset_title': 'Create New Password',
  'auth.forgot_password.new_password': 'New Password',
  'auth.forgot_password.confirm_password': 'Confirm Password',
  'auth.forgot_password.password_requirements': 'Password must contain:',
  'auth.forgot_password.requirement_length': 'At least 8 characters.',
  'auth.forgot_password.requirement_uppercase':
      'At least 1 uppercase letter (A-Z)',
  'auth.forgot_password.requirement_lowercase':
      'At least 1 lowercase letter (a-z)',
  'auth.forgot_password.requirement_number': 'At least 1 number (0-9)',
  'auth.forgot_password.requirement_special':
      'At least 1 special character (!@#%^&*~)',
  'auth.forgot_password.reset_button': 'Reset password',
  'auth.forgot_password.reset_loading': 'Resetting password...',

  // Profile Registration - User Info
  'auth.profile.user_info_title': 'User Information!',
  'auth.profile.user_info_subtitle': 'Enter your name , birth date and gender',
  'auth.profile.first_name': 'First Name',
  'auth.profile.first_name_placeholder': 'Enter your first name',
  'auth.profile.middle_name': 'Middle Name',
  'auth.profile.middle_name_placeholder': 'Enter your middle name',
  'auth.profile.last_name': 'Last Name',
  'auth.profile.last_name_placeholder': 'Enter your last name',
  'auth.profile.birth_date': 'Birth Date',
  'auth.profile.birth_date_placeholder': 'Select your birth date',
  'auth.profile.gender': 'Gender',
  'auth.profile.gender_placeholder': 'Select your gender',
  'auth.profile.gender_male': 'Male',
  'auth.profile.gender_female': 'Female',

  // Profile Registration - Terms and Conditions
  'auth.profile.terms_title': 'Terms and Conditions',
  'auth.profile.terms_subtitle': 'Read these terms and conditions to continue',
  'auth.profile.terms_1_title': 'Terms and Conditions',
  'auth.profile.terms_1_content':
      'By using this app, you agree to the following terms and conditions. Please read them carefully before proceeding.',
  'auth.profile.terms_2_title': 'User Conduct',
  'auth.profile.terms_2_content':
      'You agree to use this app in a manner that is lawful and respectful of others. Any form of harassment or abuse will not be tolerated.',
  'auth.profile.terms_3_title': 'Privacy Policy',
  'auth.profile.terms_3_content':
      'We value your privacy. Please review our privacy policy to understand how we collect, use, and protect your personal information.',
  'auth.profile.terms_4_title': 'Changes to Terms',
  'auth.profile.terms_4_content':
      'We reserve the right to modify these terms at any time. Continued use of the app constitutes acceptance of the new terms.',

  // Profile Registration - Additional Info
  'auth.profile.additional_info_title': 'Additional Information',
  'auth.profile.additional_info_subtitle':
      'Choose your language , dialect and email address',
  'auth.profile.language_spoken': 'Language Spoken',
  'auth.profile.language_placeholder': 'Select your language',
  'auth.profile.dialect': 'Dialect Group',
  'auth.profile.dialect_placeholder': 'Select your dialect',
  'auth.profile.dialect_error': 'Please select a language first.',
  'auth.profile.email': 'Email Address',
  'auth.profile.email_placeholder': 'Enter your email address',

  // Profile Registration - Password
  'auth.profile.password_title': 'Create Password!',
  'auth.profile.password_subtitle': 'Choose a unique and strong password',
  'auth.profile.password': 'Password',
  'auth.profile.password_placeholder': 'Enter your password',
  'auth.profile.confirm_password': 'Confirm Password',
  'auth.profile.confirm_password_placeholder': 'Confirm your password',
  'auth.profile.create_button': 'Create Account',
  'auth.profile.create_loading': 'Creating account',

  // ============ HOME ============
  'home.title': 'Home',
  'home.welcome': 'Welcome',
  'home.greeting': 'Hello @name,',
  'home.welcome_message': 'Welcome to Mahder',
  'home.greeting_morning': 'Good Morning',
  'home.greeting_afternoon': 'Good Afternoon',
  'home.greeting_evening': 'Good Evening',

  // Wallet
  'home.wallet.balance': 'Your wallet balance',
  'home.wallet.withdraw': 'Withdraw',
  'home.wallet.history': 'History',
  'home.wallet.currency': 'ETB',

  // ============ TASKS ============
  'home.tasks.title': 'Tasks',
  'home.tasks.your_tasks': 'Your Tasks',
  'home.tasks.my_tasks': 'My Tasks',
  'home.tasks.empty': 'No tasks available',
  'home.tasks.empty_subtitle': 'Check back later for new tasks',
  'home.tasks.refresh': 'Refresh',

  // Task Filters
  'home.tasks.filter.all': 'All',
  'home.tasks.filter.recent': 'Recent',
  'home.tasks.filter.new': 'New',
  'home.tasks.filter.completed': 'Approved',

  // Task Status
  'home.tasks.pending': 'Pending',
  'home.tasks.in_progress': 'In Progress',
  'home.tasks.completed': 'Completed',
  'home.tasks.rejected': 'Rejected',
  'home.tasks.approved': 'Approved',
  'home.tasks.under_review': 'Under Review',

  // Task Actions
  'home.tasks.view_details': 'View Details',
  'home.tasks.get_started': 'Get Started',
  'home.tasks.continue': 'Continue',
  'home.tasks.view_submissions': 'View Submissions',
  'home.tasks.submit': 'Submit Task',
  'home.tasks.submit_button': 'Submit',

  // Task Details
  'home.tasks.deadline_on': 'Deadline on',
  'home.tasks.submitted_on': 'Submitted on',
  'home.tasks.average_time': '@time min',
  'home.tasks.average_time_label': 'Average Time',
  'home.tasks.due_date': 'Due Date',
  'home.tasks.description': 'Description',
  'home.tasks.instructions': 'Instructions',
  'home.tasks.no_instructions': 'No instructions provided for this task.',
  'home.tasks.task_details': 'Task Details',
  'home.tasks.deadline': 'Deadline',
  'home.tasks.estimated_earning': 'Estimated Earning',
  'home.tasks.earning_per_task': 'Earning Per Task',
  'home.tasks.text_instructions': 'Text Instructions',
  'home.tasks.image_guide': 'Image Guide',
  'home.tasks.video_guide': 'Video Guide',
  'home.tasks.audio_guide': 'Audio Guide',
  'home.tasks.start_task': 'Start Task',

  // Task Types
  'home.tasks.type.speech_to_text': 'Speech to Text',
  'home.tasks.type.text_to_speech': 'Text to Speech',
  'home.tasks.type.text_to_text': 'Text to Text',

  // Task Status Badges
  'home.tasks.status.no_test_required': 'No Test Required',
  'home.tasks.status.test_required': 'Test Required',
  'home.tasks.status.task_rejected': '@count Task Rejected',
  'home.tasks.status.task_under_review': '@count Task Under Review',
  'home.tasks.status.task_approved': '@count Task Approved',

  // Task Submission
  'home.tasks.submission_title': 'Task Submission',
  'home.tasks.submission_subtitle': 'Submit your completed task',
  'home.tasks.submitting': 'Submitting your request...',
  'home.tasks.loading_details': 'Loading task details',
  'home.tasks.error_loading': 'Error loading task details.',
  'home.tasks.no_micro_tasks':
      'No micro tasks available for this task. Please check back later or contact support if you believe this is an error.',
  'home.tasks.invalid_task_type': 'Invalid Task Type.',
  'home.tasks.invalid_task_detail': 'Invalid Task Detail.',

  // Task Feedback
  'home.tasks.feedback': 'Feedback',
  'home.tasks.rejection_reason': 'Reason/s',
  'home.tasks.no_reason': 'No reason provided',
  'home.tasks.submission_rejected':
      'Your submission was rejected by our reviewers',
  'home.tasks.submission_rejected_comment': 'Reviewer Comment:',
  'home.tasks.no_submission': 'No submission available',
  'home.tasks.no_submission_text': 'No submission text',
  'home.tasks.attempts_left': 'You have @count attempt(s) left',
  'home.tasks.enter_text_error': 'Please enter some text before submitting.',
  'home.tasks.type_text_placeholder': 'Type your text here ...',
  'home.tasks.recording': 'Recording',
  'home.tasks.tap_to_record': 'Tap to start recording',
  'home.tasks.duration_range': 'Duration: @mins - @maxs',
  'home.tasks.min_duration': 'Min duration: @mins',
  'home.tasks.max_duration': 'Max duration: @maxs',
  'home.tasks.recording_too_short':
      'Recording too short. Minimum duration: @mins',
  'home.tasks.recording_too_long':
      'Recording too long. Maximum duration: @maxs',
  'home.tasks.stop_recording_before_switch':
      'Please stop the current recording before switching.',
  'home.tasks.need_more_seconds': 'Need @secondss more',
  'home.tasks.exceeded_by_seconds': 'Exceeded by @secondss',
  'home.tasks.seconds_remaining': '@secondss remaining',
  'home.tasks.no_text_available': 'No text available',

  // Task Test
  'home.tasks.test.title': 'Task Test',
  'home.tasks.test.description':
      'This task requires the user to take a qualification test first.',
  'home.tasks.test.take_test': 'Take Test',
  'home.tasks.test.take_test_again': 'Take Test again',
  'home.tasks.test.do_other_tasks': 'Do other Tasks',
  'home.tasks.test.back_to_tasks': 'Back to Tasks',

  // Test Status
  'home.tasks.test.under_review_title': 'Test Under Review',
  'home.tasks.test.under_review_message':
      'Your application is currently under review. We will notify you of the outcome as soon as the review process is complete. Thank you for your patience.',
  'home.tasks.test.rejected_title': 'Test Rejected',
  'home.tasks.test.rejected_message':
      'Unfortunately your test has been rejected by our reviewers , you can either try again or do other tasks.',

  // ============ PROFILE ============
  // Profile View Screen
  'profile.title': 'Profile',
  'profile.my_profile': 'My Profile',
  'profile.loading_profile': 'Loading Profile...',

  // Profile Options
  'profile.edit': 'Edit Profile',
  'profile.language': 'Language',
  'profile.help': 'Help',
  'profile.privacy_security': 'Privacy and Security',
  'profile.logout': 'Log out',

  // Logout Dialog
  'profile.logout_title': 'Logout',
  'profile.logout_confirm': 'Are you sure you want to logout?',
  'profile.logout_button': 'Logout',

  // Edit Profile Screen
  'profile.edit_title': 'Edit Profile',
  'profile.first_name': 'First Name',
  'profile.first_name_placeholder': 'Enter your first name',
  'profile.middle_name': 'Middle Name',
  'profile.middle_name_placeholder': 'Enter your middle name (optional)',
  'profile.last_name': 'Last Name',
  'profile.last_name_placeholder': 'Enter your last name',
  'profile.email': 'Email',
  'profile.email_placeholder': 'Enter your email address',
  'profile.date_of_birth': 'Date of Birth',
  'profile.date_of_birth_placeholder': 'Select your date of birth',
  'profile.gender': 'Gender',
  'profile.gender_placeholder': 'Select your gender',
  'profile.language_spoken': 'Language Spoken',
  'profile.language_spoken_placeholder': '--select',
  'profile.dialect_group': 'Dialect Group',
  'profile.dialect_group_placeholder': '--select',
  'profile.save_button': 'Save',
  'profile.saving_button': 'Saving',
  'profile.cancel_button': 'Cancel',

  // Settings Screen
  'profile.settings': 'Settings',
  'profile.personal_info': 'Personal Information',
  'profile.contact_info': 'Contact Information',
  'profile.account_info': 'Account Information',
  'profile.phone': 'Phone Number',
  'profile.address': 'Address',
  'profile.city': 'City',
  'profile.region': 'Region',
  'profile.update_button': 'Update Profile',
  'profile.change_password': 'Change Password',
  'profile.current_password': 'Current Password',
  'profile.current_password_placeholder': 'Enter your current password',
  'profile.new_password': 'New Password',
  'profile.new_password_placeholder': 'Enter your new password',
  'profile.confirm_password': 'Confirm Password',
  'profile.confirm_password_placeholder': 'Confirm your new password',
  'profile.change_password_button': 'Change Password',
  'profile.changing_password': 'Changing password...',

  // ============ NAVIGATION ============
  'nav.home': 'Home',
  'nav.tasks': 'Tasks',
  'nav.profile': 'Profile',
  'nav.settings': 'Settings',
  'nav.back_to_home': 'Back to Home',
  'nav.go_back': 'Go Back',
  'nav.menu': 'Menu',
  'nav.notifications': 'Notifications',
  'nav.messages': 'Messages',
  'nav.help': 'Help',
  'nav.about': 'About',
  'nav.contact': 'Contact',
  'nav.terms': 'Terms & Conditions',
  'nav.privacy': 'Privacy Policy',
  'nav.faq': 'FAQ',

  // ============ NOTIFICATIONS ============
  'notifications.title': 'Notifications',
  'notifications.empty_title': 'No notifications yet',
  'notifications.empty_subtitle':
      'You\'ll see notifications here when you receive them',
  'notifications.error_title': 'Failed to load notifications',
  'notifications.error_subtitle': 'Please check your connection and try again',
  'notifications.retry': 'Retry',
  'notifications.load_failed': 'Load Failed! Tap to retry',
  'notifications.release_to_load': 'Release to load more',
  'notifications.no_more': 'No more notifications',

  // ============ VALIDATION ============
  'validation.required': 'This field is required',
  'validation.email': 'Please enter a valid email',
  'validation.phone': 'Please enter a valid phone number',
  'validation.password_min': 'Password must be at least 6 characters',
  'validation.password_match': 'Passwords do not match',
  'validation.invalid_format': 'Invalid format',
  'validation.min_length': 'Minimum length is @min characters',
  'validation.max_length': 'Maximum length is @max characters',
  'validation.invalid_input': 'Invalid input',
  'validation.field_empty': 'Field cannot be empty',
  'validation.invalid_date': 'Invalid date',
  'validation.invalid_number': 'Invalid number',
  'validation.too_short': 'Input is too short',
  'validation.too_long': 'Input is too long',
  'validation.invalid_characters': 'Contains invalid characters',
  'validation.must_be_positive': 'Must be a positive number',
  'validation.must_be_numeric': 'Must be numeric',
  'validation.select_option': 'Please select an option',
  'validation.accept_terms': 'Please accept the terms and conditions',
  'validation.field_required': '@field is required',
  'validation.password_min_8': '@field must be at least 8 characters long',
  'validation.password_uppercase':
      '@field must contain at least one uppercase letter',
  'validation.password_lowercase':
      '@field must contain at least one lowercase letter',
  'validation.password_number': '@field must contain at least one number',
  'validation.password_special':
      '@field must contain at least one special character',
  'validation.confirm_password_required': 'Confirm password is required',
  'validation.passwords_not_match': 'Passwords do not match',
  'validation.phone_required': 'Phone number is required',
  'validation.phone_9_digits': 'Phone number should have 9 digits',
  'validation.phone_format_incorrect': 'Phone number format is incorrect',
  'validation.invalid_email_format': 'Invalid email format',
  'validation.is_not_number': 'is not a valid number',
  'validation.date_required': '@field is required',
  'validation.date_invalid_format': 'Please enter a valid date (yyyy-MM-dd)',
  'validation.enter_field': 'Enter @field',
  'validation.enter_phone': 'Enter your phone number',
  'validation.choose_field': 'Choose @field',
  'validation.select_field': 'Select @field',

  // ============ ERRORS ============
  'error.network': 'Network error. Please check your connection.',
  'error.server': 'Server error. Please try again later.',
  'error.timeout': 'Request timeout. Please try again.',
  'error.unauthorized': 'Unauthorized. Please login again.',
  'error.forbidden': 'Access forbidden.',
  'error.not_found': 'Resource not found.',
  'error.unknown': 'An unknown error occurred.',
  'error.invalid_credentials': 'Invalid email or password.',
  'error.account_not_activated':
      'Account not activated. Please verify your account.',
  'error.connection_failed': 'Connection failed. Please try again.',
  'error.no_internet': 'No internet connection.',
  'error.bad_request': 'Bad request. Please check your input.',
  'error.internal_server': 'Internal server error.',
  'error.service_unavailable': 'Service temporarily unavailable.',
  'error.too_many_requests': 'Too many requests. Please wait and try again.',
  'error.session_expired': 'Your session has expired. Please login again.',
  'error.permission_denied': 'Permission denied.',
  'error.file_not_found': 'File not found.',
  'error.file_too_large': 'File is too large.',
  'error.unsupported_format': 'Unsupported file format.',
  'error.operation_failed': 'Operation failed. Please try again.',
  'error.data_load_failed': 'Failed to load data.',
  'error.data_save_failed': 'Failed to save data.',
  'error.something_went_wrong': 'Something went wrong. Please try again.',

  // ============ SUCCESS ============
  'success.login': 'Login successful',
  'success.register': 'Registration successful',
  'success.profile_updated': 'Profile updated successfully',
  'success.password_changed': 'Password changed successfully',
  'success.task_submitted': 'Task submitted successfully',
  'success.verification_sent': 'Verification code sent',
  'success.saved': 'Saved successfully',
  'success.deleted': 'Deleted successfully',
  'success.updated': 'Updated successfully',
  'success.created': 'Created successfully',
  'success.sent': 'Sent successfully',
  'success.uploaded': 'Uploaded successfully',
  'success.downloaded': 'Downloaded successfully',
  'success.operation_complete': 'Operation completed successfully',
  'success.changes_saved': 'Changes saved successfully',
  'success.email_verified': 'Email verified successfully',
  'success.phone_verified': 'Phone number verified successfully',

  // ============ LANGUAGE ============
  'language.select': 'Select Language',
  'language.current': 'Current Language',
  'language.english': 'English',
  'language.amharic': 'Amharic',
  'language.afan_oromo': 'Afan Oromo',

  // ============ ONBOARDING ============
  'onboarding.task_submission.back_button_title': 'Go Back',
  'onboarding.task_submission.back_button_desc':
      'Tap this button to leave this task and return to the previous page.',
  'onboarding.task_submission.title_title': 'Task Name',
  'onboarding.task_submission.title_desc':
      'This shows the name of the task you are currently working on.',
  'onboarding.task_submission.info_button_title': 'Instructions',
  'onboarding.task_submission.info_button_desc':
      'Tap this button to view the full task instructions.',
  'onboarding.task_submission.progress_title': 'Progress',
  'onboarding.task_submission.progress_desc':
      'This shows how many micro tasks you have completed and how many remain.',
  'onboarding.task_submission.navigation_title': 'Navigation',
  'onboarding.task_submission.navigation_desc':
      'Use these buttons to move between micro tasks or swipe up and down.',
  'onboarding.task_submission.content_title': 'Task Content',
  'onboarding.task_submission.content_desc':
      'This is where you perform your task.',
  'onboarding.task_submission.tts_content_title': 'Record Audio',
  'onboarding.task_submission.tts_content_desc':
      'Read the given text. Start by tapping the microphone button, read, and tap again when finished.',
  'onboarding.task_submission.ttt_content_title': 'Write Text',
  'onboarding.task_submission.ttt_content_desc':
      'Translate the given text into your language. Write and tap "Continue" when finished.',
  'onboarding.task_submission.stt_content_title': 'Listen to Audio',
  'onboarding.task_submission.stt_content_desc':
      'Listen to the audio and write what you hear. Start by tapping the play button.',

  // Text-to-Speech specific elements
  'onboarding.tts.mic_button_title': 'Microphone Button',
  'onboarding.tts.mic_button_desc':
      'Tap to start recording. Tap again when you finish reading.',
  'onboarding.tts.submit_button_title': 'Submit',
  'onboarding.tts.submit_button_desc':
      'Tap this button to submit your recording when finished.',
  'onboarding.tts.restart_button_title': 'Restart',
  'onboarding.tts.restart_button_desc':
      'Tap this button to delete the recording and start fresh.',

  // Text-to-Text specific elements
  'onboarding.ttt.text_input_title': 'Text Input Field',
  'onboarding.ttt.text_input_desc': 'Write your translation or text here.',
  'onboarding.ttt.submit_button_title': 'Submit/Continue',
  'onboarding.ttt.submit_button_desc':
      'Tap to submit your text and move to the next task.',
  'onboarding.ttt.cancel_button_title': 'Cancel',
  'onboarding.ttt.cancel_button_desc': 'Tap this button to clear your text.',

  // Speech-to-Text specific elements
  'onboarding.stt.audio_player_title': 'Audio Player',
  'onboarding.stt.audio_player_desc':
      'Tap the play button to listen to the audio.',
  'onboarding.stt.text_input_title': 'Text Input Field',
  'onboarding.stt.text_input_desc': 'Write what you hear here.',
  'onboarding.stt.submit_button_title': 'Submit/Continue',
  'onboarding.stt.submit_button_desc':
      'Tap to submit your text and move to the next task.',
};
