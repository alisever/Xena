import geometry.tarski_2
open classical set
namespace Euclidean_plane
variables {point : Type} [Euclidean_plane point]

local attribute [instance, priority 0] prop_decidable

-- Right Angles

def R (a b c : point) : Prop := eqd a c a (S b c)

theorem R.symm {a b c : point} : R a b c → R c b a :=
begin
intro h,
have h1 := seven13 b a (S b c),
simp at h1,
unfold R at h,
exact (eqd.trans h h1).flip
end

theorem eight3 {a b c a' : point} : R a b c → a ≠ b → col b a a' → R a' b c :=
begin
intros h h1 h2,
unfold R at *,
exact four17 h1.symm h2 (seven5 b c).2 h
end

theorem R.flip {a b c : point} : R a b c → R a b (S b c) :=
begin
intro h,
unfold R at *,
simpa using h.symm
end

@[simp] theorem eight4 (a b : point) : R a a b := (seven5 a b).2

@[simp] theorem eight5a (a b : point) : R a b b := (eight4 b a).symm

theorem eight6 {a b c a' : point} : R a b c → R a' b c → B a c a' → b = c :=
begin
intros h h1 h2,
unfold R at *,
generalize h3 : S b c = c',
rw h3 at *,
have : c = c',
  exact four19 h2 h h1.flip,
rw ←this at *,
exact (seven10.1 h3)
end

theorem eight7 {a b c : point} : R a b c → R a c b → b = c :=
begin
intros h h1,
have h_1 : eqd a c a (S b c),
  unfold R at h,
  exact h,
have h_2 : eqd a b a (S c b),
  unfold R at h1,
  exact h1,
have h2 := seven5 b c,
generalize h3 : S b c = c',
rw h3 at *,
generalize h4 : S c a = a',
by_contradiction h5,
have h6 : col c b c',
  left,
  exact h2.1,
have h7 := eight3 h1.symm h5 h6,
unfold R at h7,
rw h4 at h7,
have h8 := seven5 c a,
rw h4 at h8,
have h9 := h8.2,
have h10 : R a' b c,
  unfold R,
  rw h3,
  exact eqd.trans h9.symm.flip (eqd.trans h_1 h7.flip),
exact h5 (eight6 h h10 h8.1)
end

theorem eight8 {a b : point} : R a b a → a = b :=
begin
intro h,
exact eight7 (eight5a b a).symm h 
end

theorem eight9 {a b c : point} : R a b c → col a b c → a = b ∨ c = b :=
begin
intros h h1,
cases em (a = b),
  simp *,
right,
have h2 := eight3 h h_1 (four11 h1).2.1,
exact eight8 h2
end

theorem eight10 {a b c a' b' c' : point} : R a b c → cong a b c a' b' c' → R a' b' c' :=
begin
intros h h1,
cases em (b = c),
  rw h_1 at *,
  have h2 : b' = c',
    exact id_eqd h1.2.1.symm,
  rw h2,
  exact eight5a a' c',
unfold R at *,
generalize h2 : S b c = d,
generalize h3 : S b' c' = d',
have h4 := seven5 b c,
have h5 := seven5 b' c',
rw h2 at *,
rw h3 at *,
have h6 : afs c b d a c' b' d' a',
  repeat {split},
    exact h4.1,
    exact h5.1,
    exact h1.2.1.flip,
    exact eqd.trans h4.2.symm (eqd.trans h1.2.1 h5.2),
    exact h1.2.2.flip,
  exact h1.1.flip,
have h7 := afive_seg h6 (ne.symm h_1),
exact eqd.trans h1.2.2.symm (eqd.trans h h7.flip)
end

def xperp (x : point) (A A' : set point) : Prop := line A ∧ line A' ∧ x ∈ A ∧ x ∈ A' ∧
∀ {u v}, u ∈ A → v ∈ A' → R u x v

def perp (A A' : set point) : Prop := ∃ x, xperp x A A'

notation A ` ⊥ ` B  := perp A B

theorem xperp.symm {x : point} {A A' : set point} : xperp x A A' → xperp x A' A :=
begin
intro h,
unfold xperp at *,
split,
  exact h.2.1,
split,
  exact h.1,
split,
  exact h.2.2.2.1,
split,
  exact h.2.2.1,
intros u v hu hv,
exact (h.2.2.2.2 hv hu).symm
end

theorem perp.symm {A A' : set point} : perp A A' → perp A' A :=
begin
intro h,
cases h with x hx,
constructor,
exact hx.symm
end

theorem eight14a {A A' : set point} : perp A A' → A ≠ A' :=
begin
intros h h1,
subst A',
rcases h with ⟨x, h1, h2, h3, h4, h5⟩,
cases six22 h1 h3 with y hy,
rw hy.2 at h5,
exact hy.1.symm (eight8 (h5 (six17b x y) (six17b x y)))
end

theorem eight14b {x : point} {A A' : set point} : xperp x A A' → A ≠ A' :=
λ h, eight14a ⟨x, h⟩

theorem eight14c {x : point} {A A' : set point} : xperp x A A' ↔ perp A A' ∧ is x A A' :=
begin
split,
  intro h,
  split,
  constructor,
    exact h,
  have h1 : perp A A',
    constructor,
      exact h,
  unfold xperp at h,
  unfold is,
  split,
    exact h.1,
  split,
    exact h.2.1,
  split,
    exact eight14a h1,
  split,
    exact h.2.2.1,
  exact h.2.2.2.1,
intro h,
cases h with h h1,
cases h with y hy,
unfold is at h1,
suffices : x = y,
  rwa ←this at hy,
by_contradiction,
suffices : A = A',
  exact h1.2.2.1 this,
apply six21 a h1.1 h1.2.1 h1.2.2.2.1 h1.2.2.2.2,
  unfold xperp at hy,
  exact hy.2.2.1,
exact hy.2.2.2.1
end

theorem eight14d {x y : point} {A A' : set point} : xperp x A A' → xperp y A A' → x = y :=
begin
intros hx hy,
by_contradiction,
have h : perp A A',
  constructor,
    exact hx,
have h1 := eight14a h,
suffices : A = A',
  exact h1 this,
unfold xperp at *,
exact six21 a hx.1 hx.2.1 hx.2.2.1 hx.2.2.2.1 hy.2.2.1 hy.2.2.2.1
end

theorem eight14e {A A' : set point} : perp A A' → line A ∧ line A' :=
begin
intro h,
cases h with x hx,
split,
  exact hx.1,
exact hx.2.1
end

theorem eight14f {a b c : point} {A : set point} : perp (l a b) A → col a b c → a ≠ c → perp (l a c) A :=
begin
intros h h1 h2,
suffices : l a b = l a c,
  rwa ←this,
exact six18 (eight14e h).1 h2 (six17a a b) h1
end

theorem eight13 {x : point} {A A' : set point} : xperp x A A' ↔ line A ∧ line A' ∧ x ∈ A ∧ x ∈ A' ∧
∃ u v, u ∈ A ∧ v ∈ A' ∧ u ≠ x ∧ v ≠ x ∧ R u x v :=
begin
split,
  intro h,
  split,
    exact h.1,
  split,
    exact h.2.1,
  split,
    exact h.2.2.1,
  split,
    exact h.2.2.2.1,
  unfold xperp at h,
  cases six22 h.1 h.2.2.1 with u hu,
  cases six22 h.2.1 h.2.2.2.1 with v hv,
  existsi u,
  existsi v,
  have h1 : u ∈ A,
    rw hu.2,
    simp,
  have h2 : v ∈ A',
    rw hv.2,
    simp,
  split,
    exact h1,
  split,
    exact h2,
  split,
    exact hu.1.symm,
  split,
    exact hv.1.symm,
  exact h.2.2.2.2 h1 h2,
intro h,
unfold xperp,
split,
  exact h.1,
split,
  exact h.2.1,
split,
  exact h.2.2.1,
split,
  exact h.2.2.2.1,
intros a b ha hb,
cases h.2.2.2.2 with u hu,
cases hu with v hv,
have h1 : R a x v,
  apply eight3 hv.2.2.2.2 hv.2.2.1,
  have h_1 : A = l x u,
    exact six18 h.1 hv.2.2.1.symm h.2.2.1 hv.1,
  rw h_1 at ha,
  exact ha,
apply R.symm,
apply eight3 h1.symm hv.2.2.2.1,
have h_2 : A' = l x v,
  exact six18 h.2.1 hv.2.2.2.1.symm h.2.2.2.1 hv.2.1,
rw h_2 at hb,
exact hb
end

theorem perp_of_R {a b c : point} : a ≠ b → c ≠ b → R a b c → perp (l a b) (l c (S b c)) :=
λ h h1 h2, ⟨b, eight13.2 ⟨six14 h, six14 (seven12b h1).symm, six17b a b,
or.inr (or.inl (seven5 b c).1.symm), a, c, six17a a b, six17a c (S b c), h, h1, h2⟩⟩

theorem xperp_of_R {a b c : point} : a ≠ b → c ≠ b → R a b c → xperp b (l a b) (l c b) :=
λ h h1 h2, eight13.2 ⟨six14 h, six14 h1, six17b a b,
six17b c b, a, c, six17a a b, six17a c b, h, h1, h2⟩

theorem eight15 {x : point} {A B : set point} : perp A B → x ∈ A → x ∈ B → xperp x A B :=
begin
intros h h1 h2,
cases h with y hy,
suffices : x = y,
  subst x,
  exact hy,
by_contradiction h_1,
apply eight14b hy,
apply six21 h_1,
  exact hy.1,
  exact hy.2.1,
  exact h1,
  exact h2,
  exact hy.2.2.1,
exact hy.2.2.2.1
end

theorem eight16 {a b c u x : point} : col a b x → col a b u → u ≠ x →
(c ≠ x ∧ perp (l a b) (l c x) ↔ ¬col a b c ∧ R c x u) :=
begin
intros h1 h2 h3,
split,
  intro h4,
  have h5 : xperp x (l a b) (l c x),
    exact eight15 h4.2 h1 (six17b c x), 
  split,
    intro h_1,
    apply eight14b h5,
    exact six18 h5.1 h4.1 h_1 h1,
  apply R.symm,  
  exact h5.2.2.2.2 h2 (six17a c x),
intro h4,
cases h4 with h4 h5,
have h_1 : c ≠ x,
  intro h_1,
  rw h_1 at h4,
  exact h4 h1,
split,
  exact h_1,
existsi x,
apply eight13.2,
split,
  exact six14 (six26 h4).1,
split,
  exact six14 h_1,
split,
  exact h1,
split,
  simp,
existsi u,
existsi c,
split,
  exact h2,
split,
  exact (six17a c x),
split,
  exact h3,
split,
  exact h_1,
exact h5.symm
end

theorem eight18 {a b c : point} : ¬col a b c → ∃! x, col a b x ∧ perp (l a b) (l c x) :=
begin
intros h,
cases seg_cons a a c b with y hy,
cases seven25 hy.2.symm with p hp,
have h1: R a p y,
  unfold R,
  suffices : S p y = c,
    rw this,
    exact hy.2,
  exact (seven6 hp.symm).symm,
cases seg_cons y y p a with z hz,
cases seg_cons y y a p with q hq,
generalize hq' : S z q = q',
cases seg_cons y y c q' with c' hc',
have h2 : afs a y z q q y p a,
  focus {repeat {split}},
    exact hz.1,
    exact hq.1.symm,
    exact hq.2.symm.flip,
    exact hz.2,
    exact two5 (eqd.refl a q),
  exact hq.2,
have h3 : a ≠ y,
  intro h_1,
  rw h_1 at *,
  have : y = c,
    exact id_eqd hy.2.symm,
  exact (six26 h).2.2 this,
have h4 := afive_seg h2 h3,
have h5 : cong a p y q z y,
  split,
    exact h4.symm.flip,
  split,
    exact hz.2.symm.flip,
  exact hq.2.symm.flip,
have h6 := (eight10 h1 h5).symm,
have h7 : eqd y q y q',
  unfold R at h6,
  rwa hq' at h6,
cases seven25 hc'.2 with x hx,
existsi x,
have h8 : R y x c,
  unfold R,
  suffices : S x c = c',
    rw this,
    exact hc'.2.symm,
  exact (seven6 hx.symm).symm,
have h9 : c ≠ y,
  intro h_1,
  rw ←h_1 at hy,
  apply h,
  right, right,
  exact hy.1.symm,
have h10 : y ≠ p,
  intro h_1,
  rw ←h_1 at hp,
  unfold M at hp,
  apply h9,
  exact id_eqd hp.2.flip,
have h11 : hourglass q q' y c c' z x,
  have h_1 := seven5 z q,
  rw hq' at h_1,
  focus {repeat {split}},
    exact (three7a hp.1 hq.1 h10.symm).symm,
    exact hc'.1,
    exact h7,
    exact hc'.2.symm,
    exact h_1.1,
    exact h_1.2,
    exact hx.1.symm,
  exact hx.2.symm,
have h12 := seven22 h11,
have h13 : y ≠ z,
  intro h_1,
  rw ←h_1 at hz,
  exact h10 (id_eqd hz.2.symm),
have h14 : a ≠ y,
  intro h_1,
  rw ←h_1 at hy,
  apply (six26 h).2.2,
  exact id_eqd hy.2.symm,
have h15 : l y z = l a b,
  apply six18 (six14 h13) (six26 h).1,
    right, right,
    exact hz.1,
  right, right,
  exact three7a hy.1 hz.1 h14,
have h16 : c ≠ x,
  intro h_1,
  rw h_1 at *,
  apply h,
  have h_2 : x ∈ l a b,
    rw ←h15,
  right, right,
  exact h12.symm,
  exact h_2,
have h17 : q ≠ z,
  intro h_1,
  rw h_1 at *,
  have h_2 : B z y c,
    exact three7b hq.1.symm hp.1.symm h10,
  apply h,
  suffices : c ∈ l a b,
    exact this,
  rw ←h15,
  right, right,
  exact h_2.symm,
have h18 : xperp x (l y z) (l c x),
  apply eight13.2,
  split,
    exact six14 h13,
  split,
    exact (six14 h16),
  split,
    right, right,
    exact h12.symm,
  split,
    simp,
  existsi y,
  existsi c,
  simp,
  split,
    intro h_1,
    rw h_1 at *,
    have h_1 : q ∈ l c x,
      left,
      exact three7a hp.1 hq.1 h10.symm,
    have h_2 : q' ∈ l c x,
      suffices : c' ≠ x,
        cases five2 this hx.1 hc'.1.symm,
          right, right,
          exact h_2.symm,
        right, left,
        exact h_2,
      intro h_2,
      rw h_2 at *,
      apply h9,
      exact id_eqd hx.2.symm.flip,
    have h_3 := seven5 z q,
    rw hq' at h_3,
    have h_4 : q ≠ q',
      intro h_4,
      rw ←h_4 at *,
      apply h17,
      exact seven3.1 h_3,
    have h_5 : l c x = l q q',
      exact six18 (six14 h9) h_4 h_1 h_2,
    have h_6 : z ∈ l c x,
      rw h_5,
      right, left,
      exact h_3.1.symm,
    have h_7 := (four11 h_6).2.2.1,
    have h_8 : c ∈ l a b,
      rw ←h15,
      exact h_7,
    exact h h_8,
  split,
    exact h16,
  exact h8,
rw h15 at h18,
have h19 : x ∈ l y z,
  right, right,
  exact h12.symm,
split,
  split,
    rw h15 at h19,
    exact h19,
  constructor,
    exact h18,
intros x' hx',
have h20 : c ≠ x',
  intro h_1,
  apply h,
  rw ←h_1 at hx',
  exact hx'.1,
have h21 : xperp x' (l a b) (l c x'),
  exact eight15 hx'.2 hx'.1 (six17b c x'),
have h22 : R c x x',
  apply (h18.symm).2.2.2.2,
    simp,
  exact hx'.1,
have h23 : R c x' x,
  apply (h21.symm).2.2.2.2,
    simp,
  rw ←h15,
  exact h19,
exact eight7 h23 h22
end

theorem eight17 {a : point} {A : set point} : line A → a ∉ A → ∃! x, xperp x A (l a x) :=
begin
intros h h1,
rcases h with ⟨p, q, hq, h2⟩,
subst h2,
have h3 : ¬col p q a,
  intro h_1,
  exact h1 h_1,
cases eight18 h3 with x hx,
refine ⟨x, eight15 hx.1.2 hx.1.1 (six17b a x), _⟩,
intros y hy,
exact hx.2 y ⟨hy.2.2.1, y, hy⟩
end

theorem eight19 {p q r : point} (a : point) : R p q r ↔ R (S a p) (S a q) (S a r) :=
begin
unfold R,
split,
  intro h,
  suffices : (S (S a q) (S a r)) = (S a (S q r)),
    rw this,
    exact (seven16 a).1 h,
  have h1 := seven5 (S a q) (S a r),
  suffices : M (S a r) (S a q) (S a (S q r)),
    exact seven4 h1 this,
  apply (seven14 a).1,
  exact seven5 q r,
intro h,
suffices : S a ((S (S a q) (S a r))) = S q r,
  rw ←this,
  apply (seven16 a).2,
  simp,
  exact h,
suffices : S a (S a (S (S a q) (S a r))) = (S a (S q r)),
  exact seven9 this,
simp,
have h1 := seven5 (S a q) (S a r),
suffices : M (S a r) (S a q) (S a (S q r)),
  exact seven4 h1 this,
apply (seven14 a).1,
exact seven5 q r
end

theorem eight20 {a b c p : point} : R a b c → M (S a c) p (S b c) → R b a p ∧ (b ≠ c → a ≠ p) :=
begin
intros h h1,
have h2 := seven5 b c,
have h3 := seven5 a b,
have h4 := seven5 a c,
have h5 := seven5 a (S b c),
have h6 := seven5 a p,
have h7 : R (S a b) b c,
  cases em (a = b),
    rw h_1 at *,
    simp,
    apply eight3 h h_1,
  left,
  exact h3.1,
have h8 := (eight19 a).1 h7,
unfold R at h7,
have h9 := (seven16 a).1 h7,
simp at *,
have h10 : ifs (S a c) p (S b c) b (S a (S b c)) (S a p) c b,
  focus {repeat {split}},
    exact h1.1,
    have h_1 := (seven15 a).1 h1.1,
    simp at h_1,
    exact h_1.symm,
    apply two5,
    have h_2 := seven13 a (S a c) (S b c),
    simp at h_2,
    exact h_2,
    apply eqd.trans h1.2.symm,
    have h_3 := seven13 a p (S a c),
    simp at h_3,
    exact h_3,
    exact h9.flip,
  exact h2.2.symm.flip,
have h11 := four2 h10,
split,
  unfold R,
  exact h11.flip,
intros hbc hap,
apply hbc,
have h12 := seven7 a c,
rw hap at *,
have h13 := seven5 p (S p c),
simp at h13,
have h14 := seven4 h13 h1,
rw ←h14 at h2,
exact (seven3.1 h2).symm
end

theorem eight21 {a b : point} (hab : a ≠ b) (c : point) : ∃ p t, perp (l a b) (l p a) ∧ col a b t ∧ B c t p :=
begin
cases em (col a b c) with habc h,
  cases six25 hab with c' h,
  cases eight18 h with x hx,
  have h1 : c' ≠ x,
    intro h_1,
    rw h_1 at *,
    exact h hx.1.1,
  have h2 : xperp x (l a b) (l c' x),
    exact eight15 hx.1.2 hx.1.1 (six17b c' x),
  unfold xperp at h2,
  have h3 := h2.2.2.2.2 (six17a a b) (six17a c' x),
  unfold R at h3,
  have h4 := seven5 a c',
  cases seven25 (eqd.trans h4.2.symm h3) with p hp,
  have h5 := eight20 (h2.2.2.2.2 (six17a a b) (six17a c' x)) hp,
  have h6 := h5.2 h1.symm,
  existsi p,
  existsi c,
  cases em (x = a),
    rw h_1 at hx,
    rw h_1 at hp,
    have h_2 : S a c' = p,
      exact seven3.1 hp,
    rw h_2 at h4,
    have h_3 : col c' a p,
      left,
      exact h4.1,
    have h_4 : l c' a = l p a,
      apply six18 (six14 (six26 h).2.2.symm) h6.symm h_3 (six17b c' a),
    have h_5 := hx.1,
    rw h_4 at h_5,
    split,
      exact h_5.2,
    split,
      exact habc, 
    exact three3 c p,
  split,
    existsi a,
    apply eight13.2,
    split,
      exact six14 (six26 h).1,
    split,
      exact six14 h6.symm,
    split,
      simp,
    split,
      simp,
    existsi x,
    existsi p,
    split,
      exact hx.1.1,
    simp,
    split,
      exact h_1,
    split,
      exact h6.symm,
    exact h5.1,
  split,
    exact habc,
  exact three3 c p,
cases eight18 h with x hx,
have h1 : c ≠ x,
  intro h_1,
  rw h_1 at *,
  exact h hx.1.1,
have h2 : xperp x (l a b) (l c x),
  exact eight15 hx.1.2 hx.1.1 (six17b c x),
unfold xperp at h2,
have h3 := h2.2.2.2.2 (six17a a b) (six17a c x),
unfold R at h3,
have h4 := seven5 a c,
cases seven25 (eqd.trans h4.2.symm h3) with p hp,
have h5 := eight20 (h2.2.2.2.2 (six17a a b) (six17a c x)) hp,
have h6 := h5.2 h1.symm,
cases three17 (seven5 x c).1.symm h4.1.symm hp.1.symm with t ht,
cases em (x = a),
  rw h_1 at ht,
  existsi p,
  existsi a,
  have h_2 : t = a,
    exact (bet_same ht.2).symm,
  rw h_2 at *,
  rw h_1 at hx,
  have h_3 := hx.1,
  have h_4 : l c a = l p a,
    apply six18 (six14 (six26 h).2.2.symm) h6.symm,
      left,
      exact ht.1.symm,
    simp,
  rw h_4 at h_3,
  split,
    exact h_3.2,
  split,
    exact h_3.1,
  exact ht.1.symm,
existsi p,
existsi t,
have h7 : col a b t,
  have h_2 : col a x t,
    right, left,
    exact ht.2,
  exact five4 (ne.symm h_1) (four11 hx.1.1).1 h_2,
split,
  existsi a,
  apply eight13.2,
  split,
    exact six14 (six26 h).1,
  split,
    exact six14 h6.symm,
  split,
    simp,
  split,
    simp,
  existsi x,
  existsi p,
  split,
    exact hx.1.1,
  split,
    simp,
  split,
    exact h_1,
  split,
    exact h6.symm,
  exact h5.1,
split,
  exact h7,
exact ht.1.symm
end

lemma eight23 {a b p q t t' r : point} (hp : ((l a b) ⊥ l p a) ∧ col a b t' ∧ B a t' p)
(ht : ((l b a) ⊥ l q b) ∧ col b a t ∧ B p t q) (hr : B b r q ∧ eqd a p b r): ∃ x, M a x b ∧ M p x r := 
begin
have h : a ≠ b,
  exact six13 (eight14e hp.1).1,
cases pasch ht.2.2 hr.1 with x hx,
have h1 : col a b x,
  have h_1 : col b t x,
    right, left,
    exact hx.1,
  cases em (b = t),
    rw ←h_2 at *,
    have h_3 : x = b,
      exact (bet_same hx.1).symm,
    rw h_3,
    left,
    exact three1 a b,
  exact (four11 (five4 h_2 (four11 ht.2.1).1 h_1)).2.1,
have h2 : xperp a (l a b) (l p a),
  exact eight15 hp.1 (four11 (four12 a b)).1 (six17b p a),
have h3 : xperp b (l b a) (l q b),
  exact eight15 ht.1 (four11 (four12 b a)).1 (six17b q b),
have h4 := h2.2.2.2.2 (six17b a b) (six17a p a),
have h5 := h3.2.2.2.2 (six17b b a) (six17a q b),
have h6 : R a b r,
  have : col b q r,
    right, left,
    exact hr.1.symm,
  exact (eight3 h5.symm (six13 h3.2.1) this).symm,
have h7 : ¬col a p b,
  intro h_1,
  cases eight9 h4 (four11 h_1).2.2.2.1,
    exact h h_2.symm,
  exact (six13 h2.2.1) h_2,
have h8 : ¬col a b r,
  intro h_1,
  cases eight9 h6 h_1,
    exact h h_2,
  rw h_2 at *,
  exact (six13 h2.2.1).symm (id_eqd hr.2),
suffices : eqd b p a r,
  have h_1 : p ≠ r,
    intro h_1,
    rw h_1 at hx,
    have h_2 : r = x,
      exact bet_same hx.2,
    rw h_2 at h8,
    exact h8 h1,
  constructor,
  apply seven21 h7 h_1 hr.2 this.flip (four11 h1).1,
  left,
  exact hx.2.symm,
have h9 : x ≠ a,
  intro h_1,
  rw h_1 at *,
  have h_2 : col a p r,
    right, right,
    exact hx.2,
  have h_3 : R r a b,
    exact eight3 h4.symm (six13 h2.2.1) h_2, 
  apply h,
  exact eight7 h_3 h6.symm,
have h10 := seven5 a p,
cases seg_cons x x r (S a p) with r' hr',
cases seven25 hr'.2 with m hm,
have h11 := seven5 m r,
have h12 := seven4 h11 hm.symm,
have h13 : R x m r,
  unfold R,
  rw ←h12 at hr',
  exact hr'.2.symm,
have h14 : R x a p,
  exact eight3 h4 (ne.symm h) h1,
have h15 : ¬col x p (S a p),
  intro h_1,
  have h_2 : col p a (S a p),
    left,
    exact (seven5 a p).1,
  have h_3 : p ≠ (S a p),
    intro h_3,
    exact (six13 h2.2.1) (seven10.1 h_3.symm).symm,
  have h_4 : col p a x,
    exact five4 h_3 (four11 h_2).1 (four11 h_1).2.2.1,
  cases eight9 h14.symm h_4,
    exact (six13 h2.2.1) h_5,
  exact h9 h_5,
have h16 : hourglass p (S a p) x r r' a m,
  focus {repeat {split}},
    exact hx.2.symm,
    exact hr'.1,
    unfold R at h14,
    exact h14,
    exact hr'.2.symm,
    exact h10.1,
    exact h10.2,
    rw ←h12,
    exact h11.1,
    rw ←h12,
  exact h11.2,
have h17 := seven22 h16,
have h18 : r ≠ m,
  intro h_1,
  rw ←h_1 at h17,
  have h_2 : col a x r,
    left,
    exact h17,
  apply h8,
  exact five4 h9.symm (four11 h1).1 h_2,
have h19 : x ≠ m,
  intro h_1,
  have h_2 : col r x p,
    left,
    exact hx.2,
  have h_3 : x ≠ r',
    intro h_3,
    rw [←h_1, ←h_3] at h12,
    rw ←h_1 at h18,
    apply h18,
    exact seven9 (eq.trans h12 (seven11 x).symm),
  have h_4 : col r x (S a p),
    have h_4 : col x r' (S a p),
      right, right,
      exact hr'.1,
    have h_5 : col x r' r,
      rw h_1,
      right, right,
      exact hm.1.symm,
    exact (four11 (five4 h_3 h_5 h_4)).2.1,
  have h_5 : x ≠ r,
    intro h_5,
    rw h_5 at h_1,
    exact h18 h_1,
  apply h15,
  exact five4 h_5 (four11 h_2).2.1 (four11 h_4).2.1,
have h20 : col a b m,
  have h_1 : col a x m,
    left,
    exact h17,
  exact five4 h9.symm (four11 h1).1 h_1,
have h21 : xperp b (l a b) (l r b),
  apply eight13.2,
  split,
    exact six14 h,
  split,
    exact six14 (six26 h8).2.1.symm,
  split,
    simp,
  split,
    simp,
  existsi a,
  existsi r,
  simp,
  split,
    exact h,
  split,
    exact (six26 h8).2.1.symm,
  exact h6,
have h22 : xperp m (l a b) (l r m),
  apply eight13.2,
  split,
    exact six14 h,
  split,
    exact six14 h18,
  split,
    exact h20,
  split,
    simp,
  existsi x,
  existsi r,
  split,
    exact h1,
  simp,
  split,
    exact h19,
  split,
    exact h18,
  exact h13,
have h23 : perp (l a b) (l r b),
  constructor,
  exact h21,
have h24 : perp (l a b) (l r m),
  constructor,
  exact h22,
have h25 : m = b,
  apply unique_of_exists_unique (eight18 h8),
    split,
      exact h20,
    exact h24,
  split,
    left,
    exact three1 a b,
  exact h23,
subst m,
have h26 : ifs (S a p) a p r r b r' (S a p),
  focus {repeat {split}},
    exact h10.1.symm,
    exact hm.1.symm,
    apply two4,
    apply two11 h10.1 hm.1.symm,
      exact hr.2.flip,
      exact eqd.trans h10.2.symm (eqd.trans hr.2 hm.2.symm),
    exact eqd.trans hr.2 hm.2.symm,
    exact two4 (eqd.refl r (S a p)),
  apply two5,
  apply two11 hx.2.symm hr'.1,
    unfold R at h14,
    exact h14.flip,
  exact hr'.2.symm,
have h27 := four2 h26,
unfold R at h4,
exact eqd.trans h4 h27.symm
end

theorem eight22 (a b : point) : ∃! x, M a x b :=
begin
cases em (a = b),
  rw h,
  existsi b,
  split,
    apply seven3.2,
    refl,
  intros y hy,
  exact (seven3.1 hy).symm,
apply exists_unique_of_exists_of_unique,
  cases eight21 h a with p hp,
  cases eight21 (ne.symm h) p with q hq,
  cases hp with t' hp,
  cases hq with t ht,
  cases five10 a p b q,
    cases h_1 with r hr,
    cases eight23 hp ht hr with x hx,
    constructor,
    exact hx.1,
  suffices : ∃ x, M b x a,
    cases this with x hx,
    constructor,
    exact hx.symm,
  cases h_1 with r hr,
  have : ∃ x, M b x a ∧ M q x r,
    apply eight23,
        split,
          exact ht.1,
        split,
          exact (four11 (four12 b a)).1,
        exact three3 b q,
      split,
        exact hp.1,
      split,
        exact (four11 ht.2.1).2.1,
      exact ht.2.2.symm,
    exact hr,
  cases this with x hx,
  constructor,
  exact hx.1,  
intros x y hx hy,
exact seven17 hx hy
end

theorem eight24 {a b p q r t : point} : perp (l p a) (l a b) → perp (l q b) (l a b) → 
col a b t → B p t q → B b r q → eqd a p b r → ∃ x, M a x b ∧ M p x r :=
begin
intros g3 g4 g5 g6 g7 g8,
have g9 := (four11 (four12 a b)).1,
have g10 := three3 a p,
have g11 := six17 a b,
rw g11 at g4,
have hp : ((l a b) ⊥ l p a) ∧ col a b a ∧ B a a p,
  exact ⟨g3.symm, ⟨g9, g10⟩⟩,
have ht : ((l b a) ⊥ l q b) ∧ col b a t ∧ B p t q,
  exact ⟨g4.symm, ⟨(four11 g5).2.1, g6⟩⟩,
have hr : B b r q ∧ eqd a p b r,
  exact ⟨g7, g8⟩,
exact eight23 hp ht hr
end

theorem eight25 {a b : point} : a ≠ b → ∃ c, R a b c ∧ c ≠ b :=
begin
intro h,
rcases eight21 h.symm a with ⟨c, p, h1⟩,
refine ⟨c, (eight15 h1.1 (six17a b a) (six17b c b)).2.2.2.2 (six17b b a) (six17a c b), _⟩,
exact six13 (eight14e h1.1).2
end

end Euclidean_plane