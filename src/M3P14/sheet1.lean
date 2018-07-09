import data.nat.gcd
import data.nat.modeq
import data.nat.prime
import tactic.norm_num


-- Definitions:

-- A square-free integer is an integer which is divisible by no perfect square other than 1.
def square_free_int (a : ℕ) := ∀ n : ℕ, (n*n) ∣ a → n = 1


-- Questions:

-- TODO : change ℕ to ℤ, but before that need to extend gcd to integers.

namespace nat

-- Show that for a, b, d integers, we have (da, db) = d(a,b).
theorem q1a (a b d : ℕ) : gcd (d*a) (d*b) = d * (gcd a b) := gcd_mul_left d a b

-- Let a, b, n integers, and suppose that n|ab. Show that n/(a,b) divides b.
theorem q1b (a b n : ℕ) (ha : a > 0) (hn : n > 0) : n ∣ (a*b) → (n / gcd a n) ∣ b := λ h,
have n / gcd n a ∣ b * (a / gcd n a) := dvd_of_mul_dvd_mul_right (gcd_pos_of_pos_left a hn) 
begin
  rw ← nat.mul_div_assoc _ (gcd_dvd_right n a),
  rw nat.div_mul_cancel (gcd_dvd_left n a),
  rw mul_comm b,
  rwa nat.div_mul_cancel (dvd_trans (gcd_dvd_left n a) h),
end,
begin
  cases exists_eq_mul_left_of_dvd h with c hc,
  have := coprime.dvd_of_dvd_mul_right 
    (coprime_div_gcd_div_gcd (gcd_pos_of_pos_left a hn)) this,
  rwa gcd_comm,
end

-- Express 18 as an integer linear combination of 327 and 120.
theorem q2a : ∃ x y : ℤ, 18 = 327*x + 120*y := 
    ⟨-66, 180, by norm_num⟩

-- Find, with proof, all solutions to the linear diophantine equation 100x + 68y = 14.
theorem q2b : ∀ x y : ℤ, 100*x + 68*y = 14 := sorry

-- Find a multiplicative inverse of 31 modulo 132.
theorem q2c : ∃ x : ℤ, 31*x % 132 = 1 := 
    ⟨115, by norm_num⟩

-- Find an integer congruent to 3 mod 9 and congruent to 1 mod 49.
theorem q2d : ∃ x : ℤ, x % 9 = 3 → x % 49 = 1 :=  
    ⟨-195, by norm_num⟩

-- Find, with proof, the smallest nonnegative integer n such that n = 1 (mod 3), n = 4 (mod 5), and n = 3 (mod 7).
theorem q2e : ∃ n : ℤ, ∀ n₂ : ℕ, n % 3 = 1 → n % 5 = 4 → n % 7 = 3
                            → n₂ % 3 = 1 → n₂ % 5 = 4 → n₂ % 7 = 3 → n ≤ n₂ 
                            := sorry

-- Let m and n be integers. Show that the greatest common divisor of m and n is the unique positive integer d such that:
--      - d divides both m and n, and
--      - if x divides both m and n, then x divides d.
theorem q3 : ∀ m n : ℕ, ∃! d : ℕ, ∀ x : ℤ, gcd m n = d → d ∣ m → d ∣ n → x ∣ m → x ∣ n → x ∣ d
                                    := sorry

-- Let a and b be nonzero integers. Show that there is a unique positive integer m with the following two properties:
--      - a and b divide m, and
--      - if n is any number divisible by both a and b, then m|n.
-- The number m is called the least common multiple of a and b.
theorem q4a : ∀ a b : ℤ, ∃! m : ℕ, ∀ n : ℤ, a ≠ 0 → b ≠ 0 →   
                                a ∣ m → b ∣ m → a ∣ n → b ∣ n → m ∣ n
                                := sorry 

-- Show that the least common multiple of a and b is given by |ab|/(a,b)
theorem q4b : ∀ a b : ℤ, lcm a b = abs(a*b)/(gcd (a:ℕ) (b:ℕ)) := sorry


-- Let m and n be positive integers, and let K be the kernel of the map:
--      ℤ/mnℤ → ℤ/mℤ x ℤ/nℤ 
-- that takes a class mod mn to the corresponding classes modulo m and n.
-- Show that K has (m, n) elements. What are they?
theorem q5 :

-- Show that the equation ax = b (mod n) has no solutions if b is not divisible by (a, n), and exactly (a, n) solutions in ℤ/n otherwise.
-- TODO: how to specify "there are exactly n solutions to an equation"?
theorem q6 : -- ¬(gcd a n ∣ b) → ¬(∃ x, a*x ≡ b [MOD n])

-- For n a positive integer, let σ(n) denote the sum Σ d for d∣n and d>0, of the positive divisors of n.
-- Show that the function n ↦ σ(n) is multiplicative.
theorem q7 :

-- Let p be a prime, and a be any integer. Show that a^(p²+p+1) is congruent to a^3 modulo p.
theorem q8: ∀ a p : ℤ, prime p →  a^(p^2+p+1) ≡ a^3 [MOD p] := sorry

-- Let n be a squarefree positive integer, and suppose that for all primes p dividing n, we have (p-1)∣(n - 1).
-- Show that for all integers a with (a, n) = 1, we have a^n = a (mod n).
theorem q9 : ∀ n p a, square_free_int n → prime p → p ∣ n → (p-1)∣(n - 1) → gcd a n = 1 → a^n ≡ a [MOD n] := sorry

-- Let n be a positive integer. Show that Σ Φ(d) for d∣n and d>0 = n.
-- [Hint: First show that the number of integers a with a ≤ 0 < n and (a, n) = n/d is equal to Φ(d).] 
theorem q10 :


end nat