(module
  (memory $mem 2)

  ;; Função multiplicação
  (func $mul (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.mul)

  ;; Função fatorial
  (func $fact (param $n i32) (result i32)
    (local $res i32)
    i32.const 1
    local.set $res
    (block $exit
      (loop $loop
        local.get $n
        i32.eqz
        br_if $exit ;; sai do loop se n == 0
        local.get $res
        local.get $n
        i32.mul
        local.set $res
        local.get $n
        i32.const 1
        i32.sub
        local.set $n
        br $loop
      )
    )
    local.get $res)

  ;; Função soma de vetor
  (func $vec_sum (param $ptr i32) (param $len i32) (result i32)
    (local $sum i32)
    i32.const 0
    local.set $sum
    (block $exit
      (loop $loop
        local.get $len
        i32.eqz
        br_if $exit
        local.get $sum
        local.get $ptr
        i32.load
        i32.add
        local.set $sum
        local.get $ptr
        i32.const 4
        i32.add
        local.set $ptr
        local.get $len
        i32.const 1
        i32.sub
        local.set $len
        br $loop
      )
    )
    local.get $sum)

  ;; Exporta funções
  (export "mul" (func $mul))
  (export "fact" (func $fact))
  (export "vec_sum" (func $vec_sum))
)
