//Jack Evans RPS in solidity

pragma solidity ^0.6.0;

contract RPS {
    
    mapping (string => mapping(string => int)) payoffMatrix;
    address alice;
    address payable player1pay = payable(alice);
    address bob;
    address payable player2pay = payable(bob);
    string public player1Choice;
    string public player2Choice;
    int winner;
    
    uint8 public betAmount = 1;
    
    address blank;
    
    modifier notRegisteredYet()
    {
        _;
        require(msg.sender == alice || msg.sender == bob);
        
    }
    
    modifier sentEnoughCash(uint amount) 
    {
        _;
       require(msg.value>amount);
       
    }
    
    function rps() public
    {  
        payoffMatrix["rock"]["rock"] = 0;
        payoffMatrix["rock"]["paper"] = 2;
        payoffMatrix["rock"]["scissors"] = 1;
        payoffMatrix["paper"]["rock"] = 1;
        payoffMatrix["paper"]["paper"] = 0;
        payoffMatrix["paper"]["scissors"] = 2;
        payoffMatrix["scissors"]["rock"] = 2;
        payoffMatrix["scissors"]["paper"] = 1;
        payoffMatrix["scissors"]["scissors"] = 0;
    }
    
    function getWinner() view public returns (int x)
    {
        return winner;
    }
    
    
    function play(string memory choice) public returns (int w)
    {
        if (msg.sender == alice)
            player1Choice = choice;
        else if (msg.sender == bob)
            player2Choice = choice;
        if (bytes(player1Choice).length != 0 && bytes(player2Choice).length != 0)
        {
            rps();
            winner = payoffMatrix[player1Choice][player2Choice];
            
            //deal with the payout
            if (winner == 1)
                player1pay.transfer(address(this).balance);
            else if (winner == 2)
                player2pay.transfer(address(this).balance);
            else
            {
                player1pay.transfer(address(this).balance/2);
                player2pay.transfer(address(this).balance);
            }
            
             
            // unregister players and choices
            player1Choice = "";
            player2Choice = "";
            alice = blank;
            bob = blank;
            return winner;
        }
        else 
            return -1;
    }

    function getMyBalance () view public returns (uint amount)
    {
        return msg.sender.balance;
    }
    
    function getContractBalance () view public returns (uint amount)
    {
        return address(this).balance;
    }
    
    function register() public payable
        sentEnoughCash(betAmount)
        notRegisteredYet()
    {
        if (alice == blank )
            alice = msg.sender;
        else if (bob == blank)
            bob = msg.sender;
    }
    
    function checkPlayer1() view public returns (address x)
    {
        return alice;
    }
    
    function checkPlayer2() view public returns (address x)
    {
        return bob;
    }

    
    function checkBothNotNull() view public returns (bool x)
    {
        return (bytes(player1Choice).length == 0 && bytes(player2Choice).length == 0);
    }

}
