import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying with:", deployer.address);

  // Deploy Token
  const Token = await ethers.getContractFactory("UnibridgeToken");
  const token = await Token.deploy("MyToken", "MTK", ethers.parseEther("1000"));
  await token.waitForDeployment();

  console.log("Token deployed at:", await token.getAddress());

  // Deploy Bridge
  const Bridge = await ethers.getContractFactory("Bridge");
  const bridge = await Bridge.deploy(await token.getAddress());
  await bridge.waitForDeployment();

  console.log("Bridge deployed at:", await bridge.getAddress());

  // Transfer ownership to bridge (optional, for mint/burn control)
  await token.transferOwnership(await bridge.getAddress());
  console.log("Token ownership transferred to bridge.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
