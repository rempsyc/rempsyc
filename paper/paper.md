---
title: 'rempsyc: Convenience functions for psychology'
tags:
  - R
  - psychology
  - statistics
  - visualization
authors:
  - name: Rémi Thériault
    orcid: 0000-0003-4315-6788
    affiliation: 1
affiliations:
  - name: "Departement of Psychology, Université du Québec à Montréal, Québec, Canada"
    index: 1
date: "2023-02-12"
bibliography: paper.bib
output:
  md_document:
    preserve_yaml: TRUE
journal: JOSS
link-citations: yes
---

# Summary

([R Core Team 2022](#ref-base2021))

{rempsyc} is an R package of convenience functions to make the
analysis-to-publication workflow faster and easier. It affords easily
customizable plots (via {ggplot2}) and nice APA tables exportable to
Word (via {flextable}); it makes it easy to run statistical tests, check
assumptions, or automatize various tasks. It is a package mostly geared
at researchers in the psychological sciences but people from all fields
can find it useful.

# Introduction

# Statement of need

There are many reasons to use R ([R Core Team 2022](#ref-base2021)) for
analyzing and reporting data from research studies. R is more compatible
with the ideals of open science ([Quintana 2020](#ref-quintana2020)). In
contrast to commercial software: (a) it is free to use; (b) it makes it
easy to share a fully comprehensive analysis script; (c) it is
transparent as anyone can look at the formulas or algorithms used in a
given package; (d) the community can quickly contribute new packages
based on current needs; (e) it generates better-looking figures; and (f)
it helps reduce copy-paste errors so common in psychology[1].

------------------------------------------------------------------------

However, R has a major downside: its steep learning curve due to its
programmatic interface, in contrast to perhaps more beginner-friendly
point-and-click software. Of course, this flexibility is also a
strength, and there are increasing momentum for producing packages that
make using R as easy as possible.

The R software thus makes it possible to export the results (in the form
of text (e.g., the “report” package from easystats) or tables (e.g., the
rempsyc package) directly into Microsoft Word or Microsoft Excel. It
also makes it possible to check s ’there are obvious statistical errors
directly in the PDF of your final article (via the statcheck package).
Note for artists, it is also the software that makes the most beautiful
figures to visualize your data and results !

# Examples of Features

# Acknowledgements

I would like to thank Hugues Leduc, Jay Olson, Charles-Étienne Lavoie,
and Björn Büdenbender for statistical or technical advice that helped
inform some functions of this package and/or useful feedback on this
manuscript. I would also like to acknowledge funding from the Social
Sciences and Humanities Research Council of Canada.

# References

Quintana, D. S. 2020. *Five Things about Open and Reproducible Science
That Every Early Career Researcher Should Know*. <https://osf.io/2jt9u>.

R Core Team. 2022. *R: A Language and Environment for Statistical
Computing*. Vienna, Austria: R Foundation for Statistical Computing.
<https://www.R-project.org/>.

[1] according to some estimates, up to 50% of articles have at least one
statistical error (Nuijten et al., 2016)
