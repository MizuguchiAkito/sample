import { logger } from "@/utils/logger.js";
import { HelloWorldService } from "@/feature/helloworld/helloworldService.js";

test.concurrent("echo", () => {
  const loggerSpy = vi.spyOn(logger, "_log");
  const instance = new HelloWorldService();
  instance.echo();
  expect(loggerSpy).toHaveBeenCalledWith(
    expect.objectContaining({ levelStr: "INFO" }),
    ["Hello World!"]
  );
});

test.concurrent("get", () => {
  const instance = new HelloWorldService();
  const result = instance.get();
  expect(result).toBe("Hello World!");
});
