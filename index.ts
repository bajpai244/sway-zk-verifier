import {bn, Provider, Wallet} from "fuels"
import {pi_a, pi_b, pi_c} from "./proof.json"
import publicSignals from "./public.json" 
import { SwayVerifierFactory } from "./fuels-out"

const main = async () => {

    const PROVIDER_URL="http://127.0.0.1:4000/v1/graphql"
    // Default funded account on local fuel-core
    const PRIVATE_KEY="0xde97d8624a438121b86a1956544bd72ed68cd69f2c99555b08b1e8c51ffd511c"

    const provider = new Provider(PROVIDER_URL);
    const wallet = Wallet.fromPrivateKey(PRIVATE_KEY, provider);

    const factory = new SwayVerifierFactory(wallet);
    const {contract} = await (await factory.deploy()).waitForResult()


    const a= pi_a.map((v) => {
        return bn(v);
    }).slice(0, 2)

    const b= pi_b.map((v) => {
        return v.map((v) => {
            return bn(v);
        })
    }).slice(0, 2)

    const c= pi_c.map((v) => {
        return bn(v);
    }).slice(0, 2)

    const publicSignalBN = publicSignals.map((v) => {
        return bn(v);
    })
    
    console.log(a, b, c, publicSignalBN);

    const {transactionId} = await contract.functions.verify_proof(a, b, c, publicSignalBN).call();

    console.log("result is: ", res);
}

main();