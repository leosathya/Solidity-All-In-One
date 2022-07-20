// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MultiSignatureWallet{
    struct Transaction{
        address to;
        uint value;
        bytes data;
        bool executed;
    }
    Transaction[] public Transactions;

    address[] public owners;
    uint public requiredAllowance;

    mapping(address => bool) public isOwner;
    mapping(uint => mapping(address => bool)) public approvd;

    event Deposite(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    modifier onlyOwner{
        require(isOwner[msg.sender], "Not owner");
        _;
    }
    modifier txExists(uint _txId){
        require(_txId < Transactions.length, "tx does not exists.");
        _;
    }
    modifier notApproved(uint _txId){
        require(!approvd[_txId][msg.sender], "tx already approved");
        _;
    }
    modifier notExecuted(uint _txId){
        require(!Transactions[_txId].executed, "tx already executed");
        _;
    }

    constructor(address[] memory _owners, uint _require){
        require(_owners.length != 0, "cant 0 owner");
        require(_require != 0, "cant 0 Approval");

        for(uint i; i<_owners.length; i++){
            require(_owners[i] != address(0), "cant be 0 address.");
            require(!isOwner[_owners[i]], "Owner always be unique");

            isOwner[_owners[i]] = true;
            owners[i] = _owners[i];
        }
        requiredAllowance = _require;
    }

    receive() external payable{
        emit Deposite(msg.sender, msg.value);
    }

    function submit(address _to, uint _value, bytes calldata _data) external{
        Transactions.push(Transaction({to:_to, value:_value, data:_data, executed: false}));
        emit Submit(Transactions.length - 1);
    }
    
    function approve(uint _txId) external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId){
        approvd[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function _getApprovalCount(uint _txId) private view returns(uint cout){
        for(uint i; i< owners.length; i++){
            if(approvd[_txId][owners[i]]){
                cout += 1;
            }
        }
        return cout;
    }

    function execute(uint _txId) external txExists(_txId) notExecuted(_txId){
        require(_getApprovalCount(_txId) >= requiredAllowance, "approval not reached.");
        Transaction storage _transaction = Transactions[_txId];
        _transaction.executed = true;

        (bool succ, ) = _transaction.to.call{value: _transaction.value}(_transaction.data);
        require(succ, "Execution failed.");
        emit Execute(_txId);
    }

    function revoke(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId){
        require(approvd[_txId][msg.sender], "Not approved");
        approvd[_txId][msg.sender] = false;
        
        emit Revoke(msg.sender, _txId);
    }

}