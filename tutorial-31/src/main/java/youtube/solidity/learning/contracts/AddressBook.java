package youtube.solidity.learning.contracts;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;
import org.web3j.abi.TypeReference;
import org.web3j.abi.datatypes.Address;
import org.web3j.abi.datatypes.DynamicArray;
import org.web3j.abi.datatypes.Function;
import org.web3j.abi.datatypes.Type;
import org.web3j.abi.datatypes.Utf8String;
import org.web3j.crypto.Credentials;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.RemoteCall;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.tx.Contract;
import org.web3j.tx.TransactionManager;

/**
 * <p>Auto generated code.
 * <p><strong>Do not modify!</strong>
 * <p>Please use the <a href="https://docs.web3j.io/command_line.html">web3j command line tools</a>,
 * or the org.web3j.codegen.SolidityFunctionWrapperGenerator in the 
 * <a href="https://github.com/web3j/web3j/tree/master/codegen">codegen module</a> to update.
 *
 * <p>Generated with web3j version 3.5.0.
 */
public class AddressBook extends Contract {
    private static final String BINARY = "608060405234801561001057600080fd5b50610639806100206000396000f3006080604052600436106100615763ffffffff7c01000000000000000000000000000000000000000000000000000000006000350416634ba79dfe811461006657806399900d1114610089578063a39fac121461011f578063d033c45614610184575b600080fd5b34801561007257600080fd5b50610087600160a060020a03600435166101eb565b005b34801561009557600080fd5b506100aa600160a060020a0360043516610386565b6040805160208082528351818301528351919283929083019185019080838360005b838110156100e45781810151838201526020016100cc565b50505050905090810190601f1680156101115780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561012b57600080fd5b50610134610438565b60408051602080825283518183015283519192839290830191858101910280838360005b83811015610170578181015183820152602001610158565b505050509050019250505060405180910390f35b34801561019057600080fd5b5060408051602060046024803582810135601f8101859004850286018501909652858552610087958335600160a060020a03169536956044949193909101919081908401838280828437509497506104a29650505050505050565b33600090815260208190526040812054905b818110156103815733600090815260208190526040902080548290811061022057fe5b600091825260209091200154600160a060020a03848116911614156103795733600090815260208190526040902054600110801561026057506001820381105b156102e5573360009081526020819052604090208054600019840190811061028457fe5b60009182526020808320909101543383529082905260409091208054600160a060020a0390921691839081106102b657fe5b9060005260206000200160006101000a815481600160a060020a030219169083600160a060020a031602179055505b3360009081526020819052604090208054600019840190811061030457fe5b60009182526020808320909101805473ffffffffffffffffffffffffffffffffffffffff191690553382528190526040902080549061034790600019830161050a565b50336000908152600160209081526040808320600160a060020a038716845290915281206103749161052e565b610381565b6001016101fd565b505050565b336000908152600160208181526040808420600160a060020a038616855282529283902080548451600294821615610100026000190190911693909304601f8101839004830284018301909452838352606093909183018282801561042c5780601f106104015761010080835404028352916020019161042c565b820191906000526020600020905b81548152906001019060200180831161040f57829003601f168201915b50505050509050919050565b336000908152602081815260409182902080548351818402810184019094528084526060939283018282801561049757602002820191906000526020600020905b8154600160a060020a03168152600190910190602001808311610479575b505050505090505b90565b3360008181526020818152604080832080546001808201835591855283852001805473ffffffffffffffffffffffffffffffffffffffff1916600160a060020a0389169081179091559484528252808320938352928152919020825161038192840190610575565b815481835581811115610381576000838152602090206103819181019083016105f3565b50805460018160011615610100020316600290046000825580601f106105545750610572565b601f01602090049060005260206000209081019061057291906105f3565b50565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106105b657805160ff19168380011785556105e3565b828001600101855582156105e3579182015b828111156105e35782518255916020019190600101906105c8565b506105ef9291506105f3565b5090565b61049f91905b808211156105ef57600081556001016105f95600a165627a7a7230582002b4cd1de8dbad4668d406cbb6ac585b72bbd2cfc54d016da10df49ff42ea9e90029";

    public static final String FUNC_REMOVEADDRESS = "removeAddress";

    public static final String FUNC_GETALIAS = "getAlias";

    public static final String FUNC_GETADDRESSES = "getAddresses";

    public static final String FUNC_ADDADDRESS = "addAddress";

    protected AddressBook(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    protected AddressBook(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        super(BINARY, contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }

    public RemoteCall<TransactionReceipt> removeAddress(String addr) {
        final Function function = new Function(
                FUNC_REMOVEADDRESS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(addr)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public RemoteCall<String> getAlias(String addr) {
        final Function function = new Function(FUNC_GETALIAS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(addr)), 
                Arrays.<TypeReference<?>>asList(new TypeReference<Utf8String>() {}));
        return executeRemoteCallSingleValueReturn(function, String.class);
    }

    public RemoteCall<List> getAddresses() {
        final Function function = new Function(FUNC_GETADDRESSES, 
                Arrays.<Type>asList(), 
                Arrays.<TypeReference<?>>asList(new TypeReference<DynamicArray<Address>>() {}));
        return new RemoteCall<List>(
                new Callable<List>() {
                    @Override
                    @SuppressWarnings("unchecked")
                    public List call() throws Exception {
                        List<Type> result = (List<Type>) executeCallSingleValueReturn(function, List.class);
                        return convertToNative(result);
                    }
                });
    }

    public RemoteCall<TransactionReceipt> addAddress(String addr, String alias) {
        final Function function = new Function(
                FUNC_ADDADDRESS, 
                Arrays.<Type>asList(new org.web3j.abi.datatypes.Address(addr), 
                new org.web3j.abi.datatypes.Utf8String(alias)), 
                Collections.<TypeReference<?>>emptyList());
        return executeRemoteCallTransaction(function);
    }

    public static RemoteCall<AddressBook> deploy(Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(AddressBook.class, web3j, credentials, gasPrice, gasLimit, BINARY, "");
    }

    public static RemoteCall<AddressBook> deploy(Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return deployRemoteCall(AddressBook.class, web3j, transactionManager, gasPrice, gasLimit, BINARY, "");
    }

    public static AddressBook load(String contractAddress, Web3j web3j, Credentials credentials, BigInteger gasPrice, BigInteger gasLimit) {
        return new AddressBook(contractAddress, web3j, credentials, gasPrice, gasLimit);
    }

    public static AddressBook load(String contractAddress, Web3j web3j, TransactionManager transactionManager, BigInteger gasPrice, BigInteger gasLimit) {
        return new AddressBook(contractAddress, web3j, transactionManager, gasPrice, gasLimit);
    }
}
