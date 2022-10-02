#' @title Anova Tables for Various Statistical Models (car::Anova)
#'
#' @description Compute ANOVA from the `car` package
#' and `Anova` function.
#'
#' @details Calculates type-II or type-III analysis-of-variance tables for model objects produced by lm, glm, multinom (in the nnet package), polr (in the MASS package), coxph (in the survival package), coxme (in the coxme pckage), svyglm and svycoxph (in the survey package), rlm (in the MASS package), lmer in the lme4 package, lme in the nlme package, and (by the default method) for most models with a linear predictor and asymptotically normal coefficients (see details below). For linear models, F-tests are calculated; for generalized linear models, likelihood-ratio chisquare, Wald chisquare, or F-tests are calculated; for multinomial logit and proportional-odds logit models, likelihood-ratio tests are calculated. Various test statistics are provided for multivariate linear models produced by lm or manova. Partial-likelihood-ratio tests or Wald tests are provided for Cox models. Wald chi-square tests are provided for fixed effects in linear and generalized linear mixed-effects models. Wald chi-square or F tests are provided in the default case.
#'
#' @param mod lm, aov, glm, multinom, polr mlm, coxph, coxme, lme, mer, merMod, svyglm, svycoxph, rlm, or other suitable model object.
#' @param error for a linear model, an lm model object from which the error sum of squares and degrees of freedom are to be calculated. For F-tests for a generalized linear model, a glm object from which the dispersion is to be estimated. If not specified, mod is used.
#' @param type type of test, "II", "III", 2, or 3. Roman numerals are equivalent to the corresponding Arabic numerals.
#' @param white.adjust if not FALSE, the default, tests use a heteroscedasticity-corrected coefficient covariance matrix; the various values of the argument specify different corrections. See the documentation for hccm for details. If white.adjust=TRUE then the "hc3" correction is selected.
#'
#' @return An object of class "anova", or "Anova.mlm", which usually is printed. For objects of class "Anova.mlm", there is also a summary method, which provides much more detail than the print method about the MANOVA, including traditional mixed-model univariate F-tests with Greenhouse-Geisser and Huynh-Feldt corrections.
#' @export
#' @author John Fox jfox@mcmaster.ca; the code for the Mauchly test and Greenhouse-Geisser and Huynh-Feldt corrections for non-spericity in repeated-measures ANOVA are adapted from the functions stats:::stats:::mauchly.test.SSD and stats:::sphericity by R Core; summary.Anova.mlm and print.summary.Anova.mlm incorporates code contributed by Gabriel Baud-Bovy.
#' @keywords internal anova
#' @examples
#' \donttest{
#' m <- lm(mpg ~ cyl + disp, data = mtcars)
#' car_Anova(m)
#' }
#' @importFrom stats alias coef coefficients deviance df.residual
#' formula pchisq pf terms vcov gaussian hatvalues model.frame
#' model.matrix model.response na.omit residuals weights drop1
#' family glm.fit
#' @importFrom utils head

# Type II and III tests for linear, generalized linear, and other models (J. Fox)

car_Anova <- function(mod, error, type=c("II","III", 2, 3),
                     white.adjust=c(FALSE, TRUE, "hc3", "hc0", "hc1", "hc2", "hc4"),
                     vcov.=NULL, singular.ok, ...){
  if (!is.null(vcov.)) message("Coefficient covariances computed by ", deparse(substitute(vcov.)))
  if (!missing(white.adjust)) message("Coefficient covariances computed by hccm()")
  #  vcov. <- getVcov(vcov., mod)
  if (df.residual(mod) == 0) stop("residual df = 0")
  if (deviance(mod) < sqrt(.Machine$double.eps)) stop("residual sum of squares is 0 (within rounding error)")
  type <- as.character(type)
  white.adjust <- as.character(white.adjust)
  type <- match.arg(type)
  white.adjust <- match.arg(white.adjust)
  if (missing(singular.ok)){
    singular.ok <- type == "2" || type == "II"
  }
  if (has.intercept(mod) && length(coef(mod)) == 1
      && (type == "2" || type == "II")) {
    type <- "III"
    warning("the model contains only an intercept: Type III test substituted")
  }
  if (any(is.na(coef(mod))) && singular.ok){
    if ((white.adjust != "FALSE") || (!is.null(vcov.)))
      stop("non-standard coefficient covariance matrix\n  may not be used for model with aliased coefficients")
    message("Note: model has aliased coefficients\n      sums of squares computed by model comparison")
    result <- Anova.glm(lm2glm(mod), type=type, singular.ok=TRUE, test.statistic="F", ...)
    heading <- attributes(result)$heading
    if (type == "2") type <- "II"
    if (type == "3") type <- "III"
    attr(result, "heading") <- c(paste("Anova Table (Type", type, "tests)"), "", heading[2])
    return(result)
  }
  if (white.adjust != "FALSE"){
    if (white.adjust == "TRUE") white.adjust <- "hc3"
    return(Anova.default(mod, type=type, vcov.=hccm(mod, type=white.adjust), test.statistic="F",
                         singular.ok=singular.ok, ...))
  }
  else if (!is.null(vcov.)) return(Anova.default(mod, type=type, vcov.=vcov., test.statistic="F",
                                                 singular.ok=singular.ok, ...))
  switch(type,
         II=Anova.II.lm(mod, error, singular.ok=singular.ok, ...),
         III=Anova.III.lm(mod, error, singular.ok=singular.ok, ...),
         "2"=Anova.II.lm(mod, error, singular.ok=singular.ok, ...),
         "3"=Anova.III.lm(mod, error, singular.ok=singular.ok,...))
}

Anova.lm <- car_Anova

