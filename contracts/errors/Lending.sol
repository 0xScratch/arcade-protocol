// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "../libraries/LoanLibrary.sol";

/**
 * @title LendingErrors
 * @author Non-Fungible Technologies, Inc.
 *
 * This file contains all custom errors for the lending protocol, with errors prefixed
 * by the contract that throws them (e.g., "OC_" for OriginationController). Errors
 * located in one place to make it easier to holistically look at all possible
 * protocol failure cases.
 */

// ==================================== ORIGINATION CONTROLLER ======================================
/// @notice All errors prefixed with OC_, to separate from other contracts in the protocol.

/// @notice Zero address passed in where not allowed.
error OC_ZeroAddress();

/**
 * @notice One of the predicates for item verification failed.
 *
 * @param verifier                      The address of the verifier contract.
 * @param data                          The verification data (to be parsed by verifier).
 * @param vault                         The user's vault subject to verification.
 */
error OC_PredicateFailed(address verifier, bytes data, address vault);

/**
 * @notice A caller attempted to approve themselves.
 *
 * @param caller                        The caller of the approve function.
 */
error OC_SelfApprove(address caller);

/**
 * @notice A caller attempted to originate a loan with their own signature.
 *
 * @param caller                        The caller of the approve function, who was also the signer.
 */
error OC_ApprovedOwnLoan(address caller);

/**
 * @notice The signature could not be recovered to the counterparty or approved party.
 *
 * @param target                        The target party of the signature, which should either be the signer,
 *                                      or someone who has approved the signer.
 * @param signer                        The signer determined from ECDSA.recover.
 */
error OC_InvalidSignature(address target, address signer);

/**
 * @notice The verifier contract specified in a predicate has not been whitelisted.
 *
 * @param verifier                      The verifier the caller attempted to use.
 */
error OC_InvalidVerifier(address verifier);

/**
 * @notice The function caller was neither borrower or lender, and was not approved by either.
 *
 * @param caller                        The unapproved function caller.
 */
error OC_CallerNotParticipant(address caller);

/**
 * @notice Two related parameters for batch operations did not match in length.
 */
error OC_BatchLengthMismatch();

// ==================================== ITEMS VERIFIER ======================================
/// @notice All errors prefixed with IV_, to separate from other contracts in the protocol.

/**
 * @notice Provided SignatureItem is missing an address.
 */
error IV_ItemMissingAddress();

/**
 * @notice Provided SignatureItem has an invalid collateral type.
 * @dev    Should never actually fire, since cType is defined by an enum, so will fail on decode.
 *
 * @param asset                        The NFT contract being checked.
 * @param cType                        The collateralTytpe provided.
 */
error IV_InvalidCollateralType(address asset, uint256 cType);

/**
 * @notice Provided ERC1155 signature item is requiring a non-positive amount.
 *
 * @param asset                         The NFT contract being checked.
 * @param amount                        The amount provided (should be 0).
 */
error IV_NonPositiveAmount1155(address asset, uint256 amount);

/**
 * @notice Provided ERC1155 signature item is requiring an invalid token ID.
 *
 * @param asset                         The NFT contract being checked.
 * @param tokenId                       The token ID provided.
 */
error IV_InvalidTokenId1155(address asset, int256 tokenId);

/**
 * @notice Provided ERC20 signature item is requiring a non-positive amount.
 *
 * @param asset                         The NFT contract being checked.
 * @param amount                        The amount provided (should be 0).
 */
error IV_NonPositiveAmount20(address asset, uint256 amount);


// ==================================== REPAYMENT CONTROLLER ======================================
/// @notice All errors prefixed with RC_, to separate from other contracts in the protocol.

/**
 * @notice Could not dereference loan from borrowerNoteId.
 *
 * @param target                     The loanId being checked.
 */
error RC_CannotDereference(uint256 target);

/**
 * @notice Repayment has already been completed for this loan without installments.
 *
 * @param amount                     Balance returned after calculating amount due.
 */
