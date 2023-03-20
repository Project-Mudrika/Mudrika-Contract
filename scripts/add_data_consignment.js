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
    const nationalPrivKey = process.env['NATIONAL_PVT_KEY'];;
    const national_signer_wallet = new Wallet(nationalPrivKey);
    const national = await national_signer_wallet.connect(provider);

    const contract_addr = "0x2E816FB120E4DFDc3e0EDe8641561047e6b47109";

    const contract = await hre.ethers.getContractAt("Consignment_Tracker", contract_addr);

    // Add consignments
    // params (consignmentId, requestId, receiver, consignment_name, quanity, start_location, destination)
    await contract.connect(national).addConsignment(1, 1, "0x598518be171D592b24041e92324988035C9429F5", "Clothing Supplies", 3000, "Delhi", "Trivandrum");
    await contract.connect(national).addConsignment(2, 1, "0x598518be171D592b24041e92324988035C9429F5", "Food Supplies", 2000, "Delhi", "Trivandrum");
    await contract.connect(national).addConsignment(3, 1, "0x598518be171D592b24041e92324988035C9429F5", "Medical Supplies", 10000, "Delhi", "Trivandrum");

    // Update Consignment Location
    await contract.connect(national).updateConsignmentLocation(1, "Mumbai");
    await contract.connect(national).updateConsignmentLocation(1, "Mangalore");
    await contract.connect(national).updateConsignmentLocation(1, "Kochi");
    await contract.connect(national).updateConsignmentLocation(1, "Trivandrum")

    await contract.connect(national).updateConsignmentLocation(2, "Mumbai");
    await contract.connect(national).updateConsignmentLocation(2, "Mangalore");
    await contract.connect(national).updateConsignmentLocation(2, "Kochi");
    await contract.connect(national).updateConsignmentLocation(2, "Trivandrum")

    await contract.connect(national).updateConsignmentLocation(3, "Agra")
    await contract.connect(national).updateConsignmentLocation(3, "Indore");
    await contract.connect(national).updateConsignmentLocation(3, "Bangalore");
    await contract.connect(national).updateConsignmentLocation(3, "Salem");
    await contract.connect(national).updateConsignmentLocation(3, "Trivandrum")


    const res = await contract.getConsignmentLocation(3);
    console.log(res);

    // console.log("Consignment deployed at: ", contract.address);
    // console.log("res: ", res);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
