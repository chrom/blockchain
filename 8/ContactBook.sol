// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

import "./Contact.sol";

contract ContactBook {
    
    string private _name;
    address private _address;
    address[] _contacts;
    mapping(address => Contact) public bookMap;

    constructor(string memory ownerName) {
        _name = ownerName;
        _address = msg.sender;
    }

    function addContact(string memory personName) public onlyOwner() {
        Contact newContact = new Contact(personName);
        address personAddress = address(newContact);
        _contacts.push(personAddress);
        bookMap[personAddress] = newContact;
        emit NewContact(personName, personAddress, newContact);
    }

    function getContactAddressByIndex(uint256 index) public view returns (address) {
        return _contacts[index];
    }

    function getContactByAddress(address personAddress) public view returns (Contact) {
        return bookMap[personAddress];
    }

    function callContact(uint256 index) public view returns (string memory){
        return getContactByIndex(index).reply();
    }

    function getContactByIndex(uint256 index) public view returns (Contact){
        return getContactByAddress(getContactAddressByIndex(index));
    }

    modifier onlyOwner {
        require(msg.sender == _address, "Add contact can only owner");
        _;
    }

    event NewContact(string personName, address personAddress, Contact newContact);
}