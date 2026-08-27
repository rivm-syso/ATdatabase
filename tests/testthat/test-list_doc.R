test_that("list_doc input", {

              create_database_tables(dbconn)

              expect_error(list_doc(type = 1, conn = dbconn))

              drop_database_tables(dbconn)

})



test_that("list_doc output", {

              create_database_tables(dbconn)
              x <- data.frame(x = rnorm(5), y = rnorm(5))

              add_doc(type = "test", ref = "a", doc = x, conn = dbconn)
              add_doc(type = "test", ref = "b", doc = x, conn = dbconn)
              add_doc(type = "other", ref = "c", doc = x, conn = dbconn)

              refs <- list_doc(type = "test", conn = dbconn)
              expect_equal(sort(refs), c("a", "b"))

              refs2 <- list_doc(type = "other", conn = dbconn)
              expect_equal(refs2, "c")

              refs3 <- list_doc(type = "nonexistent", conn = dbconn)
              expect_true(is.na(refs3))

              drop_database_tables(dbconn)
})
