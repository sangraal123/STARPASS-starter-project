import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("SocialNetwork", function () {
  let SocialNetwork;
  let socialNetwork;

  async function deploymentFixture() {
    SocialNetwork = await ethers.getContractFactory("SocialNetwork");
    socialNetwork = await SocialNetwork.deploy();
    await socialNetwork.deployed();

    return {socialNetwork};
  };
describe("Deployment", function () {
  it("should post a message", async function () {
    const {socialNetwork} = await loadFixture(deploymentFixture);
    const message = await "Hello, World!";
    await socialNetwork.post(message);

    const lastPostId = await socialNetwork.getLastPostId();
    expect(await lastPostId).to.equal(1);

    const post = await socialNetwork.getPost(lastPostId);
    expect(await post.message).to.equal(message);
  }); 

  it("should like a post", async function () {
    const {socialNetwork} = await loadFixture(deploymentFixture);
    const message = "We like it!";
    const totalLikes = await socialNetwork.getTotalLikes();
    await socialNetwork.post(message);
    
    await socialNetwork.like(1);

    expect(await socialNetwork.getTotalLikes()).to.equal(totalLikes + 1);
  });

  it("should unlike a post", async function () {
    const {socialNetwork} = await loadFixture(deploymentFixture);
    const message = "We don't like it!";
    const totalLikes = await socialNetwork.getTotalLikes();
    await socialNetwork.post(message);

    await socialNetwork.like(1);
    await socialNetwork.unlike(1);

    expect(await socialNetwork.getTotalLikes()).to.equal(totalLikes);
  });

  it("should store a liked state", async function () {
    const {socialNetwork} = await loadFixture(deploymentFixture);
    const message = "Checking Liked State";
    await socialNetwork.post(message);
    await socialNetwork.like(1);

    const {poster} = await socialNetwork.getPost(1);

    const likeornot = await socialNetwork.getLikedStates(ethers.utils.getAddress(poster));
    console.log("LikeorNot:", likeornot);
    expect(await likeornot["0"]).to.equal(true);
  });

  it("should store a unliked state", async function () {
    const {socialNetwork} = await loadFixture(deploymentFixture);
    const message = "Checking unliked State";
    await socialNetwork.post(message);
    await socialNetwork.like(1);
    await socialNetwork.unlike(1);

    const {poster} = await socialNetwork.getPost(1);

    const likeornot = await socialNetwork.getLikedStates(ethers.utils.getAddress(poster));
    console.log("LikeorNot:", likeornot);
    expect(await likeornot["0"]).to.equal(false);
  });

  it("should revert if post does not exist", async function () {
    const nonExistentPostId = 99;

    await expect(socialNetwork.getPost(nonExistentPostId)).to.be.revertedWith(
      "Post not found"
    );

    await expect(socialNetwork.like(nonExistentPostId)).to.be.revertedWith(
      "Post not found"
    );

    await expect(socialNetwork.unlike(nonExistentPostId)).to.be.revertedWith(
      "Post not found"
    );
  });
});
});