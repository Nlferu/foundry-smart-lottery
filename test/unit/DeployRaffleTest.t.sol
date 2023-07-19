// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {AddConsumer, CreateSubscription, FundSubscription} from "../../script/Interactions.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract DeployRaffleTest is StdCheats, Test {
    Raffle public raffle;
    HelperConfig public helperConfig;
    AddConsumer public addConsumer;
    CreateSubscription public createSubscription;
    FundSubscription public fundSubscription;

    function testDeploymentOfContracts() public {
        DeployRaffle deployRaffle = new DeployRaffle();
        (raffle, helperConfig, addConsumer) = deployRaffle.run();

        /// @dev Addresses of contracts can be found after running test -vvvvv after yellow writing from console, which says: "-> new"
        assertEq(address(deployRaffle), 0xFEfC6BAF87cF3684058D62Da40Ff3A795946Ab06);
        assertEq(address(raffle), 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9);
        assertEq(address(helperConfig), 0x6d2eed85750d316088343D6d5e91ca59eb052768);
        assertEq(address(addConsumer), 0x8Bbbb5d294c78bd70dd88E6D63498dECa0C7BBCe);

        (uint64 subscriptionId, , , , , , , ) = helperConfig.activeNetworkConfig();

        if (subscriptionId == 0) {
            assert(address(createSubscription) == 0x0000000000000000000000000000000000000000); // This should be: 0xffdcC297C11a15F778e155c20c0b7Ab1D26f5561 (it's invisible)
            assert(address(fundSubscription) == 0x0000000000000000000000000000000000000000); // This should be: 0x7C5f18184dbdb4fE367fC3B38AaA576C6B86f2Af (it's invisible)
        }

        subscriptionId = 1;
        if (subscriptionId != 0) {
            assert(address(createSubscription) == 0x0000000000000000000000000000000000000000);
            assert(address(fundSubscription) == 0x0000000000000000000000000000000000000000);
        }
    }
}
