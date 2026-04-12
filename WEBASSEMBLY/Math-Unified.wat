(module
  (memory $mem 8)

  ;; ---------------- Linear Algebra ----------------
  (func $vec_scalar_mul (param $ptr i32) (param $len i32) (param $scalar f32) (result i32) ... )
  (func $mat_transpose (param $A i32) (param $B i32) (param $N i32) (result i32) ... )
  (func $mat_mul (param $A i32) (param $B i32) (param $C i32) (param $N i32) (result i32) ... )
  (func $conv2d (param $input i32) (param $kernel i32) (param $output i32)
                (param $H i32) (param $W i32) (param $KH i32) (param $KW i32) (result i32) ... )

  ;; ---------------- Trigonometric ----------------
  (func $sin (param $x f32) (result f32) ... )
  (func $cos (param $x f32) (result f32) ... )
  (func $tan (param $x f32) (result f32)
    local.get $x
    call $sin
    local.get $x
    call $cos
    f32.div)

  ;; ---------------- Hyperbolic ----------------
  (func $sinh (param $x f32) (result f32) ... )
  (func $cosh (param $x f32) (result f32) ... )
  (func $tanh (param $x f32) (result f32)
    local.get $x
    call $sinh
    local.get $x
    call $cosh
    f32.div)

  ;; ---------------- Matrix Derivative ----------------
  (func $mat_derivative (param $A i32) (param $dA i32) (param $N i32) (param $dx f32) (result i32) ... )

  ;; ---------------- Irrational Numbers ----------------
  (func $pi (result f32) f32.const 3.14159265)
  (func $sqrt2 (result f32) f32.const 1.41421356)
  (func $phi (result f32)
    f32.const 1
    f32.const 5
    f32.sqrt
    f32.add
    f32.const 2
    f32.div)

  ;; ---------------- Exports ----------------
  (export "vec_scalar_mul" (func $vec_scalar_mul))
  (export "mat_transpose" (func $mat_transpose))
  (export "mat_mul" (func $mat_mul))
  (export "conv2d" (func $conv2d))
  (export "sin" (func $sin))
  (export "cos" (func $cos))
  (export "tan" (func $tan))
  (export "sinh" (func $sinh))
  (export "cosh" (func $cosh))
  (export "tanh" (func $tanh))
  (export "mat_derivative" (func $mat_derivative))
  (export "pi" (func $pi))
  (export "sqrt2" (func $sqrt2))
  (export "phi" (func $phi))
)
