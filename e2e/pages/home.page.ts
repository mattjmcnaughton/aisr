import { BasePage } from "./base.page";

export class HomePage extends BasePage {
  async goto() {
    await super.goto("/");
  }

  get heading() {
    return this.page.getByRole("heading", { name: "AISR" });
  }
}
