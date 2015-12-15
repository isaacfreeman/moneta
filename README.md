# Moneta
A Resolve Digital template for Solidus sites, with the following goals:
1. Quick set-up for new projects
2. Reference implementations for features we expect to use with many clients

## Features
1. Algolia search
2. Checkout specs
3. Edit buttons on the front end for admins

## Notes
- Features are built against standard Solidus. In particular, we sometimes rely on the presence of HTML classes and ids from Solidus-frontend views, which may have been changed in client projects. In general, we recommend retaining ids, data-hooks and semantically meaningful classes from Solidus when overriding views.
- Features are enabled/disabled in config/features.rb. Features switches are used wherever possible.
- Some Moneta features may evolve into complete gems.
- README-template.md contains a template structure for client project README files. Most projects probably won't need everything it has, but it's there to give dieas for things that could be documented.
