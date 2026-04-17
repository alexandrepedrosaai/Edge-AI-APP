(module
  (memory $mem 2)

  ;; sinh(x) = (e^x - e^-x)/2
  (func $sinh (param $x f32) (result f32)
    ;; approximate e^x using series expansion
    (local $x2 f32) (local $x3 f32) (local $x4 f32)
    (local $exp_pos f32) (local $exp_neg f32)
    
    local.get $x
    local.get $x
    f32.mul
    local.set $x2

    local.get $x2
    local.get $x
    f32.mul
    local.set $x3

    local.get $x3
    local.get $x
    f32.mul
    local.set $x4

    ;; e^x ≈ 1 + x + x^2/2 + x^3/6 + x^4/24
    f32.const 1
    local.get $x
    f32.add
    local.get $x2
    f32.const 2
    f32.div
    f32.add
    local.get $x3
    f32.const 6
    f32.div
    f32.add
    local.get $x4
    f32.const 24
    f32.div
    f32.add
    local.set $exp_pos

    ;; e^-x ≈ 1 - x + x^2/2 - x^3/6 + x^4/24
    f32.const 1
    local.get $x
    f32.sub
    local.get $x2
    f32.const 2
    f32.div
    f32.add
    local.get $x3
    f32.const 6
    f32.div
    f32.sub
    local.get $x4
    f32.const 24
    f32.div
    f32.add
    local.set $exp_neg

    ;; sinh(x) = (exp_pos - exp_neg)/2
    local.get $exp_pos
    local.get $exp_neg
    f32.sub
    f32.const 2
    f32.div)

  ;; cosh(x) = (e^x + e^-x)/2
  (func $cosh (param $x f32) (result f32)
    ;; approximate e^x using series expansion
    (local $x2 f32) (local $x3 f32) (local $x4 f32)
    (local $exp_pos f32) (local $exp_neg f32)
    
    local.get $x
    local.get $x
    f32.mul
    local.set $x2

    local.get $x2
    local.get $x
    f32.mul
    local.set $x3

    local.get $x3
    local.get $x
    f32.mul
    local.set $x4

    ;; e^x ≈ 1 + x + x^2/2 + x^3/6 + x^4/24
    f32.const 1
    local.get $x
    f32.add
    local.get $x2
    f32.const 2
    f32.div
    f32.add
    local.get $x3
    f32.const 6
    f32.div
    f32.add
    local.get $x4
    f32.const 24
    f32.div
    f32.add
    local.set $exp_pos

    ;; e^-x ≈ 1 - x + x^2/2 - x^3/6 + x^4/24
    f32.const 1
    local.get $x
    f32.sub
    local.get $x2
    f32.const 2
    f32.div
    f32.add
    local.get $x3
    f32.const 6
    f32.div
    f32.sub
    local.get $x4
    f32.const 24
    f32.div
    f32.add
    local.set $exp_neg

    ;; cosh(x) = (exp_pos + exp_neg)/2
    local.get $exp_pos
    local.get $exp_neg
    f32.add
    f32.const 2
    f32.div)

  ;; tanh(x) = sinh(x)/cosh(x)
  (func $tanh (param $x f32) (result f32)
    local.get $x
    call $sinh
    local.get $x
    call $cosh
    f32.div)

  ;; Export functions
  (export "sinh" (func $sinh))
  (export "cosh" (func $cosh))
  (export "tanh" (func $tanh))
)
