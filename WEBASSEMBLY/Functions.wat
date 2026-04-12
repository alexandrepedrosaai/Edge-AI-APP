(module
  (memory $mem 2)

  ;; Approximate sine using Taylor expansion around 0
  ;; sin(x) ≈ x - x^3/3! + x^5/5! - x^7/7!
  (func $sin (param $x f32) (result f32)
    (local $x2 f32) (local $x3 f32) (local $x5 f32) (local $x7 f32)
    local.get $x
    local.get $x
    f32.mul
    local.set $x2

    local.get $x2
    local.get $x
    f32.mul
    local.set $x3

    local.get $x3
    local.get $x2
    f32.mul
    local.set $x5

    local.get $x5
    local.get $x2
    f32.mul
    local.set $x7

    ;; x - x^3/6 + x^5/120 - x^7/5040
    local.get $x
    local.get $x3
    f32.const 6
    f32.div
    f32.sub
    local.get $x5
    f32.const 120
    f32.div
    f32.add
    local.get $x7
    f32.const 5040
    f32.div
    f32.sub)

  ;; Approximate cosine using Taylor expansion
  ;; cos(x) ≈ 1 - x^2/2! + x^4/4! - x^6/6!
  (func $cos (param $x f32) (result f32)
    (local $x2 f32) (local $x4 f32) (local $x6 f32)
    local.get $x
    local.get $x
    f32.mul
    local.set $x2

    local.get $x2
    local.get $x2
    f32.mul
    local.set $x4

    local.get $x4
    local.get $x2
    f32.mul
    local.set $x6

    ;; 1 - x^2/2 + x^4/24 - x^6/720
    f32.const 1
    local.get $x2
    f32.const 2
    f32.div
    f32.sub
    local.get $x4
    f32.const 24
    f32.div
    f32.add
    local.get $x6
    f32.const 720
    f32.div
    f32.sub)

  ;; Tangent: tan(x) = sin(x)/cos(x)
  (func $tan (param $x f32) (result f32)
    local.get $x
    call $sin
    local.get $x
    call $cos
    f32.div)

  ;; Export functions
  (export "sin" (func $sin))
  (export "cos" (func $cos))
  (export "tan" (func $tan))
)
