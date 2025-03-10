import type { CalculateStore } from "@/feature/calculate/store/calculateStore.js";

/**
 * このようにローカル上に保存するのは推奨されない。
 * あくまでテスト用であり、アプリケーションを作る際はRDSやDynamoDB、S3などと併用すること。
 */
export class OnMemoryCalculateStore implements CalculateStore {
  private constructor(private container: number[] = []) {}

  // この対処正しいのかわからん
  // eslint-disable-next-line @typescript-eslint/require-await
  async initialize() {
    return;
  }

  static async create() {
    const instance = new OnMemoryCalculateStore();
    await instance.initialize();
    return instance;
  }

  push(num: number) {
    this.container.push(num);
  }

  fetchAll() {
    return this.container;
  }
}
