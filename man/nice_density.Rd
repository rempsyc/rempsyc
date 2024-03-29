% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nice_density.R
\name{nice_density}
\alias{nice_density}
\title{Easy density plots}
\usage{
nice_density(
  data,
  variable,
  group = NULL,
  colours,
  ytitle = "Density",
  xtitle = variable,
  groups.labels = NULL,
  grid = TRUE,
  shapiro = FALSE,
  title = variable,
  histogram = FALSE,
  breaks.auto = FALSE,
  bins = 30
)
}
\arguments{
\item{data}{The data frame}

\item{variable}{The dependent variable to be plotted.}

\item{group}{The group by which to plot the variable.}

\item{colours}{Desired colours for the plot, if desired.}

\item{ytitle}{An optional y-axis label, if desired.}

\item{xtitle}{An optional x-axis label, if desired.}

\item{groups.labels}{The groups.labels (might rename to
\code{xlabels} for consistency with other functions)}

\item{grid}{Logical, whether to keep the default background
grid or not. APA style suggests not using a grid in the background,
though in this case some may find it useful to more easily estimate
the slopes of the different groups.}

\item{shapiro}{Logical, whether to include the p-value
from the Shapiro-Wilk test on the plot.}

\item{title}{The desired title of the plot. Can be put to \code{NULL} to remove.}

\item{histogram}{Logical, whether to add an histogram}

\item{breaks.auto}{If histogram = TRUE, then option to set bins/breaks
automatically, mimicking the default behaviour of base
R \code{\link[=hist]{hist()}} (the Sturges method). Defaults to \code{FALSE}.}

\item{bins}{If \code{histogram = TRUE}, then option to change the default bin (30).}
}
\value{
A density plot of class \code{ggplot}, by group (if provided), along a
reference line representing a matched normal distribution.
}
\description{
Make nice density plots easily. Internally, uses \code{na.rm = TRUE}.
}
\examples{
\dontshow{if (requireNamespace("ggplot2", quietly = TRUE) && requireNamespace("ggrepel", quietly = TRUE)) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# Make the basic plot
nice_density(
  data = iris,
  variable = "Sepal.Length",
  group = "Species"
)

# Further customization
nice_density(
  data = iris,
  variable = "Sepal.Length",
  group = "Species",
  colours = c("#00BA38", "#619CFF", "#F8766D"),
  xtitle = "Sepal Length",
  ytitle = "Density (vs. Normal Distribution)",
  groups.labels = c(
    "(a) Setosa",
    "(b) Versicolor",
    "(c) Virginica"
  ),
  grid = FALSE,
  shapiro = TRUE,
  title = "Density (Sepal Length)",
  histogram = TRUE
)
\dontshow{\}) # examplesIf}
}
\seealso{
Other functions useful in assumption testing:
\code{\link{nice_assumptions}}, \code{\link{nice_normality}},
\code{\link{nice_qq}}, \code{\link{nice_varplot}},
\code{\link{nice_var}}. Tutorial:
\url{https://rempsyc.remi-theriault.com/articles/assumptions}
}
\keyword{density}
\keyword{normality}
