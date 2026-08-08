import {initializeApp} from "firebase-admin/app";

initializeApp();

export {
  createStudentAccount,
  updateStudentPassword,
  updateStudentEmail,
  updateStudentAccountStatus,
  deleteStudentAccount,
} from "./student_auth/student_auth_functions";

export {
  deactivateExpiredStudentAccounts,
} from "./student_subscription/student_subscription_scheduler";
