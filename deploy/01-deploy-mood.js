const { network } = require("hardhat");
// const { networkConfig, developmentChains } = require("..helper-hardhat-config");
// const { verify } = require("../utils/verify");
const fs = require("fs");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();

  const sadSVG = fs.readFileSync("./images/frown.svg", {
    encoding: "utf8",
  });
  const happySVG = fs.readFileSync("./images/happy.svg", {
    encoding: "utf8",
  });

  console.log(sadSVG);
  log("----------------------------------------------------");
  const arguments = [happySVG, sadSVG];

  const dynamicSvgNft = await deploy("MoodNFT", {
    from: deployer,
    args: arguments,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });
};
