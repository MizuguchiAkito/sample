import { CalculateService } from "@/feature/calculate/calculateService.js";
import { OnMemoryCalculateStore } from "@/feature/calculate/store/onMemory.js";

describe("total", () => {
  test.concurrent("normal", async () => {
    const service = new CalculateService(await OnMemoryCalculateStore.create());

    const initData = [1, 2, 3, 4, 5];
    initData.forEach((value) => service.push(value));

    const result = service.total();

    expect(result).toBe(15);
  });

  // 小数点誤差
  test.concurrent.skip("decimal", async () => {
    const service = new CalculateService(await OnMemoryCalculateStore.create());

    const initData = [0.1, 0.2];
    initData.forEach((value) => service.push(value));

    const result = service.total();

    expect(result).toBe(0.3);
  });

  test.concurrent("none", async () => {
    const service = new CalculateService(await OnMemoryCalculateStore.create());

    const result = service.total();

    expect(result).toBe(0);
  });
});

describe("multiplication", () => {
  test.concurrent("normal", async () => {
    const service = new CalculateService(await OnMemoryCalculateStore.create());

    const initData = [1, 2, 3, 4, 5];
    initData.forEach((value) => service.push(value));

    const result = service.multiplication();

    expect(result).toBe(120);
  });

  // 小数点誤差
  test.concurrent.skip("Big", async () => {
    const service = new CalculateService(await OnMemoryCalculateStore.create());

    const initData = [1e10, 1e20, 1e30, 1e40, 1e50];
    initData.forEach((value) => service.push(value));

    const result = service.multiplication();

    expect(result).toBe(1e150);
  });

  test.concurrent("none", async () => {
    const service = new CalculateService(await OnMemoryCalculateStore.create());

    const result = service.multiplication();

    expect(result).toBe(0);
  });
});
