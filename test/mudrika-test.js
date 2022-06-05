const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Mudrika contract", function () {
    it("Deployment should assign the total supply of tokens to the owner", async function () {
        const [admin, higherauth, lowerauth, volunteer, public] = await ethers.getSigners();

        const Token = await ethers.getContractFactory("Mudrika");

        const mudrika = await Token.deploy();

        // add funds to the contract
        const transaction = await admin.sendTransaction({
            to: mudrika.address,
            value: 1000
        });
        await transaction.wait();

        //signing up users into the contract (will be done by backend, only admin can)
        const addHigherAuth = await mudrika.addUser(higherauth.address, 3, "NDMA");
        await addHigherAuth.wait();
        const ndma = mudrika.connect(higherauth);

        const addLowerAuth = await mudrika.addUser(lowerauth.address, 2, "SDMA");
        await addLowerAuth.wait();
        const sdma = mudrika.connect(lowerauth);

        const addVolunteer = await mudrika.addUser(volunteer.address, 1, "Volunteer");
        await addVolunteer.wait();
        const vol = mudrika.connect(volunteer);

        const addPublic = await mudrika.addUser(public.address, 0, "Public");
        await addPublic.wait();
        const publ = mudrika.connect(public);

        const remainingFunds = await mudrika.fundRemaining();

        const requestFunds = await sdma.requestFunds(1, "Flood damage");
        await requestFunds.wait();

        const approveReq = await ndma.approveRequest(1);
        await approveReq.wait();

        expect(await mudrika.fundRemaining()).to.equal(999);
    });
});
