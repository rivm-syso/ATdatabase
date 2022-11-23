test_that("remove_doc input", {

             expect_error(doc_exists(type=1, ref = "a", conn = dbconn))
             expect_error(doc_exists(type="a", ref = 1, conn = dbconn))
})

test_that("remove_doc output", {

             create_database_tables(dbconn)
             x <- data.frame(x = rnorm(5), y = rnorm(5))

             expect_false(doc_exists(type = "test", ref = "a", conn = dbconn))

             add_doc(type = "test", ref = "a", doc = x, conn = dbconn)
             expect_true(doc_exists(type = "test", ref = "a", conn = dbconn))

             remove_doc(type = "test", ref = "a", conn = dbconn)

             expect_false(doc_exists(type = "test", ref = "a", conn = dbconn))


             drop_database_tables(dbconn)

})

