import "dotenv/config.js";

import { logger } from "@/utils/logger.js";
import { app } from "@/app/app.js";

const port = 3000;

app.listen(port, () => {
  logger.info(`Competition app listening at http://localhost:${port}`);
});
