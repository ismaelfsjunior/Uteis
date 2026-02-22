#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "Protheus.ch"
  
User Function rmata116()
Local cCodFor := "000001"
Local cLojFor := "01"
Local cNumDoc := "999999999"
Local cSerie := "1"
Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local aRatcc := {}
Local aRateio := {}
Local aCCItem := {}
Local nX := 0
Local nY := 0
Local nTamFilial := 0
Local lOk := .T.
Local jtrib := JsonObject():New()
Local cFilSF1 := ""
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
  
  
//------------------------//| Abertura do ambiente |//------------------------
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "COM" TABLES "SB1","SD1","SF1"
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verificação do ambiente para teste |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
//-- Verifica informações de produto
dbSelectArea("SB1")
dbSetOrder(1)
If !SB1->(MsSeek(xFilial("SB1")+"000001"))
lOk := .F.
ConOut("Cadastrar produto: 001")
EndIf
//-- Verifica informações da TES
dbSelectArea("SF4")
dbSetOrder(1)
If !SF4->(MsSeek(xFilial("SF4")+"001"))
lOk := .F.
ConOut("Cadastrar TES: 001")
EndIf
//-- Verifica informações da condição de pagamento
dbSelectArea("SE4")
dbSetOrder(1)
If !SE4->(MsSeek(xFilial("SE4")+"001"))
lOk := .F.
ConOut("Cadastrar condição de pagamento: 001")
EndIf
//-- Verifica fornecedor
dbSelectArea("SA2")
dbSetOrder(1)
If !SA2->(MsSeek(xFilial("SA2")+"000001"))
lOk := .F.
ConOut("Cadastrar fornecedor: 001")
EndIf
If lOk
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Carrega ate 3 documentos de origem - Fornecedor 000001                                                   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
dbSelectArea("SF1")
dbSetOrder(1)
MsSeek(xFilial("SF1"))
While !EOF()
IF (Alltrim(SF1->F1_FORNECE+SF1->F1_LOJA) =="00000101")
if nX<3
cFilSF1 := xFilial("SF1")
nTamFilial := Len(cFilSF1)
aadd(aItens,{{"PRIMARYKEY",AllTrim(SubStr(&(IndexKey()),nTamFilial + 1))}}) //Tratamento para Gestao Empresas
else
exit
Endif
nX++
EndIf
dbskip()
EndDo
  
IF nX >0
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Teste de Inclusão                                                                                                                      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aCabec,{"",Ctod("01/01/2015")}) //Data Inicial
aadd(aCabec,{"",Ctod("01/12/2027")}) //Data Final
aadd(aCabec,{"",1}) //2-Inclusao;1=Exclusao
aadd(aCabec,{"",cCodFor}) //Fornecedor do documento de Origem
aadd(aCabec,{"",cLojFor}) //Loja de origem
aadd(aCabec,{"",1}) //Tipo da nota de origem: 1=Normal;2=Devol/Benef
aadd(aCabec,{"",2}) //1=Aglutina;2=Nao aglutina
aadd(aCabec,{"F1_EST",""})
aadd(aCabec,{"",1000}) //Valor do conhecimento
aadd(aCabec,{"F1_FORMUL",2}) // Utiliza Formulario proprio ? 1-Nao,2-Sim
aadd(aCabec,{"F1_DOC",cNumDoc}) //..Numero da NF de Conhecimento de Frete
aadd(aCabec,{"F1_SERIE",cSerie})
aadd(aCabec,{"F1_FORNECE",cCodFor})
aadd(aCabec,{"F1_LOJA",cLojFor})
aadd(aCabec,{"","001"}) //TES
aadd(aCabec,{"F1_BASERET",0})
aadd(aCabec,{"F1_ICMRET",0})
aadd(aCabec,{"F1_COND","001"})
aadd(aCabec,{"F1_EMISSAO",dDataBase})
aadd(aCabec,{"F1_ESPECIE","NF"})
 
// //Campos da aba informações adicionais
// //Enviar apenas conforme necessidade, se não houver, não enviar campo
// aadd(aCabec,{"F1_UFORITR","SP"})
// aadd(aCabec,{"F1_MUORITR","50308"})
// aadd(aCabec,{"F1_UFDESTR","SP"})
// aadd(aCabec,{"F1_MUDESTR","50308"})
// aadd(aCabec,{"F1_INDPRES","1"})
// aadd(aCabec,{"F1_CODA1U","XXXXX"})
// aadd(aCabec,{"F1_OBSFTIT","OBSTIT"})
// aadd(aCabec,{"F1_OBSFISC","OBSFIS"})
  
  
aRatCC := {}
AAdd (aRateio, {"0001",aRatCC})
 
MATA116(aCabec,aItens,,,aRateio)
  
If lMsErroAuto
MostraErro()
Conout("Erro!")
Else
Conout("Ok!")
Endif
EndIf
  
EndIf
  
RESET ENVIRONMENT
  
Return(.T.)
