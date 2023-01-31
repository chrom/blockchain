// 0. Створити нову папку в робочому оточенні, встановити туди Truffle Suite (командою “npm install truffle -g” та “truffle init”).
// 1. Написати міграцію, в якій:
// будуть завантажуватись в блокчейн смарт-контракти Cow, Horse, Wolf і Farmer з ДЗ №9; 
// по черзі відбуватимуться 2 виклики методу Farmer.call(<address>), де <address> є спершу адреса контракта Cow, потім Horse. Після кожного виклику в консоль повинно виводитись результат виклику (“Moooo” або “Igogo”);
// далі відбувається 2 виклики методу Farmer.feed(<address>,<food>), де в обох випадках <address> є адреса контракту Wolf, а <food> в першому випадку є “plant”, а в другому – “meat”. В консоль має виводитись результати обох викликів (в першому випадку вовк “не з’їсть” “plant”, але в другому із задоволенням “з’їсть” “meet”).
// 2. Налаштувати оточення так, щоб міграція завантажила смарт-контракти в публічну тестову мережу Sepolia.
// Підтвердженням виконання завдання є скріншот, на якому видно код міграції і скріншот з консолі, де видно результат успішного проходження міграції з усіма виводами в консоль як це описано в пункті 1.

let Farmer = artifacts.require("Farmer");
let Cow = artifacts.require("Cow");
let Horse = artifacts.require("Horse");
let Wolf = artifacts.require("Wolf");
let Dog = artifacts.require("Dog");
let StringComparerLib = artifacts.require("StringComparer");
let nutritionPlant = 'plant';
let nutritionMeat = 'meat';

module.exports = async (deployer, network, accounts) => {
    deployer.deploy(StringComparerLib)
        .then(() => {
            return deployer.link(StringComparerLib, [Cow, Horse, Dog]);
        })
        .then(() => {
            return deployer.deploy(Farmer);
        })
        .then(async (farmer) => {
            let cow = await deployer.deploy(Cow, 'Cat');
            console.log('************ START COW **************');
            console.log(`Cow by name '${await cow.getName()}' say: ${await farmer.call(cow.address)}`);
            await feedAnimal(farmer, cow, nutritionPlant);
            console.log('************ FINISH COW **************');

            return farmer;
        })
        .then(async (farmer) => {
            let horse = await deployer.deploy(Horse, 'Supper fast Horse');
            console.log('************ START HORSE **************');
            console.log(`Horse by name '${await horse.getName()}' say: ${await farmer.call(horse.address)}`);
            await feedAnimal(farmer, horse, nutritionMeat);
            console.log('************ FINISH HORSE **************');

            return farmer;
        })
        .then(async (farmer) => {
            let dog = await deployer.deploy(Dog, 'The Last of the Mohicans');
            console.log('************ START DOG **************');
            console.log(`Dog by name '${await dog.getName()}' say: ${await farmer.call(dog.address)}`);
            await feedAnimal(farmer, dog, nutritionMeat);
            console.log('************ FINISH DOG **************');

            return farmer;
        })
    ;

}

async function feedAnimal(farmer, animal, nutrition) {
    try{
        await farmer.feed(animal.address, nutrition);
        console.log(`Feeding animal by name '${await animal.getName()}' will eat: ${nutrition}`);
    } catch (e) {
        console.log(`Feeding animal by name '${await animal.getName()}' won't eat eat: ${nutrition}`);
    }
}