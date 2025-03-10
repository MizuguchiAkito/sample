import { getCurrentLogUrl } from "@/utils/logUrl.js";

vi.mock("@vendia/serverless-express");

test("local", async () => {
  // mock impl
  const sls = await import("@vendia/serverless-express");
  sls.getCurrentInvoke = (
    await vi.importActual<typeof sls>("@vendia/serverless-express")
  ).getCurrentInvoke;

  const result = getCurrentLogUrl();
  expect(result).toEqual({
    valid: false,
    message: "current invoke is not lambda",
  });
});

test("Url", async () => {
  // mock impl
  const sls = await import("@vendia/serverless-express");
  sls.getCurrentInvoke = vi.fn(() => {
    const context = {
      name: "vitestMocked",
      version: "$LATEST",
      accountId: "123456789012",
    } as const;
    return {
      context: {
        functionVersion: `${context.version}`,
        functionName: `${context.name}`,
        memoryLimitInMB: "512",
        logGroupName: `/aws/lambda/${context.name}`,
        logStreamName: `2023/02/28/${context.version}ac9b24e615fc48059f027db077fec899`,
        clientContext: undefined,
        identity: undefined,
        invokedFunctionArn: `arn:aws:lambda:ap-northeast-1:${context.accountId}:function:${context.name}`,
        awsRequestId: "896d1435-8899-46dd-a475-f4997d5eeca8",
      },
    };
  });

  const result = getCurrentLogUrl();
  expect(result).toEqual({
    valid: true,
    url: "https://console.aws.amazon.com/cloudwatch/home?region=ap-northeast-1#logsV2:log-groups/log-group/%2Faws%2Flambda%2FvitestMocked/log-events/2023%2F02%2F28%2F%24LATESTac9b24e615fc48059f027db077fec899?filterPattern=$2522896d1435-8899-46dd-a475-f4997d5eeca8$2522",
  });
});
