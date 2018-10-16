package youtube.solidity.learning;

import org.web3j.crypto.CipherException;
import org.web3j.crypto.Credentials;
import org.web3j.crypto.WalletUtils;
import org.web3j.protocol.Web3j;
import org.web3j.protocol.core.methods.response.TransactionReceipt;
import org.web3j.protocol.core.methods.response.Web3ClientVersion;
import org.web3j.protocol.http.HttpService;
import org.web3j.tx.RawTransactionManager;
import org.web3j.tx.TransactionManager;
import org.web3j.tx.Transfer;
import org.web3j.utils.Convert;
import youtube.solidity.learning.contracts.AddressBook;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.List;

public class Main {

    private final static String PRIVATE_KEY = "087db5d7c2647f17e4d028f65d46babac4525eb7f810fec992a3eac10cc53ae1";

    private final static BigInteger GAS_LIMIT = BigInteger.valueOf(6721975L);
    private final static BigInteger GAS_PRICE = BigInteger.valueOf(20000000000L);

    private final static String RECIPIENT = "0x466B6E82CD017923298Db45C5a3Db7c66Cd753C8";

    private final static String CONTRACT_ADDRESS = "0x2cf178c0fcf153dd0f40db1af064824a8c6751a5";

    public static void main(String[] args) {
        try {
            new Main();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Main() throws Exception {
        Web3j web3j = Web3j.build(new HttpService());

        Credentials credentials = getCredentialsFromPrivateKey();

        AddressBook addressBook = loadContract(CONTRACT_ADDRESS, web3j, credentials);

        removeAddress(addressBook);

        printAddresses(addressBook);
    }

    private void printWeb3Version(Web3j web3j) {
        Web3ClientVersion web3ClientVersion = null;
        try {
            web3ClientVersion = web3j.web3ClientVersion().send();
        } catch (IOException e) {
            e.printStackTrace();
        }
        String web3ClientVersionString = web3ClientVersion.getWeb3ClientVersion();
        System.out.println("Web3 client version: " + web3ClientVersionString);
    }

    private Credentials getCredentialsFromWallet() throws IOException, CipherException {
        return WalletUtils.loadCredentials(
                "passphrase",
                "wallet/path"
        );
    }

    private Credentials getCredentialsFromPrivateKey() {
        return Credentials.create(PRIVATE_KEY);
    }

    private void transferEthereum(Web3j web3j, Credentials credentials) throws Exception {
        TransactionManager transactionManager = new RawTransactionManager(
                web3j,
                credentials
        );

        Transfer transfer = new Transfer(web3j, transactionManager);

        TransactionReceipt transactionReceipt = transfer.sendFunds(
                RECIPIENT,
                BigDecimal.ONE,
                Convert.Unit.ETHER,
                GAS_PRICE,
                GAS_LIMIT
        ).send();

        System.out.print("Transaction = " + transactionReceipt.getTransactionHash());
    }

    private String deployContract(Web3j web3j, Credentials credentials) throws Exception {
        return AddressBook.deploy(web3j, credentials, GAS_PRICE, GAS_LIMIT)
                .send()
                .getContractAddress();
    }

    private AddressBook loadContract(String contractAddress, Web3j web3j, Credentials credentials) {
        return AddressBook.load(contractAddress, web3j, credentials, GAS_PRICE, GAS_LIMIT);
    }

    private void addAddresses(AddressBook addressBook) throws Exception {
        addressBook
                .addAddress("0x256a04B9F02036Ed2f785D8f316806411D605285", "Tom")
                .send();

        addressBook
                .addAddress("0x82CDf5a3192f2930726637e9C738A78689a91Be3", "Susan")
                .send();

        addressBook
                .addAddress("0x95F57F1DD015ddE7Ec2CbC8212D0ae2faC9acA11", "Bob")
                .send();
    }

    private void printAddresses(AddressBook addressBook) throws Exception {
        for (Object address : addressBook.getAddresses().send()) {
            String addressString = address.toString();
            String alias = addressBook.getAlias(addressString).send();
            System.out.println("Address " + addressString + " aliased as " + alias);
        }
    }

    private void removeAddress(AddressBook addressBook) throws Exception {
        addressBook
                .removeAddress("0x256a04B9F02036Ed2f785D8f316806411D605285")
                .send();
    }
}
