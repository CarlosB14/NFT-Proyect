import React, { useEffect, useState } from 'react'
import {
  http,
  Address,
  Hash,
  TransactionReceipt,
  createPublicClient,
  createWalletClient,
  custom,
  stringify,
  parseEther,
} from 'viem'
import { hardhat } from 'viem/chains'
import { wagmiContract } from './contract'

const publicClient = createPublicClient({
  chain: hardhat,
  transport: http(),
})
const walletClient = createWalletClient({
  chain: hardhat,
  transport: custom(window.ethereum!),
})

export function ConnectWallet() {
  const [account, setAccount] = useState<Address>()
  const [hash, setHash] = useState<Hash>()
  const [receipt, setReceipt] = useState<TransactionReceipt>()

  const connect = async () => {
    const [address] = await walletClient.requestAddresses()
    setAccount(address)
  }

  const mint = async () => {
    if (!account) return
    const { request } = await publicClient.simulateContract({
      ...wagmiContract,
      functionName: 'mint',
      account,
      value: parseEther('1')
    })
    const hash = await walletClient.writeContract(request)
    setHash(hash)
  }

  useEffect(() => {
    ; (async () => {
      if (hash) {
        const receipt = await publicClient.waitForTransactionReceipt({ hash })
        setReceipt(receipt)
      }
    })()
  }, [hash])

  if (account)
    return (
      <>
        <div>Connected: {account}</div>
        <button onClick={mint}>Mint</button>
        {receipt && (
          <>
            <div>
              Receipt:{' '}
              <pre>
                <code>{stringify(receipt, null, 2)}</code>
              </pre>
            </div>
          </>
        )}
      </>
    )
  return <button onClick={connect}>Connect Wallet</button>
}