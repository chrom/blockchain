// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;
// У Contact є:

// змінна _name (string);
// конструктор, що приймає параметр name і присвоює її до змінної _name;
// функція getName(), що повертає значення _name;
// функція reply(), що повертає рядок "<name> on call!", де замість <name> вставляється значення в змінній _name. 
// Для того, щоб вивести в одному рядку <name> та решту тексту, потрібно об'єднати 2 рядки: перший рядок,
// що міститься в змінній _name i другий рядок, що містить текст " on call!". Це можна зробити наступною командою: "string.concat(getName(), "
//  on call!"); ". Далі результат виконання цієї команди слід вивести командою return, наприклад: "  return string.concat(getName(), " on call!"); ".

contract Contact {

    string private _name;
    
    constructor(string memory name) {
    _name = name;
    }

    function getName() view public returns(string memory){
        return _name;
    }

        function reply() view public returns(string memory){
        return string.concat(getName(), " on call!");
    }
}