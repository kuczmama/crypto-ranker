import { Component, OnInit } from '@angular/core';
import { MatIconRegistry } from '@angular/material/icon';
import { PageEvent } from '@angular/material/paginator';
import { DomSanitizer } from '@angular/platform-browser';
import { ApiService, CoinsResponse } from '../api.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  displayedColumns: string[] = ['rank', 'name', 'symbol', 'links'];
  dataSource = this.apiService.getCryptos();
  // TODO: Fetch the number of cryptos from the server when the API is ready.
  length = 8264;
  pageSize = 10;
  pageSizeOptions: number[] = [10, 25, 100];

  constructor(private apiService: ApiService,
    private matIconRegistry: MatIconRegistry,
    private domSanitizer: DomSanitizer,
  ) {
    this.matIconRegistry.addSvgIcon(
      "coinmarketcap",
      this.domSanitizer.bypassSecurityTrustResourceUrl("assets/coinmarketcap_logo.svg")
    );
    this.matIconRegistry.addSvgIcon(
      "github",
      this.domSanitizer.bypassSecurityTrustResourceUrl("assets/github_logo.svg")
    );
  }
  ngOnInit(): void { }

  loadCryptoData(event?: PageEvent) {
    this.dataSource = this.apiService.getCryptos(event?.pageIndex, event?.pageSize);
  }

  openCoinmarketcapPage(coin: CoinsResponse) {
    window.open(`https://coinmarketcap.com/currencies/${coin.slug}/`, '_blank');
  }

  openGithubPage(coin: CoinsResponse) {
    window.open(coin.github_url, '_blank');
  }
}
