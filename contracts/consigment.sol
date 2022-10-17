//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./mudrika.sol";

contract Consignment_Tracker {
    address private _owner;
    // address public mudrika;
    Mudrika public mudrika;

    enum Status {
        IN_TRANSIT,
        ACCEPTED,
        RECEIVED
    }

    struct Consignment {
        uint256 consignmentId;
        uint256 requestId;
        string name;
        uint256 quantity;
        string start_location;
        string curr_location;
        Status status;
    }

    mapping(uint256 => Consignment) public consignments;

    constructor(address mudrika_address) {
        _owner = msg.sender;
        mudrika = Mudrika(mudrika_address);
    }

    modifier authority() {
        // TODO:
        _;
    }

    modifier driver() {
        // TODO:
        _;
    }

    function updateContract(address mudrika_address) public {
        // TODO:
        mudrika = Mudrika(mudrika_address);
    }

    function addConsignment(
        uint256 consignmentId,
        uint256 requestId,
        string memory name,
        uint256 quantity,
        string memory start_location
    ) public {
        // TODO:
        Consignment memory consignment = Consignment({
            consignmentId: consignmentId,
            requestId: requestId,
            name: name,
            quantity: quantity,
            start_location: start_location,
            curr_location: start_location,
            status: Status.ACCEPTED
        });

        consignments[consignmentId] = consignment;
    }

    function updateConsignmentStatus(uint256 consignmentId, uint256 status)
        public
    {
        // TODO:

        consignments[consignmentId].status = Status(status);
    }

    function updateConsignmentLocation(
        uint256 consignmentId,
        string memory location
    ) public driver {
        // TODO:

        consignments[consignmentId].curr_location = location;
    }

    function getConsignmentStatus(uint256 consignmentId)
        public
        view
        returns (Status)
    {
        // TODO:
        return consignments[consignmentId].status;
    }
}
