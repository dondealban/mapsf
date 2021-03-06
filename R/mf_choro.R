#' @title Plot a choropleth map
#' @description Plot choropleth map.
#' @eval my_params(c(
#' 'x',
#' 'var',
#' 'border',
#' 'lwd',
#' 'add' ,
#' 'col_na',
#' 'pal',
#' 'alpha',
#' 'breaks',
#' 'nbreaks',
#' 'leg_pos',
#' 'leg_title',
#' 'leg_title_cex',
#' 'leg_val_cex',
#' 'leg_val_rnd',
#' 'leg_no_data',
#' 'leg_frame'))
#' @param cex cex cex of the symbols if x is a POINT layer
#' @param pch pch type of pch if x is a POINT layer
#' @param pch_na pch for NA values if x is a POINT layer
#' @param cex_na cex for NA values if x is a POINT layer
#' @importFrom methods is
#' @keywords internal
#' @export
#' @return x is (invisibly) returned.
#' @examples
#' mtq <- mf_get_mtq()
#' mf_choro(mtq, "MED")
#'
#' mtq[6, "MED"] <- NA
#' mf_choro(
#'   x = mtq, var = "MED", col_na = "grey", pal = "Cividis",
#'   breaks = "quantile", nbreaks = 4, border = "white",
#'   lwd = .5, leg_pos = "topleft",
#'   leg_title = "Median Income", leg_title_cex = 1.1,
#'   leg_val_cex = 1, leg_val_rnd = -2, leg_no_data = "No data",
#'   leg_frame = TRUE
#' )
mf_choro <- function(x, var,
                     pal = "Mint",
                     alpha = 1,
                     breaks = "quantile",
                     nbreaks,
                     border,
                     pch = 21,
                     cex = 1,
                     lwd = .7,
                     col_na = "white",
                     cex_na = 1,
                     pch_na = 4,
                     leg_pos = mf_get_leg_pos(x),
                     leg_title = var,
                     leg_title_cex = .8,
                     leg_val_cex = .6,
                     leg_val_rnd = 2,
                     leg_no_data = "No data",
                     leg_frame = FALSE,
                     add = FALSE) {
  # default
  op <- par(mar = .gmapsf$args$mar, no.readonly = TRUE)
  on.exit(par(op))
  bg <- .gmapsf$args$bg
  fg <- .gmapsf$args$fg
  if (missing(border)) border <- fg

  # get the breaks
  breaks <- mf_get_breaks(x = x[[var]], nbreaks = nbreaks, breaks = breaks)
  nbreaks <- length(breaks) - 1
  # get the cols
  pal <- get_the_pal(pal = pal, nbreaks = nbreaks, alpha = alpha)
  # get the color vector
  mycols <- get_col_vec(x = x[[var]], breaks = breaks, pal = pal)

  no_data <- FALSE
  if (max(is.na(mycols)) == 1) {
    no_data <- TRUE
  }
  mycols[is.na(mycols)] <- col_na


  if (add == FALSE) {
    mf_init(x)
    add <- TRUE
  }

  xtype <- get_geom_type(x)
  if (xtype == "LINE") {
    plot(st_geometry(x), col = mycols, lwd = lwd, bg = bg, add = add)
  }
  if (xtype == "POLYGON") {
    plot(
      st_geometry(x),
      col = mycols, border = border, lwd = lwd,
      bg = bg, add = add
    )
  }
  if (xtype == "POINT") {
    if (pch %in% 21:25) {
      mycolspt <- border
    } else {
      mycolspt <- mycols
    }
    mycolsptbg <- mycols
    plot(
      st_geometry(x),
      col = mycolspt, bg = mycolsptbg, cex = cex, pch = pch,
      lwd = lwd, add = add
    )
  }


  mf_legend_c(
    pos = leg_pos, val = breaks, title = leg_title,
    title_cex = leg_title_cex, val_cex = leg_val_cex, val_rnd = leg_val_rnd,
    col_na = col_na, no_data = no_data, no_data_txt = leg_no_data,
    frame = leg_frame, pal = pal, bg = bg, fg = fg
  )

  return(invisible(x))
}
