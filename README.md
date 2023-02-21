# Assessing approaches for estimating individual scale-perception differences in reported party placements

Recover ```n_mp``` shift and stretch parameters (```a```, ```b```) from simulated responses (i.e., left-right placements of own party and one or more other parties on an 11pt left-right scale) using shrinkage vs. no shrinkage estimators. 

The motivating use case for this exercise is the first simulation scenario below, where only two responses per individual (MP) are observed. The remaining scenarios are included for comparison:

* [data_design.csv](data_design.csv): each MP rates own party and PM party (if own party is PM party: 2nd largest party)
* [data_complete.csv](data_complete.csv): each MP rates all parties
* [data_random.csv](data_random.csv): each MP rates ```n_obs``` randomly selected parties

Estimators used for recovering individual response parameters:

1. No shrinkage (no pooling): ```n_mp``` independent OLS regressions 
2. Shrinkage (partial pooling): REML hierarchical linear random effects regression

Assessment:

1. [model-comparison.pdf](model-comparison.pdf)
   * solid line: true regression line
   * dotted line: no shrinkage
   * dashed line: shrinkage
   * red dot: PM party
   * black dot: own party
2. ```mae``` mean absolute errors of estimated shift and stretch parameters