Anova.II.lm <- function(mod, error, singular.ok=TRUE, ...){
  if (!missing(error)){
    sumry <- summary(error, corr=FALSE)
    s2 <- sumry$sigma^2
    error.df <- error$df.residual
    error.SS <- s2*error.df
  }
  SS.term <- function(term){
    which.term <- which(term == names)
    subs.term <- which(assign == which.term)
    relatives <- relatives(term, names, fac)
    subs.relatives <- NULL
    for (relative in relatives)
      subs.relatives <- c(subs.relatives, which(assign == relative))
    hyp.matrix.1 <- I.p[subs.relatives,,drop=FALSE]
    hyp.matrix.1 <- hyp.matrix.1[, not.aliased, drop=FALSE]
    hyp.matrix.2 <- I.p[c(subs.relatives,subs.term),,drop=FALSE]
    hyp.matrix.2 <- hyp.matrix.2[, not.aliased, drop=FALSE]
    hyp.matrix.term <- if (nrow(hyp.matrix.1) == 0) hyp.matrix.2
    else t(ConjComp(t(hyp.matrix.1), t(hyp.matrix.2), vcov(mod, complete=FALSE)))
    hyp.matrix.term <- hyp.matrix.term[!apply(hyp.matrix.term, 1,
                                              function(x) all(x == 0)), , drop=FALSE]
    if (nrow(hyp.matrix.term) == 0)
      return(c(SS=NA, df=0))
    lh <- linearHypothesis(mod, hyp.matrix.term,
                           singular.ok=singular.ok, ...)
    abs(c(SS=lh$"Sum of Sq"[2], df=lh$Df[2]))
  }
  not.aliased <- !is.na(coef(mod))
  if (!singular.ok && !all(not.aliased))
    stop("there are aliased coefficients in the model")
  fac <- attr(terms(mod), "factors")
  intercept <- has.intercept(mod)
  I.p <- diag(length(coefficients(mod)))
  assign <- mod$assign
  assign[!not.aliased] <- NA
  names <- term.names(mod)
  if (intercept) names <-names[-1]
  n.terms <- length(names)
  p <- df <- f <- SS <- rep(0, n.terms + 1)
  sumry <- summary(mod, corr = FALSE)
  SS[n.terms + 1] <- if (missing(error)) sumry$sigma^2*mod$df.residual
  else error.SS
  df[n.terms + 1] <- if (missing(error)) mod$df.residual else error.df
  p[n.terms + 1] <- f[n.terms + 1] <- NA
  for (i in 1:n.terms){
    ss <- SS.term(names[i])
    SS[i] <- ss["SS"]
    df[i] <- ss["df"]
    f[i] <- df[n.terms+1]*SS[i]/(df[i]*SS[n.terms + 1])
    p[i] <- pf(f[i], df[i], df[n.terms + 1], lower.tail = FALSE)
  }
  result <- data.frame(SS, df, f, p)
  row.names(result) <- c(names,"Residuals")
  names(result) <- c("Sum Sq", "Df", "F value", "Pr(>F)")
  class(result) <- c("anova", "data.frame")
  attr(result, "heading") <- c("Anova Table (Type II tests)\n",
                               paste("Response:", responseName(mod)))
  result
}

# type III

Anova.III.lm <- function(mod, error, singular.ok=FALSE, ...){
  if (!missing(error)){
    error.df <- df.residual(error)
    error.SS <- deviance(error)
  }
  else {
    error.df <- df.residual(mod)
    error.SS <- deviance(mod)
  }
  intercept <- has.intercept(mod)
  I.p <- diag(length(coefficients(mod)))
  Source <- term.names(mod)
  n.terms <- length(Source)
  p <- df <- f <- SS <- rep(0, n.terms + 1)
  assign <- mod$assign
  not.aliased <- !is.na(coef(mod))
  if (!singular.ok && !all(not.aliased))
    stop("there are aliased coefficients in the model")
  indices <- 1:n.terms
  for (term in indices){
    subs <- which(assign == term - intercept)
    hyp.matrix <- I.p[subs,,drop=FALSE]
    hyp.matrix <- hyp.matrix[, not.aliased, drop=FALSE]
    hyp.matrix <- hyp.matrix[!apply(hyp.matrix, 1, function(x) all(x == 0)), , drop=FALSE]
    if (nrow(hyp.matrix) == 0){
      SS[term] <- NA
      df[term] <- 0
      f[term] <- NA
      p[term] <- NA
    }
    else {
      test <- linearHypothesis(mod, hyp.matrix, singular.ok=singular.ok, ...)
      SS[term] <- test$"Sum of Sq"[2]
      df[term] <- test$"Df"[2]
    }
  }
  index.error <- n.terms + 1
  Source[index.error] <- "Residuals"
  SS[index.error] <- error.SS
  df[index.error] <- error.df
  f[indices] <- (SS[indices]/df[indices])/(error.SS/error.df)
  p[indices] <- pf(f[indices], df[indices], error.df, lower.tail=FALSE)
  p[index.error] <- f[index.error] <- NA
  result <- data.frame(SS, df, f, p)
  row.names(result) <- Source
  names(result) <- c("Sum Sq", "Df", "F value", "Pr(>F)")
  class(result) <- c("anova", "data.frame")
  attr(result, "heading") <- c("Anova Table (Type III tests)\n", paste("Response:", responseName(mod)))
  result
}

