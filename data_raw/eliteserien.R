library("magrittr")
eliteserien = readr::read_csv(file = "data_raw/eliteserien.csv")
eliteserien = dplyr::mutate(eliteserien,
                            Hjemmelag = factor(Hjemmelag),
                            Bortelag = factor(Bortelag))

eliteserien$Dato = lubridate::dmy(eliteserien$Dato)

eliteserien$Dato = lubridate::ymd_hms(paste(eliteserien$Dato, eliteserien$Tid),
                                      tz = "Europe/Oslo")
eliteserien$Tid = NULL

eliteserien %>%
  dplyr::select(Season = Sesong, Round = Runde, HomeTeam = Hjemmelag,
                AwayTeam = Bortelag, HomeScore = Hjemme, AwayScore = Borte,
                Stadium = Bane, Time = Dato, GameNumber = Kampnr) ->
  eliteserien


save(eliteserien, file = "data/eliteserien.rda")
