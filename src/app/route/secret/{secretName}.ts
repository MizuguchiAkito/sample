import { getSecret } from "@/utils/secret_loader.js";
import type { ApiHandler } from "@/app/HandlerTypes.js";

export default function () {
  const get: ApiHandler<"/secret/{secretName}", "get"> = async function (
    req,
    res,
    next,
  ) {
    try {
      const name = req.params.secretName;
      // 機密情報を抜かれるため、外部の入力に依存してをgetSecretを取り出さないこと
      const value = await getSecret(name);
      res.status(200).json({
        value,
      });
    } catch (err) {
      next(err);
    }
  };

  return {
    get,
  };
}
