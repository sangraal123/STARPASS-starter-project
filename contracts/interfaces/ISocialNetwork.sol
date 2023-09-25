// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface ISocialNetwork {
    // Post a message.
    // This posted data must be accessible by the post's id from the getter function that follows below.
    function post(string memory _message) external;

    // Returns id of the last post.
    function getLastPostId() external view returns (uint256);

    // Returns the data of the post by its id.
    function getPost(uint256 _postId)
        external
        view
        returns (
            address poster,
            string memory message,
            uint256 time
        );

    // Like a post by its id.
    function like(uint256 _postId) external;

    // Unlike a post by its id.
    function unlike(uint256 _postId) external;

    // Returns total numbers of likes.
    function getTotalLikes() external view returns (uint256);

    // Returns total numbers of likes by the post.
    function getTotalLikesbyPost(uint256 _postId) external view returns(uint256);

    // Returns information about likes of the given user's ID.
    function getLikedStates(address sender) external returns (bool[] memory);
}
