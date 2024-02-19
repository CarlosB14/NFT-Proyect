'use client'

import { useAccount, useWriteContract } from 'wagmi'
import { parseEther } from 'viem'
import { wagmiContract } from './contract'

function MintBtn() {
  const account = useAccount()
  const { writeContract } = useWriteContract()
  const mint = () => {
    writeContract({
      ...wagmiContract,
      functionName: 'mint',
      value: parseEther('1')
    })
  }
  return (
    <>
      {account.status === 'connected' && (
        <button onClick={() => mint()}>
          Mint
        </button>
      )}
    </>
  )
}

export default MintBtn
