#' @noRd
theme_apa <- function(x, has.legend = FALSE) {
  x +
    ggplot2::theme_bw(base_size = 24) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5),
      axis.text.x = ggplot2::element_text(colour = "black"),
      axis.text.y = ggplot2::element_text(colour = "black"),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      axis.line = ggplot2::element_line(colour = "black"),
      axis.ticks = ggplot2::element_line(colour = "black")
    ) +
    {
      if (has.legend == FALSE) {
        ggplot2::theme(legend.position = "none")
      }
    }
}

#' @noRd
check_col_names <- function(data, names) {
  missing.cols <- lapply(names, function(x) {
    x %in% names(data)
    # grep(x, names(data), invert = F)
  })
  if (length(missing.cols) > 0) {
    id <- which(!unlist(missing.cols))
    if (isTRUE(length(id) >= 1)) {
      missing.cols <- toString(names[id])
      stop(paste0(
        "Variables not found: ",
        missing.cols,
        ". Please double check spelling."
      ))
    }
  }
}

#' @noRd
data_is_standardized <- function(data) {
  data <- dplyr::select(
    data,
    -dplyr::where(is.factor),
    -dplyr::where(function(x) {
      length(unique(x)) == 2
    })
  )
  all(
    lapply(data, function(x) {
      y <- x %>%
        attributes() %>%
        names()
      all(any(grepl("center", y)), any(grepl("scale", y)))
    }) %>%
      unlist()
  )
}

#' @noRd
model_is_standardized <- function(models.list) {
  all(
    lapply(models.list, function(submodel) {
      data_is_standardized(submodel$model)
    }) %>%
      unlist()
  )
}

#' @title Get required version of specified package dependency
#' @export
#' @param dep Dependency of the specified package to check
#' @param pkg Package to check the dependency from
get_dep_version <- function(dep, pkg = utils::packageName()) {
  suggests_field <- utils::packageDescription(pkg, fields = "Suggests")
  suggests_list <- unlist(strsplit(suggests_field, ",", fixed = TRUE))
  out <- lapply(dep, function(x) {
    dep_string <- grep(x, suggests_list, value = TRUE, fixed = TRUE)
    dep_string <- dep_string[which.min(nchar(dep_string))]
    dep_string <- unlist(strsplit(dep_string, ">", fixed = TRUE))
    gsub("[^0-9.]+", "", dep_string[2])
  })
  unlist(out)
}

#' @title Install package if not already installed
#' @export
#' @param pkgs Packages to install if not already installed
install_if_not_installed <- function(pkgs) {
  successfully_loaded <- vapply(
    pkgs,
    requireNamespace,
    FUN.VALUE = logical(1L),
    quietly = TRUE
  )
  required_pkgs <- names(which(successfully_loaded == FALSE))
  utils::install.packages(required_pkgs)
}

#' @title Reorder grouping variable in rempsyc plots
#'
#' @keywords internal
#' @noRd
.reorder_groups <- function(
  data,
  group = NULL,
  response = NULL,
  groups.order = "none"
) {
  if (is.null(group) || !group %in% names(data)) {
    return(data)
  }

  original_levels <- levels(as.factor(data[[group]]))

  # normalize (so vector orders don't break `if`)
  go1 <- groups.order[1]

  if (is.character(go1) && go1 == "none") {
    data[[group]] <- factor(data[[group]], levels = original_levels)
    return(data)
  }

  if (is.character(go1) && go1 %in% c("increasing", "decreasing")) {
    if (is.null(response)) {
      stop("`response` must be provided for increasing/decreasing ordering.")
    }
    summary_df <- data %>%
      dplyr::summarise(
        Mean = mean(.data[[response]], na.rm = TRUE),
        .by = all_of(group)
      )
    new_levels <- summary_df %>%
      dplyr::arrange(if (go1 == "increasing") Mean else dplyr::desc(Mean)) %>%
      dplyr::pull(.data[[group]])
    data[[group]] <- factor(data[[group]], levels = new_levels)
    return(data)
  }

  if (is.character(go1) && go1 == "string.length") {
    new_levels <- original_levels[order(nchar(original_levels))]
    data[[group]] <- factor(data[[group]], levels = new_levels)
    return(data)
  }

  # custom order vector (numeric or character)
  data[[group]] <- factor(data[[group]], levels = groups.order)
  data
}
