var ValidatorClient = require("@nymproject/nym-validator-client").default;

function genAddress() {
    let mnemonic = ValidatorClient.randomMnemonic();

    ValidatorClient.mnemonicToAddress(mnemonic).then((address) => {
        console.log("mnemonic:", mnemonic);
        console.log("address:",address);
    })
}

genAddress()
