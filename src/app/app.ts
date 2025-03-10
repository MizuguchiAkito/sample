import express from "express";
import bodyParser from "body-parser";
import cors from "cors";
import compression from "compression";

import { initialize } from "express-openapi";
import { logger } from "@/utils/logger.js";
import { requestCredentialsFromSecretManager } from "@/utils/secret_loader.js";
import { dependencies } from "./dependencies.js";

import path from "node:path";
import { fileURLToPath } from "url";

// __filename:
const __filename = fileURLToPath(import.meta.url);
// __dirname:
const __dirname = path.dirname(__filename);

const app = express();

app.disable("x-powered-by");

app.use(compression());
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use((req, _res, next) => {
  logger.info("Start", req.method, req.originalUrl);
  next();
});

logger.info("start initialize");

const initializePromises: Promise<unknown>[] = [];

initializePromises.push(requestCredentialsFromSecretManager());

const errorHandler: express.ErrorRequestHandler = (err, _req, res, _next) => {
  logger.error(err);
  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
  if (err.status) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-argument
    res.status(err.status).json(err);
  } else {
    res.status(500).send("Something broke!");
  }
};

initializePromises.push(
  initialize({
    app,
    dependencies,
    apiDoc: path.resolve(__dirname, "openapi.json"),
    validateApiDoc: true,
    paths: path.resolve(__dirname, "route"),
    // testFile.test.ts等を除外
    pathsIgnore: new RegExp(/^.*\.(spec|test)\..*$/),
    routesGlob: "**/*.{ts,js}",
    routesIndexFileRegExp: /(?:index)?\.[tj]s$/,
    promiseMode: true,
    exposeApiDocs: false,
    errorMiddleware: errorHandler,
  }),
);

app.use(errorHandler);

await Promise.all(initializePromises).then(() => {
  logger.info("initialize Promise call Done!");
});

export { app };
