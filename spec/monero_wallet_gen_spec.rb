require 'spec_helper'

describe MoneroWalletGen do
  it 'generates a standard address from private key' do
    priv_key = '0000000000000000000000000000000000000000000000000000000000000000'

    expect(MoneroWalletGen::generate_from_private_key(priv_key)).to eq(
      mnemonic: "abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey",
      priv_spend_key: "0000000000000000000000000000000000000000000000000000000000000000",
      priv_view_key: "9b1529acb638f497d05677d7505d354b4ba6bc95484008f6362f93160ef3e503",
      pub_spend_key: "0100000000000000000000000000000000000000000000000000000000000000",
      pub_view_key: "23f1e4bd6597b5e5b8f8716f5d5c06e2ad85081da71f5e0ba6d5b4ed92b57566",
      address: "41fJjQDhryD11111111111111111111111111111111112N1GuTZeagfRbbKcALdcZev4QXGGuoLh2x36LhaxLSxCc2YDhi"
    )
  end

  it 'generates a testnet address from private key' do
    priv_key = '0000000000000000000000000000000000000000000000000000000000000000'

    expect(MoneroWalletGen::generate_from_private_key(priv_key, testnet: true)).to eq(
      mnemonic: "abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey",
      priv_spend_key: "0000000000000000000000000000000000000000000000000000000000000000",
      priv_view_key: "9b1529acb638f497d05677d7505d354b4ba6bc95484008f6362f93160ef3e503",
      pub_spend_key: "0100000000000000000000000000000000000000000000000000000000000000",
      pub_view_key: "23f1e4bd6597b5e5b8f8716f5d5c06e2ad85081da71f5e0ba6d5b4ed92b57566",
      address: "9sCrDesy9LK11111111111111111111111111111111112N1GuTZeagfRbbKcALdcZev4QXGGuoLh2x36LhaxLSxCZ3Viua"
    )
  end

  it 'generates a random standard address' do
    address = MoneroWalletGen::generate

    expect(address[:mnemonic]).to_not be_nil
    expect(address[:priv_spend_key]).to_not be_nil
    expect(address[:priv_view_key]).to_not be_nil
    expect(address[:pub_spend_key]).to_not be_nil
    expect(address[:pub_view_key]).to_not be_nil
    expect(address[:address]).to_not be_nil

    expect(address[:address][0]).to eq('4')
  end

  it 'generates a random testnet address' do
    address = MoneroWalletGen::generate(testnet: true)

    expect(address[:mnemonic]).to_not be_nil
    expect(address[:priv_spend_key]).to_not be_nil
    expect(address[:priv_view_key]).to_not be_nil
    expect(address[:pub_spend_key]).to_not be_nil
    expect(address[:pub_view_key]).to_not be_nil
    expect(address[:address]).to_not be_nil

    expect(address[:address][0]).to eq('9')
  end
end
