import { Component, OnInit } from '@angular/core';
import { PageEvent } from '@angular/material/paginator';
import { ApiService } from '../api.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  displayedColumns: string[] = ['rank', 'name', 'symbol'];
  dataSource = this.apiService.getCryptos();
  // TODO: Fetch the number of cryptos from the server when the API is ready.
  length = 8264;
  pageSize = 10;
  pageSizeOptions: number[] = [10, 25, 100];

  constructor( private apiService: ApiService) { }

  ngOnInit(): void { }

  loadCryptoData(event?: PageEvent) {
    this.dataSource = this.apiService.getCryptos(event?.pageIndex, event?.pageSize);
  }
}
