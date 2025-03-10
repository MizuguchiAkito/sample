import { getCurrentInvoke } from "@vendia/serverless-express";
import type { ApiHandler } from "@/app/HandlerTypes.js";
import { logger } from "@/utils/logger.js";

export default function () {
  const get: ApiHandler<"/", "get"> = function (_req, res) {
    const currentInvoke = getCurrentInvoke();
    logger.info(currentInvoke);
    /* eslint-disable @typescript-eslint/no-unsafe-assignment */
    const { event = {} } = currentInvoke;
    const { requestContext = {} } = event;
    const { domainName = "localhost:3000" } = requestContext;
    /* eslint-enable @typescript-eslint/no-unsafe-assignment */
    const apiUrl = `https://${domainName}`;
    res.status(200).json({
      apiUrl,
    });
  };

  return {
    get,
  };
}
