// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;


interface Living{
    function eat(string memory food) external returns(string memory);
}

contract HasName{
    string internal _name;
    constructor(string memory name){
        _name=name;
    }

    function getName() view public returns(string memory){
        return _name;
    }
}

abstract contract Animal is Living{
    
    function eat(string memory food) pure public NutrionCheck(food) returns(string memory){
        return string.concat(string.concat("Animal eats ",food));
    }

    function sleep() pure public returns(string memory){
        return "Z-z-z...";
    }

    function speak() pure virtual public returns(string memory){
        return "...";
    }
    modifier NutrionCheck(string memory food) virtual {
        _;
    }
}

library StringComparer{
    function compare(string memory str1, string memory str2) public pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }
}

abstract contract Herbivore is Animal, HasName{
    string constant PLANT = "plant";

    modifier NutrionCheck (string memory food) override {
        require(StringComparer.compare(food,PLANT),"Can only eat plant food");
        _;
    }
}

abstract contract Carnivorous is Animal, HasName{
    string constant NUTRITION = "meat";

    modifier NutrionCheck(string memory food) override {
        require(StringComparer.compare(food,NUTRITION),"Can only eat meat food");
        _;
    }
}


abstract contract Omnivorous is Animal, HasName{
    string constant NUTRITION_MEAT = "meat";
    string constant NUTRITION_PLANT = "plant";

    modifier NutrionCheck(string memory food) override {
        require(StringComparer.compare(food,NUTRITION_MEAT) || StringComparer.compare(food,NUTRITION_PLANT), "Can only eat plant ot meat food");
        _;
    }


}

contract Dog is Omnivorous{

    constructor(string memory name) HasName(name){
    }

    function speak() pure override public returns(string memory){
        return "Woof    ";
    }
}

contract Wolf is Carnivorous{

    constructor(string memory name) HasName(name){
    }

    function speak() pure override public returns(string memory){
        return "Awoo    ";
    }
}

contract Cow is Herbivore{

    constructor(string memory name) HasName(name){
    }

    function speak() pure override public returns(string memory){
        return "Mooo";
    }
}

contract Horse is Herbivore{

    constructor(string memory name) HasName(name){
    }

    function speak() pure override public returns(string memory){
        return "Igogo";
    }

}



contract Farmer{
    function feed(address animal, string memory food) pure public returns(string memory){
        return Animal(animal).eat(food);
    }

    function call(address animal) pure public returns(string memory){
        return Animal(animal).speak();
    }
}
