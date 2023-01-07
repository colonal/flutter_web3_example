// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/utils/Strings.sol";

contract Ballot {
   
    struct Voter {
        bool voted;  
        uint vote;   
    }

    struct Proposal {
        string name;    
        uint voteCount; 
    }

    address private owner;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;
    address[] public votersList;

    modifier onlyowner() {

        require(msg.sender == owner);
        _;

    }

    constructor() {
        owner = msg.sender;
        
    }
    function isOwner() public view returns(bool){
        return owner == msg.sender;
    }

    function getProposals() public view returns (Proposal[] memory proposal_){
        return proposals;

    }

    function setProposalNames(string[] memory proposalNames) onlyowner public{
        delete proposals;
        for(uint i; i< votersList.length; i++){
           delete voters[votersList[i]];
        }
        delete votersList;
        
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    
    

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted.");
        votersList.push(msg.sender);
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += 1;
    }

    function showVote() public view returns(uint){
        Voter storage sender = voters[msg.sender];
        return sender.vote;
    }
    

    function winningProposal() private view returns (uint winningProposal_){
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }
    
    function winner() public view returns (string[] memory winnerName_) {
        string[] memory win;
        win[0] = proposals[winningProposal()].name;
        win[1] = Strings.toString(proposals[winningProposal()].voteCount);
        return win;
        // return winnerName_ = proposals[winningProposal()].name;
    }
}