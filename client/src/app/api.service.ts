import { Injectable } from '@angular/core';

export interface FakeCryptoData {
  id: number;
  name: string;
  symbol: string;
  price: number;
}

// Pulled on 12/6/2021 7:45PM PST
const FAKE_CRYPTO_DATA: FakeCryptoData[] = [
  { id: 1, name: "Bitcoin", symbol: "BTC", price: 50922.12825285672 },
  { id: 2, name: "Ethereum", symbol: "ETH", price: 4343.204885944389 },
  { id: 3, name: "Binance Coin", symbol: "BNB", price: 589.6079034084775 },
  { id: 4, name: "Tether", symbol: "USDT", price: 1.001872116117889 },
  { id: 5, name: "Solana", symbol: "SOL", price: 194.21035919038115 },
  { id: 6, name: "Cardano", symbol: "ADA", price: 1.4461079506265393 },
  { id: 7, name: "USD Coin", symbol: "USDC", price: 0.9997756361655622 },
  { id: 8, name: "XRP", symbol: "XRP", price: 0.8316979790005009 },
  { id: 9, name: "Polkadot", symbol: "DOT", price: 28.247267662372202 },
  { id: 10, name: "Terra", symbol: "LUNA", price: 66.32783360994293 },
  { id: 11, name: "Dogecoin", symbol: "DOGE", price: 0.17925788348978636 },
  { id: 12, name: "Avalanche", symbol: "AVAX", price: 94.52538744380836 },
  { id: 13, name: "SHIBA INU", symbol: "SHIB", price: 0.00003753743204478378 },
  { id: 14, name: "Polygon", symbol: "MATIC", price: 2.2699943524001847 },
  { id: 15, name: "Crypto.com Coin", symbol: "CRO", price: 0.6198280230864348 },
  { id: 16, name: "Binance USD", symbol: "BUSD", price: 1.0006168560898183 },
  { id: 17, name: "Wrapped Bitcoin", symbol: "WBTC", price: 50547.955092434146 },
  { id: 18, name: "Algorand", symbol: "ALGO", price: 1.7756029030085856 },
  { id: 19, name: "Litecoin", symbol: "LTC", price: 160.34769611089317 },
  { id: 20, name: "Uniswap", symbol: "UNI", price: 17.21406868603087 },
  { id: 21, name: "Chainlink", symbol: "LINK", price: 20.061986804283606 },
  { id: 22, name: "TRON", symbol: "TRX", price: 0.087750099597283 },
  { id: 23, name: "Bitcoin Cash", symbol: "BCH", price: 469.93929799600284 },
  { id: 24, name: "TerraUSD", symbol: "UST", price: 1.0020483722404359 },
  { id: 25, name: "Stellar", symbol: "XLM", price: 0.2961099612166672 },
  { id: 26, name: "Decentraland", symbol: "MANA", price: 3.72627542647037 },
  { id: 27, name: "Dai", symbol: "DAI", price: 1.0032455416517645 },
  { id: 28, name: "Axie Infinity", symbol: "AXS", price: 106.51965716930846 },
  { id: 29, name: "FTX Token", symbol: "FTT", price: 43.83693448029559 },
  { id: 30, name: "VeChain", symbol: "VET", price: 0.09330248594061598 },
  { id: 31, name: "Elrond", symbol: "EGLD", price: 296.7704939727033 },
  { id: 32, name: "Cosmos", symbol: "ATOM", price: 24.43033143481747 },
  { id: 33, name: "Internet Computer", symbol: "ICP", price: 29.83793047189294 },
  { id: 34, name: "Bitcoin BEP2", symbol: "BTCB", price: 51065.65254442523 },
  { id: 35, name: "Filecoin", symbol: "FIL", price: 38.94503480416375 },
  { id: 36, name: "Ethereum Classic", symbol: "ETC", price: 39.224529591170466 },
  { id: 37, name: "Hedera", symbol: "HBAR", price: 0.28444020533971753 },
  { id: 38, name: "The Sandbox", symbol: "SAND", price: 5.3606203818489755 },
  { id: 39, name: "THETA", symbol: "THETA", price: 4.790544985923062 },
  { id: 40, name: "NEAR Protocol", symbol: "NEAR", price: 7.286008680951479 },
  { id: 41, name: "Fantom", symbol: "FTM", price: 1.6176235711097418 },
  { id: 42, name: "Monero", symbol: "XMR", price: 201.873949060084 },
  { id: 43, name: "Tezos", symbol: "XTZ", price: 4.173572018255018 },
  { id: 44, name: "UNUS SED LEO", symbol: "LEO", price: 3.683978760245253 },
  { id: 45, name: "Gala", symbol: "GALA", price: 0.4856035300199239 },
  { id: 46, name: "Klaytn", symbol: "KLAY", price: 1.3174530403648044 },
  { id: 47, name: "Loopring", symbol: "LRC", price: 2.519121092834762 },
  { id: 48, name: "The Graph", symbol: "GRT", price: 0.7089945983382778 },
  { id: 49, name: "IOTA", symbol: "MIOTA", price: 1.172171332865779 },
  { id: 50, name: "Helium", symbol: "HNT", price: 31.449539168619893 }
];

@Injectable({
  providedIn: 'root'
})
export class ApiService {

  constructor() { }

  getCryptos(): FakeCryptoData[] {
    return FAKE_CRYPTO_DATA;
  }
}
