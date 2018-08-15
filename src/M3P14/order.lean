import data.nat.prime data.nat.gcd data.nat.modeq data.nat.gcd algebra.group chris_hughes_various.zmod group_theory.order_of_element M3P14.order_zmodn_kmb M3P14.phi

open zmod nat

/- Gives actual number when evaluating (e.g. #5 becomes 5) -/
instance (n : ℕ) : has_repr (zmod n) := ⟨repr ∘ fin.val⟩ 
instance  {α : Type*} [monoid α] [has_repr α] : has_repr (units α) := ⟨repr ∘ units.val⟩ 

--set_option pp.all true
/- define a function that given (a : zmod n) and a n coprime, give back (a : units (zmod n)) -/
def units_zmod_mk (a n : ℕ ) (h : nat.coprime a n) [pos_nat n] : units (zmod n) := 
{
    val := a,
    inv := a⁻¹,
    val_inv := by rw [mul_inv_eq_gcd n a, coprime.gcd_eq_one h];dsimp;rw zero_add,
    inv_val := by rw [mul_comm, mul_inv_eq_gcd n a, coprime.gcd_eq_one h];dsimp;rw zero_add,
}

def units_to_zmod {n : ℕ} [monoid (zmod n)] (a : units (zmod n)) : zmod n := 
{
    val := a.val.val,
    is_lt := a.val.2,
}

def order_of_zmod (a n : ℕ) [pos_nat n] : ℕ := if h : nat.coprime a n then @order_of (units (zmod n)) _ _ _ (units_zmod_mk a n h) else 0

theorem pow_order_zmod_of_eq_one (a n : ℕ) [pos_nat n] : (a : zmod n) ^ order_of_zmod a n = 1 :=
begin
    have em : nat.coprime a n ∨ ¬ nat.coprime a n, from (classical.em (nat.coprime a n)),
    unfold order_of_zmod,
    cases em,
    {
        rw dif_pos em,
        have eq : (units_zmod_mk a n em) ^ order_of (units_zmod_mk a n em) = 1, from pow_order_of_eq_one (units_zmod_mk a n em),
        --have eq2 : (a : zmod n) ^ order_of (a : zmod n) = 1, from pow_order_of_eq_one (units_zmod_mk a n em),
        have eq3 : (units_zmod_mk a n em).val.val = (a : zmod n).val, unfold units_zmod_mk,
        --have eq4 : (units_zmod_mk a n em) = (a : zmod n), sorry,
        unfold units_zmod_mk at eq,
        --unfold units_to_zmod at eq,
        sorry,
    },
    rw dif_neg em,
    refl,
end

theorem order_zmod_div (a n d : ℕ) (h : coprime a n) [pos_nat n] : a^d ≡ 1 [MOD n] → order_of_zmod a n ∣ d := 
begin
    intro h,
    unfold order_of_zmod,
    unfold order_of,
    sorry
end

theorem order_zmod_div_phi_n (a n : ℕ) (h : coprime a n) [pos_nat n] : order_of_zmod a n ∣ phi n :=
begin
    have : a ^ (phi n) ≡ 1 [MOD n], from euler_phi_thm a n h,
    exact order_zmod_div a n (phi n) h this,
end

@[simp] lemma units.coe_pow {α : Type*} [monoid α] (u : units α) (n : ℕ) : (↑(u ^ n) : α) = u ^ n :=
by induction n; simp [*, _root_.pow_succ]

theorem pow_order_zmod_eq_one (a n : ℕ) (h: coprime a n) [pos_nat n] : (a : zmod n) ^ (order_of_zmod a n) = (1 : zmod n) := sorry
--by rw [units.coe_inj, ← units.coe_pow, pow_order_of_eq_one]

def primitive_root (a n : ℕ) [pos_nat n] := coprime a n ∧ order_of_zmod a n = phi n

theorem primitive_root_existence (n : ℕ) [pos_nat n] : ∃ a : ℕ, (primitive_root a n) ↔ n = 1 ∨ n = 2 ∨ n = 4 ∨ ∃ p r : ℕ, prime p ∧ r > 0 → (n = p^r ∨ n = 2*p^r) := sorry