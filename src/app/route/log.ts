import { logger } from "@/utils/logger.js";
import { getCurrentLogUrl } from "@/utils/logUrl.js";
import { getCurrentInvoke } from "@vendia/serverless-express";
import type { ApiHandler } from "@/app/HandlerTypes.js";

export default function () {
  const get: ApiHandler<"/log", "get"> = function (_req, res) {
    logger.trace("trace");
    logger.debug("debug");
    logger.info("info");
    logger.warn("warn");
    logger.error("error");
    logger.fatal("fatal");
    const { valid: _valid, ...result } = getCurrentLogUrl();
    logger.info(getCurrentInvoke());
    res.status(200).json(result);
  };

  return {
    get,
  };
}
