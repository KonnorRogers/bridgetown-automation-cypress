## Prerequisites

- Ruby >= 2.5
- Bridgetown ~> 0.15.0

```bash
bridgetown -v
# => bridgetown 0.15.0.beta3 "Overlook"
```

This project requires the new `apply` command introduced in Bridgetown
`0.15.0`

## Usage

### New project

```bash
bridgetown new <newsite> --apply="https://github.com/ParamagicDev/bridgetown-automation-cypress"
```

### Existing Project

````bash
bridgetown apply https://github.com/ParamagicDev/bridgetown-automation-cypress
```

## Adding tests

Tests are located in the `cypress/` file. Checkout [Cypress](cypress.io)
for further documentation on adding Cypress tests.

## Testing automation script

Right now there is one big integration tests which is run via simple:

```bash
git clone https://github.com/ParamagicDev/bridgetown-automation-cypress/
cd bridgetown-automation-cypress
bundle install
bundle exec rake test
````

### Testing with Docker

```bash
git clone https://github.com/ParamagicDev/bridgetown-automation-cypress
cd bridgetown-automation-cypress
./compose.sh up --build
```
