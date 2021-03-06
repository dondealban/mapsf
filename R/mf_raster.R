#' @title Plot a raster
#' @description Plot a raster object over a map (SpatRaster from terra).
#' @name mf_raster
#' @param x a SpatRaster
#' @param add whether to add the layer to an existing plot (TRUE) or
#' not (FALSE).
#' @param ... bgalpha, interpolate, or other arguments passed to be passed to
#' \code{\link[terra:plotRGB]{plotRGB}} or  \code{\link[terra:plot]{plot}}
#' @note The accuracy of the final plot depends on \code{x} resolution
#' and on the setup of the graphic device.
#' @export
#' @return No return value, a map is displayed.
#' @importFrom methods is
#' @examples
#' if (require("terra")) {
#'   r <- rast(system.file("ex/elev.tif", package = "terra"))
#'   mf_raster(r)
#' }
mf_raster <- function(x, add = FALSE, ...) {
  if (!requireNamespace("terra", quietly = TRUE)) {
    stop(
      "'terra' package needed for this function to work. Please install it.",
      call. = FALSE
    )
  }

  op <- par(mar = .gmapsf$args$mar, no.readonly = TRUE)
  on.exit(par(op))

  if (add == FALSE) {
    mf_init(x)
  }

  if (is(x, "SpatRaster")) {
    ops <- list(...)
    ops$x <- x
    ops$add <- TRUE
    ops$maxcell <- ifelse(is.null(ops$maxcell), terra::ncell(x), ops$maxcell)
    ops$bgalpha <- ifelse(is.null(ops$bgalpha), 0, ops$bgalpha)
    ops$smooth <- ifelse(is.null(ops$smooth), TRUE, ops$smooth)
    if (terra::nlyr(x) == 3) {
      do.call(terra::plotRGB, ops)
    }
    if (terra::nlyr(x) == 1) {
      ops$legend <- ifelse(is.null(ops$legend), FALSE, ops$legend)
      ops$axes <- ifelse(is.null(ops$axes), FALSE, ops$axes)
      ops$box <- ifelse(is.null(ops$box), FALSE, ops$box)
      do.call(terra::plot, ops)
    }
  }
}
