# Crytpto Github Ranker

Website: [https://kuczmama.github.io/crypto-ranker/#/home](https://kuczmama.github.io/crypto-ranker/#/home)

This project will attempt to rate github projects by an unbiased set of criteria.  The criteria include:

- Number of commits - more is better
- Number of contributors - more is better
- Recency of last commit - more recent is better
- Frequency of commits - More frequent is better, but the most recent commits are ranked higher than the older commits.
- Number of issues - More is better, because that means there is active development
- Number of github stars
- Number of forks
- NUmber of github watcher - more is better
- Ratio of open issues to closed issues - The ratio should be smaller
- Language used, bonus points for esoteric languages, minus points for smart contract languages like solidity.

## How the score is calculated

Each criteria is ranked in terms of a percentile, where the top 20% is ranked a 5, 80th percentile is 4, and bottom 20% is ranked a 1.  Each is rated by its recency.

## MVP Requirements

- [x] Load a github url through the API
- [x] Load all of the criteria and put the raw data into a data store
- [x] Rank the data based on above criteria
- [x] Update the data at least once per day
- [x] Display the data on a frontend# crypto-ranker

## Nice to have features

- [x] Update the database so it's on the paid plan of heroku
- [x] Make it so there is only 1 github url per project
- [ ] Store runner service in database
- [ ] Calculate rank and rank score over time
- [ ] Graph rank score over time
- [ ] Rank commits based off of frequency
 
## Architecture

This diagram shows what the MVP's architecture will look like once it is all completed

![Server Architecture](diagrams/proposed-architecture.png)

### Components

- **Third Party data loading service** - Service to load raw data from third party websites
- **Data Source DB** - Database to have metadata about *where* to load the third party data from, and logs around loading
- **Data Processing Service** - Process the loaded data from all of the third party data sources, this will rank each project, and bundle the meaningful information together and store the data in the database.
- **Ranking Data DB** - This has all of the ranked crypto data, as well as the raw data that can be used to rank more projects
- **Web API** - A web API will allow users to query data from the database, and run custom queries
- **Data Bundling Service** - This will query the ranking data DB, and it will bundle it into meaningful data to the user, and store that data in a CDN for quick retrieval
- **Web Client** - The frontend of the website, this will be what the user sees, it will contain all of the ranking information

## API

The API is hosted at [https://cryptoranker.herokuapp.com/](https://cryptoranker.herokuapp.com/)

To access the coins you can use the endpoint [https://cryptoranker.herokuapp.com/api/v1/coins](https://cryptoranker.herokuapp.com/api/v1/coins)

The API allows for certain params

*limit* - integer - max 100

*sort* - filter by a column name eg: rank.  To order prefix '+' or '-' to the sort param
    +  sort ascending
    - sort descending

*page* - integer - starts at 0

### Example

GET /api/v1/coins?sort=+rank&limit=10&page=2

This query returns all coins, sorted by rank ascending, limit 10, on the second page of coins.
Meaning that of the 1000's of coins ranked this returns coins of rank 20-29, because we are on the 3rd page
since pages are 0 index.

### Return all coins and their rankings

GET /api/v1/coins

```txt
GET /api/v1/coins

[{
    [{
        "id":"35ed5260-60cb-4461-bf24-18b80760009a",
        "coin_marketcap_id":6636,
        "name":"Polkadot",
        "symbol":"DOT",
        "slug":"polkadot-new",
        "rank":0,
        "coin_marketcap_source_code_url":"https://github.com/paritytech/polkadot",
        "github_url":"https://github.com/paritytech/polkadot",
        "created_at":"2022-01-22T21:18:24.980Z",
        "updated_at":"2022-01-23T03:02:24.862Z",
        "rank_score":30
    },
    {}...
}]
```

### Return an individual coin

GET /api/v1/coins/:id

Return a singular coin

```txt
GET /api/v1/coins/35ed5260-60cb-4461-bf24-18b80760009a

{
        "id":"35ed5260-60cb-4461-bf24-18b80760009a",
        "coin_marketcap_id":6636,
        "name":"Polkadot",
        "symbol":"DOT",
        "slug":"polkadot-new",
        "rank":0,
        "coin_marketcap_source_code_url":"https://github.com/paritytech/polkadot",
        "github_url":"https://github.com/paritytech/polkadot",
        "created_at":"2022-01-22T21:18:24.980Z",
        "updated_at":"2022-01-23T03:02:24.862Z",
        "rank_score":30
    }
```

### Return github metadata for a given coin

GET /api/v1/coins/:id/github-metadata

Return the github metadata for a given coin

```txt
GET /api/v1/coins/35ed5260-60cb-4461-bf24-18b80760009a/github-metadata

{"id":"d2f40ccb-d131-40b9-be96-9a9813115b4f","language":"C++","watchers_count":61343,"open_issues_count":1000,"commit_count":32319,"contributors_count":362,"stars_count":61343,"forks_count":31338,"size":194761,"days_since_last_commit":2,"source_code_url":"https://github.com/bitcoin/bitcoin","owner":"bitcoin","repo":"bitcoin","created_at":"2022-01-23T01:20:29.798Z","updated_at":"2022-01-23T01:20:29.798Z","coin_id":"0c919e1d-987f-4f6e-b4b9-fad3cb48e39b"}
```


## Install

```txt
git clone https://github.com/kuczmama/crypto-ranker
cd crypto-ranker

bundle install
ruby app/server.rb

rake db:create
rake db:migrate
rake db:seed
```
