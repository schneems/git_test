# Git Test

Your test results...distributed

git\_test runs your tests and stores them in git. Use git_test to track
tests over multiple branches, runs, and teammates. Run git\_test when you pull and push
and you'll always know the state of your project!

## Install

    $ gem install git_test

## Use

Before you push your code to a central repo run your tests

    $ git_test push

After you pull new code down run your tests

    $ git_test pull

Whenever you feel like it, run your tests

    $ git_test run


To view the last test run on this branch

    $ git_test show last

or simply

    $ git_test show

To view all test reports on a branch you can run

    $ git_test show all

      2011-10-21T23:22:09Z_schneems_passed.html
      2011-10-22T00:22:05Z_schneems_passed.html
      2011-10-22T00:23:28Z_schneems_passed.html
      2011-10-22T00:26:09Z_schneems_passed.html
      2011-10-22T00:27:24Z_schneems_passed.html
      2011-10-22T00:27:37Z_schneems_passed.html
      2011-10-22T00:28:43Z_schneems_passed.html
      2011-10-22T00:31:25Z_schneems_passed.html
      2011-10-22T00:31:42Z_schneems_passed.html

To view a specific test report run:

    $ git_test show 2011-10-22T00:22:05Z_schneems_passed.html

This implementation is set up to run rspec tests by default. There are additional arguments to configure on the command line if you want to run something else.

To get help:

    $ git_test help

## The How

Git test works by making a temp directory, cloning your repository into that directory, running your tests on the cloned repo, and then writing the results to a branch `git_test_reports`. When done, the reports are pushed back to your local repo.


# Why

## CI Isn't Enough

On most projects everyone should run tests locally. The goal of git_test is to make running local tests as easy as possible and also to make them more useful. We do that by storing the result so you can compare branches and find out if another team-members pull request is ATP without having to ask.

Even better have your CI save its results in git_test.


## Shades of Red

For most test suites there are two colors Red (failed) and Green (passed) however testing isn't always so clear cut. The number of failures as well as the specific tests that failed matter too. While this might shock some diehard TDD folk, git_test is meant to be pragmatic. Taking a look at [quite a few popular Ruby Projects](http://travis-ci.org/) shows that you don't always have to have a green build 100% of the time to have a working product. When a test is failing it is important to know if that failure was introduced in the code changes or if it was pre-existing. 


## Git Flow

This style of testing goes very well with [GitHub Flow](http://scottchacon.com/2011/08/31/github-flow.html) do your work in seperate branch and when you're ready to have it in production pull request then merge it into master. If for some reason your tests fail you can quickly use git_test to determine if you introduced the failure, or if it was already occurring on the master branch.

