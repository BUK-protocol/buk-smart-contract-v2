// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ISignatureVerifier {

  /**
   * @dev Function verify
   * Verifies the signature of a hashed message using ECDSA.
   * @param _hash The original message hash that was signed.
   * @param _signature The signature of the message.
   * @return The address of the signer who generated the given signature.
   */
  function verify(bytes32 _hash, bytes memory _signature) external view returns (address); 
}