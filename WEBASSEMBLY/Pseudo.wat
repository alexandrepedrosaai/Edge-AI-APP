(func $pi_integral (param $steps i32) (result f32)
  (local $sum f32) (local $i i32) (local $dx f32) (local $x f32)
  local.set $dx (f32.const 1.0)
  local.get $dx
  local.get $steps
  f32.convert_i32_s
  f32.div
  local.set $dx

  local.set $i (i32.const 0)
  local.set $sum (f32.const 0)

  (loop $loop
    local.get $i
    local.get $steps
    i32.ge_u
    br_if 1

    ;; x = i*dx
    local.get $i
    f32.convert_i32_s
    local.get $dx
    f32.mul
    local.set $x

    ;; sum += 4/(1+x^2)
    local.get $sum
    f32.const 4
    local.get $x
    local.get $x
    f32.mul
    f32.const 1
    f32.add
    f32.div
    f32.add
    local.set $sum

    local.get $i
    i32.const 1
    i32.add
    local.set $i
    br $loop
  )

  ;; integral ≈ sum*dx
  local.get $sum
  local.get $dx
  f32.mul)
