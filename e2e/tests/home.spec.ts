import { test, expect } from "../fixtures";

test.describe("Home Page", () => {
  test("displays the AISR heading", async ({ homePage }) => {
    await homePage.goto();
    await expect(homePage.heading).toBeVisible();
  });
});
