import type { ApiHandler } from "@/app/HandlerTypes.js";
import { logger } from "@/utils/logger.js";

export default function () {
  const post: ApiHandler<"/uppercase", "post"> = function (req, res) {
    logger.info(req.body);

    res.status(200).json({
      output: "test",
    });
  };

  return {
    post,
  };
}
