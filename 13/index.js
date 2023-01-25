// npm install web3

let web3 = require('web3');
let abi = require('./compiled/abi.js');
let contractAddress = '0x79B5EDE5ae894ea14643D3a767323Cb3Ef092C32';
let Web3 = new web3(new web3.providers.HttpProvider('http://127.0.0.1:7545'));


let contract = new Web3.eth.Contract(abi, contractAddress);
let index = 9;
contract.methods.getContactNameByindex(index).call().then((result) => {
    console.log(result);
});


// contract.methods.addContact('Jekson', '0x23839DF7EF445949C072FBD4D471Ae2056269c54').send(
//     {from: '0xA9Dc90750C7d81625945e2FD1a7D4222c7a05B25', gas: 999999}
// ).then((result) => {
//     console.log(result);
//     contract.methods.getContactNameByindex(8).call().then((result) => {
//         console.log(result);
//     });
// });

