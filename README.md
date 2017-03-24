![Codeship status](https://codeship.com/projects/b580f560-2de6-0133-79c1-52e1cc32b2ed/status?branch=master)

[![Code Climate](https://codeclimate.com/github/makeitrealcamp/start/badges/gpa.svg)](https://codeclimate.com/github/makeitrealcamp/start)

[![Test Coverage](https://codeclimate.com/github/makeitrealcamp/start/badges/coverage.svg)](https://codeclimate.com/github/makeitrealcamp/start/coverage)

# Learning Platform

The learning platform we use at Make it Real. It is a Rails 4 project that uses [PostgreSQL](https://www.postgresql.org/) as the database and [Docker](https://www.docker.com/) to evaluate the challenges.

## Requirements

In order to install and run the project locally you need to have the following installed:

* [PostgreSQL](https://www.postgresql.org/)
* [Docker](https://www.docker.com/) (optional, only if you want to evaluate challenges)

## Setup

Once you have installed the requirements, download the project by cloning it from Git:

```
$ git clone git@github.com:makeitrealcamp/start.git
```

Then, install the dependencies with:

```
$ bundle
```

Create the database, load the schema and seed the database:

```
$ rails db:create
$ rails db:schema:load
$ rails db:seed
```

## Contributing

The workflow for contributing to this project is the following:

**1. Identify an issue you want to work on**

Checkout our [Waffle board](https://waffle.io/makeitrealcamp/start) to identify the issues that are ready for work (they are ordered by priority). Once you have selected one, assign it to yourself (you can`t have more than **two** issues assigned to you at the same time).

**2. Create a branch**

```
$ git checkout master
$ git pull
$ git checkout -b xx-short-description
```

The name of the branch should start with the number of the issue, followed by max three keywords that describe the issue (e.g. `23-fix-homepage`, `56-change-font`, etc.).

**3. Work on the branch**

Commit often and try to create small commits, just be sure that the tests are passing before commiting. Rebase against the upstream frequently to prevent your branch from diverging significantly:

```
$ git fetch origin
$ git rebase origin/master
```

Once you finish, you can push the branch and initiate a pull request.

**Note:** remember that an issue is not finished until it's fully tested!

**4. Push the branch and initiate the pull request**

When you are done, and you have organized your commits locally, it's time to push the branch.

```
$ git push -u origin xx-short-description
```

Open a pull request (PR) on Github.

### Writing good commit messages

A commit message has a first line, a blank line and an optional body. For example (taken from the Rails repository):

```
Make flash messages cookie compatible with Rails 4

In #xxx we removed the discard key from the session hash used to flash
messages and that broke compatibility with Rails 4 applications because they
try to map in the discarded flash messages and it returns nil.

Fixes #xxx.
```

Notice that the first line and the body are capitalized. The first line should be 50 characters or less and should start with a verb (e.g. make, fix, create, implement, add, etc.).

The body should be wrapper to 72 characters and you can reference any issue and [use keywords to close them](https://help.github.com/articles/closing-issues-via-commit-messages/).

**Tip:** Think about sending an e-mail to a colleague where the first line is the subject of the email, and the body is the body of the e-mail.