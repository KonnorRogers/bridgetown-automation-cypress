describe("Testing that links exist in the navbar", () => {
  beforeEach(() => {
    cy.visit("/");
  });

  context("navbar links appear on all pages", () => {
    cy.get('[href="/"]').click();
    cy.get('[href="/posts"]').click();
    cy.get('[href="/about"]').click();
  });
});
