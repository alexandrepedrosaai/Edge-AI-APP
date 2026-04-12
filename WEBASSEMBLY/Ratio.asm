(module
  ;; Declaração de memória
  (memory $mem 1)

  ;; Função de soma
  (func $add (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    i32.add)

  ;; Exporta a função
  (export "add" (func $add))
)
