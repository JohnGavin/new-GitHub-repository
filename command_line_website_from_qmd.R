# install.packages(c("gert", "usethis", "quarto"))

library(usethis)
library(gert)
library(gh)
library(quarto)
library(here)

# setup authenticate == Personal Access Token (PAT) via
# usethis::create_github_token()
# gitcreds::gitcreds_set()
# If not exists, configure Git username / email:
# gert::git_config_global_set("user.name", "John Gavin")
# gert::git_config_global_set("user.email", "john.b.gavin@gmail.com")


# Create remote new GitHub repository
repo_name <- "new-GitHub-repository"
github_username <- "JohnGavin"
gh("POST /user/repos", name = repo_name, private = FALSE)

# Clone repository to local from remote
repo_url <- paste0("https://github.com/", github_username, "/", repo_name, ".git")
git_clone(repo_url, path = repo_name)
# setwd(here("..", "..", repo_name))
getwd()

# Create Quarto document
writeLines(c(
  "---",
  "title: \"My Quarto Document\"",
  "format: html",
  "---",
  "",
  "# Hello, GitHub Pages!",
  "This is a Quarto document."
), "index.qmd")

# Render Quarto document
quarto_render("index.qmd",
  # expected to be a filename only, not a path, relative or absolute.
  #   WARNING: not "docs/index.html"
  output_file = "index.html")

# Create _quarto.yml
fn <- "_quarto.yml"
writeLines(c(
  "project:",
  "  type: website",
  # specify the output directory as 'docs'
  "  output-dir: docs"
), fn)
readLines(fn)

# A .nojekyll file is created in the docs directory
#     to prevent Jekyll from processing the site.
dir.create("docs", showWarnings = FALSE)
file.rename("index.html", "docs/index.html")
file.create("docs/.nojekyll")

# Add, commit, and push all changes
git_add(".")
git_commit("sample repo with GH website")
git_push()
git_pull()

# Check GH Actions log files
# https://github.com/JohnGavin/new-GitHub-repository/actions/
# Wait, if necessary
(url <- paste0("https://", github_username,
  ".github.io/", repo_name))
browseURL(url)

# configure GH 'settings' / Pages / main branch & /docs folder

