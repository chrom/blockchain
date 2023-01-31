let Farmer = artifacts.require("Farmer");
let Cow = artifacts.require("Cow");
let Horse = artifacts.require("Horse");
let Dog = artifacts.require("Dog");
// ************************************
// За допомогою нашого Truffle пишемо і запускаємо тести для зв’язки контрактів Horse, Dog i Farmer.
//     Потрібно написати тести для перевірки наступних припущень:
//     Horse and Farmer
// Horse has the correct name.
//     Horse can sleep.
//     Horse can eat “plant”.
// Horse cannot eat ”meat”, ”not-food”, ”plastic”.
// ve, Horse responds correctly (”Igogo” або інші відповідні звуки які видає ваш контракт Horse).
// Farmer can feed Horse with plant (if you have any other plant-based food - it is okay).
// Farmer cannot feed Horse with anything else(”meat”,”plastic”,”fingers”,etc).
// ************************************
// Dog and Farmer
// Dog has the correct name.
//     Dog can sleep.
//     Dog can eat “plant”.
//     Dog can eat ”meat”.
//     Dog cannot eat ”not-food”, ”plastic”, ”chocolate”.
// Farmer can call Dog, Dog responds correctly.(”Woof” або інші відповідні звуки які видає ваш контракт Dog)
// ************************************


contract("Horse and Farmer", async (accounts) => {

    it("Horse and Farmer:: Horse has the correct name.", async () => {
        let horse = await Horse.deployed();
        assert.equal(await horse.getName(), 'Supper fast Horse', "This is not that horse!");
    });

    it("Horse and Farmer::Horse can sleep.", async () => {
        let horse = await Horse.deployed();
        assert.equal(await horse.sleep(), 'Z-z-z...', "The horse can't sleep...");
    });

    it('Horse and Farmer::Horse can eat “plant”', async () => {
        let farmer = await Farmer.deployed();
        let horse = await Horse.deployed();
        assert.equal(await farmer.feed(horse.address, "plant"), 'Animal eats plant', "Horse can't eat plant");
    });

    it('Horse and Farmer::Horse can\'t eat “meat”', async () => {
        let farmer = await Farmer.deployed();
        let horse = await Horse.deployed();
        try {
            await farmer.feed(horse.address, "meat");
            throw null;
        } catch (error) {
            assert.equal(Object.values(error.data)[0].reason, "Can only eat plant food", 'The horse has a meat problem....');
        }
    });

    it('Horse and Farmer::Horse can\'t eat “plastic”', async () => {
        let farmer = await Farmer.deployed();
        let horse = await Horse.deployed();

        try {
            await farmer.feed(horse.address, "plastic");
            throw null;
        } catch (error) {
            assert.equal(Object.values(error.data)[0].reason, "Can only eat plant food", 'The horse has a plastic problem....');
        }
    });

    it("Horse and Farmer::Farmer can call horse", async () => {
        let farmer = await Farmer.deployed();
        let horse = await Horse.deployed();
        assert.equal(await farmer.call(horse.address), 'Igogo', "The horse responds incorrectly");
    });
});
contract("Dog and Farmer", async (accounts) => {


    it("Dog and Farmer:: Dog has the correct name.", async () => {
        let dog = await Dog.deployed();
        assert.equal(await dog.getName(), 'The Last of the Mohicans', "This is not that Dog!");
    });

    it("Dog and Farmer::Dog can sleep.", async () => {
        let dog = await Dog.deployed();
        assert.equal(await dog.sleep(), 'Z-z-z...', "The Dog can't sleep...");
    });

    it('Dog and Farmer::Dog can eat “plant”', async () => {
        let farmer = await Farmer.deployed();
        let dog = await Dog.deployed();
        assert.equal(await farmer.feed(dog.address, "plant"), 'Animal eats plant', "Dog can eat plant");
    });

    it('Dog and Farmer::Dog can eat “meat”', async () => {
        let farmer = await Farmer.deployed();
        let dog = await Dog.deployed();
        assert.equal(await farmer.feed(dog.address, "meat"), 'Animal eats meat', "Dog can eat meat");
    });

    it('Dog and Farmer::Dog can\'t eat “not-food”', async () => {
        let farmer = await Farmer.deployed();
        let dog = await Dog.deployed();
        try {
            await farmer.feed(dog.address, "not-food");
            throw null;
        } catch (error) {
            assert.equal(Object.values(error.data)[0].reason, "Can only eat plant ot meat food", 'The dog has a not-food problem....');
        }
    });

    it('Dog and Farmer::Dog can\'t eat “plastic”', async () => {
        let farmer = await Farmer.deployed();
        let dog = await Dog.deployed();
        try {
            await farmer.feed(dog.address, "plastic");
            throw null;
        } catch (error) {
            assert.equal(Object.values(error.data)[0].reason, "Can only eat plant ot meat food", 'The dog has a plastic problem....');
        }
    });

    it('Dog and Farmer::Dog can\'t eat “chocolate”', async () => {
        let farmer = await Farmer.deployed();
        let dog = await Dog.deployed();
        try {
            await farmer.feed(dog.address, "chocolate");
            throw null;
        } catch (error) {
            assert.equal(Object.values(error.data)[0].reason, "Can only eat plant ot meat food", 'The dog has a chocolate problem....');
        }
    });

    it("Dog and Farmer::Farmer can call Dog", async () => {
        let farmer = await Farmer.deployed();
        let dog = await Dog.deployed();
        assert.equal(await farmer.call(dog.address), 'Woof...', "The dog responds incorrectly");
    });

});
