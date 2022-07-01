//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Mudrika {
    address private _owner;
    mapping(address => User) private users;

    uint256 public requestCount;
    mapping(uint256 => Request) public requestsReceived;

    enum UserType {
        PUBLIC,
        VOLUNTEER,
        AUTHORITY_LOW,
        AUTHORITY_HIGH,
        ADMIN
    }

    struct User {
        address account;
        string name;
        UserType userType;
    }

    struct Request {
        uint256 requestId;
        uint256 fund;
        string description;
        address from;
        address to;
        bool approvalStatus;
    }

    event requestAdded(uint256 requestId);
    event fundTransferred(uint256 amount, address to);
    event fundDeposited(uint256 amount, address by);

    modifier onlyAdmin() {
        require(
            users[msg.sender].userType == UserType.ADMIN,
            "Only Admin can perform this action"
        );
        _;
    }

    modifier higherAuthority() {
        require(
            users[msg.sender].userType == UserType.AUTHORITY_HIGH,
            "Only HigherAuthority can perform this action"
        );
        _;
    }

    modifier lowerAuthority() {
        require(
            users[msg.sender].userType == UserType.AUTHORITY_LOW,
            "Only LowerAuthority can perform this action"
        );
        _;
    }

    constructor() {
        _owner = msg.sender;
        requestCount = 0;
        addAdmin(msg.sender, "Admin");
    }

    function addAdmin(address account, string memory name) private {
        User memory newUser = User({
            name: name,
            account: account,
            userType: UserType.ADMIN
        });

        users[account] = newUser;
    }

    function fundRemaining() public view returns (uint256) {
        return address(this).balance;
    }

    function addUser(
        address account,
        uint8 userType,
        string memory name
    ) public {
        //only add users of equal of lower authority
        require(
            uint8(users[msg.sender].userType) >= userType,
            "Lower auth user cannot add higher auth user"
        );
        User memory newUser = User({
            name: name,
            account: account,
            userType: UserType(userType)
        });

        users[account] = newUser;
    }

    function requestFunds(
        uint256 amount,
        address to,
        string memory description // lowerAuthority
    ) public {
        Request memory newReq = Request({
            description: description,
            from: msg.sender,
            to: to,
            fund: amount,
            requestId: requestCount + 1,
            approvalStatus: false
        });

        requestsReceived[requestCount + 1] = newReq;
        requestCount++;
    }

    function approveRequest(uint256 requestId) public higherAuthority {
        require(requestId <= requestCount, "Request not found");
        require(
            requestsReceived[requestId].approvalStatus == false,
            "Request already approved"
        );
        sendFunds(
            requestsReceived[requestId].from,
            requestsReceived[requestId].fund,
            requestId
        );
    }

    function sendFunds(
        address to,
        uint256 amount,
        uint256 requestId
    ) private {
        require(amount <= address(this).balance, "Insufficient Funds");
        requestsReceived[requestId].approvalStatus = true;
        payable(to).transfer(amount);
        emit fundTransferred(amount, to);
    }

    // function viewRequests() public view higherAuthority returns (Request) {}

    receive() external payable {
        // won't accept donations, only admin can put in money
        require(
            users[msg.sender].userType == UserType.ADMIN,
            "only admin can send money to contract"
        );
        emit fundDeposited(msg.value, msg.sender);
    }
}
