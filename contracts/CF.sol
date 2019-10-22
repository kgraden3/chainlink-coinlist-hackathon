pragma solidity ^0.4.24

import "https://github.com/smartcontractkit/chainlink/evm/contracts/ChainlinkClient.sol";
import "https://github.com/smartcontractkit/chainlink/evm/contracts/vendor/Ownable.sol";
import "https://github.com/smartcontractkit/chainlink/evm/contracts/vendor/Oracle.sol";
import "https://github.com/smartcontractkit/chainlink/evm/contracts/vendor/SafeMath.sol";
import "https://github.com/smartcontractkit/chainlink/evm/contracts/vendor/SignedSafeMath.sol";
import "https://github.com/smartcontractkit/chainlink/evm/contracts/interfaces/RequestChainlinkInterface.sol";
import "https://github.com/smartcontractkit/chainlink/evm/contracts/interfaces/LinkTokenInterface.sol";
import "https://github.com/smartcontractkit/chainlink/evm/contracts/interfaces/OracleInterface.sol";



contract CarbonFootprint is ChainlinkClient, Ownable {
    bytes32 jobID = "493610cff14346f786f88ed791ab7704";
    uint256 constant payment = 1 * LINK;
    uint256 public charity;
    uint256 public dataEntry;
    uint256 public TotalFootprint;

    address public owner;
    address public TestAcct = "0xd01722e6EF82f6542B9652B3C5feD9E972F03185";
    address public OneTree = "0xD8b690C711676C9454a73417B1d9973dD4bCb8ab";
    
    event DataSource(
        bytes32 indexed requestId,
        uint256 indexed dataPoint
    );
    
    event Footprint(
        bytes32 indexed requestId,
        uint256 indexed print
    );
    
    constructor() public {
        setLinkToken(0x20fE562d797A42Dcb3399062AE9546cd06f63280);
        setOracle(0xc99B3D447826532722E41bc36e644ba3479E4365);
        owner = msg.sender;
    } 
 
    function requestData(address _oracle, string jobID)
        public 
        onlyOwner
    {
        Chainlink.Request memory req = buildChainlinkRequest(jobID, this, this.receiveDataSource.selector);
// insert API
        sendChainlinkRequest(req, payment);
    }
    
    function receiveDataSource(bytes32 _requestId, uint256 _dataPoint)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit DataSource(_requestId, _dataPoint);
        dataEntry = _dataPoint;
    }
    
    function calculateFootprint(uint256 _dataEntry)
        public
    {
        print = _dataEntry / 5;
    }
    
    function storeFootprint(bytes32 _requestId, uint256 _print)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit Footprint(_requestId, _print);
        TotalFootprint = _print;
        charity = TotalFootprint;
    }
    
    function sendCharity(address _TestAcct, string jobID, uint256 _charity) 
        public 
        onlyOwner 
    {
 // execute transfer       
    }
  
    function getChainlinkToken() public view returns (address) {
        return chainlinkTokenAddress();
    }
    
}
