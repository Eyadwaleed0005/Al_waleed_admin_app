import {getAuth} from "firebase-admin/auth";
import {
  FieldValue,
  getFirestore,
  Timestamp,
} from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import {onSchedule} from "firebase-functions/v2/scheduler";

const region = "us-central1";

const maxStudentsPerRun = 100;

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

function getErrorMessage(
  error: unknown,
): string {
  if (
    typeof error === "object" &&
    error !== null &&
    "message" in error
  ) {
    return String(error.message);
  }

  return "Unknown error.";
}

export const deactivateExpiredStudentAccounts =
  onSchedule(
    {
      schedule: "every 2 hours",
      timeZone: "Africa/Cairo",
      region,
      memory: "256MiB",
      cpu: "gcf_gen1",
      timeoutSeconds: 60,
      minInstances: 0,
      maxInstances: 1,
      retryCount: 0,
    },
    async () => {
      const firestore = getFirestore();
      const auth = getAuth();
      const now = Timestamp.now();

      const expiredStudentsSnapshot =
        await firestore
          .collection(
            firestoreCollections.students,
          )
          .where(
            firestoreFields.isActive,
            "==",
            true,
          )
          .where(
            firestoreFields.subscriptionEndAt,
            "<=",
            now,
          )
          .orderBy(
            firestoreFields.subscriptionEndAt,
            "asc",
          )
          .limit(maxStudentsPerRun)
          .get();

      if (expiredStudentsSnapshot.empty) {
        logger.info(
          "No expired student accounts found.",
        );

        return;
      }

      await Promise.all(
        expiredStudentsSnapshot.docs.map(
          async (studentDocument) => {
            const studentId =
              studentDocument.id;

            const subscriptionEndAt =
              studentDocument.get(
                firestoreFields.subscriptionEndAt,
              );

            if (
              !(subscriptionEndAt instanceof Timestamp)
            ) {
              logger.warn(
                "Student has an invalid subscription end date.",
                {
                  studentId,
                },
              );

              return;
            }

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
                [firestoreFields.isActive]:
                  false,
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
                  errorCode,
                  errorMessage:
                    getErrorMessage(error),
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
            expiredStudentsSnapshot.size,
        },
      );
    },
  );
