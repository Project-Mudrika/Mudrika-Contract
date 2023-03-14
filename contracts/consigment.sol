//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract Consignment_Tracker {
    address private _owner;
    // address public mudrika;
    // Mudrika public mudrika;
    enum Status {
        IN_TRANSIT,
        ACCEPTED,
        RECEIVED
    }

    struct Consignment {
        uint256 consignmentId;
        address curr_holder;
        address sender;
        address receiver;
        uint256 requestId;
        string name;
        uint256 quantity;
        string start_location;
        string curr_location;
        Status status;
    }

    mapping(uint256 => Consignment) public consignments;

    event locationUpdated(uint256 consignmentId, string location, address updater);
    event statusUpdated(uint256 consignmentId, Status status, address updater);
    event consignmentAdded(Consignment consignment, address by);


    constructor() {
        _owner = msg.sender;
    }

    // function updateContract(address mudrika_address) public {
    //     // TODO:
    //     // mudrika = Mudrika(mudrika_address);
    // }

    function addConsignment(
        uint256 consignmentId,
        uint256 requestId,
        address receiver,
        string memory name,
        uint256 quantity,
        string memory start_location
    ) public {
        // TODO:
        Consignment memory consignment = Consignment({
            consignmentId: consignmentId,
            curr_holder: msg.sender,
            sender: msg.sender,
            receiver: receiver,
            requestId: requestId,
            name: name,
            quantity: quantity,
            start_location: start_location,
            curr_location: start_location,
            status: Status.ACCEPTED
        });

        consignments[consignmentId] = consignment;

        emit consignmentAdded(consignment, msg.sender);
    }

    function updateConsignmentStatus(
        uint256 consignmentId,
        uint256 status
    ) public {
        // TODO:

        consignments[consignmentId].status = Status(status);

        emit statusUpdated(consignmentId, Status(status), msg.sender);
    }

    function updateConsignmentLocation(
        uint256 consignmentId,
        string memory location
    ) public {
        // TODO:

        consignments[consignmentId].curr_location = location;
        consignments[consignmentId].curr_holder = msg.sender;

        emit locationUpdated(consignmentId, location, msg.sender);
    }

    function getConsignmentLocation(
        uint256 consignmentId
    ) public view returns (string memory) {
        string memory res = string(abi.encodePacked(consignments[consignmentId].curr_holder, consignments[consignmentId].curr_location));
    return res;
    }

    function getConsignmentStatus(
        uint256 consignmentId
    ) public view returns (Status) {
        // TODO:
        return consignments[consignmentId].status;
    }

    function getConsignmentDriver(
        uint256 consignmentId
    ) public view returns (
        address
    )
    {
        return consignments[consignmentId].curr_holder;
    }
}
