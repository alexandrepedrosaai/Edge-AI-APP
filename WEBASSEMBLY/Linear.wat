(module
  ;; Memória linear para armazenar matrizes e vetores
  (memory $mem 2)

  ;; Multiplicação escalar de vetor
  (func $vec_scalar_mul (param $ptr i32) (param $len i32) (param $scalar f32)
                         (result i32)
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

        ;; load value and multiply
        local.get $ptr
        local.get $i
        i32.const 4
        i32.mul
        i32.add
        f32.load
        local.get $scalar
        f32.mul

        ;; store back
        f32.store

        ;; increment index
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $loop
      )
    )
    i32.const 0)

  ;; Multiplicação de matrizes (C = A x B)
  (func $mat_mul (param $A i32) (param $B i32) (param $C i32)
                 (param $N i32) (result i32)
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
            ;; calculate address
            local.get $C
            local.get $i
            local.get $N
            i32.mul
            local.get $j
            i32.add
            i32.const 4
            i32.mul
            i32.add
            ;; value to store
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

  ;; Exporta funções
  (export "vec_scalar_mul" (func $vec_scalar_mul))
  (export "mat_mul" (func $mat_mul))
)
