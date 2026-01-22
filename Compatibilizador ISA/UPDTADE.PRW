#INCLUDE "TOTVS.CH"
#INCLUDE "Protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOPCONN.CH' 
user Function xupdat()   
    PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO "EST" USER "admin" PASSWORD "siga7777"
    FSAtuSX3()
return nil

//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX3()
Local aEstrut   := {}
Local aSX3      := {}
Local cAliasAtu := ""
Local cSeqAtu   := ""
Local nI        := 0
Local nJ        := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nPosVld   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )
Local cUsaCpo   := FsX3Info("A1_BAIRRO",1)
Local cResCpo   := FsX3Info("A1_BAIRRO",2)
AutoGrLog( "Ínicio da Atualização" + " SX3" + CRLF )
aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
{ "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
{ "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
{ "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
{ "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
{ "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
{ "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } ,{ "X3_LOCALIZ", 0 }  }
aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } ) 

cValor := "00"
//aAdd(aSX3,{{'SB1',.T.},{cValor,.T.},{'B1_XIDISA',.T.},{'C',.T.},{40,.T.},{0,.T.},{'ID Prod ISA',.T.},{'ID Prod ISA',.T.},{'ID Prod ISA',.T.},{'ID Produto no ISA forca',.T.},{'ID Produto no ISA forca',.T.},{'ID Produto no ISA forca',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{1,.T.},{'',.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SB1",.T.},{cValor,.T.},{'B1_XIDISA',.T.},{'C',.T.},{40,.T.},{0,.T.},{'ID Prod ISA',.T.},{'ID Prod ISA',.T.},{'ID Prod ISA',.T.},{'ID Produto no ISA forca',.T.},{'ID Produto no ISA forca',.T.},{'ID Produto no ISA forca',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SB1",.T.},{cValor,.T.},{'B1_XFORCA',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia produto para ISA',.T.},{'Envia produto para ISA',.T.},{'Envia produto para ISA',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'S=Sim;N=Nao' ,.T.},{'S=Sim;N=Nao',.T.},{'S=Sim;N=Nao',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})

aAdd(aSX3,{{"SBM",.T.},{cValor,.T.},{'BM_XIDISA',.T.},{'C',.T.},{40,.T.},{0,.T.},{'ID Grupo ISA',.T.},{'ID Grupo ISA',.T.},{'ID Grupo ISA',.T.},{'ID Grupo no ISA forca',.T.},{'ID Grupo no ISA forca',.T.},{'ID Grupo no ISA forca',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SBM",.T.},{cValor,.T.},{'BM_YGSENV',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia Grupo para ISA',.T.},{'Envia Grupo para ISA',.T.},{'Envia Grupo para ISA',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'S=Sim;N=Nao' ,.T.},{'S=Sim;N=Nao',.T.},{'S=Sim;N=Nao',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})

aAdd(aSX3,{{"SB2",.T.},{cValor,.T.},{'B2_XQTENVF',.T.},{'N',.T.},{14,.T.},{2,.T.},{'Qt Env Forca',.T.},{'Qt Env Forca',.T.},{'Qt Env Forca',.T.},{'Qt Enviada forca de vendas',.T.},{'Qt Enviada forca de vendas',.T.},{'Qt Enviada forca de vendas',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SB2",.T.},{cValor,.T.},{'B2_XDTHREV',.T.},{'C',.T.},{30,.T.},{0,.T.},{'Data e Hora',.T.},{'Data e Hora',.T.},{'Data e Hora',.T.},{'Data e Hora envio forca',.T.},{'Data e Hora envio forca',.T.},{'Data e Hora envio forca',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})

aAdd(aSX3,{{"SA1",.T.},{cValor,.T.},{'A1_XIDISA',.T.},{'C',.T.},{40,.T.},{0,.T.},{'ID Clie ISA',.T.},{'ID Clie ISA',.T.},{'ID Clie ISA',.T.},{'ID Cliente no ISA forca',.T.},{'ID Cliente no ISA forca',.T.},{'ID Cliente no ISA forca',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SA1",.T.},{cValor,.T.},{'A1_YGSENV',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia Cliente para ISA',.T.},{'Envia Cliente para ISA',.T.},{'Envia Cliente para ISA',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'S=Sim;N=Nao' ,.T.},{'S=Sim;N=Nao',.T.},{'S=Sim;N=Nao',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SA1",.T.},{cValor,.T.},{'A1_YFORPGT',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Forma Pgto',.T.},{'Forma Pgto',.T.},{'Forma Pgto',.T.},{'Forma de pagamento',.T.},{'Forma de pagamento',.T.},{'Forma de pagamento',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'S=Sim;N=Nao' ,.T.},{'S=Sim;N=Nao',.T.},{'S=Sim;N=Nao',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SA1",.T.},{cValor,.T.},{'A1_XPAYLOA',.T.},{'M',.T.},{10,.T.},{0,.T.},{'Payload ISA',.T.},{'Payload ISA',.T.},{'Payload ISA',.T.},{'Payload ISA',.T.},{'Payload ISA',.T.},{'Payload ISA',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})

aAdd(aSX3,{{"SA3",.T.},{cValor,.T.},{'A3_XIDISA',.T.},{'C',.T.},{40,.T.},{0,.T.},{'ID Vend ISA',.T.},{'ID Vend ISA',.T.},{'ID Vend ISA',.T.},{'ID Vendedor no ISA forca',.T.},{'ID Vendedor no ISA forca',.T.},{'ID Cliente no ISA forca',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SA3",.T.},{cValor,.T.},{'A3_YGSENV',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia Vendedor para ISA',.T.},{'Envia Vendedor para ISA',.T.},{'Envia Vendedor para ISA',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'S=Sim;N=Nao' ,.T.},{'S=Sim;N=Nao',.T.},{'S=Sim;N=Nao',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})

aAdd(aSX3,{{"DA0",.T.},{cValor,.T.},{'DA0_YGSENV',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia Tabela para ISA',.T.},{'Envia Tabela para ISA',.T.},{'Envia Tabela para ISA',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'S=Sim;N=Nao' ,.T.},{'S=Sim;N=Nao',.T.},{'S=Sim;N=Nao',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})

aAdd(aSX3,{{"DA1",.T.},{cValor,.T.},{'DA1_XIDISA',.T.},{'C',.T.},{40,.T.},{0,.T.},{'ID Tabe ISA',.T.},{'ID Tabe ISA',.T.},{'ID Tabe ISA',.T.},{'ID Tabela no ISA forca',.T.},{'ID Tabela no ISA forca',.T.},{'ID Tabela no ISA forca',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"DA1",.T.},{cValor,.T.},{'DA1_XPVULT',.T.},{'N',.T.},{14,.T.},{2,.T.},{'Ult prc vend',.T.},{'Ult prc vend',.T.},{'Ult prc vend',.T.},{'Ultimo preco de venda enviado',.T.},{'Ultimo preco de venda enviado',.T.},{'Ultimo preco de venda enviado',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})

aAdd(aSX3,{{"SE4",.T.},{cValor,.T.},{'E4_XIDISA',.T.},{'C',.T.},{40,.T.},{0,.T.},{'ID Cond ISA',.T.},{'ID Cond ISA',.T.},{'ID Cond ISA',.T.},{'ID Condicao no ISA forca',.T.},{'ID Condicao no ISA forca',.T.},{'ID Condicao no ISA forca',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SE4",.T.},{cValor,.T.},{'E4_YGSENV',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia p/ ISA',.T.},{'Envia Condicao para ISA',.T.},{'Envia Condicao para ISA',.T.},{'Envia Condicao para ISA',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'S=Sim;N=Nao' ,.T.},{'S=Sim;N=Nao',.T.},{'S=Sim;N=Nao',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})

aAdd(aSX3,{{"SC5",.T.},{cValor,.T.},{'C5_XIDISA',.T.},{'C',.T.},{40,.T.},{0,.T.},{'ID Pedido ISA',.T.},{'ID Pedido ISA',.T.},{'ID Pedido ISA',.T.},{'ID Pedido no ISA forca',.T.},{'ID Pedido no ISA forca',.T.},{'ID Pedido no ISA forca',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SC5",.T.},{cValor,.T.},{'C5_YCDPALM',.T.},{'C',.T.},{9,.T.},{0,.T.},{'Num Ped ISA',.T.},{'Num Ped ISA',.T.},{'Num Ped ISA',.T.},{'numero pedido no ISA forca',.T.},{'numero pedido no ISA forca',.T.},{'numero pedido no ISA forca',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SC5",.T.},{cValor,.T.},{'C5_XSTATUS',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Status enviado',.T.},{'Status enviado',.T.},{'Status enviado',.T.},{'Status enviado',.T.},{'Status enviado',.T.},{'Status enviado',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SC5",.T.},{cValor,.T.},{'C5_XPAYLOA',.T.},{'M',.T.},{10,.T.},{0,.T.},{'Payload ISA',.T.},{'Payload ISA',.T.},{'Payload ISA',.T.},{'Payload ISA',.T.},{'Payload ISA',.T.},{'Payload ISA',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SC5",.T.},{cValor,.T.},{'C5_XPEDSTA',.T.},{'M',.T.},{10,.T.},{0,.T.},{'Ret. status',.T.},{'Ret. status',.T.},{'Ret. status',.T.},{'Ret. status',.T.},{'Ret. status',.T.},{'Ret. status',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})
aAdd(aSX3,{{"SC5",.T.},{cValor,.T.},{'C5_VLPEISA',.T.},{'N',.T.},{14,.T.},{2,.T.},{'Tot. Ped ISA',.T.},{'Tot. Ped ISA',.T.},{'Tot. Ped ISA',.T.},{'Tot. Ped ISA',.T.},{'Tot. Ped ISA',.T.},{'Tot. Ped ISA',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})

aAdd(aSX3,{{"SE1",.T.},{cValor,.T.},{'E1_XIDISA',.T.},{'C',.T.},{40,.T.},{0,.T.},{'ID Tit ISA',.T.},{'ID Tit ISA',.T.},{'ID Tit ISA',.T.},{'ID Titulo no ISA forca',.T.},{'ID Titulo no ISA forca',.T.},{'ID Titulo no ISA forca',.T.},{'',.T.},{'',.T.},{cUsaCpo,.T.},{'',.T.},{'',.T.},{0,.T.},{cResCpo,.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'N',.T.},{'S',.T.},{'',.T.}})

nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )
aSort( aSX3,,, { |x,y| x[nPosArq][1]+x[nPosOrd][1]+x[nPosCpo][1] < y[nPosArq][1]+y[nPosOrd][1]+y[nPosCpo][1] } ) 
dbSelectArea( "SX3" ) 
dbSetOrder( 2 ) 
cAliasAtu := "" 
For nI := 1 To Len( aSX3 ) 
    SX3->( dbSetOrder( 2 ) )
    If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo][1], nTamSeek ) ) )
        cSeqAtu := xsequen(aSX3[nI][nPosArq][1])
        RecLock( "SX3", .T. )
        For nJ := 1 To Len( aSX3[nI] )
            If SX3->(FieldPos( aEstrut[nJ][1])) > 0
                If nJ == nPosOrd  // Ordem
                    SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), cSeqAtu  ) )
                ElseIf aEstrut[nJ][2] > 0
                    SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] ) )
                EndIf
            EndIf
        Next nJ
        dbCommit()
        MsUnLock()
        AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo][1] )
    endif
Next nI
aAlias := {"SB1","SBM","SB2","SA1","SA3","DA0","DA1","SE4","SC5","SE1"}
for nI := 1 to len(aAlias)
    X31UPDTABLE(aAlias[nI])
next nI    
AutoGrLog( CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )
Return NIL


Static Function xsequen(cAlias) 
    Local cValor := ""
    //cQuery := "SELECT top 1 X3_ORDEM,X3_ARQUIVO FROM SX3010 WHERE X3_ARQUIVO = '"+cAlias+"' ORDER BY X3_ORDEM DESC "
    cQuery := "SELECT * FROM ( SELECT X3_ORDEM, X3_ARQUIVO FROM SX3010 WHERE X3_ARQUIVO = '" + cAlias + "' ORDER BY X3_ORDEM DESC ) WHERE ROWNUM = 1 "
    if select("SX3UPD") > 0
        SX3UPD->(DbCloseArea())
    endif    
    dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"SX3UPD",.F.,.T.)
    if !empty(SX3UPD->X3_ORDEM)
        cValor :=  Soma1(SX3UPD->X3_ORDEM)
    endif    
return cValor

Static Function FsX3Info(cCampo,nTipo) 
    Local cRet := "" 
    Local aArea := SX3->(GetArea())
    SX3->( dbSetOrder( 2 ) )
    If SX3->( dbSeek(cCampo) )
        If nTipo == 1
            cRet := SX3->X3_USADO
        Else
            cRet := SX3->X3_RESERV
        EndIf
    EndIf
    RestArea(aArea)
Return cRet
