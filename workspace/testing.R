testthat::use


test1 = gm(data = dplyr::filter(eliteserien, Season == 2016),
          family = "poisson",
          chains = 1)

sort(unique(dplyr::filter(eliteserien, Season == 2016)$AwayTeam))

# Decreasing variance Poisson goal model with Eliteserien after 2016.
gm(data = dplyr::filter(eliteserien, Season > 2016),
   family = "poisson",
   time = "dv",
   chains = 1)

test0 = poiss(dplyr::filter(eliteserien, Season > 2016))
test = poiss_date(dplyr::filter(eliteserien, Season > 2016),
                  chains = 1)

hist(rstan::extract(test)$alpha)
hist(rstan::extract(test)$beta)
hist(rstan::extract(test)$gamma)



# Ordinary Poisson goal model with Eliteserien season 2016.

test3 = gm(data = dplyr::filter(eliteserien, Season == 2016),
           family = "poisson",
           homefield = "team",
           chains = 1)

par(xaxt = "n")
z = apply(rstan::extract(test3)$homefields, 2, function(x) quantile(x, c(0.05, 0.5, 0.95)))
ord = order(z[2, ])
plot(z[1, ][ord], ylim = c(-0.5, 1.5), lwd = 2, type = "l", xlab = NA, ylab =
       "Hjemmefordel", main = "Hjemmefordel i Eliteserien 2016", bty = "l")
lines(z[2, ][ord], type = "l", lwd = 2)
lines(z[3, ][ord], type = "l", lwd = 2)
abline(h = 0, lty = 3)

labs = sort(unique(dplyr::filter(eliteserien, Season == 2016)$AwayTeam))[ord]
axis(1, at = 1:length(labs), labels = FALSE)
text(x = 1:length(labs), par("usr")[3] - 0.1, labels = labs, srt = 45, pos = 1, xpd = TRUE)

for(i in 1:length(labs)) abline(v = i, lty = 3, col = "grey")
