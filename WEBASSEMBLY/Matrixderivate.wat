(func $mat_derivative (param $A i32) (param $dA i32) (param $N i32) (param $dx f32) (result i32)
  (local $i i32) (local $j i32) (local $f1 f32) (local $f2 f32)
  local.set $i (i32.const 0)
  (loop $outer
    local.get $i
    local.get $N
    i32.ge_u
    br_if 1
    local.set $j (i32.const 0)
    (loop $inner
      local.get $j
      local.get $N
      i32.ge_u
      br_if 1

      ;; f1 = A[i*N+j] at x+dx
      local.get $A
      local.get $i
      local.get $N
      i32.mul
      local.get $j
      i32.add
      i32.const 4
      i32.mul
      i32.add
      f32.load
      local.get $dx
      f32.add
      local.set $f1

      ;; f2 = A[i*N+j] at x-dx
      local.get $A
      local.get $i
      local.get $N
      i32.mul
      local.get $j
      i32.add
      i32.const 4
      i32.mul
      i32.add
      f32.load
      local.get $dx
      f32.sub
      local.set $f2

      ;; dA[i*N+j] = (f1 - f2)/(2*dx)
      local.get $dA
      local.get $i
      local.get $N
      i32.mul
      local.get $j
      i32.add
      i32.const 4
      i32.mul
      i32.add
      local.get $f1
      local.get $f2
      f32.sub
      local.get $dx
      f32.const 2
      f32.mul
      f32.div
      f32.store

      local.get $j
      i32.const 1
      i32.add
      local.set $j
      br $inner
    )
    local.get $i
    i32.const 1
    i32.add
    local.set $i
    br $outer
  )
  i32.const 0)
