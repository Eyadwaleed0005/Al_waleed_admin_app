import {getAuth} from "firebase-admin/auth";
import {
  HttpsError,
  onCall,
} from "firebase-functions/v2/https";

const region = "us-central1";

const callableFunctionOptions = {
  region,
  memory: "256MiB" as const,
  cpu: "gcf_gen1" as const,
  timeoutSeconds: 60,
  minInstances: 0,
  maxInstances: 1,
};

function getRequestData(
  data: unknown,
): Record<string, unknown> {
  if (
    typeof data !== "object" ||
    data === null
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Request data is invalid.",
    );
  }

  return data as Record<string, unknown>;
}

function getRequiredString(
  data: Record<string, unknown>,
  key: string,
): string {
  const value = data[key];

  if (
    typeof value !== "string" ||
    value.trim().length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      `${key} is required.`,
    );
  }

  return value.trim();
}

function getRequiredPassword(
  data: Record<string, unknown>,
  key: string,
): string {
  const value = data[key];

  if (
    typeof value !== "string" ||
    value.length === 0
  ) {
    throw new HttpsError(
      "invalid-argument",
      `${key} is required.`,
    );
  }

  return value;
}

function getRequiredBoolean(
  data: Record<string, unknown>,
  key: string,
): boolean {
  const value = data[key];

  if (typeof value !== "boolean") {
    throw new HttpsError(
      "invalid-argument",
      `${key} must be a boolean.`,
    );
  }

  return value;
}

function validatePassword(
  password: string,
): void {
  if (password.length < 8) {
    throw new HttpsError(
      "invalid-argument",
      "Password must contain at least 8 characters.",
    );
  }

  if (password.includes(" ")) {
    throw new HttpsError(
      "invalid-argument",
      "Password must not contain spaces.",
    );
  }

  if (!/[A-Z]/.test(password)) {
    throw new HttpsError(
      "invalid-argument",
      "Password must contain an uppercase letter.",
    );
  }

  if (!/[a-z]/.test(password)) {
    throw new HttpsError(
      "invalid-argument",
      "Password must contain a lowercase letter.",
    );
  }

  if (!/[0-9]/.test(password)) {
    throw new HttpsError(
      "invalid-argument",
      "Password must contain a number.",
    );
  }

  if (
    !/[!@#$%^&*(),.?":{}|<>]/.test(
      password,
    )
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Password must contain a special character.",
    );
  }
}

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

function handleAuthError(
  error: unknown,
): never {
  if (error instanceof HttpsError) {
    throw error;
  }

  const errorCode = getErrorCode(error);

  switch (errorCode) {
  case "auth/email-already-exists":
    throw new HttpsError(
      "already-exists",
      "An account already exists with this email.",
    );

  case "auth/uid-already-exists":
    throw new HttpsError(
      "already-exists",
      "An account already exists with this identifier.",
    );

  case "auth/user-not-found":
    throw new HttpsError(
      "not-found",
      "The requested account does not exist.",
    );

  case "auth/invalid-email":
  case "auth/invalid-password":
  case "auth/invalid-uid":
    throw new HttpsError(
      "invalid-argument",
      "The provided account data is invalid.",
    );

  case "auth/insufficient-permission":
    throw new HttpsError(
      "permission-denied",
      "The operation is not permitted.",
    );

  case "auth/too-many-requests":
  case "auth/quota-exceeded":
    throw new HttpsError(
      "resource-exhausted",
      "Too many requests. Please try again later.",
    );

  default:
    throw new HttpsError(
      "internal",
      "The operation could not be completed.",
    );
  }
}

export const createStudentAccount = onCall(
  callableFunctionOptions,
  async (request) => {
    try {
      const data = getRequestData(
        request.data,
      );

      const email = getRequiredString(
        data,
        "email",
      ).toLowerCase();

      const password = getRequiredPassword(
        data,
        "password",
      );

      validatePassword(password);

      const studentAccount =
          await getAuth().createUser({
            email,
            password,
            emailVerified: false,
            disabled: false,
          });

      return {
        studentId: studentAccount.uid,
      };
    } catch (error) {
      handleAuthError(error);
    }
  },
);

export const updateStudentPassword = onCall(
  callableFunctionOptions,
  async (request) => {
    try {
      const data = getRequestData(
        request.data,
      );

      const studentId = getRequiredString(
        data,
        "studentId",
      );

      const newPassword = getRequiredPassword(
        data,
        "newPassword",
      );

      validatePassword(newPassword);

      await getAuth().updateUser(
        studentId,
        {
          password: newPassword,
        },
      );

      return {
        success: true,
      };
    } catch (error) {
      handleAuthError(error);
    }
  },
);

export const updateStudentEmail = onCall(
  callableFunctionOptions,
  async (request) => {
    try {
      const data = getRequestData(
        request.data,
      );

      const studentId = getRequiredString(
        data,
        "studentId",
      );

      const newEmail = getRequiredString(
        data,
        "newEmail",
      ).toLowerCase();

      await getAuth().updateUser(
        studentId,
        {
          email: newEmail,
          emailVerified: false,
        },
      );

      return {
        success: true,
      };
    } catch (error) {
      handleAuthError(error);
    }
  },
);

export const updateStudentAccountStatus = onCall(
  callableFunctionOptions,
  async (request) => {
    try {
      const data = getRequestData(
        request.data,
      );

      const studentId = getRequiredString(
        data,
        "studentId",
      );

      const isActive = getRequiredBoolean(
        data,
        "isActive",
      );

      const auth = getAuth();

      await auth.updateUser(
        studentId,
        {
          disabled: !isActive,
        },
      );

      if (!isActive) {
        await auth.revokeRefreshTokens(
          studentId,
        );
      }

      return {
        success: true,
      };
    } catch (error) {
      handleAuthError(error);
    }
  },
);

export const deleteStudentAccount = onCall(
  callableFunctionOptions,
  async (request) => {
    try {
      const data = getRequestData(
        request.data,
      );

      const studentId = getRequiredString(
        data,
        "studentId",
      );

      await getAuth().deleteUser(
        studentId,
      );

      return {
        success: true,
      };
    } catch (error) {
      handleAuthError(error);
    }
  },
);
