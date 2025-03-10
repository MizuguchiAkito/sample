import type { ApiHandler } from "@/app/HandlerTypes.js";

export default function () {
  const get: ApiHandler<"/ping", "get"> = function (_req, res) {
    res.status(200).json({
      message: "pong",
    });
  };

  return {
    get,
  };
}
