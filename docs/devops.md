# DevOps

## Cloud.gov

SORN DASH is deployed to
[cloud.gov](https://cloud.gov/) on the
Identity Project Management Office’s subscription. It runs in a
FISMA-low environment.

We have a service account which is used for automated deployment of
updates from Github. We use service accounts to allow for better
auditing of our activity from automated processes like continuous
deployment or nightly checks for newly published SORNs.

For more on using service accounts with cloud.gov see:
[https://cloud.gov/docs/services/cloud-gov-service-account/](https://cloud.gov/docs/services/cloud-gov-service-account/)

`.cloud-gov/deploy.sh` is the shell script that allows a developer to
rebuild the application’s environment on cloud.gov from scratch and also
includes methods to allow for deploying new instances of the app. The
script does the following:

  - creates database and necessary services

  - creates service account; but other users must be added through the
    cli or cloud.gov dashboard.

  - manifest file sets up actual instance

  - `start.sh` runs migration before every start

The environment requires 1GB of memory and Postgres 12 or later.

## Github

### **Repo**

All SORN DASH code is kept and managed in this public Github repository: [https://github.com/18F/all\_sorns](https://github.com/18F/all_sorns)

All SORN Dash code is open source under a **CC0 license**.

### **Automation**

SORN DASH uses **Github Actions** for CI/CD automation tasks and
scheduling. There are three workflows in
[`.github/workflows`](https://github.com/18F/all_sorns/tree/main/.github/workflows):

- [`test.yml`](https://github.com/18F/all_sorns/blob/main/.github/workflows/test.yml)
 runs our suite of tests described in QA and is triggered on every
 commit.

- [`deploy.yml`](https://github.com/18F/all_sorns/blob/main/.github/workflows/deploy.yml)
 deploys new code on the main branch into the production environment on cloud.gov using a service specific account. It is triggered when
 new commits are made to the main branch and if all tests (if tests
 pass).

- [`sorn-grab.yml`](https://github.com/18F/all_sorns/blob/main/.github/workflows/sorn-grab.yml) pings the service container on cloud.gov
 every day at 2:11am easteern to run the [`find_sorns job`](https://github.com/18F/all_sorns/blob/main/app/jobs/find_sorns_job.rb) to find and download any new SORNs from the Federal Register. (**note:** We rely on Github for this because cloud.gov does not allow root access that is required to run a cron-job within the container.)

### **Security**

We’ve set the [protected
branches](https://docs.github.com/en/github/administering-a-repository/about-protected-branches)
policy recommended for the GSA ATO process. All pull-requests to the
main branch must be approved by at least one other developer.

We use
[**Snyk**](https://github.com/snyk/snyk)
to check our application dependencies in `package.json` and
`gemfil` to see if any of our dependencies have known
vulnerabilities.

## QA

### **Automated tests**

SORN DASH has a robust test suite to ensure code quality. All tests can
be found in `/spec`. To run tests on your local machine run:

 `rspec`

`search\_spec.rb` is integration tests and is written in
[capybara](https://github.com/teamcapybara/capybara).

### **Code Climate**

We have the [Code
Climate](https://codeclimate.com/github/18F/all_sorns)
integration enabled on our Github repository to monitor code quality
standards. Code Climate scans every new pull-request to evaluate code
quality and flag issues. We use default rules and address all
suggestions before merging. Trust Code Climate.

### **OWASP Zap**

[OWASP
Zap](https://owasp.org/www-project-zap/) is a tool we use to
dynamically scan our application for security vulnerabilities. Zap is
run against the live application to find common security
vulnerabilities. We did Zap scanning manually, but it can be automated
to run routinely. Zap scans should be run whenever substantive changes
are made to the code base.

## Security and Maintenance

SORN Dash will require occasional updates to its gems and other
dependencies, to make sure that it is secure.

If **Snyk** finds a vulnerability in any of our dependencies, it
automatically creates pull requests against the main branch to remediate
it.

GSA-IT will also ping the maintainer of a project to notify them of
security patches that need to be applied. Cloud.gov may request updates
from time to time to the production environment. SORN DASH is a low
impact system and can be taken offline if necessary to apply these
updates.
