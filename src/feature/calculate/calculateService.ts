import type { CalculateStore } from "@/feature/calculate/store/calculateStore.js";

export class CalculateService {
  constructor(private store: CalculateStore) {}

  total() {
    return this.store.fetchAll().reduce((previous, current) => {
      return previous + current;
    }, 0);
  }

  multiplication() {
    const values = this.store.fetchAll();
    if (values.length === 0) {
      return 0;
    }
    return values.reduce((previous, current) => {
      return previous * current;
    }, 1);
  }

  push(num: number) {
    this.store.push(num);
  }

  current() {
    return this.store.fetchAll();
  }
}
