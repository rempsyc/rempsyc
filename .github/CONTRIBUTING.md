# Contribution Guidelines

All contributions are welcome. Thank you for contributing!

There are several ways to contribute:

## 1. Open an Issue

[Open an issue](https://github.com/rempsyc/rempsyc/issues) to *report a bug* (or typo), *suggest a feature request*, or *get help* (yes, no need to go on Stack Overflow, you get help from the author directly and your issue becomes a tutorial for others!).

When opening an issue, try to include a **reprex**, a *minimally reproducible example* that can be replicated with one of the base datasets in R, such as the `mtcars` dataset. To make a reprex, consider using the [reprex package](https://www.tidyverse.org/help/#reprex). It takes a bit of time to get used to it, but it is very useful!

#### Pro Tip on Creating a Reprex FAST

Here's a quality of life upgrade I learned late regarding reprexes. Instead of loading the package with `library(reprex)`, copying your code with `Ctrl+c` and then typing `reprex()` in the console, there is a faster way. When you install the package the first time, it actually adds an addin in RStudio. Simply click on the `Addins` button below the `Help` menu, then in the search bar type `reprex` and select `Render reprex...` after you've copied your relevant code.

This opens a reprex window where you can specify different options and finally click on the blue `Render` button to render the reprex. This is cool because it also allows you to easily add your session info to the reprex by checking the `Append session info` check box.

But wait, there is a way to make it even faster! Make this addin selection a shortcut with (for example) `Ctrl+r` by going to `Tools`, `Modify Keyboard Shortcuts...`, then in the search bar type `reprex`, then for the `Render reprex...` row, click on the `Shortcut` column, and type your desired shortcut (I use `Ctrl+r`). Then, copy your code with `Ctr+c`, open the reprex addin window with `Ctrl+r`, press tab 3 times and then press enter. BAM! A reprex in < 5 seconds.

## 2. Start a Discussion

[Start a discussion](https://github.com/rempsyc/rempsyc/discussions) to discuss ideas, organization, meta-ideas, ask questions, or create polls, or anything else that doesn't fit well in an issue.

## 3. Submit a Pull Request

Submit a PR (if you've never heard the term before, that's a Pull Request!). That essentially means to make a *code contribution* to the package repository. If that's too complicated for you, don't worry, you can just copy-paste your code contribution in an issue and I will add it.

If you are a bit more experienced however, it is suggested to submit a PR. The recommended workflow to submit a PR is the following.

1. Fork the repository (use: `usethis::create_from_github("rempsyc/rempsyc")`).
2. Create a branch (in RStudio, click on the tiny purple flowchart under the `Git` tab, between the blue wheel and `main` branch buttons), and name it based on the theme of your suggested changes.
3. Commit and then push (`Ctrl+p`) your changes to your branch from RStudio.
4. Submit a PR with your modified branch (go to your branch on the GitHub website, and it will automatically suggest to open a PR and draft a message for you).
5. Include one or more reprexes showing the old and new behaviour for comparison.

Note that before using those `usethis` steps, you will need to have:

1. installed the [`git` software](https://git-scm.com/downloads) (i.e., not an R package);
2. created a github token with `usethis::create_github_token()` (see `usethis::gh_token_help()` for help);
3. set your credentials with `gitcreds::gitcreds_set()`.
