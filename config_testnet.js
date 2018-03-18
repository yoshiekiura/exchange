/* eslint-env browser */

module.exports = {
  homeURL: 'https://exchange.cryptex.cc',
  contractEtherDelta: 'smart_contract/etherdelta.sol',
  contractToken: 'smart_contract/token.sol',
  contractReserveToken: 'smart_contract/reservetoken.sol',
  contractEtherDeltaAddrs: [
    { addr: '0xbbd12947a484615f53f9d85dfd9bb2468a809212', info: 'Variable Finney' },
  ],
  ethTestnet: 'ropsten',
  ethProvider: 'http://localhost:8545',
  ethGasPrice: 20000000000,
  ethAddr: '0x0000000000000000000000000000000000000000',
  ethAddrPrivateKey: '',
  gasApprove: 250000,
  gasDeposit: 250000,
  gasWithdraw: 250000,
  gasTrade: 250000,
  gasOrder: 250000,
  ordersOnchain: false,
  apiServer: 'https://api.cryptex.cc',
  userCookie: 'EtherDelta',
  eventsCacheCookie: 'Cryptex_eventsCache',
  deadOrdersCacheCookie: 'Cryptex_deadOrdersCache',
  ordersCacheCookie: 'Cryptex_ordersCache',
  etherscanAPIKey: 'GCGR1C9I17TYIRNYUDDEIJH1K5BRPH4UDE',
  tokens: [
    { addr: '0x0000000000000000000000000000000000000000', name: 'ETH', decimals: 18 },
    { addr: '0x40aade55175aaeed9c88612c3ed2ff91d8943964', name: '1ST', decimals: 18 },
    { addr: '0x36f5f9157d894fb1ae58deb04b237c7507502ffd', name: 'CSH', decimals: 0 },
    { addr: '0x9d4f4ba6850878acd7ae2ed6255c1a86e8fe6914', name: 'KUM', decimals: 0 },
  ],
  defaultPair: { token: 'CSH', base: 'ETH' },
  pairs: [
    { token: '1ST', base: 'ETH' },
    { token: 'CSH', base: 'ETH' },
  ],
};
