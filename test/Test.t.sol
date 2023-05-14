// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

// import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Mock721.sol";
import "../src/OtherSimpleStore.sol";
import "../src/MockERC20.sol";
import {YulAirdrop} from "../src/YulAirdrop.sol";
contract SimpleStoreTest is Test {
    /// @dev Address of the SimpleStore contract.
    address simon = address(0x123);
    SimpleStore public simpleStore;
    Mock721 public mock721;
    OtherSimpleStore public otherSimpleStore;
    Mock721 public huff721;
    MockERC20 public mockERC20;
    YulAirdrop public yulAirdrop;
    uint amt = 200;

    /// @dev Setup the testing environment.
    function deploy(bytes memory bytecode) public returns (address) {
        address deployedContractAddress;
        assembly {
            deployedContractAddress := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        require(deployedContractAddress != address(0), "Contract deployment failed");
        return deployedContractAddress;
    }
    function setUp() public {
        // simpleStore = SimpleStore(HuffDeployer.deploy("SimpleStore"));
        // bytes memory erc721HuffByecode = hex"609d8060093d393df360003560e01c806363fba62e1461005e578063552410771461008a5780632096525514610091578063202edc12146100375760006000fd5b60043560040135600061004b565b14610055575b6001018180610045565b60005260206000f35b602435602052636352211e600052602060006024601c6004355afa1561007f575b60006000fd60206000f35b6004356000555b60005460005260206000f3";
        bytes memory bytecode = hex"609b8060093d393df360003560e01c80631889f64f14610011575b6323b872dd6000523360205230604052606435606052600060006064601c60006044355af1156100955763a9059cbb600052600435600401356000610057565b1461008f575b6001018060043590602002600401908101356020526024350135604052600060006044601c60006044355af115610095578181610051565b60006000f35b60006000fd";
        
        address deployedContractAddress = deploy(bytecode);
        simpleStore = SimpleStore(deployedContractAddress);
        // mock721 = new Mock721();
        otherSimpleStore = new OtherSimpleStore();
        yulAirdrop = new YulAirdrop();
        // mockERC20 = new MockERC20();
        // address _deployedHuff721 = deploy(erc721HuffByecode);
        // huff721 = Mock721(_deployedHuff721);

        

    }

    function uintToAddress(uint256 _uint) public pure returns (address) {
        return address(uint160(_uint));
    }

    function testSimpleStoreHuff() public {
        vm.deal(simon,100000000 ether);
        vm.startPrank(simon);
        address[] memory arr0 = new address[](amt);
        uint[] memory arr1 = new uint[](amt);
        uint total;
        uint amount_to_send_to_each = 1;
        for(uint i; i<amt; i++){
            arr0[i] = address(uintToAddress(i+1));
            arr1[i] = amount_to_send_to_each;
            total += amount_to_send_to_each;
        }

        mockERC20 = new MockERC20();

        uint256 myBal = mockERC20.balanceOf(simon);
        //approve
        mockERC20.approve(address(simpleStore),myBal);
        //Send all to contract

        simpleStore.airdropERC20(arr0,arr1,address(mockERC20),total);

        // for(uint i; i<5; i++){
        //    uint bal = mockERC20.balanceOf(arr0[i]);
        //    assertEq(bal,arr1[i]);
        // }

    }

    function testYulAirdrop() public {
        vm.deal(simon,100000000 ether);
        vm.startPrank(simon);
        address[] memory arr0 = new address[](amt);
        uint[] memory arr1 = new uint[](amt);
        uint total;
        uint amount_to_send_to_each = 1;
     for(uint i; i<amt; i++){
        arr0[i] = address(uintToAddress(i+1));
        arr1[i] = amount_to_send_to_each;
            total += amount_to_send_to_each;
        }
        mockERC20 = new MockERC20();
        
        uint256 myBal = mockERC20.balanceOf(simon);
        //Send all to contract
        //approve
        mockERC20.approve(address(yulAirdrop),myBal);
        yulAirdrop.airdropERC20(address(mockERC20), arr0, arr1, total);

        for(uint i; i<5; i++){
           uint bal = mockERC20.balanceOf(arr0[i]);
           assertEq(bal,arr1[i]);
        }

    }

    /// @dev Ensure that you can set and get the value.
    // function testHuffFindOwnerOf() public {
    //     // simpleStore.setValue(10);
    //     // console.log("VALUE = ", 10);
    //     // console.log(simpleStore.getValue());
    //     // assertEq(10, simpleStore.getValue());
    //     vm.startPrank(simon);
    //     address _ownerOf1 = simpleStore.findOwnerOf(address(mock721),1);
    //     console.logAddress(_ownerOf1);

    // }

    // function testYulFindOwnerOf() public {
    //     vm.startPrank(simon);
    //     address _ownerOf1 = otherSimpleStore.findOwnerOf(address(mock721),1);
    //     console.logAddress(_ownerOf1);

    // }

    // function testHuffMint() public {
    //     vm.startPrank(simon);
    //     huff721.mint(simon,2);
    //     address _ownerOf2 = simpleStore.findOwnerOf(address(huff721),2);
    //     console.logAddress(_ownerOf2);
   
    // }
}

interface SimpleStore {
    function setValue(uint256) external;
    function getValue() external returns (uint256);
    function findOwnerOf(address,uint256) external view returns(address);
    //#define function loopArray(uint256[],uint256[]) view returns (uint256)
    function airdropERC20(address[] calldata,uint256[] calldata,address,uint256) external;

}
