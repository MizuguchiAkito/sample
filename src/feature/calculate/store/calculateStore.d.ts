export interface CalculateStore {
  push: (num: number) => void;
  fetchAll: () => number[];
  initialize: () => Promise<void>;
}
