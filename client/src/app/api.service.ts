import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface CoinsResponse {
  id: string;
  name: string;
  symbol: string;
  slug: string;
  rank: number;
  rank_score: number;
  github_url: string;
  created_at: String; // ISO date time string
  updated_at: String; // ISO date time string
  coin_marketcap_id: number;
  coin_marketcap_source_code_url: string;
}

// API endpoint for CoinsResponse
// const COINS_API = 'https://cryptoranker.herokuapp.com/api/v1/coins';
const COINS_API = 'http://localhost:4567/api/v1/coins';

@Injectable({
  providedIn: 'root'
})
export class ApiService {

  constructor(private http: HttpClient) { }

  /**
   * Gets an array of CoinsResponse from the API backend in JSON format.
   * @param pageIndex the current page index
   * @param pageLimit number of items to return in the response
   * @returns 
   */
  getCryptos(pageIndex = 0, pageLimit = 10): Observable<CoinsResponse[]> {
    return this.http.get<CoinsResponse[]>(COINS_API, {
      params: {
        page: pageIndex,
        limit: pageLimit,
      }
    });
  }
}
