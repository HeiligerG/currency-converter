import { assertEquals } from "@std/assert";
import { Converter } from "./conversion.ts";

Deno.test("get undefined rate", () => {
  // Arrange
  const converter = new Converter();

  // Act
  const actual = converter.getRate("usd", "chf");

  // Assert
  assertEquals(actual, undefined);
});

Deno.test("set and get rate", () => {
  // Arrange
  const converter = new Converter();

  // Act
  converter.setRate("usd", "chf", 0.81);
  const actual = converter.getRate("usd", "chf");

  // Assert
  assertEquals(actual, 0.81);
});

Deno.test("update rate", () => {
  // Arrange
  const converter = new Converter();

  // Act
  converter.setRate("usd", "chf", 0.99);
  converter.setRate("usd", "chf", 0.81);
  const actual = converter.getRate("usd", "chf");

  // Assert
  assertEquals(actual, 0.81);
});

Deno.test("set, get, and remove rate", () => {
  // Arrange
  const converter = new Converter();

  // Act
  converter.setRate("usd", "chf", 0.81);
  converter.removeRate("usd", "chf");
  const actual = converter.getRate("usd", "chf");

  // Assert
  assertEquals(actual, undefined);
});

Deno.test("set and get reverse rate", () => {
  // Arrange
  const converter = new Converter();

  // Act
  converter.setRate("usd", "chf", 0.81);
  const actual = converter.getRate("chf", "usd");

  // Assert
  assertEquals(actual, 1 / 0.81);
});

Deno.test("conversion with unavailable rate", () => {
  // Arrange
  const converter = new Converter();

  // Act
  converter.setRate("eur", "dem", 2.0);
  const actual = converter.convert("eur", "dem", 50.0);

  // Assert
  assertEquals(actual, 100.0);
});

Deno.test("conversion with available rate", () => {
  // Arrange
  const converter = new Converter();

  // Act
  converter.setRate("usd", "chf", 0.81);
  const actual = converter.convert("usd", "btc", 100);

  // Assert
  assertEquals(actual, undefined);
});

Deno.test("conversion with reverse rate", () => {
  // Arrange
  const converter = new Converter();

  // Act
  converter.setRate("eur", "dem", 2.0);
  const actual = converter.convert("dem", "eur", 50.0);

  // Assert
  assertEquals(actual, 25.0);
});
