# Monero Address Generator
Lets you generate a fully functional monero address which you can send money to.

## Installation
Install the gem:
```bash
gem install monero_wallet_gen
```

And require it from your ruby file:
```ruby
require 'monero_wallet_gen'
```
## Usage

**Generate a wallet from a private key**

```ruby
priv_key = '0000000000000000000000000000000000000000000000000000000000000000'
MoneroWalletGen::generate_from_private_key(priv_key)
# =>
{
  priv_spend_key: "0000000000000000000000000000000000000000000000000000000000000000",
  pub_spend_key: "0100000000000000000000000000000000000000000000000000000000000000",
  priv_view_key: "9b1529acb638f497d05677d7505d354b4ba6bc95484008f6362f93160ef3e503",
  pub_view_key: "23f1e4bd6597b5e5b8f8716f5d5c06e2ad85081da71f5e0ba6d5b4ed92b57566",
  address: "41fJjQDhryD11111111111111111111111111111111112N1GuTZeagfRbbKcALdcZev4QXGGuoLh2x36LhaxLSxCc2YDhi",
  mnemonic: "abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey"
}
```

**Generate a testnet wallet from a private key**

```ruby
priv_key = '0000000000000000000000000000000000000000000000000000000000000000'
MoneroWalletGen::generate_from_private_key(priv_key, testnet: true)
# =>
{
  priv_spend_key: "0000000000000000000000000000000000000000000000000000000000000000",
  pub_spend_key: "0100000000000000000000000000000000000000000000000000000000000000",
  priv_view_key: "9b1529acb638f497d05677d7505d354b4ba6bc95484008f6362f93160ef3e503",
  pub_view_key: "23f1e4bd6597b5e5b8f8716f5d5c06e2ad85081da71f5e0ba6d5b4ed92b57566",
  address: "9sCrDesy9LK11111111111111111111111111111111112N1GuTZeagfRbbKcALdcZev4QXGGuoLh2x36LhaxLSxCZ3Viua",
  mnemonic: "abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey"
}
```

**Generate a random wallet**
```ruby
MoneroWalletGen::generate
# =>
{
  priv_spend_key: "0000000000000000000000000000000000000000000000000000000000000000",
  pub_spend_key: "0100000000000000000000000000000000000000000000000000000000000000",
  priv_view_key: "9b1529acb638f497d05677d7505d354b4ba6bc95484008f6362f93160ef3e503",
  pub_view_key: "23f1e4bd6597b5e5b8f8716f5d5c06e2ad85081da71f5e0ba6d5b4ed92b57566",
  address: "41fJjQDhryD11111111111111111111111111111111112N1GuTZeagfRbbKcALdcZev4QXGGuoLh2x36LhaxLSxCc2YDhi",
  mnemonic: "abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey"
}
```

**Generate a random testnet wallet**
```ruby
MoneroWalletGen::generate(testnet: true)
# =>
{
  priv_spend_key: "0000000000000000000000000000000000000000000000000000000000000000",
  pub_spend_key: "0100000000000000000000000000000000000000000000000000000000000000",
  priv_view_key: "9b1529acb638f497d05677d7505d354b4ba6bc95484008f6362f93160ef3e503",
  pub_view_key: "23f1e4bd6597b5e5b8f8716f5d5c06e2ad85081da71f5e0ba6d5b4ed92b57566",
  address: "9sCrDesy9LK11111111111111111111111111111111112N1GuTZeagfRbbKcALdcZev4QXGGuoLh2x36LhaxLSxCZ3Viua",
  mnemonic: "abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey abbey"
}
```
