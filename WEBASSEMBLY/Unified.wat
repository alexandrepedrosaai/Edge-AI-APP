(module
  (memory $mem 8)

  ;; ---------------- Linear Algebra ----------------

  ;; Vector scalar multiplication
  (func $vec_scalar_mul (param $ptr i32) (param $len i32) (param $scalar f32) (result i32)
    (local $i i32)
    i32.const 0
    local.set $i
    (block $exit
      (loop $loop
        local.get $i
        local.get $len
        i32.ge_u
        br_if $exit
        
        ;; calculate address
        local.get $ptr
        local.get $i
        i32.const 4
        i32.mul
        i32.add
        
        ;; load, multiply and store
        local.get $ptr
        local.get $i
        i32.const 4
        i32.mul
        i32.add
        f32.load
        local.get $scalar
        f32.mul
        f32.store
        
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $loop
      )
    )
    i32.const 0)

  ;; Matrix transpose
  (func $mat_transpose (param $A i32) (param $B i32) (param $N i32) (result i32)
    (local $i i32) (local $j i32)
    i32.const 0
    local.set $i
    (block $exit_outer
      (loop $outer
        local.get $i
        local.get $N
        i32.ge_u
        br_if $exit_outer
        
        i32.const 0
        local.set $j
        (block $exit_inner
          (loop $inner
            local.get $j
            local.get $N
            i32.ge_u
            br_if $exit_inner
            
            ;; B[j*N + i] = A[i*N + j]
            ;; calculate address for B
            local.get $B
            local.get $j
            local.get $N
            i32.mul
            local.get $i
            i32.add
            i32.const 4
            i32.mul
            i32.add
            
            ;; load from A
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
            
            ;; store to B
            f32.store
            
            local.get $j
            i32.const 1
            i32.add
            local.set $j
            br $inner
          )
        )
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $outer
      )
    )
    i32.const 0)

  ;; Matrix multiplication
  (func $mat_mul (param $A i32) (param $B i32) (param $C i32) (param $N i32) (result i32)
    (local $i i32) (local $j i32) (local $k i32) (local $sum f32)
    i32.const 0
    local.set $i
    (block $exit_outer
      (loop $outer
        local.get $i
        local.get $N
        i32.ge_u
        br_if $exit_outer
        
        i32.const 0
        local.set $j
        (block $exit_inner
          (loop $inner
            local.get $j
            local.get $N
            i32.ge_u
            br_if $exit_inner
            
            f32.const 0
            local.set $sum
            i32.const 0
            local.set $k
            (block $exit_dot
              (loop $dot
                local.get $k
                local.get $N
                i32.ge_u
                br_if $exit_dot
                
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
        )
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $outer
      )
    )
    i32.const 0)

  ;; 2D convolution
  (func $conv2d (param $input i32) (param $kernel i32) (param $output i32)
                (param $H i32) (param $W i32) (param $KH i32) (param $KW i32) (result i32)
    (local $i i32) (local $j i32) (local $m i32) (local $n i32) (local $sum f32)
    i32.const 0
    local.set $i
    (block $exit_outer
      (loop $outer
        local.get $i
        local.get $H
        i32.ge_u
        br_if $exit_outer
        
        i32.const 0
        local.set $j
        (block $exit_inner
          (loop $inner
            local.get $j
            local.get $W
            i32.ge_u
            br_if $exit_inner
            
            f32.const 0
            local.set $sum
            i32.const 0
            local.set $m
            (block $exit_km
              (loop $km
                local.get $m
                local.get $KH
                i32.ge_u
                br_if $exit_km
                
                i32.const 0
                local.set $n
                (block $exit_kn
                  (loop $kn
                    local.get $n
                    local.get $KW
                    i32.ge_u
                    br_if $exit_kn
                    
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
                )
                local.get $m
                i32.const 1
                i32.add
                local.set $m
                br $km
              )
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
        )
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $outer
      )
    )
    i32.const 0)

  ;; ---------------- Trigonometric ----------------

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
    
    local.get $x
    local.get $x3
    f32.const 6.0
    f32.div
    f32.sub
    local.get $x5
    f32.const 120.0
    f32.div
    f32.add
    local.get $x7
    f32.const 5040.0
    f32.div
    f32.sub)

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
    
    f32.const 1.0
    local.get $x2
    f32.const 2.0
    f32.div
    f32.sub
    local.get $x4
    f32.const 24.0
    f32.div
    f32.add
    local.get $x6
    f32.const 720.0
    f32.div
    f32.sub)

  ;; Export functions
  (export "vec_scalar_mul" (func $vec_scalar_mul))
  (export "mat_transpose" (func $mat_transpose))
  (export "mat_mul" (func $mat_mul))
  (export "conv2d" (func $conv2d))
  (export "sin" (func $sin))
  (export "cos" (func $cos))
)
