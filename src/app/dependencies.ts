import { CalculateService } from "@/feature/calculate/calculateService.js";
import { OnMemoryCalculateStore } from "@/feature/calculate/store/onMemory.js";
import { HelloWorldService } from "@/feature/helloworld/helloworldService.js";

export const dependencies = {
  services: {
    helloworldService: new HelloWorldService(),
    calculateService: new CalculateService(
      await OnMemoryCalculateStore.create()
    ),
  },
};
