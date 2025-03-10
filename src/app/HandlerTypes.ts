import type { RequestHandler } from "express";
import type { paths } from "./schema.js";

export type PathParam<
  Path extends keyof paths,
  Method extends keyof paths[Path],
> = paths[Path][Method] extends { parameters: { path: infer U } } ? U : never;

export type QueryParam<
  Path extends keyof paths,
  Method extends keyof paths[Path],
> = paths[Path][Method] extends { parameters: { query: infer U } } ? U : never;

export type ResponseBody<
  Path extends keyof paths,
  Method extends keyof paths[Path],
> = paths[Path][Method] extends {
  responses: infer CodeObjects;
}
  ? paths[Path][Method] extends {
      responses: {
        // keyof
        [Code in keyof CodeObjects]: {
          content: { "application/json": infer U };
        };
      };
    }
    ? U
    : never
  : never;

export type RequestBody<
  Path extends keyof paths,
  Method extends keyof paths[Path],
> = paths[Path][Method] extends {
  requestBody?: { content: { "application/json": infer U } };
}
  ? U
  : never;

// ApiHandlerに対して Promise<void>となるasync関数を渡していいようにする
type AnyFunction = (...args: never[]) => unknown;
type ArgumentsExtract<T extends AnyFunction> = T extends (
  ...args: infer P
) => unknown
  ? P
  : never;
type AwaitableFunction<T extends AnyFunction, R = Awaited<ReturnType<T>>> =
  | ((...args: ArgumentsExtract<T>) => R)
  | ((...args: ArgumentsExtract<T>) => Promise<R>);

export type ApiHandler<
  Path extends keyof paths,
  Method extends keyof paths[Path],
> = AwaitableFunction<
  RequestHandler<
    PathParam<Path, Method>,
    ResponseBody<Path, Method>,
    RequestBody<Path, Method>,
    QueryParam<Path, Method>
  >
>;
