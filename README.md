Repositório para os códigos das listas de Infraestrutura de Hardware, além do projeto.

# TODO:
- Fazer reset
- ~~ALUop estado inicial~~
- ~~MemWR (trocar 0 e 1)~~
- ~~Passar IRwrite pra outro estado (estado1)~~
- ~~Modificacao arquitetura div (tá certo?):~~
    - ~~Colocar wait (esperar 32 ciclos)~~
    - ~~Depois do wait ativar High e Low~~
- ~~Addi
    - ~~Criar outra caixa pro addi e mudar o regdst 
- ~~Mudar posição da caixa do overflow~~
- Alterações para instruções tipo I
- Sinal de LT da ALU (sendo feito na primeira cartolina, mas não na segunda)
- Colocar caixinhas para carregamento antes das operações de shift
- ~~Ajustes para jr~~
- Ajustes para o mux adicionado com os sinais da ALU
- ~~Colocar wait (estados de load)~~
- Alterações nos stores (mesmas dos loads), adicionar wait ao ler da memória
- ALUOp e mudar entrada MemToReg (jal)
- Colocar estados iniciais de Inc e dec
- ~~Colocar addiu (não gera overflow)

## Exceções:
- Fazer PC-4 para EP
- pegar os 8 bits menos significativos da memória, extender e mandar pra pc

## VERILOG:
- Verificar se caixinhas dos MUX estão corretas
    - Aparentemente mux_ALUSrcA e mux_BWD estão escolhendo inputC com 11 e não 10
    - Verificar se outros MUX não tem esse problema (se é que há um)