Anova.glm <- function(mod, type=c("II","III", 2, 3), test.statistic=c("LR", "Wald", "F"),
                      error, error.estimate=c("pearson", "dispersion", "deviance"),
                      vcov.=vcov(mod, complete=TRUE), singular.ok, ...){
  type <- as.character(type)
  type <- match.arg(type)
  test.statistic <- match.arg(test.statistic)
  error.estimate <- match.arg(error.estimate)
  if (!missing(vcov.)) {
    if (test.statistic != "Wald"){
      warning(paste0('test.statistic="', test.statistic,
                     '"; vcov. argument ignored'))
    } else {
      message("Coefficient covariances computed by ", deparse(substitute(vcov.)))
    }
  }
  vcov. <- getVcov(vcov., mod)
  if (has.intercept(mod) && length(coef(mod)) == 1
      && (type == "2" || type == "II")) {
    type <- "III"
    warning("the model contains only an intercept: Type III test substituted")
  }
  if (missing(singular.ok)){
    singular.ok <- type == "2" || type == "II"
  }
  switch(type,
         II=switch(test.statistic,
                   LR=Anova.II.LR.glm(mod, singular.ok=singular.ok),
                   Wald=Anova.default(mod, type="II", singular.ok=singular.ok, vcov.=vcov.),
                   F=Anova.II.F.glm(mod, error, error.estimate, singular.ok=singular.ok)),
         III=switch(test.statistic,
                    LR=Anova.III.LR.glm(mod, singular.ok=singular.ok),
                    Wald=Anova.default(mod, type="III", singular.ok=singular.ok, vcov.=vcov.),
                    F=Anova.III.F.glm(mod, error, error.estimate, singular.ok=singular.ok)),
         "2"=switch(test.statistic,
                    LR=Anova.II.LR.glm(mod, singular.ok=singular.ok),
                    Wald=Anova.default(mod, type="II", singular.ok=singular.ok, vcov.=vcov.),
                    F=Anova.II.F.glm(mod, error, error.estimate, singular.ok=singular.ok)),
         "3"=switch(test.statistic,
                    LR=Anova.III.LR.glm(mod, singular.ok=singular.ok),
                    Wald=Anova.default(mod, type="III", singular.ok=singular.ok, vcov.=vcov.),
                    F=Anova.III.F.glm(mod, error, error.estimate, singular.ok=singular.ok)))
}

Anova.default <- function(mod, type=c("II","III", 2, 3), test.statistic=c("Chisq", "F"),
                          vcov.=vcov(mod, complete=FALSE), singular.ok, error.df, ...){
  if (missing(error.df)){
    error.df <- df.residual(mod)
    test.statistic <- match.arg(test.statistic)
    if (test.statistic == "F" && (is.null(error.df) || is.na(error.df))){
      test.statistic <- "Chisq"
      message("residual df unavailable, test.statistic set to 'Chisq'")
    }
  }
  vcov. <- getVcov(vcov., mod)
  type <- as.character(type)
  type <- match.arg(type)
  if (missing(singular.ok))
    singular.ok <- type == "2" || type == "II"
  switch(type,
         II=Anova.II.default(mod, vcov., test.statistic, singular.ok=singular.ok,
                             error.df=error.df),
         III=Anova.III.default(mod, vcov., test.statistic, singular.ok=singular.ok,
                               error.df=error.df),
         "2"=Anova.II.default(mod, vcov., test.statistic, singular.ok=singular.ok,
                              error.df=error.df),
         "3"=Anova.III.default(mod, vcov., test.statistic, singular.ok=singular.ok,
                               error.df=error.df))
}

Anova.II.default <- function(mod, vcov., test, singular.ok=TRUE, error.df,...){
  hyp.term <- function(term){
    which.term <- which(term==names)
    subs.term <- if (is.list(assign)) assign[[which.term]] else which(assign == which.term)
    relatives <- relatives(term, names, fac)
    subs.relatives <- NULL
    for (relative in relatives){
      sr <- if (is.list(assign)) assign[[relative]] else which(assign == relative)
      subs.relatives <- c(subs.relatives, sr)
    }
    hyp.matrix.1 <- I.p[subs.relatives,,drop=FALSE]
    hyp.matrix.1 <- hyp.matrix.1[, not.aliased, drop=FALSE]
    hyp.matrix.2 <- I.p[c(subs.relatives,subs.term),,drop=FALSE]
    hyp.matrix.2 <- hyp.matrix.2[, not.aliased, drop=FALSE]
    hyp.matrix.term <- if (nrow(hyp.matrix.1) == 0) hyp.matrix.2
    else t(ConjComp(t(hyp.matrix.1), t(hyp.matrix.2), vcov.))
    hyp.matrix.term <- hyp.matrix.term[!apply(hyp.matrix.term, 1,
                                              function(x) all(x == 0)), , drop=FALSE]
    if (nrow(hyp.matrix.term) == 0)
      return(c(statistic=NA, df=0))
    hyp <- linearHypothesis.default(mod, hyp.matrix.term,
                                    vcov.=vcov., test=test, error.df=error.df,
                                    singular.ok=singular.ok, ...)
    if (test=="Chisq") c(statistic=hyp$Chisq[2], df=hyp$Df[2])
    else c(statistic=hyp$F[2], df=hyp$Df[2])
  }
  not.aliased <- !is.na(coef(mod))
  if (!singular.ok && !all(not.aliased))
    stop("there are aliased coefficients in the model")
  fac <- attr(terms(mod), "factors")
  intercept <- has.intercept(mod)
  p <- length(coefficients(mod))
  I.p <- diag(p)
  assign <- assignVector(mod) # attr(model.matrix(mod), "assign")
  if (!is.list(assign)) assign[!not.aliased] <- NA
  else if (intercept) assign <- assign[-1]
  names <- term.names(mod)
  if (intercept) names <- names[-1]
  n.terms <- length(names)
  df <- c(rep(0, n.terms), error.df)
  if (inherits(mod, "coxph") || inherits(mod, "survreg")){
    if (inherits(mod, "coxph")) assign <- assign[assign != 0]
    clusters <- grep("^cluster\\(", names)
    strata <- grep("^strata\\(.*\\)$", names)
    for (cl in clusters) assign[assign > cl] <- assign[assign > cl] - 1
    for (st in strata) assign[assign > st] <- assign[assign > st] - 1
    if (length(clusters) > 0 || length(strata) > 0) {
      message("skipping term ", paste(names[c(clusters, strata)], collapse=", "))
      names <- names[-c(clusters, strata)]
      df <- df[-c(clusters, strata)]
      n.terms <- n.terms - length(clusters) - length(strata)
    }
  }
  #	if (inherits(mod, "plm")) assign <- assign[assign != 0]
  p <- teststat <- rep(0, n.terms + 1)
  teststat[n.terms + 1] <- p[n.terms + 1] <- NA
  for (i in 1:n.terms){
    hyp <- hyp.term(names[i])
    teststat[i] <- abs(hyp["statistic"])
    df[i] <- abs(hyp["df"])
    p[i] <- if (test == "Chisq")
      pchisq(teststat[i], df[i], lower.tail=FALSE)
    else pf(teststat[i], df[i], df[n.terms + 1], lower.tail=FALSE)
  }
  result <- if (test == "Chisq"){
    if (length(df) == n.terms + 1) df <- df[1:n.terms]
    data.frame(df[df > 0], teststat[!is.na(teststat)], p[!is.na(teststat)])
  }
  else data.frame(df, teststat, p)
  if (nrow(result) == length(names) + 1) names <- c(names,"Residuals")
  row.names(result) <- names[df > 0]
  names(result) <- c ("Df", test, if (test == "Chisq") "Pr(>Chisq)"
                      else "Pr(>F)")
  class(result) <- c("anova", "data.frame")
  attr(result, "heading") <- c("Analysis of Deviance Table (Type II tests)\n",
                               paste("Response:", responseName(mod)))
  result
}

