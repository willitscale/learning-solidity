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

import java.io.IOException;
import java.math.BigDecimal;
import java.math.BigInteger;

public class Main {

    private final static String PRIVATE_KEY = "087db5d7c2647f17e4d028f65d46babac4525eb7f810fec992a3eac10cc53ae1";

    private final static BigInteger GAS_LIMIT = BigInteger.valueOf(6721975L);
    private final static BigInteger GAS_PRICE = BigInteger.valueOf(20000000000L);

    private final static String RECIPIENT = "0x466B6E82CD017923298Db45C5a3Db7c66Cd753C8";

    public static void main(String[] args) {
        try {
            new Main();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Main() throws Exception {
        Web3j web3j = Web3j.build(new HttpService());

        TransactionManager transactionManager = new RawTransactionManager(
                web3j,
                getCredentialsFromPrivateKey()
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
}
