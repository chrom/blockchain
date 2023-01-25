// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

// Практика:
// Створити смарт-контракт, який дозволяє наступний функціонал:
// 1. записувати ім'я та адресу його власника;
// 2. дозволяти записувати адреси та імена (контакти) інших користувачів, а також їх порядкові номери;
// 3. дозволяти знаходити раніше додані контакти за їх порядковим номером або адресою;
// 3. контролювати, щоб ніхто крім власника не міг додавати нові контакти;
// 4. випускати подію "NewContact" кожен раз, коли додається новий контакт.

contract ContactBook {
    
    string private _name;
    address private _address;
    address[] _bookArray;
    mapping(address => string) public bookMap; 

    constructor(string memory ownerName) {
        _name = ownerName;
        _address = msg.sender;
    }

    function addContact(string memory personName, address personAddress) public onlyOner returns (uint) {
        require(msg.sender != personAddress, "Owner can't add him self.");
        _bookArray.push(personAddress);
        bookMap[personAddress] = personName;
        emit NewContact(personName, personAddress);
        return _bookArray.length-1;
    }
    
    function getContactAddressByIndex(uint256 index) public view returns (address) {
        return _bookArray[index];
    }

    function getContactNameByAddress(address personAddress) public view returns (string memory) {
        return bookMap[personAddress];
    }

    
    function getContactNameByindex(uint256 index) public view returns (string memory){
        return getContactNameByAddress(getContactAddressByIndex(index));
    }

    modifier onlyOner {
        require(msg.sender == _address, "Add contact can only owner");
        _;
    }

    event NewContact(string personName, address personAddress);
}