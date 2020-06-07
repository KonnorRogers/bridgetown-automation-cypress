describe("Testing that links exist in the navbar", () => {
  beforeEach(() => {
    cy.visit("/");
  });

  context("navbar links appear on all pages", () => {
    cy.get('[href="/"]').click();
    assert.equal(cy.url(), "/");

    cy.get('[href="/posts"]').click();
    assert.equal(cy.url(), "/posts");

    cy.get('[href="/about"]').click();
    assert.equal(cy.url(), "/about");
  });
});
