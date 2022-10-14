contract Consignment {
    address private _owner;
    address public mudrika;

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

    mapping(uint256 => ConsignmentId) public 

    constructor(mudrika_address: address) {
        _owner = msg.sender;
        mudrika = mudrika_address;
    }

    modifier authority() {
        // TODO:
    }

    modifier driver() {
        // TODO:
    }

    function updateContract(address mudrika_address) {
        // TODO:
    }

    function addConsignment(uint256 consignmentId, uint256 requestId, string name, uint256 quantity, string start_location) {
        // TODO:
        Consignment memory assignment = new Consignment({consignmentId, 
            requestId, 
            name, 
            quantity, 
            start_location, 
            curr_location: start_location,
            status: Status.ACCEPTED
        });
    }

    function updateConsignmentStatus(uint256 consignmentId, uint256 status){
        // TODO:
    }

    function updateConsignmentLocation(uint256 consignmentId, string location) driver {
        // TODO:
    }

    function getConsignmentStatus(uint256 consignmentId) public view {
        // TODO:
    }
}