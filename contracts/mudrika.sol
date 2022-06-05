//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Mudrika {
    address private _owner;
    mapping(address => User) private users;

    uint256 private _requestCount;
    mapping(uint256 => Request) private requestsReceived;

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
        require(users[msg.sender].userType == UserType.AUTHORITY_HIGH);
        _;
    }

    modifier lowerAuthority() {
        require(users[msg.sender].userType == UserType.AUTHORITY_LOW);
        _;
    }

    constructor() {
        _owner = msg.sender;
        _requestCount = 0;
        addAdmin(msg.sender, 4, "Admin");
    }

    function addAdmin(
        address account,
        uint8 userType,
        string memory name
    ) private {
        User memory newUser = User({
            name: name,
            account: account,
            userType: UserType(userType)
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
    ) public onlyAdmin {
        User memory newUser = User({
            name: name,
            account: account,
            userType: UserType(userType)
        });

        users[account] = newUser;
    }

    function requestFunds(uint256 amount, string memory description)
        public
        lowerAuthority
    {
        Request memory newReq = Request({
            description: description,
            from: address(this),
            to: msg.sender,
            fund: amount,
            requestId: _requestCount + 1,
            approvalStatus: false
        });

        requestsReceived[_requestCount + 1] = newReq;
        _requestCount++;
    }

    function approveRequest(uint256 requestId) public higherAuthority {
        require(requestId <= _requestCount);
        sendFunds(
            requestsReceived[requestId].to,
            requestsReceived[requestId].fund
        );
    }

    function sendFunds(address to, uint256 amount) private {
        require(amount <= address(this).balance, "Insufficient Funds");
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
