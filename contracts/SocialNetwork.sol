// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./interfaces/ISocialNetwork.sol";
import "hardhat/console.sol";

contract SocialNetwork is ISocialNetwork {
    uint256 private _lastId;

    constructor() {
        _lastId = 0;
    }

    event NewPost(address poster, string message, uint256 timestamp, uint256 likes, uint256 indexed id);

    struct Post {
        address poster;
        string message;
        uint256 timestamp;
        uint256 likes;
        uint256 id;
    }

    Post[] private _posts;

    function post(string memory _message) external {
        _lastId++;
        _posts.push(Post(msg.sender, _message, block.timestamp, 0, _lastId));
        emit NewPost(msg.sender, _message, block.timestamp, 0, _lastId);
    }

    function getLastPostId() external view returns (uint256) {
        return _lastId;
    }

    function getPost(uint256 _postId)
        external
        view
        returns (
            string memory message,
            uint256 totalLikes,
            uint256 time
        )
    {
        for (uint256 i = 0; i < _posts.length; i++) {
            console.log(_posts[i].id,_posts[i].poster,_posts[i].message);
            console.log(_posts[i].likes,_posts[i].timestamp);
        }
        for (uint256 i = 0; i < _posts.length; i++) {
            if (_posts[i].id == _postId) {
                return (_posts[i].message, _posts[i].likes, _posts[i].timestamp);
            }
        }
        // 指定されたIDに対応する投稿が見つからない場合はエラーメッセージを返す
        revert("Post not found");
    }

    function like(uint256 _postId) external {
        for (uint256 i = 0; i < _posts.length; i++) {
            if (_posts[i].id == _postId) {
                _posts[i].likes++;
                return;
            }
        }
        // 指定されたIDに対応する投稿が見つからない場合はエラーメッセージを返す
        revert("Post not found");
    }

    function unlike(uint256 _postId) external {
        for (uint256 i = 0; i < _posts.length; i++) {
            if (_posts[i].id == _postId) {
                _posts[i].likes--;
                return;
            }
        }
        // 指定されたIDに対応する投稿が見つからない場合はエラーメッセージを返す
        revert("Post not found");
    }
}
