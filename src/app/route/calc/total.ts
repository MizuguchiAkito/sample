import type { dependencies } from "@/app/dependencies.js";
import type { ApiHandler } from "@/app/HandlerTypes.js";

export default function (services: typeof dependencies.services) {
  const get: ApiHandler<"/calc/total", "get"> = function (_req, res) {
    res.status(200).json({
      total: services.calculateService.total(),
    });
  };

  return {
    get,
  };
}
