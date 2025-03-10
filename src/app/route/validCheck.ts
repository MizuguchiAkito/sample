import type { ApiHandler } from "@/app/HandlerTypes.js";
import { logger } from "@/utils/logger.js";

export default function () {
  const post: ApiHandler<"/validCheck", "post"> = function (req, res) {
    logger.info(req.body);

    res.sendStatus(200);
  };

  return {
    post,
  };
}
