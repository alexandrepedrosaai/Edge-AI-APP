(module
  ;; Linear memory for matrices
  (memory $mem 4)

  ;; Matrix transpose: B = Aᵀ
  (func $mat_transpose (param $A i32) (param $B i32) (param $N i32) (result i32)
    (local $i i32) (local $j i32)
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

        ;; B[j*N + i] = A[i*N + j]
        local.get $B
        local.get $j
        local.get $N
        i32.mul
        local.get $i
        i32.add
        i32.const 4
        i32.mul
        i32.add

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

  ;; Matrix multiplication: C = A × B
  (func $mat_mul (param $A i32) (param $B i32) (param $C i32) (param $N i32) (result i32)
    (local $i i32) (local $j i32) (local $k i32) (local $sum f32)
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

        local.set $sum (f32.const 0)
        local.set $k (i32.const 0)
        (loop $dot
          local.get $k
          local.get $N
          i32.ge_u
          br_if 1

          ;; sum += A[i*N+k] * B[k*N+j]
          local.get $A
          local.get $i
          local.get $N
          i32.mul
          local.get $k
          i32.add
          i32.const 4
          i32.mul
          i32.add
          f32.load

          local.get $B
          local.get $k
          local.get $N
          i32.mul
          local.get $j
          i32.add
          i32.const 4
          i32.mul
          i32.add
          f32.load

          f32.mul
          local.get $sum
          f32.add
          local.set $sum

          local.get $k
          i32.const 1
          i32.add
          local.set $k
          br $dot
        )

        ;; C[i*N+j] = sum
        local.get $C
        local.get $i
        local.get $N
        i32.mul
        local.get $j
        i32.add
        i32.const 4
        i32.mul
        i32.add
        local.get $sum
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

  ;; 2D convolution: output = input * kernel
  (func $conv2d (param $input i32) (param $kernel i32) (param $output i32)
                (param $H i32) (param $W i32) (param $KH i32) (param $KW i32) (result i32)
    (local $i i32) (local $j i32) (local $m i32) (local $n i32) (local $sum f32)
    local.set $i (i32.const 0)
    (loop $outer
      local.get $i
      local.get $H
      i32.ge_u
      br_if 1

      local.set $j (i32.const 0)
      (loop $inner
        local.get $j
        local.get $W
        i32.ge_u
        br_if 1

        local.set $sum (f32.const 0)
        local.set $m (i32.const 0)
        (loop $km
          local.get $m
          local.get $KH
          i32.ge_u
          br_if 1

          local.set $n (i32.const 0)
          (loop $kn
            local.get $n
            local.get $KW
            i32.ge_u
            br_if 1

            ;; sum += input[(i+m)*W + (j+n)] * kernel[m*KW+n]
            local.get $input
            local.get $i
            local.get $m
            i32.add
            local.get $W
            i32.mul
            local.get $j
            local.get $n
            i32.add
            i32.add
            i32.const 4
            i32.mul
            i32.add
            f32.load

            local.get $kernel
            local.get $m
            local.get $KW
            i32.mul
            local.get $n
            i32.add
            i32.const 4
            i32.mul
            i32.add
            f32.load

            f32.mul
            local.get $sum
            f32.add
            local.set $sum

            local.get $n
            i32.const 1
            i32.add
            local.set $n
            br $kn
          )

          local.get $m
          i32.const 1
          i32.add
          local.set $m
          br $km
        )

        ;; output[i*W+j] = sum
        local.get $output
        local.get $i
        local.get $W
        i32.mul
        local.get $j
        i32.add
        i32.const 4
        i32.mul
        i32.add
        local.get $sum
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

  ;; Export functions
  (export "mat_transpose" (func $mat_transpose))
  (export "mat_mul" (func $mat_mul))
  (export "conv2d" (func $conv2d))
)
