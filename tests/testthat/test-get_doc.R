test_that("get_doc input", {

              create_database_tables(dbconn)

              expect_error(get_doc(type=1, ref = "a", conn = dbconn))
              expect_error(get_doc(type="a", ref = 1, conn = dbconn))

              drop_database_tables(dbconn)

})



test_that("get_doc output", {

              create_database_tables(dbconn)
              x <- data.frame(x = rnorm(5), y = rnorm(5))

              add_doc(type = "test", ref = "a", doc = x, conn = dbconn)
              x2 <- get_doc(type = "test", ref = "a", conn = dbconn)
              expect_equal(x,x2, tolerance = 0.001)
              x3 <- get_doc(type = "nonexistent", ref = "a", conn = dbconn)
              expect_true(is.na(x3))

              drop_database_tables(dbconn)
})
