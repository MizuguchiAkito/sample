import type { Handler } from "aws-lambda";
import { logger } from "@/utils/logger.js";

// eslint-disable-next-line @typescript-eslint/require-await
export const handler: Handler = async (event, context) => {
  logger.info(event);
  logger.info(context);
  return {
    message: "success",
  };
};
