% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prisma_create_swir.R
\name{prisma_create_swir}
\alias{prisma_create_swir}
\title{prisma_create_swir}
\usage{
prisma_create_swir(
  f,
  proc_lev,
  source,
  out_file_swir,
  out_format,
  base_georef,
  fill_gaps,
  wl_swir,
  order_swir,
  fwhm_swir,
  apply_errmatrix,
  ERR_MATRIX,
  selbands_swir = NULL,
  in_L2_file = NULL
)
}
\arguments{
\item{f}{input data he5 from caller}

\item{proc_lev}{`character` Processing level (e.g., "1", "2B") - passed by caller}

\item{source}{`character` ["HC0" | "HRC"], Considered Data Cube Default: 'HCO'}

\item{out_file_swir}{output file name for SWIR}

\item{out_format}{`character`` ["TIF" | "ENVI"], Output format, Default: 'tif'}

\item{base_georef}{`logical` if TRUE, apply base georeferencing on L1, L2B/C data,
using the "Georeference from input GLT" procedure explained here:
https://www.harrisgeospatial.com/docs/backgroundgltbowtiecorrection.html,
Default: TRUE}

\item{fill_gaps}{`logical` if TRUE, when georeferencing on L1, L2B/C data,
substitute missing values with results of a 3x3 focal filter on the georeferenced
data, Default: TRUE}

\item{wl_swir}{passed by caller - array of PRISMA SWIR wavelengths}

\item{order_swir}{passed by caller - ordering of array of PRISMA SWIR wavelengths}

\item{fwhm_swir}{passed by caller - array of PRISMA SWIR fwhms}

\item{apply_errmatrix}{Not yet implemented!}

\item{ERR_MATRIX}{`logical` if TRUE, also save the SATURATION ERROR MATRIX Data, default: FALSE
SATURATION ERROR MATRIX is coded as:
 0=pixel ok;
 1=DEFECTIVE PIXEL from KDP
 2= Pixel in saturation.
 3= Pixel with lower radiometric accuracy, due to coregistration effects.
 4= Pixel becomes NaN or Inf during processing.}

\item{selbands_swir}{`numeric array` containing wavelengths (in nanometers) of bands that should be extracted from
the SWIR data cube. If not NULL, only the bands with wavelengths closest to these values are extracted, Default: NULL}

\item{in_L2_file}{`character` full path of an L2B/C file to be used to extract georeeferencing
info and angles for a corresponding L1 file. If not NULL, and `in_file` is a L1 file, the LAT and LON
fields used for bowtie georeferencing are taken from the L2 file instead than from the L1 file. The ANGLES
data are also retrieved from the L2 file.}
}
\value{
the function is called for its side effects
}
\description{
helper function used to process and save the SWIR data cube
}
