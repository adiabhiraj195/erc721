// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

error MoodNft__CantFlipMoodIfNotOwner();
error ERC721Metadata__URI_QueryFor_NonExistentToken();

contract MoodNFT is ERC721, Ownable {
    event NftCreated(uint256 tokenId);

    enum NftMood {
        HAPPY,
        SAD
    }

    string private s_happyNftUri;
    string private s_sadNftUri;
    uint256 private s_tokenCounter;

    mapping(uint256 => NftMood) private s_tokebnIdToMood;

    constructor(
        string memory happyNftUri,
        string memory sadNftUri
    ) ERC721("MoodNft", "MFT") Ownable(msg.sender) {
        s_happyNftUri = happyNftUri;
        s_sadNftUri = sadNftUri;
        s_tokenCounter = 0;
    }

    function mintNFT() public {
        uint256 tokenCounter = s_tokenCounter;

        _safeMint(msg.sender, tokenCounter);
        s_tokenCounter++;

        emit NftCreated(tokenCounter);
    }

    function flipMood(uint256 tokenId) public {
        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokebnIdToMood[tokenId] == NftMood.HAPPY) {
            s_tokebnIdToMood[tokenId] = NftMood.SAD;
        } else {
            s_tokebnIdToMood[tokenId] = NftMood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }

        string memory imageURI = s_happyNftUri;

        if (s_tokebnIdToMood[tokenId] == NftMood.SAD) {
            imageURI = s_sadNftUri;
        }

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                            abi.encodePacked(
                                '{"name":"',
                                name(), // You can add whatever name here
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function getHappyUri() public view returns (string memory) {
        return s_happyNftUri;
    }

    function getSadUri() public view returns (string memory) {
        return s_sadNftUri;
    }
}
