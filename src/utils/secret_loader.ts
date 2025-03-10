import {
  SecretsManagerClient,
  type SecretsManagerClientConfig,
  GetSecretValueCommand,
  type GetSecretValueCommandInput,
} from "@aws-sdk/client-secrets-manager";
import { logger } from "@/utils/logger.js";

const secrets = new Map<string, string>();

let requestCSMCalled = false;
let requestCSMCallDone = false;

/**
 * 機密情報をSecretsManagerからロードする関数
 */
export async function requestCredentialsFromSecretManager() {
  requestCSMCalled = true;
  try {
    const clientConfig: SecretsManagerClientConfig = {
      region: "ap-northeast-1",
    };

    const client = new SecretsManagerClient(clientConfig);

    const input: GetSecretValueCommandInput = {
      SecretId: process.env["SECRET_NAME"],
    };

    const command = new GetSecretValueCommand(input);

    const result = await client.send(command);

    if (!result.SecretString) {
      throw new Error("get secret failed: unreachable.");
    }

    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    const secretObj: Record<string, string> = JSON.parse(result.SecretString);

    for (const key in secretObj) {
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      secrets.set(key, secretObj[key]!);
    }
    logger.info("Secret is Loaded!");
  } catch (e) {
    logger.error(e);
    logger.warn("Failed to load secret from Secret Manager.");
    logger.warn("Check your credentials.");
    logger.mark("Secret is only referenced locally.");
  }
  requestCSMCallDone = true;
}

/**
 * 機密情報を取得する関数
 * @param secretName 取得したい機密情報のKEY
 * @returns SECRET
 */
export async function getSecret(secretName: string): Promise<string> {
  if (!requestCSMCalled) {
    await requestCredentialsFromSecretManager();
  } else {
    if (!requestCSMCallDone) {
      throw new Error(
        "requestCEM is processing.\nCheck if your code has await.",
      );
    }
  }

  const envValue = process.env[secretName];

  if (envValue) {
    return envValue;
  }

  if (!secrets.has(secretName)) {
    throw new Error(
      secretName + " is NOT defined.\nPlease check your spell and CSM",
    );
  }

  // 必ず存在する
  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  return secrets.get(secretName)!;
}
