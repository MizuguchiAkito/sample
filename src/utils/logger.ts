import log4js from "log4js";
import { getCurrentInvoke } from "@vendia/serverless-express";
const getRequestId = function () {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-return, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
  return getCurrentInvoke().context?.getRemainingTimeInMillis();
};

const config: log4js.Configuration = {
  appenders: {
    // Lambda向け
    forLambda: {
      type: "console",
      layout: {
        type: "pattern",
        pattern: "[%p]\t%c%n%m",
      },
    },
    // Lambdaの出力をエミュレート
    emulateLambda: {
      type: "console",
      layout: {
        type: "pattern",
        pattern: "%d\t%x{getRequestId}\tINFO\t[%p]\t%c%n%m",
        // localの場合は必ずundefinedになる
        tokens: {
          getRequestId,
        },
      },
    },
    // Lambdaの出力をエミュレート(色付き)
    emulateLambdaWithColor: {
      type: "console",
      layout: {
        type: "pattern",
        pattern: "%[%d\t%x{getRequestId}\tINFO\t[%p]\t%c%]%n%m",
        tokens: {
          getRequestId,
        },
      },
    },
    // stack traceを出力
    traceOut: {
      type: "console",
      layout: {
        type: "pattern",
        pattern: "[STACKTRACE]\t%c%n%s",
      },
    },
    // logger.fatalの場合は出力
    fatalTrace: {
      type: "logLevelFilter",
      appender: "traceOut",
      level: "fatal",
      maxLevel: "fatal",
    },
    // logger.traceの場合は出力
    trace: {
      type: "logLevelFilter",
      appender: "traceOut",
      level: "trace",
      maxLevel: "trace",
    },
  },
  categories: {
    // Lambda向けのLogger
    default: {
      appenders: ["forLambda", "fatalTrace", "trace"],
      level: "info",
      enableCallStack: true,
    },
    // local向けのLogger(色付き)
    localColor: {
      appenders: ["emulateLambdaWithColor", "fatalTrace", "trace"],
      level: "trace",
      enableCallStack: true,
    },
    // local向けのLogger
    local: {
      appenders: ["emulateLambda", "fatalTrace", "trace"],
      level: "trace",
      enableCallStack: true,
    },
  },
};

log4js.configure(config);

// LOGGER_TYPE環境変数で制御可能
const loggerType =
  Object.keys(config.categories).find(
    (value) => value === process.env["LOGGER_TYPE"],
  ) ?? "default";

export const logger = log4js.getLogger(loggerType);
