import {getAuth} from "firebase-admin/auth";
import {
  FieldValue,
  getFirestore,
  Timestamp,
} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {onSchedule} from "firebase-functions/v2/scheduler";

const region = "us-central1";

const firestoreCollections = {
  students: "students",
} as const;

const firestoreFields = {
  isActive: "isActive",
  subscriptionEndAt: "subscriptionEndAt",
  updatedAt: "updatedAt",
} as const;

function getErrorCode(
  error: unknown,
): string {
  if (
    typeof error === "object" &&
    error !== null &&
    "code" in error
  ) {
    return String(error.code);
  }

  return "";
}

export const deactivateExpiredStudentAccounts =
    onSchedule(
      {
        schedule: "every 5 minutes",
        timeZone: "Africa/Cairo",
        region,
      },
      async () => {
        const firestore = getFirestore();
        const auth = getAuth();
        const now = Timestamp.now();

        const activeStudentsSnapshot =
            await firestore
              .collection(
                firestoreCollections.students,
              )
              .where(
                firestoreFields.isActive,
                "==",
                true,
              )
              .get();

        const expiredStudents =
            activeStudentsSnapshot.docs.filter(
              (studentDocument) => {
                const subscriptionEndAt =
                    studentDocument.get(
                      firestoreFields
                        .subscriptionEndAt,
                    );

                if (
                  !(subscriptionEndAt instanceof Timestamp)
                ) {
                  logger.warn(
                    "Student has an invalid subscription end date.",
                    {
                      studentId: studentDocument.id,
                    },
                  );

                  return false;
                }

                return subscriptionEndAt.toMillis() <=
                    now.toMillis();
              },
            );

        if (expiredStudents.length === 0) {
          logger.info(
            "No expired student accounts found.",
          );

          return;
        }

        await Promise.all(
          expiredStudents.map(
            async (studentDocument) => {
              const studentId =
                  studentDocument.id;

              try {
                await auth.updateUser(
                  studentId,
                  {
                    disabled: true,
                  },
                );

                await auth.revokeRefreshTokens(
                  studentId,
                );

                await studentDocument.ref.update({
                  [firestoreFields.isActive]: false,
                  [firestoreFields.updatedAt]:
                      FieldValue.serverTimestamp(),
                });

                logger.info(
                  "Student account deactivated.",
                  {
                    studentId,
                  },
                );
              } catch (error) {
                const errorCode =
                    getErrorCode(error);

                if (
                  errorCode ===
                  "auth/user-not-found"
                ) {
                  await studentDocument.ref.update({
                    [firestoreFields.isActive]:
                        false,
                    [firestoreFields.updatedAt]:
                        FieldValue.serverTimestamp(),
                  });

                  logger.warn(
                    "Student Auth account was not found.",
                    {
                      studentId,
                    },
                  );

                  return;
                }

                logger.error(
                  "Failed to deactivate student account.",
                  {
                    studentId,
                    error,
                  },
                );
              }
            },
          ),
        );

        logger.info(
          "Expired subscriptions check completed.",
          {
            expiredStudentsCount:
                expiredStudents.length,
          },
        );
      },
    );
