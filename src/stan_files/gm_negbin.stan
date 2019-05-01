data {
  int<lower = 0> N_MATCHES; // Number of matches.
  int<lower = 0> N_TEAMS;   // Number of teams.
  int y[N_MATCHES, 4];      // Data.
}

parameters {
  real<lower = 0> attack[N_TEAMS];
  real<lower = 0> defense[N_TEAMS];
  real<lower = 0> dispersion;
  real baseline;
  real<lower = 0> homefield;
}

model {

  // Prior.

  baseline ~ normal(0, 1);
  homefield ~ normal(0, 1) T[0, ];
  dispersion ~ exponential(1);

  for(i in 1:N_TEAMS) {
    attack[i] ~ normal(0, 1) T[0, ];
    defense[i] ~ normal(0, 1) T[0, ];
  }

  // Likelihood.
  for(i in 1:N_MATCHES) {
    int home_index = y[i, 3];
    int away_index = y[i, 4];
    real home_attack  = attack[home_index];
    real home_defense = defense[home_index];
    real away_attack  = attack[away_index];
    real away_defense = defense[away_index];
    y[i, 1] ~ neg_binomial_2_log(baseline + homefield + home_attack - away_defense, dispersion);
    y[i, 2] ~ neg_binomial_2_log(baseline + away_attack - home_defense, dispersion);
  }

}

