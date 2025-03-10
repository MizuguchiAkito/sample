import "source-map-support/register.js";
import { configure as serverlessExpress } from "@vendia/serverless-express";
import type { APIGatewayProxyEvent, Context } from "aws-lambda";

import { app } from "@/app/app.js";
import { logger } from "@/utils/logger.js";

export const handler = serverlessExpress({ app });

// for debug
export const printer = (event: APIGatewayProxyEvent, context: Context) => {
  logger.log(JSON.stringify(event));
  logger.log(JSON.stringify(context));
  return {};
};
