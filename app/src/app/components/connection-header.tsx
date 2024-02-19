'use client'

import { useAccount, useConnect, useDisconnect } from 'wagmi'

function ConnectionHeader() {
  const account = useAccount()
  const { connectors, connect, status, error } = useConnect()
  const { disconnect } = useDisconnect()
  
  const formatAddress = (address: `0x${string}` | undefined) => {
    if (!address) return ''
    return `${address.slice(0, 6)}...${address.slice(-4)}`
  }

  return (
    <>
      <header className='header'>
        <h1>NFT-Project</h1>
        <nav>
          <ul>
            <li>
              {formatAddress(account.address)}
            </li>
            {account.status === 'connected' && (
              <li>
                <button type="button" onClick={() => disconnect()}>
                  Disconnect
                </button>
              </li>
            )}
            {connectors.map((connector) => (
              <button
                key={connector.uid}
                onClick={() => connect({ connector })}
                type="button"
              >
                {connector.name}
              </button>
            ))}
          </ul>
        </nav>
      </header>
    </>
  )
}

export default ConnectionHeader
