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
    const message = await "We like it!";
    await socialNetwork.post(message);

    const postId = await socialNetwork.getLastPostId();
    await socialNetwork.like(postId);
    const post = await socialNetwork.getPost(postId);
    expect(await post.totalLikes).to.equal(1);
  });

  it("should unlike a post", async function () {
    const {socialNetwork} = await loadFixture(deploymentFixture);
    const message = await "We don't like it!";
    await socialNetwork.post(message);

    const postId = await socialNetwork.getLastPostId();
    await socialNetwork.like(postId);
    await socialNetwork.unlike(postId);
    const post = await socialNetwork.getPost(postId);
    expect(await post.totalLikes).to.equal(0);
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