// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
require("@nomiclabs/hardhat-waffle");
require('dotenv').config();
const { Signer, Wallet } = require('ethers');

async function main() {
    // Hardhat always runs the compile task when running scripts with its command
    // line interface.
    //
    // If this script is run directly using `node` you may want to call compile
    // manually to make sure everything is compiled
    // await hre.run('compile');

    // We get the contract to deploy

    const provider = hre.ethers.provider;
    const statePrivKey = process.env['STATE_PVT_KEY'];;
    const state_signer_wallet = new Wallet(statePrivKey);
    const state = await state_signer_wallet.connect(provider);

    const contract_addr = "0x4963C5E97e8E499bf90517c95329c1d1725105ca";
    // console.log('contract_addr', contract_addr);

    // const Consignment = await hre.ethers.getContractFactory("Consignment_Tracker");
    const contract = await hre.ethers.getContractAt("contracts/mudrika.sol:Mudrika", contract_addr)

    // Add User accounts
    await contract.addUser("0x598518be171D592b24041e92324988035C9429F5", 4, "Ajay State Officer")

    // Add requests
    await contract.connect(state).requestFunds(30000, "0xD802Aa1408bbCC59DB8204A41637918dED209af7", "Tsunami relief funds for Kerala")

    const res = await contract.fundRemaining();
    console.log("Fund Remaining: ", res);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
