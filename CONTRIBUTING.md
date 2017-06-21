# How to Contribute

## Short version

Essentially, do the normal GitHub thing - fork and pull request. We track issues in this repository.

This project is [Apache 2.0 licensed](LICENSE). By contributing to this project,
you agree to the terms of the license, and you agree that you have the right to
submit your contribution under the terms of the license.

## Slightly longer version

* Submit an issue in this repository for any bug or feature request.
* Fork this repository.
* Create a topic branch in your fork named after the issue.
  * Optionally with a short description like `issue-42-answer-everything`
* Commit your changes to the branch, referencing the issue in your commit message.
  * Your commit message should have a summary line, followed by an empty line, followed by a description of the commit.
  * Create or update any tests and documentation as needed.
* Submit a pull request to this repository.

## Testing

Because the modules require a copy of the agent install files to function,
you must supply a local path to the files for Beaker to copy them to the
node under test. Use the `TE_AGENT_install_root` environment variable for this.

Testing this module at Tripwire is done with our own internal Vagrant cluster
and box files. Those nodesets are not in this repository, as they will not run
for anyone else. There is a default nodeset defined using a public puppetlabs
box, but we do not use it for testing.
