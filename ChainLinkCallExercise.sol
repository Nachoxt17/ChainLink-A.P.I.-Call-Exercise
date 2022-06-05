pragma solidity ^0.6.0;
/**+-Tutorials:_
https://youtu.be/pgf8Prwibio
https://dapp-world.com/smartbook/call-any-api-in-smart-contract-parti-f77z
https://dapp-world.com/smartbook/call-any-api-in-smart-contract-partii-J8hn
*/

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

contract GetAPI is ChainlinkClient {
    using Chainlink for Chainlink.Request;
  
    bytes32 public volume;
    
    //+-This is ChainLink Node Operator Oracle Address, it will change depending on the E.V.M. Chain Used (ETH, Polygon, etc):_
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    constructor() public {
        setPublicChainlinkToken();
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
        jobId = "50fc4215f89443d185b061e5d7af9490";
        fee = 0.1 * 10 ** 18; // (Varies by network and job)
    }
    
    function requestVolumeData() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        request.add("get", "https://reqres.in/api/products/3");
      
        request.add("path", "data.name");
        
        
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    

    function fulfill(bytes32 _requestId, bytes32 _volume) public recordChainlinkFulfillment(_requestId)
    {
        volume = _volume;
    }
    
    function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
        uint8 i = 0;
        while(i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }
    
 
}