error RC_NoPaymentDue(uint256 amount);

/**
 * @notice Caller is not the owner of lender note.
 *
 * @param caller                     Msg.sender of the function call.
 */
error RC_OnlyLender(address caller);

/**
 * @notice Loan has not started yet.
 *
 * @param startDate                 block timestamp of the startDate of loan stored in LoanData.
 */
error RC_BeforeStartDate(uint256 startDate);

/**
 * @notice Loan does not have any installments.
 *
 * @param numInstallments           Number of installments returned from LoanTerms.
 */
error RC_NoInstallments(uint256 numInstallments);

/**
 * @notice No interest payment or late fees due.
 *
 * @param amount                    Minimum interest plus late fee amount returned
 *                                  from minimum payment calculation.
 */
error RC_NoMinPaymentDue(uint256 amount);

/**
 * @notice Repaid amount must be larger than zero.
 *
 * @param amount                    Amount function call parameter.
 */
error RC_RepayPartGTZero(uint256 amount);

/**
 * @notice Amount paramater less than the minimum amount due.
 *
 * @param amount                    Amount function call parameter.
 */
error RC_RepayPartGTMin(uint256 amount);

// ==================================== Loan Core ======================================
/// @notice All errors prefixed with LC_, to separate from other contracts in the protocol.

/**
 * @notice Loan duration must be greater than 1hr and less than 3yrs.
 *
 * @param durationSecs                 Total amount of time in seconds.
 */
error LC_LoanDuration(uint256 durationSecs);

/**
 * @notice Check collateral is not already used in a active loan.
 *
 * @param collateralAddress             Address of the collateral.
 * @param collateralId                  ID of the collateral token.
 */
error LC_CollateralInUse(address collateralAddress, uint256 collateralId);

/**
 * @notice Interest must be greater than 0.01%. (interestRate / 1e18 >= 1)
 *
 * @param interestRate                  InterestRate with 1e18 multiplier.
 */
error LC_InterestRate(uint256 interestRate);

/**
 * @notice Loan terms must have even number of installments and intallment periods must be < 1000000.
 *
 * @param numInstallments               Number of installment periods in loan.
 */
error LC_NumberInstallments(uint256 numInstallments);

/**
 * @notice Ensure valid initial loan state when starting loan.
 *
 * @param state                         Current state of a loan according to LoanState enum.
 */
error LC_StartInvalidState(LoanLibrary.LoanState state);

/**
 * @notice Loan duration has not expired.
 *
 * @param dueDate                       Timestamp of the end of the loan duration.
 */
error LC_NotExpired(uint256 dueDate);

/**
 * @notice Loan duration has not expired.
 *
 * @param returnAmount                  Total amount due for entire loan repayment.
 */
error LC_BalanceGTZero(uint256 returnAmount);

/**
 * @notice Loan duration has not expired.
 *
 * @param user                          Address of collateral owner.
 * @param nonce                         Represents the number of transactions sent by address.
 */
error LC_NonceUsed(address user, uint160 nonce);

// ================================== Full Insterest Amount Calc ====================================
/// @notice All errors prefixed with FIAC_, to separate from other contracts in the protocol.

/**
 * @notice Interest must be greater than 0.01%. (interestRate / 1e18 >= 1)
 *
 * @param interestRate                  InterestRate with 1e18 multiplier.
 */
error FIAC_InterestRate(uint256 interestRate);


// ==================================== Promissory Note ======================================
/// @notice All errors prefixed with PN_, to separate from other contracts in the protocol.

/**
 * @notice Caller of mint function must have the MINTER_ROLE in AccessControl.
 *
 * @param caller                        Address of the function caller.
 */
error PN_MintingRole(address caller);

/**
 * @notice Caller of burn function must have the BURNER_ROLE in AccessControl.
 *
 * @param caller                        Address of the function caller.
 */
error PN_BurningRole(address caller);



/**
 * @notice No token transfers while contract is in paused state.
 */
error PN_ContractPaused();