Anova.III.default <- function(mod, vcov., test, singular.ok=FALSE, error.df, ...){
  intercept <- has.intercept(mod)
  p <- length(coefficients(mod))
  I.p <- diag(p)
  names <- term.names(mod)
  n.terms <- length(names)
  assign <- assignVector(mod) # attr(model.matrix(mod), "assign")
  df <- c(rep(0, n.terms), error.df)
  if (inherits(mod, "coxph")){
    if (intercept) names <- names[-1]
    assign <- assign[assign != 0]
    clusters <- grep("^cluster\\(", names)
    strata <- grep("^strata\\(.*\\)$", names)
    for (cl in clusters) assign[assign > cl] <- assign[assign > cl] - 1
    for (st in strata) assign[assign > st] <- assign[assign > st] - 1
    if (length(clusters) > 0 || length(strata) > 0) {
      message("skipping term ", paste(names[c(clusters, strata)], collapse=", "))
      names <- names[-c(clusters, strata)]
      df <- df[-c(clusters, strata)]
      n.terms <- n.terms - length(clusters) - length(strata)
    }
  }
  #	if (inherits(mod, "plm")) assign <- assign[assign != 0]
  if (intercept) df[1] <- sum(grepl("^\\(Intercept\\)", names(coef(mod))))
  teststat <- rep(0, n.terms + 1)
  p <- rep(0, n.terms + 1)
  teststat[n.terms + 1] <- p[n.terms + 1] <- NA
  not.aliased <- !is.na(coef(mod))
  if (!singular.ok && !all(not.aliased))
    stop("there are aliased coefficients in the model")
  for (term in 1:n.terms){
    subs <- if (is.list(assign)) assign[[term]] else which(assign == term - intercept)
    hyp.matrix <- I.p[subs,,drop=FALSE]
    hyp.matrix <- hyp.matrix[, not.aliased, drop=FALSE]
    hyp.matrix <- hyp.matrix[!apply(hyp.matrix, 1, function(x) all(x == 0)), , drop=FALSE]
    if (nrow(hyp.matrix) == 0){
      teststat[term] <- NA
      df[term] <- 0
      p[term] <- NA
    }
    else {
      hyp <- linearHypothesis.default(mod, hyp.matrix,
                                      vcov.=vcov., test=test, error.df=error.df,
                                      singular.ok=singular.ok, ...)
      teststat[term] <- if (test=="Chisq") hyp$Chisq[2] else hyp$F[2]
      df[term] <- abs(hyp$Df[2])
      p[term] <- if (test == "Chisq")
        pchisq(teststat[term], df[term], lower.tail=FALSE)
      else pf(teststat[term], df[term], df[n.terms + 1], lower.tail=FALSE)
    }
  }
  result <- if (test == "Chisq"){
    if (length(df) == n.terms + 1) df <- df[1:n.terms]
    data.frame(df, teststat[!is.na(teststat)], p[!is.na(teststat)])
  }
  else data.frame(df, teststat, p)
  if (nrow(result) == length(names) + 1) names <- c(names,"Residuals")
  row.names(result) <- names
  names(result) <- c ("Df", test, if (test == "Chisq") "Pr(>Chisq)"
                      else "Pr(>F)")
  class(result) <- c("anova", "data.frame")
  attr(result, "heading") <- c("Analysis of Deviance Table (Type III tests)\n",
                               paste("Response:", responseName(mod)))
  result
}

Anova.III.LR.glm <- function(mod, singular.ok=FALSE, ...){
  if (!singular.ok && any(is.na(coef(mod))))
    stop("there are aliased coefficients in the model")
  Source <- if (has.intercept(mod)) term.names(mod)[-1]
  else term.names(mod)
  n.terms <- length(Source)
  p <- df <- LR <- rep(0, n.terms)
  dispersion <- summary(mod, corr = FALSE)$dispersion
  deviance <- deviance(mod)/dispersion
  for (term in 1:n.terms){
    mod.1 <- drop1(mod, scope=eval(parse(text=paste("~",Source[term]))))
    df[term] <- mod.1$Df[2]
    LR[term] <- if (df[term] == 0) NA else (mod.1$Deviance[2]/dispersion)-deviance
    p[term] <- pchisq(LR[term], df[term], lower.tail = FALSE)
  }
  result <- data.frame(LR, df, p)
  row.names(result) <- Source
  names(result) <- c("LR Chisq", "Df", "Pr(>Chisq)")
  class(result) <- c("anova","data.frame")
  attr(result, "heading") <- c("Analysis of Deviance Table (Type III tests)\n", paste("Response:", responseName(mod)))
  result
}

# F test

