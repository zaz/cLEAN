import Init.Data.Nat.Bitwise.Lemmas
import Lean.Elab.Command

-- Test that omega produces constructive proofs for decidable propositions

theorem omega_iff_nat (x : Nat) : (x + 1) % 2 = 1 ↔ x % 2 = 0 := by omega

theorem omega_pow_case (x n : Nat) (h : x < 2^(n+1)) :
    (2^(n+1) - (x + 1)) % 2 = 1 ↔ x % 2 = 0 := by omega

-- Verify no Classical.choice in decidable cases
open Lean Elab Command in
run_cmd do
  for name in #[``omega_iff_nat, ``omega_pow_case] do
    let axioms ← collectAxioms name
    if axioms.contains `Classical.choice then
      throwError "FAIL: {name} uses Classical.choice but shouldn't: {axioms}"
    logInfo m!"PASS: {name} is constructive: {axioms}"

-- Note: Nat.testBit_two_pow_sub_succ is a library theorem compiled by stage0,
-- so it won't be constructive until after a full bootstrap.
-- We verify the fix works by checking theorems compiled by stage1 above.
