import { Component, OnInit } from '@angular/core';
import { ApiService } from '../api.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  displayedColumns: string[] = ['id', 'name', 'symbol', 'price'];
  dataSource = this.apiService.getCryptos();

  constructor( private apiService: ApiService) { }

  ngOnInit(): void { }

}
