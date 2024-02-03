'use client'

import { useAccount, useWriteContract, useReadContract } from 'wagmi'
import { parseEther } from 'viem'
import { wagmiContract } from './contract'

function NFTCard() {
  const result = useReadContract({
    ...wagmiContract, 
    functionName: 'showNft',
  })
  return (
    <>
      <h2>NFT Card</h2>
      <p>Balance: {result.data?.toString()}</p>
    </>
  )
}

export default NFTCard
