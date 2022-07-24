// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TimeLock{
    address public owner;
    mapping(bytes32 => bool) public isQueued;

    uint public constant MIN_DELAY = 10; // let 10sec
    uint public constant MAX_DELAY = 1000; // let 1000sec;
    uint public constant GRACE_PERIOD = 10000; 

    event Queue(bytes32 indexed TxId, address indexed targetContract, uint value, string func, bytes data, uint timestamp);
    event Execute(bytes32 indexed TxId, address indexed targetContract, uint value, string func, bytes data, uint timestamp);
    event Cancel(bytes32 indexed TxId);

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner function");
        _;
    }


    constructor(){
        owner = msg.sender;
    }

    receive() external payable{}

    function getTxId(address _targetContract, uint _value, string calldata _func, bytes calldata _data, uint _timestamp) public pure returns(bytes32){
        return keccak256(abi.encode(_targetContract, _value, _func, _data, _timestamp));
    }

    function queue(address _targetContract, uint _value, string calldata _func, bytes calldata _data, uint _timestamp) external onlyOwner{
        // create TxId
        bytes32 TxId = getTxId(_targetContract, _value, _func, _data, _timestamp);
        // TxId must unique
        require(!isQueued[TxId], "Tx already queued.");
        // check timestamp
        //require(_timestamp < block.timestamp + MIN_DELAY || _timestamp > block.timestamp + MAX_DELAY, "Time stamp not in range.");
        // queue Tx
        isQueued[TxId] = true;

        emit Queue(TxId, _targetContract, _value, _func, _data, _timestamp);
    }

    function execute(address _targetContract, uint _value, string calldata _func, bytes calldata _data, uint _timestamp) external payable onlyOwner{
        bytes32 TxId = getTxId(_targetContract, _value, _func, _data, _timestamp);
        // check is queued
        require(isQueued[TxId], "Transaction Not Present in Queue");
        // check current time > _timestamp
        require(block.timestamp > _timestamp, "Time not reached.");
        // check is Tx expire or not
        require(block.timestamp < _timestamp + GRACE_PERIOD, "Transaction Expired.");
        // delete tx from queue
        isQueued[TxId] = false;
        // execute tx
        bytes memory data;
        if(bytes(_func).length > 0){
            data = abi.encodePacked(
                // 1st need function Selector ==> bytes4(keccak256(bytes(_func)))
                // then uppend data to it 
                bytes4(keccak256(bytes(_func))), _data
            );
        }
        else{
            data = _data;
        }

        (bool succ, ) = _targetContract.call{value: _value}(data);
        require(succ, "Execution Failed.");

        emit Execute(TxId, _targetContract, _value, _func, _data, _timestamp);
    }

    function cancelTx(bytes32 TxId) external onlyOwner {
        require(isQueued[TxId], "Tx Not In Queue");
        isQueued[TxId] = false;

        emit Cancel(TxId);
    }
}

contract UseTimeLock{
    address public timeLock;

    constructor(address _timeLock){
        timeLock = _timeLock;
    }

    function test() external view{
        require(msg.sender == timeLock, "Only call by Timelock");
    }

    function getTimestamp() public view returns(uint){
        return block.timestamp + 100;
    }
}