# Assessing approaches for estimating individual differences in reported party placements

Use shrinkage vs. no shrinkage estimators to recover ```n_mp``` shift and stretch parameters (i.e., differential item functioning) per country from simulated responses of left-right placements of two or more parties on an 11-pt left-right item. 

The motivating use case for this exercise is the first simulation scenario, where only two responses per individual are observed; the remaining scenarios are included for comparison:

* [data_design.csv](data_design.csv): each MP rates own party and PM party (if own party is PM party: 2nd largest party)
* [data_complete.csv](data_complete.csv): each MP rates all parties
* [data_random.csv](data_random.csv): each MP rates ```n_obs``` randomly selected parties

## Estimators and quality assessment

Estimators used for recovering individual response parameters:

1. No shrinkage (no pooling): independent OLS regressions for each individual
2. Shrinkage (partial pooling): REML two-stage hierarchical linear random effects regression

Assessment:

1. [model-comparison.pdf](model-comparison.pdf)
   * solid line: true regression line
   * dotted line: no shrinkage
   * dashed line: shrinkage
   * red dot: PM party
   * black dot: own party
2. ```mae``` mean absolute errors of estimated shift and stretch parameters


## Theoretical background

The generative model for the simulation is a multilevel version of the standard Aldrich-McKelvey measurement model for how respondents place parties (and themselves) on likert-type policy items, which, applied to a single country can be stated as

$$
y_{ij} = \alpha_i + \beta_i y_{j}^\ast + \epsilon_{ij}
$$

where $y_{ij}$ is the observed placement on a left-right item of party $j$ by individual $i$, $y_{j}^\ast$ is the true position of party $j$ on a globally shared left-right scale, $\alpha_i$ and $\beta_i$ are individual-specific (shift and stretch) parameters capturing systematic differences in how respondents translate parties' true positions into the survey item (i.e. differential item functioning), and $\epsilon_{ij}$ is a mean-zero iid-normal error made by individual $i$ in the placement of party $j$.

The simulation assumes that differential item functioning (i.e. differences in item perception) varies in a Gaussian manner across individuals with individuals from the same country exhibiting commonalities in scale perception due to shared context (e.g. number of parties). This is captured by a nested two-stage multilevel setup in which individual shift and stretch parameters are drawn from (independent) normal distributions whose country-specific means are drawn from a standard normal distribution.
