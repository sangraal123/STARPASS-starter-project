// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "./interfaces/ISocialNetwork.sol";
import "hardhat/console.sol";

contract SocialNetwork is ISocialNetwork {
    uint256 private _lastId;
    uint256 private _totalLikes;

    constructor() {
        _lastId = 0;
        _totalLikes = 0;
    }

    event NewPost();
    event NewLike();
    event NewUnlike();

    struct Post {
        address poster;
        string message;
        uint256 timestamp;
        uint256 id;
    }

    Post[] private _posts;
    mapping(uint256 => address[]) private _likedStates;


    function post(string memory _message) external {
        _lastId++;
        _posts.push(Post(msg.sender, _message, block.timestamp,_lastId));
        emit NewPost();
        return;
    }

    function getLastPostId() external view returns (uint256) {
        return _lastId;
    }

    function getPost(uint256 _postId)
        external
        view
        returns (
            address poster,
            string memory message,
            uint256 time
        )
    {
        for (uint256 i = 0; i < _posts.length; i++) {
            console.log(_posts[i].id,_posts[i].poster,_posts[i].message,_posts[i].timestamp);
        }
        for (uint256 i = 0; i < _posts.length; i++) {
            if (_posts[i].id == _postId) {
                return (_posts[i].poster, _posts[i].message, _posts[i].timestamp);
            }
        }
        // 指定されたIDに対応する投稿が見つからない場合はエラーメッセージを返す
        revert("Post not found");
    }

    function like(uint256 postId) external {
        for (uint256 i = 0; i < _posts.length; i++){
            if (_posts[i].id == postId) {
                _likedStates[postId].push(msg.sender);
                _totalLikes++;
                emit NewLike();
                return;
            }
        }
        // 指定されたIDに対応する投稿が見つからない場合はエラーメッセージを返す
        revert("Post not found");
    }

    function unlike(uint256 postId) external {
        for (uint256 i = 0; i < _posts.length; i++){
            if (_posts[i].id == postId) {
                address[] storage addresses = _likedStates[postId];
                for (uint256 j = 0; j < addresses.length; j++) {
                    if (addresses[j] == msg.sender) {
                            delete addresses[j];
                            _totalLikes--;
                            emit NewUnlike();
                            return;
                    }
                }
            }
        }
        // 指定されたIDに対応する投稿が見つからない場合はエラーメッセージを返す
        revert("Post not found");
    }

    function getTotalLikes() external view returns (uint256) {
        return _totalLikes;
    }

    function getTotalLikesbyPost(uint256 postId) external view returns(uint256) {
        address[] memory addresses = _likedStates[postId];
        uint256 count = 0;

        for (uint256 i = 0; i < addresses.length; i++){
            if(addresses[i] != address(0))
            {
                count++;
            }
        }

        return count;
    }

    function getLikedStates(address sender) external view returns (bool[] memory) {
        bool[] memory likedStates = new bool[](_lastId);

        for (uint256 i = 1; i <= _lastId; i++) {
            uint256 likedStateCount = _likedStates[i].length;
            for (uint256 j = 0; j < likedStateCount; j++) {
                if (_likedStates[i][j] == sender) {
                    likedStates[i-1] = true;
                    break;
                }
            }
        }
        return likedStates;
    }
}