Anova.III.F.glm <- function(mod, error, error.estimate, singular.ok=FALSE, ...){
  if (!singular.ok && any(is.na(coef(mod))))
    stop("there are aliased coefficients in the model")
  fam <- family(mod)$family
  if ((fam == "binomial" || fam == "poisson") && error.estimate == "dispersion"){
    warning("dispersion parameter estimated from the Pearson residuals, not taken as 1")
    error.estimate <- "pearson"
  }
  if (missing(error)) error <- mod
  df.res <- df.residual(error)
  error.SS <- switch(error.estimate,
                     pearson=sum(residuals(error, "pearson")^2, na.rm=TRUE),
                     dispersion=df.res*summary(error, corr = FALSE)$dispersion,
                     deviance=deviance(error))
  Source <- if (has.intercept(mod)) term.names(mod)[-1]
  else term.names(mod)
  n.terms <- length(Source)
  p <- df <- f <- SS <-rep(0, n.terms+1)
  f[n.terms+1] <- p[n.terms+1] <- NA
  df[n.terms+1] <- df.res
  SS[n.terms+1] <- error.SS
  dispersion <- error.SS/df.res
  deviance <- deviance(mod)
  for (term in 1:n.terms){
    mod.1 <- drop1(mod, scope=eval(parse(text=paste("~",Source[term]))))
    df[term] <- mod.1$Df[2]
    SS[term] <- mod.1$Deviance[2] - deviance
    f[term] <- if (df[term] == 0) NA else (SS[term]/df[term])/dispersion
    p[term] <- pf(f[term], df[term], df.res, lower.tail = FALSE)
  }
  result <- data.frame(SS, df, f, p)
  row.names(result) <- c(Source, "Residuals")
  names(result) <- c("Sum Sq", "Df", "F values", "Pr(>F)")
  class(result) <- c("anova","data.frame")
  attr(result, "heading") <- c("Analysis of Deviance Table (Type III tests)\n",
                               paste("Response:", responseName(mod)),
                               paste("Error estimate based on",
                                     switch(error.estimate,
                                            pearson="Pearson residuals", dispersion="estimated dispersion",
                                            deviance="deviance"), "\n"))
  result
}

# type II

# LR test

Anova.II.LR.glm <- function(mod, singular.ok=TRUE, ...){
  if (!singular.ok && any(is.na(coef(mod))))
    stop("there are aliased coefficients in the model")
  # (some code adapted from drop1.glm)
  which.nms <- function(name) which(asgn == which(names == name))
  fac <- attr(terms(mod), "factors")
  names <- if (has.intercept(mod)) term.names(mod)[-1]
  else term.names(mod)
  n.terms <- length(names)
  X <- model.matrix(mod)
  y <- mod$y
  if (is.null(y)) y <- model.response(model.frame(mod), "numeric")
  wt <- mod$prior.weights
  if (is.null(wt)) wt <- rep(1, length(y))
  asgn <- attr(X, 'assign')
  df <- p <- LR <- rep(0, n.terms)
  dispersion <- summary(mod, corr = FALSE)$dispersion
  for (term in 1:n.terms){
    rels <- names[relatives(names[term], names, fac)]
    exclude.1 <- as.vector(unlist(sapply(c(names[term], rels), which.nms)))
    mod.1 <- glm.fit(X[, -exclude.1, drop = FALSE], y, wt, offset = mod$offset,
                     family = mod$family, control = mod$control)
    dev.1 <- deviance(mod.1)
    mod.2 <- if (length(rels) == 0) mod
    else {
      exclude.2 <- as.vector(unlist(sapply(rels, which.nms)))
      glm.fit(X[, -exclude.2, drop = FALSE], y, wt, offset = mod$offset,
              family = mod$family, control = mod$control)
    }
    dev.2 <- deviance(mod.2)
    df[term] <- df.residual(mod.1) - df.residual(mod.2)
    if (df[term] == 0) LR[term] <- p[term] <- NA
    else {
      LR[term] <- (dev.1 - dev.2)/dispersion
      p[term] <- pchisq(LR[term], df[term], lower.tail=FALSE)
    }
  }
  result <- data.frame(LR, df, p)
  row.names(result) <- names
  names(result) <- c("LR Chisq", "Df", "Pr(>Chisq)")
  class(result) <- c("anova", "data.frame")
  attr(result, "heading") <-
    c("Analysis of Deviance Table (Type II tests)\n", paste("Response:", responseName(mod)))
  result
}


# F test

Anova.II.F.glm <- function(mod, error, error.estimate, singular.ok=TRUE, ...){
  # (some code adapted from drop1.glm)
  if (!singular.ok && any(is.na(coef(mod))))
    stop("there are aliased coefficients in the model")
  fam <- family(mod)$family
  if ((fam == "binomial" || fam == "poisson") && error.estimate == "dispersion"){
    warning("dispersion parameter estimated from the Pearson residuals, not taken as 1")
    error.estimate <- "pearson"
  }
  which.nms <- function(name) which(asgn == which(names == name))
  if (missing(error)) error <- mod
  df.res <- df.residual(error)
  error.SS <- switch(error.estimate,
                     pearson = sum(residuals(error, "pearson")^2, na.rm=TRUE),
                     dispersion = df.res*summary(error, corr = FALSE)$dispersion,
                     deviance = deviance(error))
  fac <- attr(terms(mod), "factors")
  names <- if (has.intercept(mod)) term.names(mod)[-1]
  else term.names(mod)
  n.terms <- length(names)
  X <- model.matrix(mod)
  y <- mod$y
  if (is.null(y)) y <- model.response(model.frame(mod), "numeric")
  wt <- mod$prior.weights
  if (is.null(wt)) wt <- rep(1, length(y))
  asgn <- attr(X, 'assign')
  p <- df <- f <- SS <- rep(0, n.terms+1)
  f[n.terms+1] <- p[n.terms+1] <- NA
  df[n.terms+1] <- df.res
  SS[n.terms+1] <- error.SS
  dispersion <- error.SS/df.res
  for (term in 1:n.terms){
    rels <- names[relatives(names[term], names, fac)]
    exclude.1 <- as.vector(unlist(sapply(c(names[term], rels), which.nms)))
    mod.1 <- glm.fit(X[, -exclude.1, drop = FALSE], y, wt, offset = mod$offset,
                     family = mod$family, control = mod$control)
    dev.1 <- deviance(mod.1)
    mod.2 <- if (length(rels) == 0) mod
    else {
      exclude.2 <- as.vector(unlist(sapply(rels, which.nms)))
      glm.fit(X[, -exclude.2, drop = FALSE], y, wt, offset = mod$offset,
              family = mod$family, control = mod$control)
    }
    dev.2 <- deviance(mod.2)
    df[term] <- df.residual(mod.1) - df.residual(mod.2)
    if (df[term] == 0) SS[term] <- f[term] <- p[term] <- NA
    else {
      SS[term] <- dev.1 - dev.2
      f[term] <- SS[term]/(dispersion*df[term])
      p[term] <- pf(f[term], df[term], df.res, lower.tail=FALSE)
    }
  }
  result <- data.frame(SS, df, f, p)
  row.names(result) <- c(names, "Residuals")
  names(result) <- c("Sum Sq", "Df", "F value", "Pr(>F)")
  class(result) <- c("anova", "data.frame")
  attr(result, "heading") <- c("Analysis of Deviance Table (Type II tests)\n",
                               paste("Response:", responseName(mod)),
                               paste("Error estimate based on",
                                     switch(error.estimate,
                                            pearson="Pearson residuals",
                                            dispersion="estimated dispersion",
                                            deviance="deviance"), "\n"))
  result
}


