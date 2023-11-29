#!/bin/bash

# Define the file path
FILE_PATH="./circuits/contract/circuits/plonk_vk.sol"

# Determine the OS and execute the appropriate sed command
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS uses BSD sed, which requires an empty string argument with -i
    sed -i '' 's/function verify(bytes calldata _proof, bytes32\[\] calldata _publicInputs) external view returns (bool) {/function verify(bytes memory _proof, bytes32[] memory _publicInputs) public view returns (bool) {/' "$FILE_PATH"
else
    # Linux uses GNU sed, which does not require an empty string with -i
    sed -i 's/function verify(bytes calldata _proof, bytes32\[\] calldata _publicInputs) external view returns (bool) {/function verify(bytes memory _proof, bytes32[] memory _publicInputs) public view returns (bool) {/' "$FILE_PATH"
fi

# Solidity code to append
CODE='
interface IFunctionVerifier {
    function verify(bytes32 _inputHash, bytes32 _outputHash, bytes memory _proof) external returns (bool);

    function verificationKeyHash() external pure returns (bytes32);
}

contract FunctionVerifier is IFunctionVerifier, UltraVerifier {
    event VerifyInputs(bytes32 input0, bytes32 input1, bytes proof);

    function verify(bytes32 _inputHash, bytes32 _outputHash, bytes memory _proof) external returns (bool) {
        bytes32[] memory input = new bytes32[](2);
        input[0] = bytes32(uint256(_inputHash) & ((1 << 253) - 1));
        input[1] = bytes32(uint256(_outputHash) & ((1 << 253) - 1));

        emit VerifyInputs(input[0], input[1], _proof);

        return this.verify(_proof, input);
    }

    function verificationKeyHash() external pure returns (bytes32) {
        return keccak256(abi.encode(UltraVerificationKey.verificationKeyHash()));
    }
}
'

# Append the code to the file
echo "$CODE" >> "$FILE_PATH"
