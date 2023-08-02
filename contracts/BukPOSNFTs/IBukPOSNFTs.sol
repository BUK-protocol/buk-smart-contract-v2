// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/IAccessControl.sol";

interface IBukPOSNFTs is IERC1155, IAccessControl {

    /**
    * @dev Function to update the treasury address.
    * @param _bukTreasuryContract Address of the treasury.
     * @notice This function can only be called by a contract with `BUK_NFT_CONTRACT_ROLE`
    */
    function setTreasury(address _bukTreasuryContract) external;

    /**
    * @dev Function to update the currency address.
    * @param _currencyContract Address of the currency contract.
     * @notice This function can only be called by a contract with `BUK_NFT_CONTRACT_ROLE`
    */
    function setCurrency(address _currencyContract) external;

    /**
     * @dev Function to grant the BukNFT role to a given contract
     * @param _nftContract address: The address of the NFT contract
     * @notice This function can only be called by a contract with `BUK_PROTOCOL_CONTRACT_ROLE`
     */
    function grantBukNFTRole(address _nftContract) external;

    /**
     * @dev To set the Buk Protocol role Access.
     * @param _bukProtocolContract - Address of Buk Protocol contract
     * @notice This function can only be called by a contract with `BUK_NFT_CONTRACT_ROLE`
     */
    function grantBukProtocolRole(address _bukProtocolContract) external;

    /**
     * @dev Function to set the URI for a given ID
     * @param _id uint256: The ID of the token
     * @param _newuri string: The new URI of the token
     * @notice This function can only be called by a contract with `BUK_NFT_CONTRACT_ROLE`
     */
    function setURI(uint256 _id, string memory _newuri) external;

    /**
     * @dev Function to update the contract name
     * @notice This function can only be called by a contract with `BUK_NFT_CONTRACT_ROLE`
     */
    function updateName(string memory _contractName) external;

    /**
     * @dev Function to toggle the NFT transferability status
     * @param _tokenId uint256: The ID of the token
     * @param _isTranferable bool: Transferability status of the NFT
     * @notice This function can only be called by a contract with `ADMIN_ROLE`
     */
    function toggleNftTransfer(uint256 _tokenId, bool _isTranferable) external;

    /**
     * @dev Function to mint tokens
     * @param _account address: The address to which the tokens will be minted
     * @param _id uint256: The ID of the token
     * @param _amount uint256: The amount of tokens to be minted
     * @param _newuri string: The URI of the token
     * @param _data bytes: Additional data associated with the token
     * @notice This function can only be called by a contract with `BUK_NFT_CONTRACT_ROLE`
     */
    function mint(
        address _account,
        uint256 _id,
        uint256 _amount,
        string calldata _newuri,
        bytes calldata _data
    ) external;

    /**
     * @dev Transfers ownership of an NFT token from one address to another.
     * @param _from - The current owner of the NFT.
     * @param _to - The address to transfer the ownership to.
     * @param _id - The ID of the NFT token.
     * @param _amount - The amount of NFTs to mint.
     * @param _data - Additional data to include in the transfer.
     * @notice This function checks if the NFT is tranferable or not.
     * @notice This function can only be called by a contract with `MARKETPLACE_CONTRACT_ROLE`
     */
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _amount,
        bytes memory _data
    ) external;

    /**
     * @dev Transfers ownership of multiple NFT tokens from one address to another.
     * @param _from - The current owner of the NFTs.
     * @param _to - The address to transfer the ownership to.
     * @param _ids - The IDs of the NFT tokens.
     * @param _amounts - Count of ERC1155 tokens of the respective token IDs.
     * @param _data - Additional data to include in the transfer.
     * @notice This function checks if the NFTs are tranferable or not.
     * @notice This function can only be called by a contract with `MARKETPLACE_CONTRACT_ROLE`
     */
    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    ) external;

    /**
     * @dev name of the contract
     */
    function name() external view returns (string memory);

    /**
     * @dev address of the BukNFTs contract
     */
    function nftContract() external view returns (address);

    /**
     * @dev address of the Buk Protocol contract
     */
    function bukProtocolContract() external view returns (address);

    /**
     * @dev Mapping for token URI's for Buk PoS NFTs
     * @param _id uint256: The ID of the token
     */
    function bookingTickets(uint256 _id) external view returns (string memory);

    /**
     * @dev Mapping to toggle the transferrability of Buk PoS NFTs
     * @param _id uint256: The ID of the token
     */
    function transferStatus(uint256 _id) external view returns (bool);

    /**
     * @dev To retrieve information about the royalties associated with a specific token.
     * @param _tokenId - The token ID of the NFT.
     * @param _salePrice - The price at which the token is being sold.
     */
    function royaltyInfo(
        uint256 _tokenId,
        uint256 _salePrice
    )
        external
        view
        returns (address[] memory receivers, uint256[] memory royaltyAmounts);


    /**
     * @dev Function to get the URI for a given ID
     * @param _id uint256: The ID of the token
     */
    function uri(uint256 _id) external view returns (string memory);
}