#   ____________________________________________________________________________
#   Utils                                                                   ####

has.intercept <- function (model, ...) {
  UseMethod("has.intercept")
}

has.intercept.default <- function(model, ...) any(names(coefficients(model))=="(Intercept)")

has.intercept.multinom <- function(model, ...) {
  nms <- names(coef(model))
  any(grepl("\\(Intercept\\)", nms))
}

term.names <- function (model, ...) {
  UseMethod("term.names")
}

term.names.default <- function (model, ...) {
  term.names <- labels(terms(model))
  if (has.intercept(model)) c("(Intercept)", term.names)
  else term.names
}


relatives <- function(term, names, factors){
  is.relative <- function(term1, term2) {
    all(!(factors[,term1]&(!factors[,term2])))
  }
  if(length(names) == 1) return(NULL)
  which.term <- which(term==names)
  (1:length(names))[-which.term][sapply(names[-which.term],
                                        function(term2) is.relative(term, term2))]
}

linearHypothesis <- function (model, ...)
  UseMethod("linearHypothesis")

linearHypothesis.default <- function(model, hypothesis.matrix, rhs=NULL,
                                     test=c("Chisq", "F"), vcov.=NULL, singular.ok=FALSE, verbose=FALSE,
                                     coef. = coef(model), suppress.vcov.msg=FALSE, error.df, ...){
  if (missing(error.df)){
    df <- df.residual(model)
    test <- match.arg(test)
    if (test == "F" && (is.null(df) || is.na(df))){
      test <- "Chisq"
      message("residual df unavailable, test set to 'Chisq'")
    }
  } else {
    df <- error.df
  }
  if (is.null(df)) df <- Inf ## if no residual df available
  if (df == 0) stop("residual df = 0")
  V <- if (is.null(vcov.)) vcov(model, complete=FALSE)
  else if (is.function(vcov.)) vcov.(model) else vcov.
  b <- coef.
  if (any(aliased <- is.na(b)) && !singular.ok)
    stop("there are aliased coefficients in the model")
  b <- b[!aliased]
  if (is.null(b)) stop(paste("there is no coef() method for models of class",
                             paste(class(model), collapse=", ")))
  if (is.character(hypothesis.matrix)) {
    L <- makeHypothesis(names(b), hypothesis.matrix, rhs)
    if (is.null(dim(L))) L <- t(L)
    rhs <- L[, NCOL(L)]
    L <- L[, -NCOL(L), drop = FALSE]
    rownames(L) <- hypothesis.matrix
  }
  else {
    L <- if (is.null(dim(hypothesis.matrix))) t(hypothesis.matrix)
    else hypothesis.matrix
    if (is.null(rhs)) rhs <- rep(0, nrow(L))
  }
  q <- NROW(L)
  value.hyp <- L %*% b - rhs
  vcov.hyp <- L %*% V %*% t(L)
  if (verbose){
    cat("\nHypothesis matrix:\n")
    print(L)
    cat("\nRight-hand-side vector:\n")
    print(rhs)
    cat("\nEstimated linear function (hypothesis.matrix %*% coef - rhs)\n")
    print(drop(value.hyp))
    cat("\n")
    if (length(vcov.hyp) == 1) cat("\nEstimated variance of linear function\n")
    else cat("\nEstimated variance/covariance matrix for linear function\n")
    print(drop(vcov.hyp))
    cat("\n")
  }
  SSH <- as.vector(t(value.hyp) %*% solve(vcov.hyp) %*% value.hyp)
  test <- match.arg(test)
  if (!(is.finite(df) && df > 0)) test <- "Chisq"
  name <- try(formula(model), silent = TRUE)
  if (inherits(name, "try-error")) name <- substitute(model)
  title <- "Linear hypothesis test\n\nHypothesis:"
  topnote <- paste("Model 1: restricted model","\n", "Model 2: ",
                   paste(deparse(name), collapse = "\n"), sep = "")
  note <- if (is.null(vcov.) || suppress.vcov.msg) ""
  else "\nNote: Coefficient covariance matrix supplied.\n"
  rval <- matrix(rep(NA, 8), ncol = 4)
  colnames(rval) <- c("Res.Df", "Df", test, paste("Pr(>", test, ")", sep = ""))
  rownames(rval) <- 1:2
  rval[,1] <- c(df+q, df)
  if (test == "F") {
    f <- SSH/q
    p <- pf(f, q, df, lower.tail = FALSE)
    rval[2, 2:4] <- c(q, f, p)
  }
  else {
    p <- pchisq(SSH, q, lower.tail = FALSE)
    rval[2, 2:4] <- c(q, SSH, p)
  }
  if (!(is.finite(df) && df > 0)) rval <- rval[,-1]
  result <- structure(as.data.frame(rval),
                      heading = c(title, printHypothesis(L, rhs, names(b)), "", topnote, note),
                      class = c("anova", "data.frame"))
  attr(result, "value") <- value.hyp
  attr(result, "vcov") <- vcov.hyp
  result
}

