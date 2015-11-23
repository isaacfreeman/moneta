# Solidus Base Template
A template for Solidus sites

## Set-up
How to set up a dev environment for this project
1. Clone the project
2. Create a `database.yml` file and place it in config/ (You can probably just copy the `config/database.sample.yml` sample file.)
3. Run `bundle install` to grab the gems.
etc.

## Admin user
spree@example.com / spree123
## Granting a User Access to Spree Admin

Find the user and give him the Spree role.

```
u = User.find(5)
u.spree_roles << Spree::Role.where(name:"admin").first
```

## Hosting Environments
## Repository
URL
### Staging
URL
Git remote
Admin URL
### Production
URL
Git remote
Admin URL
### Asset Hosting

## Working Protocols
### Branches
* The `master` branch contains the state of the site on the production server
* The `staging` branch contains the state of the site on the staging server
* All other branches should start with a number that matches a corresponding open issue on Github
* Rebase off of `master` often, and especially before submitting a pull request to make sure your feature branch has the latest hotness.
* [Issues](https://github.com/ovenbits/cellucor.com/issues) should be created for all major features, bugs, discussions and other reasonably sized bits to work on. When possible, reference issue numbers in your commits and close issues with commits.
* When a branch is ready for either staging or master, send a [Pull Request](https://github.com/ovenbits/cellucor.com/pull/new/master) detailing the changes made, any dependency updates, screenshots of updates if needed, and any other information to help with the merge.
### Code Standards
#### Ruby
In general, try and follow the guidelines in the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide).
* Soft tabs, two spaces.
* Use ruby 1.9 style hash syntax. `attr: value` not `:attr => value`
* Keep external dependencies to a minimum. Only add gems if you must.
* Create small, simple classes that have a single responsibility when at all possible.
* Factories, not fixtures for data tests.
* Aim to write good tests for all classes. Testing is not as necessary for views, but use good judgement.
* Set your text editor to remove trailing spaces, etc..
* Use locales for text, even if the project will only ever be in English
* Separate code that overrides Solidus from code the implements new features.
  * Use spree subdirectories (`app/controllers/spree`, `app/models/spree` etc.) only for overriding files that also exist in Solidus.
  * Use Deface to insert new admin view code.
#### JavaScript
#### Stylesheets
### Debugging
* Call 'byebug' anywhere in the code to stop execution and get a debugger console
### Deploying
* Use maintenance mode if...
Deployment commands


## Tests
Models, services and other general classes should be tested. Helpers and views can be tested if possible, but not required.
Run the testing suite by running:
```bash
rake test
```
After running tests, code coverage will be available in the `coverage/index.html` file. Try and keep coverage above 95%.



## Integrations
### Email
### Mailing lists
### Fulfillment
### Analytics
### Search

## Client Information
### Primary contact
### SKU format

## Custom Features

## Working with Data
### Pulling data from Production
### Importing Products
TODO
### Importing Redirects
TODO
