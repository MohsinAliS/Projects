// SPDX-License-Identifier: MIT
pragma solidity >0.7.5;

contract crowdFundings{

mapping (address=>uint) public contributers;
address public manager;
uint public minimumContribution;
uint public deadLine;
uint public target;
uint public raisedAmount;
uint public noOfContributor;

struct request {
string description;
address payable recipient;
uint value;
bool completed;
uint noOfVoters;
mapping (address=>bool) voters;
}

mapping (uint=>request) public requests;
uint public numRequest;
constructor(uint _target, uint _deadLine){

    target=_target;
    deadLine= block.timestamp+_deadLine;
    minimumContribution=100 wei;
    manager=msg.sender;
} 

    function sendEth() public payable {
        require (block.timestamp<deadLine,"dead line had passed");
        require (msg.value>= minimumContribution,"you can't send minimum amount");

    if(contributers[msg.sender]==0){
        noOfContributor++;
    }
        contributers[msg.sender]+=msg.value;
        raisedAmount+=msg.value;
    }
    
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function reFund() public{
 require(block.timestamp>deadLine && raisedAmount<target,"you are not eligible for refund");
 require (contributers[msg.sender]>0);
 address payable user= payable(msg.sender);
 user.transfer(contributers[msg.sender]);
 contributers[msg.sender]=0;
    }

    modifier onlyManager(){
        require(msg.sender==manager,"only manager can call this function");_;
    }

    function createRequests(string memory _discrtiption, address payable _recipient, uint _value)
    public onlyManager{
   // request storage newRequest= requests[_numRequest]; 
    numRequest++;
    requests[numRequest].description=_discrtiption;  
    requests[numRequest].recipient=_recipient;
    requests[numRequest].value=_value;
    requests[numRequest].completed=false;
    requests[numRequest].noOfVoters=0;
    }

    function voteRequest(uint _requestNo) public{
        require(contributers[msg.sender]>0,"you must be contributor");
        require (requests[_requestNo].voters[msg.sender]==false,"you have already voted");
        requests[_requestNo].voters[msg.sender]==true;
        requests[_requestNo].noOfVoters++;
    }
    function makePayment(uint _requestNo) public onlyManager{

        require(raisedAmount>=target);
        require(requests[_requestNo].completed==false,"the request has been completed");
        require(requests[_requestNo].noOfVoters>noOfContributor/2,"MAJOrity not saport");
        requests[_requestNo].recipient.transfer(requests[_requestNo].value);
        requests[_requestNo].completed==true;
    }

}
