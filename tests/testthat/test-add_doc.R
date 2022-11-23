
test_that("add_doc input", {

              create_database_tables(dbconn)
              x <- data.frame(x = rnorm(5), y = rnorm(5))

              expect_error(add_doc(type=1, ref = "a", doc = x, conn = dbconn))
              expect_error(add_doc(type="a", ref = 1, doc = x, conn = dbconn))
              expect_error(add_doc(type="a", ref = "a", doc = x, conn = dbconn,
                                   overwrite = "a"))


              drop_database_tables(dbconn)

})


test_that("add_doc output, new doc", {

              create_database_tables(dbconn)
              x <- data.frame(x = rnorm(5), y = rnorm(5))


              add_doc(type = "test", ref = "a", doc = x, conn = dbconn)

              x2 <- get_db_tables(dbconn)$meta %>%
                  dplyr::filter(type == "test", ref == "a") %>%
                  dplyr::pull(doc)  %>%
                  jsonlite::fromJSON()

              expect_equal(x,x2, tolerance = 0.001)


              drop_database_tables(dbconn)

})


test_that("add_doc output, overwrite doc", {


              create_database_tables(dbconn)
              x1 <- data.frame(x = rnorm(5), y = rnorm(5))
              x2 <- data.frame(x = rnorm(5), y = rnorm(5))

              add_doc(type = "test", ref = "a", doc = x1, conn = dbconn)
              expect_error(add_doc(type = "test", ref = "a", doc = x1, conn = dbconn))

              add_doc(type = "test", ref = "a", doc = x2, conn = dbconn, overwrite = TRUE)


              x2_t <- get_db_tables(dbconn)$meta %>%
                  dplyr::filter(type == "test", ref == "a") %>%
                  dplyr::pull(doc)  %>%
                  jsonlite::fromJSON()

              expect_equal(x2,x2_t, tolerance = 0.001)

              drop_database_tables(dbconn)

})
