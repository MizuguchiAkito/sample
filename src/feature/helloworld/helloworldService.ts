import { logger } from "@/utils/logger.js";

export class HelloWorldService {
  hello = "Hello World!" as const;

  echo() {
    logger.info(this.hello);
  }

  get() {
    return this.hello;
  }
}
