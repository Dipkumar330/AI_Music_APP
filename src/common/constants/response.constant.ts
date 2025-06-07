export const RESPONSE_SUCCESS = {
  TASK_CREATED: 'Task Created Successfully',
  TASK_STATUS_CHANGE: 'Task Status Change Successfully',
  USER_LOGIN: 'User Successfully Login',
  USER_LISTED: 'Users Listed',
  USER_INSERTED: 'User Created',
  USER_UPDATED: 'User Updated',
  USER_DELETED: 'User Deleted',
  RECORD_LISTED: 'Records Listed',
  RECORD_INSERTED: 'Record Inserted',
  RECORD_UPDATED: 'Record Updated',
  RECORD_DELETED: 'Record Deleted'
};

export const RESPONSE_ERROR = {
  USER_NOT_FOUND: 'User not found',
  USER_ALREADY_EXIST: 'User already exist with this email',
    USER_ALREADY_EXIST_PHONE_NUMBER: 'User already exist with this phoneNumber'
};

export const USER_RESPONSE_SUCCESS = {
  USER_SIGN_UP_SUCC: 'User signup successfully.',
  USER_NOT_FOUND: 'User details not found.',
  USER_UPDATED_SUCC: 'User updated successfully.',
  USER_LOGIN_SUCC : "User signIn successfully.",
  USER_VERIFY_OTP_SUCC: "User verify otp successfully.",
  USER_SEND_OTP_SUCC : "User send otp successfully"
};

export const HOMEPAGE_RESPONSE_SUCCESS = {
  HOME_PAGE_LIST_SUCC: 'Home page list get successfully.',
};

export const COMMON_MSG = {
  EMAIL_ALREADY_EXISTS: 'This email id is already in use.',
  PHONE_NUM_ALREADY_EXISTS: 'This phoneNumber is already in use',
  INVALID_EMAIL_FORMAT: 'Invalid email format.',
  INVALID_PASSWORD_FORMAT:
    'Password must be at least 8 characters long and contain at least 1 special character, 1 number, and 1 capital letter'
};

export const MIDDLEWARE_MSG = {
  MID_USER_ACC_DELETED: 'Your account has been deleted. Please contact admin for assistance.',
  MID_USER_ACC_INACTIVE:
    'This account is currently inactive and cannot be accessed. Please contact admin for assistance.'
};
