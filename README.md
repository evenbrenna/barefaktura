README
======

Development guidelines
----------------------
1. **Check out a new well-named branch from master**
  git checkout master
  git checkout -b my-new-feature
2. **Commit often and push regularly to remote**
  git push -u origin my-new-feature
  Every push triggers a build and runs tests, so this will help to catch bugs early without wasting time running testing locally.
3. **Merge to master and deploy**
  git checkout master
  git pull
  git merge my-new-feature
  git push
  This will trigger a build of master, run the test-suite and deploy to staging.
  If all goes well master will be deployed to production.
4. **Done**

***

Status
------------

**Code Ship Build Status**

[ ![Codeship Status for evenbrenna/BareFaktura](https://codeship.com/projects/bbc45710-8b03-0132-04dc-660f9dc63bc4/status?branch=master)](https://codeship.com/projects/60234)

**Code Climate**

[![Code Climate](https://codeclimate.com/repos/54d917c669568006d5002a33/badges/cd14de099850f960a83b/gpa.svg)](https://codeclimate.com/repos/54d917c669568006d5002a33/feed)
