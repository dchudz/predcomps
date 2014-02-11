Current for getting pages onto the Github pages site:

1. Edit Rmd files here.
2. Compile them to HTML (run all lines or just the appropriate lines in "compile-all.R")
3. Commit the changes
4. Checkout gh-pages branch, and run: "git checkout master notes/*.html"
5. As soon as you commit and push the changes to Github in the gh-pages branch, they're live.
6. If adding a new page, you probably want to add it to the navigation in _layouts/page.html