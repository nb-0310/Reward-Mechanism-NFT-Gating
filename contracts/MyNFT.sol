// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    bool public publicMintOpen = false;
    bool public allowListMintOpen = false;

    constructor(address initialOwner)
        ERC721("MyNFT", "MN")
        Ownable(initialOwner)
    {}

    struct SpecialUser {
        bool flag;
        bytes32 name;
    }

    mapping(address => SpecialUser) public allowList;

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function setAllowList(
        address[] calldata addresses,
        bytes32[] calldata names
    ) public onlyOwner {
        require(
            addresses.length == names.length,
            "The array lengths should be equal!!!"
        );

        for (uint256 i = 0; i < addresses.length; i++) {
            allowList[addresses[i]] = SpecialUser(true, names[i]);
        }
    }

    function removeAllowList(address[] calldata addresses) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            allowList[addresses[i]].flag = false;
        }
    }

    function setMinting(bool _publicMintOpen, bool _allowListMintOpen)
        public
        onlyOwner
    {
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }

    function setBaseURI(string memory newBaseURI) public onlyOwner {
        // Set a new base URI for metadata
        // Example: "ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/"
        // You can set this to a different IPFS or HTTP base URI
    }

    function publicMint() public payable {
        require(publicMintOpen, "Public Minting Closed!");
        require(msg.value == 0.01 ether, "Not Enough Funds Transferred!");

        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function allowListMint() public payable {
        require(allowListMintOpen, "Allow List Minting Closed!");
        require(msg.value == 0.001 ether, "Not Enough Funds Transferred!");

        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
