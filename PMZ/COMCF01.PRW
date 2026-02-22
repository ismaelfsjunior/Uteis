#include 'totvs.ch'
#include 'restful.ch'
#INCLUDE "Protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOPCONN.CH' 
#Include "parmtype.ch"
//-------------------------------------------------------------------
/*{Protheus.doc} conhecimento de frete
API para conhecimento de frete
@author Ismael Junior
@since 18/10/2025
@version 1.0
*/
//-------------------------------------------------------------------

user function comcf01()
    local cRead as char
    local cParser as char
    local aNames as array
    local jJson
    local cFilSA2 := "" as char
    local cFilSF1 := "" as char
    local nTamFilial := 0 as numeric
    local bError as block
    local cError as char 
    Local aArea      := FWGetArea()
    Local nX := 0 as numeric
    Local aCabec := {} as array
    Local aItens := {} as array
    Private lMsHelpAuto   := .F.
    Private lAutoErrNoFile:= .T.    
    Private lMsErroAuto := .F.

    bError := ErrorBlock({|oError| cError := oError:ErrorStack})     
    jJson := JsonObject():new()
    cRead := '{"Filial":"22763502007896","Valor":1000,"Documento":"999999992","Serie":"1","FornecedorFrete":"00335130313","CondPag":"001","TpOrigem":1,"Aglutina":2,"TpEntrada":2,"Notas":[{"Fornecedor":"00335130313","DocOrig":"000000001","SerOrig":"1"},{"Fornecedor":"00335130313","DocOrig":"000000002","SerOrig":"1"}]}'
    cParser := jJson:fromJson(cRead)

    if cParser == nil
        ConOut("JSON parseado corretamente:")     
        aNames := jJson:getNames()
        cCNPJ := cValToChar(jJson["Filial"])
        PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO "EST" USER "admin" PASSWORD "siga181" TABLES "SF1"                   
        DbSelectArea('SA2')
        SA2->(dbSetOrder(3))
        dbSelectArea("SF4")
        SF4->(dbSetOrder(1))
        dbSelectArea("SE4")
        SE4->(dbSetOrder(1))
        dbSelectArea("SF1")
        SF1->(dbSetOrder(1))        
        cFilSA2 := xFilial("SA2") 
        cFilSF1 := xFilial("SF1") 
        nTamFilial := Len(cFilSF1)
        //-- Verifica informações da TES
        If !SF4->(MsSeek(xFilial("SF4")+"001"))
        lOk := .F.
        ConOut("Cadastrar TES: 001")
        EndIf
        cCGCFre   :=  Padr(AllTrim(cValToChar(jJson["FornecedorFrete"])), tamSX3("A2_CGC")[1], " ")   
        cDoc      :=  Padr(AllTrim(cValToChar(jJson["Documento"])), tamSX3("F1_DOC")[1], " ")
        cSerie    :=  Padr(AllTrim(cValToChar(jJson["Serie"])), tamSX3("F1_SERIE")[1], " ")
        cConPag   :=  Padr(AllTrim(cValToChar(jJson["CondPag"])), tamSX3("E4_CODIGO")[1], " ")  
        //-- Verifica informações da condição de pagamento
        If !SE4->(MsSeek(xFilial("SE4")+cConPag))
        lOk := .F.
        ConOut("Cadastrar condição de pagamento: 001")
        EndIf
        if !(SA2->(dbSeek(cFilSA2+cCGCFre)))
            cRet := EncodeUTF8('{"info": "Fornecedor não encontrado","codigo":"'+cCGCFre+'"}')
            conout('Fornecedor nao encontrado')
            RestArea(aArea)          
            return nil                
        EndIF 
        aadd(aCabec,{"",Ctod("01/01/2015")}) //Data Inicial
        aadd(aCabec,{"",dDataBase}) //Data Final
        aadd(aCabec,{"",jJson["TpEntrada"]}) //2-Inclusao;1=Exclusao
        aadd(aCabec,{"",SA2->A2_COD}) //Fornecedor do documento de Origem
        aadd(aCabec,{"",SA2->A2_LOJA}) //Loja de origem        
        aadd(aCabec,{"",jJson["TpOrigem"]}) //Tipo da nota de origem: 1=Normal;2=Devol/Benef
        aadd(aCabec,{"",jJson["Aglutina"]}) //1=Aglutina;2=Nao aglutina
        aadd(aCabec,{"F1_EST",""})
        aadd(aCabec,{"",jJson["Valor"]}) //Valor do conhecimento
        aadd(aCabec,{"F1_FORMUL",1}) // Utiliza Formulario proprio ? 1-Nao,2-Sim
        aadd(aCabec,{"F1_DOC",cDoc}) //..Numero da NF de Conhecimento de Frete
        aadd(aCabec,{"F1_SERIE",cSerie})
        aadd(aCabec,{"F1_FORNECE",SA2->A2_COD})
        aadd(aCabec,{"F1_LOJA",SA2->A2_LOJA})
        aadd(aCabec,{"","001"}) //TES 
        aadd(aCabec,{"F1_BASERET",0})
        aadd(aCabec,{"F1_ICMRET",0})
        aadd(aCabec,{"F1_COND","001"})
        aadd(aCabec,{"F1_EMISSAO",dDataBase})
        aadd(aCabec,{"F1_ESPECIE","NF"})          
               
        for nX := 1 to len(jJson["Notas"]) 
            //-- Verifica fornecedor
            cCGC := Padr(AllTrim(cValToChar(jJson["Notas"][nX]["Fornecedor"])), tamSX3("A2_CGC")[1], " ") 
            cDocFor := Padr(AllTrim(cValToChar(jJson["Notas"][nX]["DocOrig"])), tamSX3("F1_DOC")[1], " ")
            cSerFor := Padr(AllTrim(cValToChar(jJson["Notas"][nX]["SerOrig"])), tamSX3("F1_SERIE")[1], " ")
            if !(SA2->(dbSeek(cFilSA2+cCGC)))
                cRet := EncodeUTF8('{"info": "Fornecedor não encontrado","codigo":"'+cCGC+'"}')
                conout('Fornecedor nao encontrado')
                RestArea(aArea)          
                return nil
            EndIF 
            SF1->(DbGoTop())
            if (SF1->(dbSeek(cFilSF1+cDocFor+cSerFor+SA2->A2_COD+SA2->A2_LOJA)))
                aadd(aItens,{{"PRIMARYKEY",AllTrim(SubStr(&(IndexKey()),nTamFilial + 1))}})
            endif
        next nX   
        MATA116(aCabec,aItens,,,,)
        if !Empty(cError)
            ConErr(cError)
            cRet := '{"CODERR": 422,'
            cRet += '"MSG": "'+EncodeUTF8(cError)+'"}'                
            RestArea(aArea)
            RESET ENVIRONMENT                       
            return nil     
        endif  
        ErrorBlock(bError)         
        If lMsErroAuto
            MostraErro()
            Conout("Erro!")
        Else
            Conout("Ok!")
        Endif                                   
    else
        //Caso o parser falhe, exibe no console o erro do parser
        ConErr("Erro no parser do JSON:", cParser)
    endif
FWRestArea(aArea)
RESET ENVIRONMENT
Return nil

