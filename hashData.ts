import keccak256 from "keccak256";
import MerkleTree from "merkletreejs";
import fs from "fs";
// import { ethers } from "hardhat";
import { ethers, solidityPackedKeccak256 } from "ethers";

const addresses = fs
  .readFileSync("address.csv", {
    encoding: "utf-8",
  })
  .split("\n")
  .map((row: string): string[] => {
    return row.split(",");
  });

const leaves = [];
for (let addres of addresses) {
  if (addres[0] === "address") continue;
  const leaf = solidityPackedKeccak256(
    ["address", "uint"],
    [addres[0], addres[1]]
  );
  leaves.push(leaf);
}
const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
const root = tree.getRoot().toString("hex");

const treeObj: any = { root, tree: [] };

for (let i = 0; i < leaves.length; i++) {
  const proof = tree.getHexProof(leaves[i]);
  treeObj.tree.push({
    leaf: leaves[i],
    proof,
  });
}

//create a file and push the data gotten to the file

const jsonFilePath = "data.json";

const jsonString = JSON.stringify(treeObj);

fs.writeFileSync(jsonFilePath, jsonString, "utf-8");

console.log(treeObj.tree);

//Manually generated Layer

// const layer1 = [];

// const halfLength = Math.round(leaves.length / 2);

// for (let ifl = 0; ifl < halfLength; ifl++) {
//   const mult = ifl * 2;
//   if (mult < leaves.length - 1) {
//     layer1.push(
//       solidityPackedKeccak256(
//         ["bytes", "bytes"],
//         [leaves[mult], leaves[mult + 1]]
//       )
//     );
//   } else {
//     layer1.push(leaves[mult]);
//   }
// }

// console.log({ layer1 });
