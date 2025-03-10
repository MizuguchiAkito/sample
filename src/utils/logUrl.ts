import { getCurrentInvoke } from "@vendia/serverless-express";
import type { Context } from "aws-lambda";

export const getCurrentLogUrl = () => {
  const { context } = getCurrentInvoke() as {
    context?: Context;
  };
  if (!context) {
    return {
      valid: false,
      message: "current invoke is not lambda",
    } as const;
  }
  const region = context.invokedFunctionArn.split(":")[3];
  if (!region) {
    return {
      valid: false,
      message: "current invoke is not lambda",
    } as const;
  }
  const { logStreamName, logGroupName, awsRequestId } = context;
  const url =
    `https://console.aws.amazon.com/cloudwatch/home?region=${region}#logsV2:log-groups/log-group/${encodeURIComponent(
      logGroupName
    )}/log-events/${encodeURIComponent(
      logStreamName
    )}?filterPattern=$2522${encodeURIComponent(awsRequestId)}$2522` as const;
  return { valid: true, url } as const;
};
