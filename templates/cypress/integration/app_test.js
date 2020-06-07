describe("Testing that links exist in the navbar", () => {
  beforeEach(() => {
    cy.visit(baseUrl);
  });

  context("navbar appears on all pages", () => {
    cy.get('[href="/"]').click();
    cy.get('[href="/index"]').click();
    cy.get('[href="/about"]').click();
  });
});
