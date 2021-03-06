#' @title prisma_create_vnir
#' @description helper function used to process and save the VNIR data cube
#' @param f input data he5 from caller
#' @param proc_lev `character` Processing level (e.g., "1", "2B") - passed by caller
#' @param out_file_vnir output file name for VNIR
#' @param wl_vnir passed by caller - array of PRISMA VNIR wavelengths
#' @param order_vnir passed by caller - ordering of array of PRISMA VNIR wavelengths
#' @param fwhm_vnir passed by caller - array of PRISMA VNIR fwhms
#' @inheritParams convert_prisma
#' @return the function is called for its side effects
#' @importFrom hdf5r h5attr
#' @importFrom raster raster extent flip t setExtent stack
#' @importFrom tools file_path_sans_ext
#' @importFrom utils write.table
#'
prisma_create_vnir <- function(f,
                               proc_lev,
                               source,
                               out_file_vnir,
                               out_format,
                               base_georef,
                               fill_gaps,
                               wl_vnir,
                               order_vnir,
                               fwhm_vnir,
                               apply_errmatrix,
                               ERR_MATRIX,
                               selbands_vnir = NULL,
                               in_L2_file = NULL){

    # Get geo info ----

    geo <- prisma_get_geoloc(f, proc_lev, source, wvl = "VNIR", in_L2_file)

    # Get the datacube and required attributes frim hdr ----
    if(proc_lev == 1) {
        vnir_cube <- f[[paste0("HDFEOS/SWATHS/PRS_L1_", source, "/Data Fields/VNIR_Cube")]][,,]
        vnir_scale  <- hdf5r::h5attr(f, "ScaleFactor_Vnir")
        vnir_offset <- hdf5r::h5attr(f, "Offset_Vnir")
        if (any(apply_errmatrix | ERR_MATRIX)) {
            err_cube <- f[[paste0("HDFEOS/SWATHS/PRS_L1_", source,
                                  "/Data Fields/VNIR_PIXEL_SAT_ERR_MATRIX/")]]
        }
    } else {
        vnir_cube <- f[[paste0("HDFEOS/SWATHS/PRS_L", proc_lev,"_",
                               source, "/Data Fields/VNIR_Cube")]][,,]
        vnir_max <- hdf5r::h5attr(f, "L2ScaleVnirMax")
        vnir_min <- hdf5r::h5attr(f, "L2ScaleVnirMin")
        if (any(apply_errmatrix | ERR_MATRIX)) {
            err_cube <- f[[paste0("HDFEOS/SWATHS/PRS_L", proc_lev,"_",
                                  source, "/Data Fields/VNIR_PIXEL_SAT_ERR_MATRIX")]][,,]
        }
    }

    # Get the different bands in order of wvl, and convert to `raster` bands ----
    # Also georeference if needed
    ind_vnir <- 1
    if (is.null(selbands_vnir)) {
        seqbands <- 1:66
    } else {
        seqbands <- unlist(lapply(selbands_vnir, FUN = function(x) which.min(abs(wl_vnir - x))))
    }

    for (band_vnir in seqbands) {

        if (wl_vnir[band_vnir] != 0) {

            if(proc_lev %in% c("1", "2B", "2C")) {
                if (base_georef) {
                    message("Importing Band: ", band_vnir, " of: 66 and applying bowtie georeferencing")
                    band <- raster::raster((vnir_cube[,order_vnir[band_vnir], ]),
                                           crs = "+proj=longlat +datum=WGS84")
                    lat  <- geo$lat
                    lon  <- geo$lon
                    if (proc_lev == "1") {
                        band <- (band / vnir_scale) - vnir_offset
                    }
                    band <- prisma_basegeo(band, lon, lat, fill_gaps)

                    if (ERR_MATRIX) {
                        satband <- raster::raster((err_cube[,order_vnir[band_vnir], ]),
                                                  crs = "+proj=longlat +datum=WGS84")
                        satband <- prisma_basegeo(satband, lon, lat, fill_gaps)
                    }

                } else {
                    message("Importing Band: ", band_vnir, " of: 66")
                    band <- raster::raster((vnir_cube[,order_vnir[band_vnir], ]),
                                           crs = "+proj=longlat +datum=WGS84")
                    if (proc_lev == "1") {
                        band <- (band / vnir_scale) - vnir_offset
                    }
                    band <- raster::flip(band, 1)

                    if (ERR_MATRIX) {
                        satband <- raster::raster((err_cube[,order_vnir[band_vnir], ]),
                                                  crs = "+proj=longlat +datum=WGS84")
                        satband <- raster::flip(satband, 1)
                    }
                }
            } else {
                if (proc_lev == "2D") {
                    message("Importing Band: ", band_vnir, " of: 66")
                    band <- raster::raster((vnir_cube[,order_vnir[band_vnir], ]),
                                           crs = paste0("+proj=utm +zone=", geo$proj_code,
                                                        ifelse(substring(geo$proj_epsg, 3, 3) == 7, " +south", ""),
                                                        " +datum=WGS84 +units=m +no_defs"))
                    band <- raster::t(band)
                    ex <- matrix(c(geo$xmin - 15,
                                   geo$xmin - 15 + dim(band)[2]*30,
                                   geo$ymin - 15,
                                   geo$ymin - 15 + dim(band)[1]*30),
                                 nrow = 2, ncol = 2, byrow = T)
                    ex <- raster::extent(ex)
                    band <- raster::setExtent(band, ex, keepres = FALSE)

                    if (ERR_MATRIX) {
                        satband <- raster::raster((err_cube[,order_vnir[band_vnir], ]),
                                                  crs = "+proj=longlat +datum=WGS84")
                        satband <- raster::flip(satband, 1)
                        satband <- raster::t(satband)
                        ex <- matrix(c(geo$xmin - 15,
                                       geo$xmin - 15 + dim(satband)[2]*30,
                                       geo$ymin - 15,
                                       geo$ymin - 15 + dim(satband)[1]*30),
                                     nrow = 2, ncol = 2, byrow = T)
                        ex <- raster::extent(ex)
                        satband <- raster::setExtent(satband, ex, keepres = FALSE)
                    }

                }
            }

            if (ind_vnir == 1) {
                rast_vnir <- band
                if (ERR_MATRIX) rast_err <- satband
            } else {
                rast_vnir <- raster::stack(rast_vnir, band)
                if (ERR_MATRIX) rast_err <- raster::stack(rast_err, satband)
            }
            ind_vnir <- ind_vnir + 1
        } else {
            message("Band: ", band_vnir, " not present")
        }
    }

    # Write the cube ----

    if (is.null(selbands_vnir)) {
        # names(rast_vnir) <- paste0("b", seqbands, "_", round(wl_vnir, digits = 3))
        orbands <- seqbands[wl_vnir != 0]
        names(rast_vnir) <- paste0("b", orbands)
        wl_sub   <- wl_vnir[wl_vnir != 0]
        fwhm_sub <- fwhm_vnir[wl_vnir != 0]
    } else {
        # names(rast_vnir) <- paste0("b", seqbands, "_", round(wl_vnir[seqbands], digits = 3))
        orbands <- seqbands
        names(rast_vnir) <- paste0("b", orbands)
        wl_sub   <- wl_vnir[seqbands]
        fwhm_sub <- fwhm_vnir[seqbands]
    }

    # wl_vnir   <- wl_vnir[wl_vnir != 0]
    # fwhm_vnir <- fwhm_vnir[fwhm_vnir != 0]
    rm(vnir_cube)
    rm(band)
    gc()

    message("- Writing VNIR raster -")

    rastwrite_lines(rast_vnir,
                    out_file_vnir,
                    out_format,
                    proc_lev,
                    scale_min = vnir_min,
                    scale_max = vnir_max)

    if (ERR_MATRIX) {
         message("- Writing SATERR raster -")
        out_file_vnir_err <- gsub("VNIR", "SATERR", out_file_vnir)
        rastwrite_lines(rast_err,
                        out_file_vnir_err,
                        out_format,
                        "SATERR",
                        scale_min = NULL,
                        scale_max = NULL)
    }

    if (out_format == "ENVI") {
        cat("band names = {", paste(names(rast_vnir),collapse=","), "}", "\n",
            file=raster::extension(out_file_vnir, "hdr"), append=TRUE)
        out_hdr <- paste0(tools::file_path_sans_ext(out_file_vnir), ".hdr")
        write(c("wavelength = {",
                paste(round(wl_sub, digits = 4), collapse = ","), "}"),
              out_hdr, append = TRUE)
        write(c("fwhm = {",
                paste(round(fwhm_sub, digits = 4), collapse = ","), "}"),
              out_hdr, append = TRUE)
        write("wavelength units = Nanometers")
        write("sensor type = PRISMA")
        # hdr_in  <- readLines(out_hdr)
        # start_line_bnames <- grep("band names", hdr_in) + 1
        # end_line_bnames <- start_line_bnames + length(wl_sub) - 1
        # for (bb in start_line_bnames:(end_line_bnames - 1)) {
        #     hdr_in[bb] <- paste0(names(rast_vnir)[bb-start_line_bnames+1], ",")
        # }
        # hdr_in[end_line_bnames] <- paste0(tail(names(rast_vnir), 1), "}")
        # fileConn <-file(out_hdr)
        # writeLines(hdr_in, fileConn)
        # close(fileConn)
        # writeLines(hdr_in, )

    }

    out_file_txt <- paste0(tools::file_path_sans_ext(out_file_vnir), ".wvl")
    utils::write.table(data.frame(band = 1:length(wl_sub),
                                  orband = orbands,
                                  wl   = wl_sub,
                                  fwhm = fwhm_sub,
                                  stringsAsFactors = FALSE),
                       file = out_file_txt, row.names = FALSE)
}