linearHypothesis.lm <- function(model, hypothesis.matrix, rhs=NULL,
                                test=c("F", "Chisq"), vcov.=NULL,
                                white.adjust=c(FALSE, TRUE, "hc3", "hc0", "hc1", "hc2", "hc4"),
                                singular.ok=FALSE, ...){
  if (df.residual(model) == 0) stop("residual df = 0")
  if (deviance(model) < sqrt(.Machine$double.eps)) stop("residual sum of squares is 0 (within rounding error)")
  if (!singular.ok && is.aliased(model))
    stop("there are aliased coefficients in the model.")
  test <- match.arg(test)
  white.adjust <- as.character(white.adjust)
  white.adjust <- match.arg(white.adjust)
  if (white.adjust != "FALSE"){
    if (white.adjust == "TRUE") white.adjust <- "hc3"
    vcov. <- hccm(model, type=white.adjust)
  }
  rval <- linearHypothesis.default(model, hypothesis.matrix, rhs = rhs,
                                   test = test, vcov. = vcov., singular.ok=singular.ok, ...)
  if (is.null(vcov.)) {
    rval2 <- matrix(rep(NA, 4), ncol = 2)
    colnames(rval2) <- c("RSS", "Sum of Sq")
    SSH <- rval[2,test]
    if (test == "F") SSH <- SSH * abs(rval[2, "Df"])
    df <- rval[2, "Res.Df"]
    error.SS <- deviance(model)
    rval2[,1] <- c(error.SS + SSH * error.SS/df, error.SS)
    rval2[2,2] <- abs(diff(rval2[,1]))
    rval2 <- cbind(rval, rval2)[,c(1, 5, 2, 6, 3, 4)]
    class(rval2) <- c("anova", "data.frame")
    attr(rval2, "heading") <- attr(rval, "heading")
    attr(rval2, "value") <- attr(rval, "value")
    attr(rval2, "vcov") <- attr(rval, "vcov")
    rval <- rval2
  }
  rval
}

printHypothesis <- function(L, rhs, cnames){
  hyp <- rep("", nrow(L))
  for (i in 1:nrow(L)){
    sel <- L[i,] != 0
    h <- L[i, sel]
    h <- ifelse(h < 0, as.character(h), paste("+", h, sep=""))
    nms <- cnames[sel]
    h <- paste(h, nms)
    h <- gsub("-", " - ", h)
    h <- gsub("+", "  + ", h, fixed=TRUE)
    h <- paste(h, collapse="")
    h <- gsub("  ", " ", h, fixed=TRUE)
    h <- sub("^\\ \\+", "", h)
    h <- sub("^\\ ", "", h)
    h <- sub("^-\\ ", "-", h)
    h <- paste(" ", h, sep="")
    h <- paste(h, "=", rhs[i])
    h <- gsub(" 1([^[:alnum:]_.]+)[ *]*", "",
              gsub("-1([^[:alnum:]_.]+)[ *]*", "-",
                   gsub("- +1 +", "-1 ", h)))
    h <- sub("Intercept)", "(Intercept)", h)
    h <- gsub("-", " - ", h)
    h <- gsub("+", "  + ", h, fixed=TRUE)
    h <- gsub("  ", " ", h, fixed=TRUE)
    h <- sub("^ *", "", h)
    hyp[i] <- h
  }
  hyp
}

responseName <- function (model, ...) {
  UseMethod("responseName")
}

responseName.default <- function (model, ...) deparse(attr(terms(model), "variables")[[2]])

is.aliased <- function(model){
  !is.null(alias(model)$Complete)
}

makeHypothesis <- function(cnames, hypothesis, rhs = NULL){
  parseTerms <- function(terms){
    component <- gsub("^[-\\ 0-9\\.]+", "", terms)
    component <- gsub(" ", "", component, fixed=TRUE)
    component
  }
  stripchars <- function(x) {
    x <- gsub("\\n", " ", x)
    x <- gsub("\\t", " ", x)
    x <- gsub(" ", "", x, fixed = TRUE)
    x <- gsub("*", "", x, fixed = TRUE)
    x <- gsub("-", "+-", x, fixed = TRUE)
    x <- strsplit(x, "+", fixed = TRUE)[[1]]
    x <- x[x!=""]
    x
  }
  char2num <- function(x) {
    x[x == ""] <- "1"
    x[x == "-"] <- "-1"
    as.numeric(x)
  }
  constants <- function(x, y) {
    with.coef <- unique(unlist(sapply(y,
                                      function(z) which(z == parseTerms(x)))))
    if (length(with.coef) > 0) x <- x[-with.coef]
    x <- if (is.null(x)) 0 else sum(as.numeric(x))
    if (any(is.na(x)))
      stop('The hypothesis "', hypothesis,
           '" is not well formed: contains bad coefficient/variable names.')
    x
  }
  coefvector <- function(x, y) {
    rv <- gsub(" ", "", x, fixed=TRUE) ==
      parseTerms(y)
    if (!any(rv)) return(0)
    if (sum(rv) > 1) stop('The hypothesis "', hypothesis,
                          '" is not well formed.')
    rv <- sum(char2num(unlist(strsplit(y[rv], x, fixed=TRUE))))
    if (is.na(rv))
      stop('The hypothesis "', hypothesis,
           '" is not well formed: contains non-numeric coefficients.')
    rv
  }

  if (!is.null(rhs)) rhs <- rep(rhs, length.out = length(hypothesis))
  if (length(hypothesis) > 1)
    return(rbind(Recall(cnames, hypothesis[1], rhs[1]),
                 Recall(cnames, hypothesis[-1], rhs[-1])))

  cnames_symb <- sapply(c("@", "#", "~"), function(x) length(grep(x, cnames)) < 1)

  if(any(cnames_symb)) {
    cnames_symb <- head(c("@", "#", "~")[cnames_symb], 1)
    cnames_symb <- paste(cnames_symb, seq_along(cnames), cnames_symb, sep = "")
    hypothesis_symb <- hypothesis
    for(i in order(nchar(cnames), decreasing = TRUE))
      hypothesis_symb <- gsub(cnames[i], cnames_symb[i], hypothesis_symb, fixed = TRUE)
  } else {
    stop('The hypothesis "', hypothesis,
         '" is not well formed: contains non-standard coefficient names.')
  }

  lhs <- strsplit(hypothesis_symb, "=", fixed=TRUE)[[1]]
  if (is.null(rhs)) {
    if (length(lhs) < 2) rhs <- "0"
    else if (length(lhs) == 2) {
      rhs <- lhs[2]
      lhs <- lhs[1]
    }
    else stop('The hypothesis "', hypothesis,
              '" is not well formed: contains more than one = sign.')
  }
  else {
    if (length(lhs) < 2) as.character(rhs)
    else stop('The hypothesis "', hypothesis,
              '" is not well formed: contains a = sign although rhs was specified.')
  }
  lhs <- stripchars(lhs)
  rhs <- stripchars(rhs)
  rval <- sapply(cnames_symb, coefvector, y = lhs) - sapply(cnames_symb, coefvector, y = rhs)
  rval <- c(rval, constants(rhs, cnames_symb) - constants(lhs, cnames_symb))
  names(rval) <- c(cnames, "*rhs*")
  rval
}

