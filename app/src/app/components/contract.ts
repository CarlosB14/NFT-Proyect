import { maxUint256 } from "viem";

export const wagmiContract = {
  address: '0x5FbDB2315678afecb367f032d93F642f64180aa3',
  abi: [
    { inputs: [], stateMutability: 'nonpayable', type: 'constructor' },
    {
      anonymous: false,
      inputs: [],
      name: 'mint',
      type: 'function',
      stateMutability: 'payable',
      outputs: [],
    },
    {
      anonymous: false,
      inputs: [],
      name: 'balance',
      type: 'function',
      stateMutability: 'view',
      outputs: [{ type: 'uint256' }],
    },
  ],
} as const