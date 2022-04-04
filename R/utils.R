check_namespace <- function(package) {
  if (!requireNamespace(package, quietly = T)) {
    cat('Package "', package, '" is required for this function.',
           '\n Please install with: install.packages("', package, '") \n', sep = "")
    stop(call. = F,
         paste0('Package "', package, '" required.'))
  }
}