lm2glm <- function(mod){
  class(mod) <- c("glm", "lm")
  wts <- mod$weights
  mod$prior.weights <- if (is.null(wts)) rep(1, length(mod$residuals)) else wts
  mod$y <- model.response(model.frame(mod))
  mod$linear.predictors <- mod$fitted.values
  mod$control <- list(epsilon=1e-8, maxit=25, trace=FALSE)
  mod$family <- gaussian()
  mod$deviance <- sum(residuals(mod)^2, na.rm=TRUE)
  mod
}

hccm <- function(model, ...){
  UseMethod("hccm")
}

hccm.lm <-function (model, type = c("hc3", "hc0", "hc1", "hc2", "hc4"),
                    singular.ok = TRUE, ...) {
  e <- na.omit(residuals(model))
  removed <- attr(e, "na.action")
  wts <- if (is.null(weights(model))) 1
  else weights(model)
  type <- match.arg(type)
  if (any(aliased <- is.na(coef(model))) && !singular.ok)
    stop("there are aliased coefficients in the model")
  sumry <- summary(model, corr = FALSE)
  s2 <- sumry$sigma^2
  V <- sumry$cov.unscaled
  if (type == FALSE)
    return(s2 * V)
  h <- hatvalues(model)
  if (!is.null(removed)){
    wts <- wts[-removed]
    h <- h[-removed]
  }
  X <- model.matrix(model)[, !aliased, drop=FALSE]
  df.res <- df.residual(model)
  n <- length(e)
  e <- wts*e
  p <- ncol(X)
  factor <- switch(type, hc0 = 1, hc1 = df.res/n,
                   hc2 = 1 - h, hc3 = (1 - h)^2, hc4 = (1 - h)^pmin(4, n * h/p))
  V <- V %*% t(X) %*% apply(X, 2, "*", (e^2)/factor) %*% V
  bad <- h > 1 - sqrt(.Machine$double.eps)
  if ((n.bad <- sum(bad)) > 0 && !(type %in% c("hc0", "hc1"))) {
    nms <- names(e)
    bads <- if (n.bad <= 10) {
      paste(nms[bad], collapse=", ")
    } else {
      paste0(paste(nms[bad[1:10]], collapse=", "), ", ...")
    }
    if (any(is.nan(V))){
      stop("cannot proceed because of ", n.bad, if (n.bad == 1) " case " else " cases ",
           "with hatvalue = 1:\n   ", bads)
    } else {
      warning("adjusted coefficient covariances may be unstable because of ", n.bad,
              if (n.bad == 1) " case " else " cases ",
              "with hatvalue near 1:\n   ", bads)
    }
  }
  V
}

hccm.default<-function(model, ...){
  stop("requires an lm object")
}

getVcov <- function(v, mod, ...){
  if(missing(v)) return(vcov(mod, ...))
  if(inherits(v, "matrix")) return(v)
  if(is.function(v)) return(v(mod, ...))
  if(is.null(v)) return(vcov(mod, ...))
  v <- try(as.matrix(v), silent=TRUE)
  if (is.matrix(v)) return(v)
  stop("vcov. must be a matrix or a function")
}

assignVector <- function(model, ...) UseMethod("assignVector")

assignVector.default <- function(model, ...){
  m <- model.matrix(model)
  assign <- attr(m, "assign")
  if (!is.null(assign)) return (assign)
  m <- model.matrix(formula(model), data=model.frame(model))
  assign <- attr(m, "assign")
  if (!has.intercept(model)) assign <- assign[assign != 0]
  assign
}

assignVector.svyolr <- function(model, ...){
  m <- model.matrix(model)
  assign <- attr(m, "assign")
  assign[assign != 0]
}

ConjComp <- function(X, Z = diag( nrow(X)), ip = diag(nrow(X))) {
  # This function by Georges Monette
  # finds the conjugate complement of the proj of X in span(Z) wrt
  #    inner product ip
  # - assumes Z is of full column rank
  # - projects X conjugately wrt ip into span Z
  xq <- qr(t(Z) %*% ip %*% X)
  if (xq$rank == 0) return(Z)
  Z %*% qr.Q(xq, complete = TRUE) [ ,-(1:xq$rank)]
}

