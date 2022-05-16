

test_that("datetime_to_matrix input", {


              expect_error(datetime_to_matrix(Tstart = "2022-01-01 10:15:00",
                                              Tend = "2021-02-02 12:13:15"))


              expect_error(datetime_to_matrix(Tstart = "huh?",
                                              Tend = "2021-02-02 12:13:15"))


              expect_error(datetime_to_matrix(Tstart = "2022-01-01 10:15:00",
                                              Tend = "huh?"))


})


test_that("datetime_to_matrix output", {

              x <- datetime_to_matrix(Tstart = "2020-01-01 10:15:00", 
                                      Tend = "2021-02-02 12:13:15")
              x
              expect_true(is.matrix(x))
              expect_equal(x[1,1], 1577873700)
              expect_equal(x[1,2], 1612267995)

})

