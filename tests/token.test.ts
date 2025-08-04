import { describe, it, expect, beforeEach } from 'vitest'

type Principal = string

interface EduFundTokenState {
  admin: Principal
  paused: boolean
  totalSupply: bigint
  balances: Map<Principal, bigint>
  staked: Map<Principal, bigint>
  delegations: Map<Principal, Principal>
  MAX_SUPPLY: bigint
}

const ZERO_ADDRESS = 'SP000000000000000000002Q6VF78'

let state: EduFundTokenState

const createMockState = (): EduFundTokenState => ({
  admin: 'ST1ADMINADDRESS00000000000000000000000000',
  paused: false,
  totalSupply: 0n,
  balances: new Map(),
  staked: new Map(),
  delegations: new Map(),
  MAX_SUPPLY: 50_000_000n
})

const isAdmin = (caller: Principal) => caller === state.admin

const setPaused = (caller: Principal, pause: boolean) => {
  if (!isAdmin(caller)) return { error: 100 }
  state.paused = pause
  return { value: pause }
}

const mint = (caller: Principal, recipient: Principal, amount: bigint) => {
  if (!isAdmin(caller)) return { error: 100 }
  if (recipient === ZERO_ADDRESS) return { error: 105 }
  if (state.totalSupply + amount > state.MAX_SUPPLY) return { error: 103 }
  const balance = state.balances.get(recipient) || 0n
  state.balances.set(recipient, balance + amount)
  state.totalSupply += amount
  return { value: true }
}

const transfer = (caller: Principal, recipient: Principal, amount: bigint) => {
  if (state.paused) return { error: 104 }
  if (recipient === ZERO_ADDRESS) return { error: 105 }
  const bal = state.balances.get(caller) || 0n
  if (bal < amount) return { error: 101 }
  state.balances.set(caller, bal - amount)
  const recipientBal = state.balances.get(recipient) || 0n
  state.balances.set(recipient, recipientBal + amount)
  return { value: true }
}

const stake = (caller: Principal, amount: bigint) => {
  if (state.paused) return { error: 104 }
  const bal = state.balances.get(caller) || 0n
  if (bal < amount) return { error: 101 }
  state.balances.set(caller, bal - amount)
  const stakedBal = state.staked.get(caller) || 0n
  state.staked.set(caller, stakedBal + amount)
  return { value: true }
}

const unstake = (caller: Principal, amount: bigint) => {
  if (state.paused) return { error: 104 }
  const stakedBal = state.staked.get(caller) || 0n
  if (stakedBal < amount) return { error: 102 }
  state.staked.set(caller, stakedBal - amount)
  const bal = state.balances.get(caller) || 0n
  state.balances.set(caller, bal + amount)
  return { value: true }
}

const delegate = (caller: Principal, to: Principal) => {
  if (state.paused) return { error: 104 }
  if (to === ZERO_ADDRESS) return { error: 105 }
  state.delegations.set(caller, to)
  return { value: to }
}

// -------------------- TESTS --------------------

describe('EduFund Token Contract', () => {
  const user1 = 'ST1USER1111111111111111111111111111111111'
  const user2 = 'ST1USER2222222222222222222222222222222222'

  beforeEach(() => {
    state = createMockState()
  })

  it('should allow minting by admin', () => {
    const result = mint(state.admin, user1, 1_000n)
    expect(result).toEqual({ value: true })
    expect(state.balances.get(user1)).toBe(1000n)
    expect(state.totalSupply).toBe(1000n)
  })

  it('should prevent minting over max supply', () => {
    const result = mint(state.admin, user1, 100_000_000n)
    expect(result).toEqual({ error: 103 })
  })

  it('should transfer tokens', () => {
    mint(state.admin, user1, 500n)
    const result = transfer(user1, user2, 200n)
    expect(result).toEqual({ value: true })
    expect(state.balances.get(user1)).toBe(300n)
    expect(state.balances.get(user2)).toBe(200n)
  })

  it('should not transfer if paused', () => {
    mint(state.admin, user1, 500n)
    setPaused(state.admin, true)
    const result = transfer(user1, user2, 100n)
    expect(result).toEqual({ error: 104 })
  })

  it('should allow staking', () => {
    mint(state.admin, user1, 1000n)
    const result = stake(user1, 400n)
    expect(result).toEqual({ value: true })
    expect(state.balances.get(user1)).toBe(600n)
    expect(state.staked.get(user1)).toBe(400n)
  })

  it('should prevent unstaking more than staked', () => {
    mint(state.admin, user1, 1000n)
    stake(user1, 300n)
    const result = unstake(user1, 500n)
    expect(result).toEqual({ error: 102 })
  })

  it('should allow unstaking', () => {
    mint(state.admin, user1, 1000n)
    stake(user1, 300n)
    const result = unstake(user1, 200n)
    expect(result).toEqual({ value: true })
    expect(state.staked.get(user1)).toBe(100n)
    expect(state.balances.get(user1)).toBe(900n)
  })

  it('should allow delegating vote power', () => {
    const result = delegate(user1, user2)
    expect(result).toEqual({ value: user2 })
    expect(state.delegations.get(user1)).toBe(user2)
  })

  it('should fail delegate to zero address', () => {
    const result = delegate(user1, ZERO_ADDRESS)
    expect(result).toEqual({ error: 105 })
  })
})