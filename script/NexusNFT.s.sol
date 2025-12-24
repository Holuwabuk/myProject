//SPDX-License-Identifier:MIT
pragma solidity 0.8.30;
import {Script} from "../lib/forge-std/src/Script.sol";
import {NexusNFT} from "../src/NexusNFT.sol";
import {console} from "../lib/forge-std/src/console.sol";
contract NexusNFTScript is Script {
    NexusNFT public nexus;

    function run() external {
        // Load deployer private key from .env
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    
        vm.startBroadcast(deployerPrivateKey);
        // 1️⃣ Deploy contract
        nexus = new NexusNFT(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266); //deployer in the brak
        console.log("NexusNFT deployed at:", address(nexus));

        // 2️⃣ Set allowlist addresses; you can remove the whole lines,you can set it after deploymentclear:
       address[] memory allowlist = new address[](3);
        allowlist[0] = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; 
        allowlist[1] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        allowlist[2] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
        nexus.setAllowListMint(allowlist);
        console.log("Allowlist configured");

        // 3️⃣ Open minting
        nexus.editMintingState(true, true);
        console.log("Minting opened");

        // 4️⃣ Optional: Allowlist mint
        nexus.allowedMint{value: 0.1 ether}();
        console.log("Allowlist mint done");

        // 5️⃣ Optional: General mint
        nexus.generalMint{value: 0.9 ether}();
        console.log("General mint done");

        vm.stopBroadcast();
    }
}
