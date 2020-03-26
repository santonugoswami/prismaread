context("convert_prisma")
skip_on_travis()
skip_on_cran()

test_that("convert_prisma works as expected - L1C", {
    skip_on_travis()
    skip_on_cran()
    # VNIR ----
    convert_prisma("D:/prismaread/L1/PRS_L1_STD_OFFL_20200215103028_20200215103033_0001.he5",
                   "D:/prismaread/L1/testL1", SWIR = FALSE, overwrite = T, ERR_MATRIX = FALSE,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = FALSE, GLINT = FALSE)

    # SWIR ----
    convert_prisma("D:/prismaread/L1/PRS_L1_STD_OFFL_20200215103028_20200215103033_0001.he5",
                   "D:/prismaread/L1/testL1", SWIR = TRUE, VNIR = FALSE, overwrite = T,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = FALSE, GLINT = FALSE)

    # FULL Cube (using already available data) ----
    convert_prisma("D:/prismaread/L1/PRS_L1_STD_OFFL_20200215103028_20200215103033_0001.he5",
                   "D:/prismaread/L1/testL1", SWIR = TRUE, VNIR = TRUE, overwrite = FALSE,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = TRUE, PAN = FALSE, GLINT = FALSE)

    # PAN ----
    convert_prisma("D:/prismaread/L1/PRS_L1_STD_OFFL_20200215103028_20200215103033_0001.he5",
                   "D:/prismaread/L1/testL1", SWIR = FALSE, VNIR = FALSE,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = TRUE
                   , GLINT = FALSE, overwrite = T)

})


test_that("convert_prisma works as expected - L2B", {
    skip_on_travis()
    skip_on_cran()
    # VNIR ----
    convert_prisma("D:/prismaread/L2B/PRS_L2B_STD_20200215103028_20200215103033_0001.he5",
                   "D:/prismaread/L2B/testL2B", SWIR = FALSE, overwrite = T,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = FALSE, GLINT = FALSE)

    # SWIR ----
    convert_prisma("D:/prismaread/L2B/PRS_L2B_STD_20200215103028_20200215103033_0001.he5",
                   "D:/prismaread/L2B/testL2B", SWIR = TRUE, VNIR = FALSE, overwrite = T,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = FALSE, GLINT = FALSE)

    # PAN ----
    convert_prisma("D:/prismaread/L2B/PRS_L2B_STD_20200215103028_20200215103033_0001.he5",
                   "D:/prismaread/L2B/testL2B", SWIR = FALSE, VNIR = FALSE,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = TRUE
                   , GLINT = FALSE, overwrite = T)


})

test_that("convert_prisma works as expected - L2C", {
    skip_on_travis()
    skip_on_cran()
    # VNIR ----
    convert_prisma("D:/prismaread/L2C/PRS_L2C_STD_20200215103028_20200215103033_0001.he5",
                   "D:/prismaread/L2C/testL2C", SWIR = FALSE, overwrite = T, base_georef = TRUE,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = FALSE, GLINT = FALSE)

    # SWIR ----
    convert_prisma("D:/prismaread/L2C/PRS_L2C_STD_20200215103028_20200215103033_0001.he5",
                   "D:/prismaread/L2C/testL2C", SWIR = TRUE, VNIR = FALSE, overwrite = T, base_georef = TRUE,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = FALSE, GLINT = FALSE)

    # PAN ----
    convert_prisma("D:/prismaread/L2C/PRS_L2C_STD_20200215103028_20200215103033_0001.he5",
                   "D:/prismaread/L2C/testL2C", SWIR = FALSE, VNIR = FALSE,overwrite = T, base_georef = TRUE,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = TRUE
                   , GLINT = FALSE)

})

test_that("convert_prisma works as expected - L2D", {
    skip_on_travis()
    skip_on_cran()
    # VNIR ----
    convert_prisma("D:/prismaread/L2D/PRS_L2D_STD_20190616102249_20190616102253_0001.he5",
                   "D:/prismaread/L2D/testL2D", SWIR = FALSE,overwrite = T,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = FALSE, GLINT = FALSE)

    # SWIR ----
    convert_prisma("D:/prismaread/L2D/PRS_L2D_STD_20190616102249_20190616102253_0001.he5",
                   "D:/prismaread/L2D/testL2D", SWIR = TRUE, VNIR = FALSE,overwrite = T,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = FALSE, GLINT = FALSE)

    # PAN ----
    convert_prisma("D:/prismaread/L2D/PRS_L2D_STD_20190616102249_20190616102253_0001.he5",
                   "D:/prismaread/L2D/testL2D_pan", SWIR = FALSE, VNIR = FALSE,overwrite = T,
                   CLOUD = FALSE, ATCOR = FALSE, FULL = FALSE, PAN = TRUE
                   , GLINT = FALSE)

})