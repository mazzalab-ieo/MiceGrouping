# MiceGrouping

We implemented a R function to reduce the possible bias obtained by grouping mice by cage at the initial time point of an experiment.
The idea is to create groups of mice that are homogeneous on some specific variables of interest and that can be used as starting point for the experiment at hand
The function is based on the anti-clustering method, which reduces the differences between groups while increasing those whithin groups.

## Input
The input of the functions are:
- the dataset with the measurements
- the name of the columns in the dataset containing the variables of interest (e.g. tumor size, weigth)
- the number of elelemts expected for each group
- the name of the column in the dataset containing the mice ID (optional)

## Output
As output, the function provides:
- the initial dataset with an additional column called "Opt_groups", which contains the labels for the homogeneous groups
- a plot with the distribution of the variable of interest over the complete dataset
- plots with the distribution of the variables of interest in the optimized groups (optional: the addition of the mice ID in each group)
- plot of the sample distribution in the space of the variable of interest, colored by the optimixed groups.
