import type { dependencies } from "@/app/dependencies.js";
import type { ApiHandler } from "@/app/HandlerTypes.js";

export default function (services: typeof dependencies.services) {
  const get: ApiHandler<"/hello", "get"> = function (_req, res) {
    services.helloworldService.echo();

    res.status(200).json({
      message: services.helloworldService.get(),
    });
  };

  return {
    get,
  };
}
