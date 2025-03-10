import type { dependencies } from "@/app/dependencies.js";
import type { ApiHandler } from "@/app/HandlerTypes.js";

export default function (services: typeof dependencies.services) {
  const put: ApiHandler<"/calc/push", "put"> = function (req, res) {
    for (const num of req.body.numbers) {
      services.calculateService.push(num);
    }
    res.status(200).json({
      numbers: services.calculateService.current(),
    });
  };

  return {
    put,
  };
}
