# Crytpto Github Ranker

This project will attempt to rate github projects by an unbiased set of criteria.  The criteria include:

- Number of commits - more is better
- Number of contributors - more is better
- Recency of last commit - more recent is better
- Number of issues - More is better, because that means there is active development
- Ratio of open issues to closed issues - The ratio should be smaller
- Language used, bonus points for esoteric languages, minus points for smart contract languages like solidity.

## How the score is calculated

Each criteria is ranked in terms of a percentile, where the top 20% is ranked a 5, 80th percentile is 4, and bottom 20% is ranked a 1.  Each is rated by its recency.

## MVP Requirements

- [ ] Load a github url through the API
- [ ] Load all of the criteria and put the raw data into a data store
- [ ] Rank the data based on above criteria
- [ ] Display the data on a frontend# crypto-ranker
