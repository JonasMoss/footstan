#' Fitting Goal Models with STAN
#'
#' \code{gm} is is used to fit goal models, specified by giving the desired
#'     family, time dependence, and a suitably formatted data frame.
#'
#' @export
#' @param data A list or data frame containing the data. Should contain the
#'    columns \code{HomeTeam}, \code{AwayTeam} giving the names of the teams
#'    that play each game, together with their scores \code{HomeScore} and
#'    \code{AwayScore}. If time dependence is used, the list must contain
#'    \code{Time}, the time when each game was played.
#' @param family The goal model distribution. Defaults to "poisson", which is
#'    the only distribution supported right now. Will probably implement
#'    Negative Binomial in the future.
#' @param time Time dependence. Choose "none" for no time dependence or "dv" for
#'    for decreasing variance time dependence with an inverse logit link.
#' @param homefield The kind of homefield advantage. Can be the same for all
#'    teams or team specific.
#' @param date Optional argument telling the date of the match you wish to
#'    predict. Only used when \code{time = "dv"}.
#' @param ... Passed to \code{rstan::sampling}.
#' @return A \code{stanfit} object.
#' @examples
#' \dontrun{
#' # Ordinary Poisson goal model with Eliteserien after 2016.
#' gm(data = dplyr::filter(eliteserien, Season > 2016),
#'    family = "poisson")
#'
#' # Decreasing variance Poisson goal model with Eliteserien after 2016.
#' gm(data = dplyr::filter(eliteserien, Season > 2016),
#'    family = "poisson",
#'    time = "dv",
#'    chains = 1)
#' }

gm = function(data, family = "poisson", time = c("none", "dv"),
              homefield = c("intercept", "team"), date = lubridate::now(), ...) {

  time = match.arg(time, c("none", "dv"))
  homefield = match.arg(homefield, c("intercept", "team"))

  teams = sort(unique(data$HomeTeam))
  y = dplyr::mutate(data,
                    HomeTeam = as.integer(as.numeric(droplevels(HomeTeam))),
                    AwayTeam = as.integer(as.numeric(droplevels(AwayTeam))))
  y = dplyr::select(y, HomeScore, AwayScore, HomeTeam, AwayTeam)

  N_MATCHES = nrow(data)
  N_TEAMS = length(teams)

  stan_data = list(N_TEAMS = N_TEAMS,
                   N_MATCHES = N_MATCHES,
                   y = y)

  model = stanmodels$gm_poisson

  if(homefield == "team") model = stanmodels$gm_poisson_homefield_team

  if(time == "dv") {
    stan_data$difftimes = -as.numeric(difftime(data$Time, date),
                                      units = "weeks")/52.25
    if(family == "poisson") model = stanmodels$gm_poisson_dv
  }

  rstan::sampling(model, data = stan_data, ...)

}
