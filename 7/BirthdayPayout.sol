// SPDX-License-Identifier: GPL-3.0


// Є смарт-контракт BirthdayPayout, який ми розбирали на уроці.

// Він дозволяє додавати в базу даних членів команди, їх імена, адреси, заробітну плату і день народження. 
// Також він дозволяє знайти члена команди, у якого зараз день народження (функція findBirthday) і зробити
// йому подарунок на день народження (функція birthdayPayout). Зараз у даного смарт-контракту є 1
// проблема: смарт-контракт ніяк не контролює, щоб одному працівнику в один день не було вислано 2 подарунки.

// Завдання: потрібно покращити код смарт-контракту так, щоб в межах виклику 1 функції смарт-контракт:

// пропрацьовував всю базу працівників;
// находив усіх іменинників і кожному з них робив виплату;
// також смарт-контракт повинен контролювати, щоб при повторному виклику цієї функції не отримували подарунки ті працівники, які їх вже отримали.
// Підтвердженням виконання завдання є код покращеного смарт-контракту, який треба відправити на віддалений репозиторій.
// Дайте доступ лектору на перегляд (нік на GitHub ashlionTimeless) та додайте посилання на репозиторій у поле відповіді в особистому кабінеті.

pragma solidity ^0.8.17;

import "https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/master/contracts/BokkyPooBahsDateTimeLibrary.sol";

contract BirthdayPayout {

    address _owner;

    Teammate[] public _teammates;

    uint256 constant PRESENT = 1;

    mapping(address => uint) public sent;

    struct Teammate {
        string name;
        address account;
        uint256 birthday;
    }

    constructor() {
        _owner = msg.sender;
    }

    function addTeammate(address account, string memory name, uint256 birthday) public onlyOwner {
        require(_owner != account, "Cannot add one self");
        Teammate memory newTeammate = Teammate(name, account, birthday);
        _teammates.push(newTeammate);
        emit NewTeammate(account, name);
    }

    function sendPresents() public onlyOwner {
        uint256 today_year = BokkyPooBahsDateTimeLibrary.getYear(block.timestamp);
        require(getTeammatesNumber() > 0, "No teammates in the database");
        for (uint256 i = 0; i < getTeammatesNumber(); i++) {
            if (checkBirthday(i) && sent[getTeammate(i).account] != today_year) {
                sendToTeammate(i);
                sent[getTeammate(i).account] = today_year;
                emit HappyBirthday(_teammates[i].name, _teammates[i].account);
            }
        }
    }

    function checkBirthday(uint256 index) view public returns (bool){
        uint256 today = block.timestamp;
        (uint256 birthday_year, uint256 birthday_month,uint256 birthday_day) = getDate(getTeammate(index).birthday);

        (uint256 today_year, uint256 today_month, uint256 today_day) = getDate(today);

        if (birthday_day == today_day && birthday_month == today_month && birthday_year != today_year) {
            return true;
        }
        return false;
    }


    function getDate(uint256 timestamp) pure public returns (uint256 year, uint256 month, uint256 day){
        (year, month, day) = BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
    }

    function getTeammate(uint256 index) view public returns (Teammate memory){
        return _teammates[index];
    }

    function getTeam() view public returns (Teammate[] memory){
        return _teammates;
    }

    function getTeammatesNumber() view public returns (uint256){
        return _teammates.length;
    }

    function sendToTeammate(uint256 index) public onlyOwner {
        // Check whether current balance if enough for sending a present
        require(address(this).balance >= PRESENT, "Contract balance is low");
        payable(_teammates[index].account).transfer(PRESENT);
    }

    function deposit() public payable {

    }

    modifier onlyOwner{
        require(msg.sender == _owner, "Sender should be the owner of contract");
        _;
    }

    event NewTeammate(address account, string name);

    event HappyBirthday(string name, address account);
}