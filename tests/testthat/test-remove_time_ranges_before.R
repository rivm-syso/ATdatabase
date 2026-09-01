######################################################################
# helpers to seed the database for these tests
######################################################################

# insert a cache record with an explicit download time
seed_cache <- function(station, start, end, time_dl, conn) {
    qry <- glue::glue_sql(
        "INSERT INTO cache (station, start, end, time_dl) VALUES ({station}, {start}, {end}, {time_dl});",
        .con = conn)
    pool::dbExecute(conn, qry)
}

# insert a single measurement
seed_measurement <- function(station, timestamp, conn) {
    qry <- glue::glue_sql(
        "INSERT INTO measurements (station, parameter, value, aggregation, timestamp) VALUES ({station}, 'pm25', 1.0, 3600, {timestamp});",
        .con = conn)
    pool::dbExecute(conn, qry)
}

# insert a location record
seed_location <- function(station, conn) {
    qry <- glue::glue_sql(
        "INSERT INTO location (station, lat, lon, timestamp) VALUES ({station}, 52.0, 5.0, 0);",
        .con = conn)
    pool::dbExecute(conn, qry)
}


test_that("remove_time_ranges_before checks input", {
    create_database_tables(dbconn)
    expect_error(remove_time_ranges_before("2022-01-01", conn = dbconn))
    drop_database_tables(dbconn)
})


test_that("remove_time_ranges_before removes measurements inclusive of endpoints", {
    create_database_tables(dbconn)

    start <- as.numeric(lubridate::as_datetime("2022-02-01 00:00:00"))
    end <- as.numeric(lubridate::as_datetime("2022-02-02 00:00:00"))
    dl <- as.numeric(lubridate::as_datetime("2022-03-01 00:00:00"))

    seed_location("test-1", dbconn)
    seed_cache("test-1", start, end, dl, dbconn)

    # measurement before range (kept), at start (removed), inside (removed),
    # at end (removed) and after range (kept)
    seed_measurement("test-1", start - 3600, dbconn)
    seed_measurement("test-1", start, dbconn)
    seed_measurement("test-1", start + 3600, dbconn)
    seed_measurement("test-1", end, dbconn)
    seed_measurement("test-1", end + 3600, dbconn)

    res <- remove_time_ranges_before(lubridate::as_datetime("2022-04-01"), conn = dbconn)

    tbls <- get_db_tables(dbconn)
    remaining <- tbls$measurements$timestamp

    expect_true((start - 3600) %in% remaining)
    expect_true((end + 3600) %in% remaining)
    expect_false(start %in% remaining)
    expect_false((start + 3600) %in% remaining)
    expect_false(end %in% remaining)
    expect_equal(length(remaining), 2)

    # station still has measurements, so it is not removed from location
    expect_true("test-1" %in% tbls$location$station)
    expect_false(res[["test-1"]]$removed)

    drop_database_tables(dbconn)
})


test_that("remove_time_ranges_before removes station from location when empty", {
    create_database_tables(dbconn)

    start <- as.numeric(lubridate::as_datetime("2022-02-01 00:00:00"))
    end <- as.numeric(lubridate::as_datetime("2022-02-02 00:00:00"))
    dl <- as.numeric(lubridate::as_datetime("2022-03-01 00:00:00"))

    seed_location("test-1", dbconn)
    seed_cache("test-1", start, end, dl, dbconn)

    # all measurements fall within the removed range
    seed_measurement("test-1", start, dbconn)
    seed_measurement("test-1", start + 3600, dbconn)
    seed_measurement("test-1", end, dbconn)

    res <- remove_time_ranges_before(lubridate::as_datetime("2022-04-01"), conn = dbconn)

    tbls <- get_db_tables(dbconn)
    expect_equal(nrow(tbls$measurements), 0)
    expect_false("test-1" %in% tbls$location$station)
    expect_true(res[["test-1"]]$removed)

    # cache record is removed as well
    expect_equal(nrow(tbls$cache), 0)

    drop_database_tables(dbconn)
})


test_that("remove_time_ranges_before respects the cutoff date", {
    create_database_tables(dbconn)

    start <- as.numeric(lubridate::as_datetime("2022-02-01 00:00:00"))
    end <- as.numeric(lubridate::as_datetime("2022-02-02 00:00:00"))
    dl_new <- as.numeric(lubridate::as_datetime("2022-05-01 00:00:00"))

    seed_location("test-1", dbconn)
    seed_cache("test-1", start, end, dl_new, dbconn)
    seed_measurement("test-1", start + 3600, dbconn)

    # cutoff is before the download time, nothing should be removed
    res <- remove_time_ranges_before(lubridate::as_datetime("2022-04-01"), conn = dbconn)

    tbls <- get_db_tables(dbconn)
    expect_equal(length(res), 0)
    expect_equal(nrow(tbls$measurements), 1)
    expect_true("test-1" %in% tbls$location$station)
    expect_equal(nrow(tbls$cache), 1)

    drop_database_tables(dbconn)
})


test_that("remove_time_ranges_before returns a named list keyed by station", {
    create_database_tables(dbconn)

    start1 <- as.numeric(lubridate::as_datetime("2022-02-01 00:00:00"))
    end1 <- as.numeric(lubridate::as_datetime("2022-02-02 00:00:00"))
    start2 <- as.numeric(lubridate::as_datetime("2022-02-10 00:00:00"))
    end2 <- as.numeric(lubridate::as_datetime("2022-02-11 00:00:00"))
    dl <- as.numeric(lubridate::as_datetime("2022-03-01 00:00:00"))

    seed_location("test-1", dbconn)
    seed_location("test-2", dbconn)
    seed_cache("test-1", start1, end1, dl, dbconn)
    seed_cache("test-2", start2, end2, dl, dbconn)
    seed_measurement("test-1", start1 + 3600, dbconn)
    seed_measurement("test-2", start2 + 3600, dbconn)

    res <- remove_time_ranges_before(lubridate::as_datetime("2022-04-01"), conn = dbconn)

    expect_setequal(names(res), c("test-1", "test-2"))
    expect_true(all(c("start", "end", "removed") %in% names(res[["test-1"]])))
    expect_equal(as.numeric(res[["test-1"]]$start), start1)
    expect_equal(as.numeric(res[["test-1"]]$end), end1)
    expect_true(res[["test-1"]]$removed)

    drop_database_tables(dbconn)
})
