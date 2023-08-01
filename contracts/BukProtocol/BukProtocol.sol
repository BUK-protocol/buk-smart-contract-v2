// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../BukNFTs/IBukNFTs.sol";
import "../BukTreasury/IBukTreasury.sol";
import "./IBukProtocol.sol";

/**
 * @title BUK Protocol Contract
 * @author BUK Technology Inc
 * @dev Contract to manage operations of the BUK protocol to manage BukNFTs tokens and underlying sub-contracts.
 */
contract BukProtocol is AccessControl, ReentrancyGuard, IBukProtocol {
    /**
     * @dev address _bukWallet        Address of the Buk wallet.
     * @dev address _currency          Address of the currency.
     * @dev address _bukTreasury          Address of the Buk treasury contract.
     * @dev address nftContract Address of the Buk NFT contract.
     * @dev address nftPoSContract  Address of the Buk NFT PoS Contract.
     */
    address private _bukWallet;
    address private _currency;
    address private _bukTreasury;
    address public nftContract;
    address public nftPoSContract;

    /**
     * @dev Commission charged on bookings.
     */
    uint8 public commission = 5;

    /**
     * @dev Counters.Counter bookingIds    Counter for booking IDs.
     */
    uint256 private _bookingIds;

    //COMMENT Need to add comment to this
    Royalty[] public royalties;

    /**
     * @dev Constant for the role of admin
     */
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");

    /**
     * @dev mapping(uint256 => Booking) bookingDetails   Mapping of booking IDs to booking details.
     */
    mapping(uint256 => Booking) public bookingDetails; //bookingID -> Booking Details

    /**
     * @dev Constructor to initialize the contract
     * @param bukTreasury Address of the treasury.
     * @param currency Address of the currency.
     * @param bukWallet Address of the Buk wallet.
     */
    constructor(address bukTreasury, address currency, address bukWallet) {
        _currency = currency;
        _bukTreasury = bukTreasury;
        _bukWallet = bukWallet;
        _setupRole(ADMIN_ROLE, _msgSender());
        _grantRole(ADMIN_ROLE, _msgSender());
    }

    /**
     * @dev See {IBukProtocol-setTreasury}.
     */
    function setTreasury(address bukTreasury) external onlyRole(ADMIN_ROLE) {
        _bukTreasury = bukTreasury;
        emit SetTreasury(bukTreasury);
    }

    /**
     * @dev See {IBukProtocol-setTokenUri}.
     */
    function setTokenUri(
        uint _tokenId,
        string memory _newUri
    ) external onlyRole(ADMIN_ROLE) {
        IBukNFTs(nftContract).setURI(_tokenId, _newUri);
        emit SetTokenURI(_tokenId, _newUri);
    }

    /**
     * @dev See {IBukProtocol-setRoyaltyInfo}.
     */
    function setRoyaltyInfo(
        address[] memory _recipients,
        uint96[] memory _percentages
    ) external onlyRole(ADMIN_ROLE) {
        require(
            _recipients.length == _percentages.length,
            "Input arrays must have the same length"
        );
        delete royalties;
        for (uint i = 0; i < _recipients.length; i++) {
            require(_percentages[i] <= 100, "Percentage is more than 100");
            Royalty memory newRoyalty = Royalty(
                _recipients[i],
                _percentages[i]
            );
            royalties.push(newRoyalty);
        }
    }

    /**
     * @dev See {IBukProtocol-updateNFTName}.
     */
    function updateNFTName(
        string memory _contractName
    ) external onlyRole(ADMIN_ROLE) {
        IBukNFTs(nftContract).updateName(_contractName);
        emit UpdateContractName(_contractName);
    }

    /**
     * @dev See {IBukProtocol-grantBukProtocolRole}.
     */
    function grantBukProtocolRole(
        address _newBukProtocol
    ) external onlyRole(ADMIN_ROLE) {
        IBukNFTs(nftContract).grantBukProtocolRole(_newBukProtocol);
        emit GrantBukProtocolRole(address(this), _newBukProtocol);
    }

    /**
     * @dev See {IBukProtocol-setCommission}.
     */
    function setCommission(uint8 _commission) external onlyRole(ADMIN_ROLE) {
        commission = _commission;
        emit SetCommission(_commission);
    }

    /**
     * @dev See {IBukProtocol-bookRoom}.
     */
    function bookRoom(
        uint256 _count,
        uint256[] memory _total,
        uint256[] memory _baseRate,
        uint256 _checkin,
        uint256 _checkout
    ) external nonReentrant returns (bool) {
        require(
            ((_total.length == _baseRate.length) &&
                (_total.length == _count) &&
                (_count > 0)),
            "Array sizes mismatch"
        );
        uint256[] memory bookings = new uint256[](_count);
        uint total = 0;
        uint commissionTotal = 0;
        for (uint8 i = 0; i < _count; ++i) {
            ++_bookingIds;
            bookingDetails[_bookingIds] = Booking(
                _bookingIds,
                BookingStatus.booked,
                0,
                _msgSender(),
                _checkin,
                _checkout,
                _total[i],
                _baseRate[i]
            );
            bookings[i] = _bookingIds;
            total += _total[i];
            commissionTotal += (_baseRate[i] * commission) / 100;
            emit BookRoom(_bookingIds);
        }
        return _bookingPayment(commissionTotal, total);
    }


    /**
     * @dev See {IBukProtocol-bookingRefund}.
     */
    function bookingRefund(
        uint256[] memory _ids,
        address _owner
    ) external onlyRole(ADMIN_ROLE) {
        uint256 len = _ids.length;
        require((len > 0), "Array is empty");
        for (uint8 i = 0; i < len; ++i) {
            require(
                bookingDetails[_ids[i]].owner == _owner,
                "Check the booking owner"
            );
            require(
                bookingDetails[_ids[i]].status == BookingStatus.booked,
                "Check the Booking status"
            );
        }
        uint total = 0;
        for (uint8 i = 0; i < len; ++i) {
            bookingDetails[_ids[i]].status = BookingStatus.cancelled;
            total +=
                bookingDetails[_ids[i]].total +
                (bookingDetails[_ids[i]].baseRate * commission) /
                100;
        }
        IBukTreasury(_bukTreasury).cancelUSDCRefund(total, _owner);
        emit BookingRefund(total, _owner);
    }

    /**
     * @dev See {IBukProtocol-confirmRoom}.
     */
    function confirmRoom(
        uint256[] memory _ids,
        string[] memory _uri,
        bool _status
    ) external nonReentrant {
        uint256 len = _ids.length;
        for (uint8 i = 0; i < len; ++i) {
            require(
                bookingDetails[_ids[i]].status == BookingStatus.booked,
                "Check the Booking status"
            );
            require(
                bookingDetails[_ids[i]].owner == _msgSender(),
                "Only booking owner has access"
            );
        }
        require((len == _uri.length), "Check Ids and URIs size");
        require(((len > 0) && (len < 11)), "Not in max - min booking limit");
        IBukNFTs bukNftsContract = IBukNFTs(nftContract);
        for (uint8 i = 0; i < len; ++i) {
            bookingDetails[_ids[i]].status = BookingStatus.confirmed;
            bukNftsContract.mint(
                _ids[i],
                bookingDetails[_ids[i]].owner,
                1,
                "",
                _uri[i],
                _status
            );
            bookingDetails[_ids[i]].tokenID = _ids[i];
        }
        emit MintBookingNFT(_ids, true);
    }

    /**
     * @dev See {IBukProtocol-checkout}.
     */
    function checkout(uint256[] memory _ids) external onlyRole(ADMIN_ROLE) {
        uint256 len = _ids.length;
        require(((len > 0) && (len < 11)), "Not in max-min booking limit");
        for (uint8 i = 0; i < len; ++i) {
            require(
                bookingDetails[_ids[i]].status == BookingStatus.confirmed,
                "Check the Booking status"
            );
        }
        for (uint8 i = 0; i < len; ++i) {
            bookingDetails[_ids[i]].status = BookingStatus.expired;
            IBukNFTs(nftContract).burn(
                bookingDetails[_ids[i]].owner,
                _ids[i],
                1,
                true
            );
        }
        emit CheckoutRooms(_ids, true);
    }

    /**
     * @dev See {IBukProtocol-cancelRoom}.
     */
    function cancelRoom(
        uint256 _id,
        uint256 _penalty,
        uint256 _refund,
        uint256 _charges
    ) external onlyRole(ADMIN_ROLE) {
        require(
            (bookingDetails[_id].status == BookingStatus.confirmed),
            "Not a confirmed Booking"
        );
        require(
            ((_penalty + _refund + _charges) < (bookingDetails[_id].total + 1)),
            "Transfer amount exceeds total"
        );
        IBukNFTs bukNftsContract = IBukNFTs(nftContract);
        bookingDetails[_id].status = BookingStatus.cancelled;
        IBukTreasury(_bukTreasury).cancelUSDCRefund(_penalty, _bukWallet);
        IBukTreasury(_bukTreasury).cancelUSDCRefund(
            _refund,
            bookingDetails[_id].owner
        );
        IBukTreasury(_bukTreasury).cancelUSDCRefund(_charges, _bukWallet);
        bukNftsContract.burn(bookingDetails[_id].owner, _id, 1, false);
        emit CancelRoom(_id, true);
    }

    /**
     * @dev See {IBukProtocol-getRoyaltyInfo}.
     */
    //TODO Need to confirm the access to this function
    function getRoyaltyInfo() external view returns (Royalty[] memory) {
        return royalties;
    }

    /**
     * @dev Function to do the booking payment.
     * @param _commission Total BUK commission.
     * @param _total Total Booking Charge Excluding BUK commission.
     */
    function _bookingPayment(
        uint256 _commission,
        uint256 _total
    ) internal returns (bool) {
        IERC20(_currency).transferFrom(_msgSender(), _bukWallet, _commission);
        IERC20(_currency).transferFrom(_msgSender(), _bukTreasury, _total);
        return true;
    }
}
