// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract Item {
    uint public priceInWei;
    uint public index;
    uint public pricePaid;
    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        parentContract = _parentContract;
        index = _index;
        priceInWei = _priceInWei;
    }

    receive() external payable {
        require(pricePaid == 0, "Item is paid already!");
        require(priceInWei == msg.value, "Only full payments allowed!");
        pricePaid += msg.value;    
        (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        require(success, "Delivery did not work");
    }

    fallback () external {}
}