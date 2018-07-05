structure Euclidean_plane :=
(Point : Type)
(Line : Type)
(is_on : Point → Line → Prop)
(line_through_points : ∀ p q : Point, p ≠ q → ∃! L : Line, is_on p L ∧ is_on q L)
(Line_segment : Type)


