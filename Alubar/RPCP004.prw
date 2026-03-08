#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RPCP004    ºAutor ³Ismael Junior     º Data ³  02/03/2026  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ STATUS DE PROGRAMAÇÃO                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RPCP004()
//Local   nLin        := 190
//Local   nItem       := 0
Local 	_cSql		:= ''
Local 	cFileLogo	:= ''
Local   cStartPath := ""
Local 	cCaminho := ""
Local 	cFile := 'StatusProgramacao'
Local aPergs   := {}
Local dDataDe  := FirstDate(Date())
Local dDataAt  := LastDate(Date())
Local lServer := .T.
local lTReport := .F.
Local lViewPDF := .T.
Local lCj  := .T.
Private _cAlias := ""
Private cData := '-'+dtoc(DATE())
//Private	oPrinter	:= fwMSPrinter():New(cFile,6 , .F. ,cCaminho, .T. )
Private oPrinter := FWMSPrinter():New(cFile+cData ,IMP_PDF, .F., cCaminho, .T. , lTReport, /*@oPrintSetup*/, /*cPrinter*/, lServer, /*descontinuado*/, /*lRaw*/, lViewPDF, /*nQtdCopy*/ )  
Private oBrushBlue := TBrush():New(,RGB(42, 97, 159))
Private oBrushCian := TBrush():New(,CLR_HCYAN)
Private oBrushGray := TBrush():New(,CLR_LIGHTGRAY)  
Private oBrushCyan := TBrush():New(,RGB(201, 222, 242))         
Private oFont06		:= TFont():New('Arial',06,06,,.F.,,,,.T.,.F.),;
oFont07		:= TFont():New('Arial',07,07,,.F.,,,,.T.,.F.),;
oFont08		:= TFont():New('Arial',08,08,,.F.,,,,.T.,.F.),;
oFont09		:= TFont():New('Arial',09,09,,.F.,,,,.T.,.F.),;
oFont10		:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.),;
oFont10n	:= TFont():New('Arial',10,10,,.T.,,,,.T.,.F.),;
oFont11		:= TFont():New('Arial',11,11,,.F.,,,,.T.,.F.),;
oFont11n	:= TFont():New('Arial',11,11,,.T.,,,,.T.,.F.),;
oFont12		:= TFont():New('Arial',12,12,,.T.,,,,.T.,.F.),;
oFont14		:= TFont():New('Arial',14,14,,.T.,,,,.T.,.F.),;
oFont15		:= TFont():New('Arial',15,15,,.T.,,,,.T.,.F.),;
oFont18		:= TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
oFont16	    := TFont():New('Arial',16,16,,.F.,,,,.T.,.F.),;
oFont16n	:= TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),; 
oFont16s	:= TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
oFont20n	:= TFont():New('Arial',20,20,,.T.,,,,.T.,.F.),;
oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.),;
oFont22n	:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)
oFont24n	:= TFont():New('Arial',24,24,,.T.,,,,.T.,.F.)
SET CENTURY ON
cStartPath := GetSrvProfString('Startpath','')
cCaminho := "C:\Relato\"
FErase( cCaminho+cFile+'.pdf' )
_cSql		:= ''
aAdd(aPergs, {1, "Data De",  dDataDe,  "", ".T.", "", ".T.", 80,  .T.})
aAdd(aPergs, {1, "Data Até", dDataAt,  "", ".T.", "", ".T.", 80,  .T.})
If !ParamBox(aPergs, "Informe os parâmetros")
    return nil    
EndIf 

oPrinter:SetLandscape() // SetPortrait()
oPrinter:SetResolution(72)
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetMargin(10,15,15,10) // nEsquerda, nSuperior, nDireita, nInferior
oPrinter:StartPage()
    //Monto minha consulta conforme parametros passado
    cQuery := ""
    cQuery += "WITH BASE_MES AS ( "
        cQuery += "SELECT CASE WHEN SB1.B1_GRUPO IN ('1023','1024','0415') THEN 'CARRETEL' WHEN SB1.B1_GRUPO IN ('1025') THEN 'CONJUNTO DE FECHAMENTO' END AS DESCRICAO, "
            cQuery += "CASE WHEN SB1.B1_GRUPO IN ('1023','1024','0415') THEN 'CR' WHEN SB1.B1_GRUPO IN ('1025') THEN 'CF' END AS TIPO, "
            cQuery += "SUM(SC2.C2_QUANT) AS MES "
        cQuery += "FROM " +RetSqlName("SC2")+ " SC2 "
        cQuery += "INNER JOIN " +RetSqlName("SB1")+ " SB1 ON SB1.B1_COD = SC2.C2_PRODUTO "
        cQuery += "WHERE SC2.C2_FILIAL = '01' AND SC2.C2_DATPRI >= '"+DTOS(FirstDate(MV_PAR01))+"' AND SC2.C2_DATPRF <= '"+DTOS(LastDate(MV_PAR02))+"' AND SC2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_CDINTEL <> '' "
        cQuery += "AND ( (SB1.B1_DESC LIKE '%CARRETEL%' AND SB1.B1_GRUPO IN ('1023','1024','0415')) OR (SB1.B1_GRUPO IN ('1025')) ) "
        cQuery += "GROUP BY CASE WHEN SB1.B1_GRUPO IN ('1023','1024','0415') THEN 'CARRETEL' WHEN SB1.B1_GRUPO IN ('1025') THEN 'CONJUNTO DE FECHAMENTO' END, "
                cQuery += "CASE WHEN SB1.B1_GRUPO IN ('1023','1024','0415') THEN 'CR' WHEN SB1.B1_GRUPO IN ('1025') THEN 'CF' END "
    cQuery += "), "
    cQuery += "BASE_PERIODO AS ( "
        cQuery += "SELECT 'CARRETEL' AS DESCRICAO, '1.1CR' AS TIPO, SUM(SC2.C2_QUANT) AS PERIODO, SUM(SC2.C2_QUJE) AS REALIZADO "
        cQuery += "FROM " +RetSqlName("SC2")+ " SC2 INNER JOIN " +RetSqlName("SB1")+ " SB1 ON SB1.B1_COD = SC2.C2_PRODUTO "
        cQuery += "WHERE SC2.C2_FILIAL = '01' AND SC2.C2_DATPRI >= '"+DTOS(MV_PAR01)+"' AND SC2.C2_DATPRF <= '"+DTOS(MV_PAR02)+"' AND SC2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_CDINTEL <> '' AND SB1.B1_DESC LIKE '%CARRETEL%' AND SB1.B1_GRUPO IN ('1023','1024','0415') "
        cQuery += "UNION ALL "
        cQuery += "SELECT 'CONJUNTO DE FECHAMENTO' AS DESCRICAO, '1.2CF' AS TIPO, SUM(SC2.C2_QUANT) AS PERIODO, SUM(SC2.C2_QUJE) AS REALIZADO "
        cQuery += "FROM " +RetSqlName("SC2")+ " SC2 INNER JOIN " +RetSqlName("SB1")+ " SB1 ON SB1.B1_COD = SC2.C2_PRODUTO "
        cQuery += "WHERE SC2.C2_FILIAL = '01' AND SC2.C2_DATPRI >= '"+DTOS(MV_PAR01)+"' AND SC2.C2_DATPRF <= '"+DTOS(MV_PAR02)+"' AND SC2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_CDINTEL <> '' AND SB1.B1_GRUPO IN ('1025') "
    cQuery += "), "
    cQuery += "BASE_DET_CR AS ( "
        cQuery += "SELECT '2.1CR' AS TIPO, SC2.C2_PADCLI, SB1.B1_DESC, SB1.B1_COD, SC2.C2_QUANT, SC2.C2_QUJE "
        cQuery += "FROM " +RetSqlName("SC2")+ " SC2 INNER JOIN " +RetSqlName("SB1")+ " SB1 ON SB1.B1_COD = SC2.C2_PRODUTO "
        cQuery += "WHERE SC2.C2_FILIAL = '01' AND SC2.C2_DATPRI >= '"+DTOS(MV_PAR01)+"' AND SC2.C2_DATPRF <= '"+DTOS(MV_PAR02)+"' AND SC2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_CDINTEL <> '' AND SB1.B1_DESC LIKE '%CARRETEL%' AND SB1.B1_GRUPO IN ('1023','1024','0415') "
    cQuery += "), "
    cQuery += "MES_CR AS ( SELECT B1_COD, SUM(C2_QUANT) AS MES FROM BASE_DET_CR GROUP BY B1_COD ), "
    cQuery += "BASE_DET_CF AS ( "
        cQuery += "SELECT '2.2CF' AS TIPO, SC2.C2_PADCLI, SB1.B1_DESC, SB1.B1_COD, SC2.C2_QUANT, SC2.C2_QUJE "
        cQuery += "FROM " +RetSqlName("SC2")+ " SC2 INNER JOIN " +RetSqlName("SB1")+ " SB1 ON SB1.B1_COD = SC2.C2_PRODUTO "
        cQuery += "WHERE SC2.C2_FILIAL = '01' AND SC2.C2_DATPRI >= '"+DTOS(MV_PAR01)+"' AND SC2.C2_DATPRF <= '"+DTOS(MV_PAR02)+"' AND SC2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SB1.B1_CDINTEL <> '' AND SB1.B1_GRUPO IN ('1025') "
    cQuery += "), "
    cQuery += "MES_CF AS ( SELECT B1_COD, SUM(C2_QUANT) AS MES FROM BASE_DET_CF GROUP BY B1_COD ), "
    cQuery += "MES_TIPO AS ( "
        cQuery += "SELECT 'CR' AS TIPO, SUM(MES) AS MES FROM MES_CR "
        cQuery += "UNION ALL "
        cQuery += "SELECT 'CF' AS TIPO, SUM(MES) AS MES FROM MES_CF "
    cQuery += ") "
    cQuery += " "
    cQuery += "SELECT TIPO, C2_PADCLI, DESCRICAO, MES, PERIODO, REALIZADO, DIF_UNID, DIF_PERCENT "
    cQuery += "FROM ( "
        cQuery += "SELECT P.TIPO, '' AS C2_PADCLI, P.DESCRICAO, MT.MES, P.PERIODO AS PERIODO, P.REALIZADO, "
            cQuery += "(P.REALIZADO - P.PERIODO) AS DIF_UNID, "
            cQuery += "ROUND((P.REALIZADO - P.PERIODO) / NULLIF(P.PERIODO, 0) * 100, 2) AS DIF_PERCENT, "
            cQuery += "0 AS ORDEM "
        cQuery += "FROM BASE_PERIODO P LEFT JOIN MES_TIPO MT ON MT.TIPO = RIGHT(P.TIPO, 2) "
    cQuery += " "
        cQuery += "UNION ALL "
    cQuery += " "
        cQuery += "SELECT B.TIPO, B.C2_PADCLI, B.B1_DESC AS DESCRICAO, M.MES, "
            cQuery += "SUM(B.C2_QUANT) AS PERIODO, SUM(B.C2_QUJE) AS REALIZADO, "
            cQuery += "(SUM(B.C2_QUJE) - SUM(B.C2_QUANT)) AS DIF_UNID, "
            cQuery += "ROUND((SUM(B.C2_QUJE) - SUM(B.C2_QUANT)) / NULLIF(SUM(B.C2_QUANT), 0) * 100, 2) AS DIF_PERCENT, "
            cQuery += "1 AS ORDEM "
        cQuery += "FROM BASE_DET_CR B INNER JOIN MES_CR M ON M.B1_COD = B.B1_COD "
        cQuery += "GROUP BY B.TIPO, B.C2_PADCLI, B.B1_DESC, M.MES "
    cQuery += " "
        cQuery += "UNION ALL "
    cQuery += " "
        cQuery += "SELECT B.TIPO, B.C2_PADCLI, B.B1_DESC AS DESCRICAO, M.MES, "
            cQuery += "SUM(B.C2_QUANT) AS PERIODO, SUM(B.C2_QUJE) AS REALIZADO, "
            cQuery += "(SUM(B.C2_QUJE) - SUM(B.C2_QUANT)) AS DIF_UNID, "
            cQuery += "ROUND((SUM(B.C2_QUJE) - SUM(B.C2_QUANT)) / NULLIF(SUM(B.C2_QUANT), 0) * 100, 2) AS DIF_PERCENT, "
            cQuery += "1 AS ORDEM "
        cQuery += "FROM BASE_DET_CF B INNER JOIN MES_CF M ON M.B1_COD = B.B1_COD "
        cQuery += "GROUP BY B.TIPO, B.C2_PADCLI, B.B1_DESC, M.MES "
    cQuery += ") X "
    cQuery += "ORDER BY X.TIPO, X.ORDEM, X.C2_PADCLI, X.DESCRICAO; "

    //Se o alias estiver aberto, irei fechar, isso ajuda a evitar erros
    IF Select("TRB") <> 0
        DbSelectArea("TRB")
        TRB->(DbCloseArea())
    ENDIF

    //Tratando a query para o AdvPL
    //crio o novo alias
    TCQUERY cQuery NEW ALIAS "TRB"

    dbSelectArea("TRB")
    TRB->(dbGoTop())
    oPrinter:Box(15,5,95,830)  // QUADRO CABEÇALHO (L1, C1, L2, C2)
    cFileLogo	:= cStartPath + 'LGRL.BMP' 
    oPrinter:SayBitmap( 20, 9, cFileLogo, 80, 75)
    oPrinter:Say(55,215,"STATUS DE PROGRAMAÇÃO | ALUBAR MONTENEGRO | AMN",oFont20n)
    oPrinter:Say(80,260,"FABRICA DE CARRETEL | "+DTOC(MV_PAR01) + " - "+DTOC(MV_PAR02),oFont20n)

    oPrinter:Box(105,5,230,830)  // QUADRO TIPO DE PRODUTO (L1, C1, L2, C2)
    oPrinter:Fillrect( {105,5,155,420}, oBrushBlue, "-2")
    oPrinter:Fillrect( {105,420,155,830}, oBrushGray, "-2")
    oPrinter:Fillrect( {205,5,230,830}, oBrushGray, "-2") 
    oPrinter:Say(136,150,"TIPO DE PRODUTO",oFont16n,,CLR_WHITE)
    oPrinter:Say(125,450,"PROGRAMADO",oFont16n)
    oPrinter:Say(125,730,"DIFERENÇA",oFont16n)
    oPrinter:Say(150,445,"MÊS",oFont16n)
    oPrinter:Say(150,513,"PERIODO",oFont16n) 
    oPrinter:Say(135,592,"REALIZADO",oFont16n)
    oPrinter:Say(150,700,"(UNID)",oFont16n)
    oPrinter:Say(150,790,"(%)",oFont16n)

    oPrinter:Line(105,420,230,420) // Linha Vertical tipo de produto
    oPrinter:Line(130,420,130,580) // Linha orizontal Programado
    oPrinter:Line(130,680,130,830) // Linha orizontal Diferença 
    oPrinter:Line(155,5,155,830) // Linha orizontal tipo de produto

    oPrinter:Line(130,500,230,500) // Linha Vertical mes
    oPrinter:Line(105,580,230,580) // Linha Vertical periodo
    oPrinter:Line(105,680,230,680) // Linha Vertical realizado --
    oPrinter:Line(130,760,230,760) // Linha Vertical (unid)
    nValor := 1574
    nVlneg := -1919
    nPerce := -50
    nVlmes := 0
    nVlPer := 0
    nVlRea := 0
    While TRB->(!Eof())
        nVlmes := nVlmes + TRB->MES
        nVlPer := nVlPer + TRB->PERIODO
        nVlRea := nVlRea + TRB->REALIZADO       
        if TRB->TIPO $ "1.1CR"
            nvl1mes := TRB->MES
            nVl1Per := TRB->PERIODO
            nVl1Rea := TRB->REALIZADO
            nVl1Dif := TRB->DIF_UNID
            nVl1Pec := TRB->DIF_PERCENT
            oPrinter:Say(175,190,"CARRETEL",oFont16n)
            oPrinter:Say(175,425,Alltrim(transform(TRB->MES,"@E 999,999,999")),oFont14) //mes
            oPrinter:Say(175,505,Alltrim(transform(TRB->PERIODO,"@E 999,999,999")),oFont14) // periodo
            oPrinter:Say(175,590,Alltrim(transform(TRB->REALIZADO,"@E 999,999,999")),oFont14) // realizado
            oPrinter:Say(175,685,Alltrim(transform(TRB->DIF_UNID,"@E 999,999,999")),oFont14,iif(TRB->DIF_UNID < 0 ,CLR_HRED,)) // unid
            oPrinter:Say(175,765,Alltrim(transform(TRB->DIF_PERCENT,"@E 9999"))+'%',oFont14,,iif(TRB->DIF_PERCENT < 0 ,CLR_HRED,)) // %
            oPrinter:Line(180,5,180,830) // Linha orizontal carretel
        endif
        if TRB->TIPO $ "1.2CF"
            nvl2mes := TRB->MES
            nVl2Per := TRB->PERIODO
            nVl2Rea := TRB->REALIZADO
            nVl2Dif := TRB->DIF_UNID
            nVl2Pec := TRB->DIF_PERCENT        
            oPrinter:Say(200,130,"CONJUNTO DE FECHAMENTO",oFont16n)
            oPrinter:Say(200,425,Alltrim(transform(TRB->MES,"@E 999,999,999")),oFont14) //mes
            oPrinter:Say(200,505,Alltrim(transform(TRB->PERIODO,"@E 999,999,999")),oFont14) // periodo
            oPrinter:Say(200,590,Alltrim(transform(TRB->REALIZADO,"@E 999,999,999")),oFont14) // realizado
            oPrinter:Say(200,685,Alltrim(transform(TRB->DIF_UNID,"@E 999,999,999")),oFont14,iif(TRB->DIF_UNID < 0 ,CLR_HRED,)) // unid
            oPrinter:Say(200,765,Alltrim(transform(TRB->DIF_PERCENT,"@E 9999"))+'%',oFont16n,,iif(TRB->DIF_PERCENT < 0 ,CLR_HRED,)) // %
            oPrinter:Line(205,5,205,830) // Linha orizontal conjunto de fechamento
            Exit
        endif
        TRB->(dbSkip())
    EndDo        
    oPrinter:Say(225,185,"TOTAL (UND)",oFont16n)
    nVlUnid := ROUND((nVlRea - nVlPer), 2)
    nVlPerc := ROUND((((nVlRea - nVlPer) / nVlPer) * 100), 2)
    oPrinter:Say(225,425,Alltrim(transform(nVlmes,"@E 999,999,999")),oFont14) //mes
    oPrinter:Say(225,505,Alltrim(transform(nVlPer,"@E 999,999,999")),oFont14) // periodo
    oPrinter:Say(225,590,Alltrim(transform(nVlRea,"@E 999,999,999")),oFont14) // realizado
    oPrinter:Say(225,685,Alltrim(transform(nVlUnid,"@E 999,999,999")),oFont14,iif(nVlUnid < 0 ,CLR_HRED,)) // unid
    oPrinter:Say(225,765,Alltrim(transform(nVlPerc,"@E 9999"))+'%',oFont14,,CLR_BLUE) // %

    // ************ DETALHAMENTO POR PRODUTO ********************
    oPrinter:Box(235,5,590,830)  // DETALHAMENTO POR PRODUTO (L1, C1, L2, C2)
    oPrinter:Fillrect( {235,5,310,420}, oBrushCyan, "-2")
    oPrinter:Fillrect( {235,420,310,830}, oBrushGray, "-2")
    //oPrinter:Fillrect( {205,5,575,830}, oBrushGray, "-2")

    oPrinter:Line(235,420,590,420) // Linha Vertical detalhamento de produto
    nLin := 260
    oPrinter:Say(nLin-5,125,"DETALHAMENTO POR PRODUTO",oFont16n)
    oPrinter:Say(nLin-5,450,"PROGRAMADO",oFont16n)
    oPrinter:Line(nLin,5,nLin,580) // Linha orizontal detalhamento de produto e Programado
    nLin := nLin + 25
    oPrinter:Say(nLin+5,10,"CLIENTE",oFont16n)
    oPrinter:Say(nLin-5,200,"TIPO DE PRODUTO",oFont16n)
    oPrinter:Say(nLin-5,445,"MÊS",oFont16n)
    oPrinter:Say(nLin-5,513,"PERIODO",oFont16n)
    oPrinter:Say(nLin-15,592,"REALIZADO",oFont16n) 
    oPrinter:Say(nLin-15,700,"(UNID)",oFont16n)
    oPrinter:Say(nLin-15,790,"(%)",oFont16n)
    oPrinter:Line(nLin,80,nLin,830) // Linha orizontal tipo de produto
    nLin := nLin + 25
    oPrinter:Say(nLin-5,220,"CARRETEL",oFont16n)
    oPrinter:Say(nLin-5,425,Alltrim(transform(nvl1mes,"@E 999,999,999")),oFont14) //mes
    oPrinter:Say(nLin-5,505,Alltrim(transform(nVl1Per,"@E 999,999,999")),oFont14) // periodo
    oPrinter:Say(nLin-5,590,Alltrim(transform(nVl1Rea,"@E 999,999,999")),oFont14) // realizado
    oPrinter:Say(nLin-5,685,Alltrim(transform(nVl1Dif,"@E 999,999,999")),oFont14,iif(nVl1Dif < 0 ,CLR_HRED,)) // unid
    oPrinter:Say(nLin-5,765,Alltrim(transform(nVl1Pec,"@E 9999"))+'%',oFont14,,iif(nVl1Pec < 0 ,CLR_HRED,)) // %
    oPrinter:Line(nLin,80,nLin,830) // Linha orizontal Carretel

    oPrinter:Line(260,80,590,80) // Linha Vertical cliente
    oPrinter:Line(260,500,590,500) // Linha Vertical mes
    oPrinter:Line(235,580,590,580) // Linha Vertical periodo
    oPrinter:Line(235,680,590,680) // Linha Vertical realizado --
    oPrinter:Line(235,760,590,760) // Linha Vertical (unid)
    While TRB->(!Eof())
        if !TRB->TIPO $ "1.1CR#1.2CF"
            if nLin >= 575
                oPrinter:EndPage()
                oPrinter:StartPage()
                oPrinter:Box(20,5,590,830)  // box proxima pagina (L1, C1, L2, C2)                
                nLin := 20
                oPrinter:Fillrect( {nLin,5,nLin+20,420}, oBrushCyan, "-2")
                oPrinter:Fillrect( {nLin,420,nLin+20,830}, oBrushGray, "-2")            
                oPrinter:Line(nLin,80,590,80) // Linha Vertical cliente
                oPrinter:Line(nLin,420,590,420) // Linha Vertical detalhamento de produto
                oPrinter:Line(nLin,500,590,500) // Linha Vertical mes
                oPrinter:Line(nLin,580,590,580) // Linha Vertical periodo
                oPrinter:Line(nLin,680,590,680) // Linha Vertical realizado --
                oPrinter:Line(nLin,760,590,760) // Linha Vertical (unid)  
                if TRB->TIPO $ "2.1CR"
                    oPrinter:Say(nLin+15,12,"-",oFont16n)
                    oPrinter:Say(nLin+15,190,"CARRETEL",oFont16n)
                    oPrinter:Say(nLin+15,425,Alltrim(transform(nvl1mes,"@E 999,999,999")),oFont14) //mes
                    oPrinter:Say(nLin+15,505,Alltrim(transform(nVl1Per,"@E 999,999,999")),oFont14) // periodo
                    oPrinter:Say(nLin+15,590,Alltrim(transform(nVl1Rea,"@E 999,999,999")),oFont14) // realizado
                    oPrinter:Say(nLin+15,685,Alltrim(transform(nVl1Dif,"@E 999,999,999")),oFont14,iif(nVl1Dif < 0 ,CLR_HRED,)) // unid
                    oPrinter:Say(nLin+15,765,Alltrim(transform(nVl1Pec,"@E 9999"))+'%',oFont14,,iif(nVl1Pec < 0 ,CLR_HRED,)) // %
                endif
                if TRB->TIPO $ "2.2CF"       
                    oPrinter:Say(nLin+15,12,"-",oFont16n)
                    oPrinter:Say(nLin+15,150,"CONJUNTO DE FECHAMENTO",oFont16n)
                    oPrinter:Say(nLin+15,425,Alltrim(transform(nvl2mes,"@E 999,999,999")),oFont14) //mes
                    oPrinter:Say(nLin+15,505,Alltrim(transform(nVl2Per,"@E 999,999,999")),oFont14) // periodo
                    oPrinter:Say(nLin+15,590,Alltrim(transform(nVl2Rea,"@E 999,999,999")),oFont14) // realizado
                    oPrinter:Say(nLin+15,685,Alltrim(transform(nVl2Rea,"@E 999,999,999")),oFont14,iif(nVl2Dif < 0 ,CLR_HRED,)) // unid
                    oPrinter:Say(nLin+15,765,Alltrim(transform(nVl2Pec,"@E 9999"))+'%',oFont16n,,iif(nVl2Pec < 0 ,CLR_HRED,)) // %
                endif
                nLin := nLin + 20
                oPrinter:Line(nLin,80,nLin,830) // Linha orizontal Carretel                                            
            endif 
            if TRB->TIPO == "2.2CF" .AND. lCj    
                oPrinter:Fillrect( {nLin,5,nLin+20,420}, oBrushCyan, "-2")
                oPrinter:Fillrect( {nLin,420,nLin+20,830}, oBrushGray, "-2") 
                oPrinter:Line(nLin,80,nLin+20,80) // Linha Vertical cliente
                oPrinter:Line(nLin,500,nLin+20,500) // Linha Vertical mes
                oPrinter:Line(nLin,580,nLin+20,580) // Linha Vertical periodo
                oPrinter:Line(nLin,680,nLin+20,680) // Linha Vertical realizado --
                oPrinter:Line(nLin,760,nLin+20,760) // Linha Vertical (unid)                           
                nLin := nLin + 20
                oPrinter:Say(nLin-5,12,"-",oFont16n)
                oPrinter:Say(nLin-5,150,"CONJUNTO DE FECHAMENTO",oFont16n)
                oPrinter:Say(nLin-5,425,Alltrim(transform(nvl2mes,"@E 999,999,999")),oFont14) //mes
                oPrinter:Say(nLin-5,505,Alltrim(transform(nVl2Per,"@E 999,999,999")),oFont14) // periodo
                oPrinter:Say(nLin-5,590,Alltrim(transform(nVl2Rea,"@E 999,999,999")),oFont14) // realizado
                oPrinter:Say(nLin-5,685,Alltrim(transform(nVl2Dif,"@E 999,999,999")),oFont14,iif(nVl2Dif < 0 ,CLR_HRED,)) // unid
                oPrinter:Say(nLin-5,765,Alltrim(transform(nVl2Pec,"@E 9999"))+'%',oFont14,,iif(nVl2Pec < 0 ,CLR_HRED,)) // %
                oPrinter:Line(nLin,5,nLin,830) // Linha orizontal Carretel  
                lCj  := .F.          
            endif   
            nLin := nLin + 15
            oPrinter:Say(nLin-5,10,Alltrim(TRB->C2_PADCLI),oFont12) //cliente
            oPrinter:Say(nLin-5,85,substr(Alltrim(TRB->DESCRICAO),1,62),oFont12) //produto
            oPrinter:Say(nLin-5,425,Alltrim(transform(TRB->MES,"@E 999,999,999")),oFont12) //mes
            oPrinter:Say(nLin-5,505,Alltrim(transform(TRB->PERIODO,"@E 999,999,999")),oFont12) // periodo
            oPrinter:Say(nLin-5,590,Alltrim(transform(TRB->REALIZADO,"@E 999,999,999")),oFont12) // realizado
            oPrinter:Say(nLin-5,685,Alltrim(transform(TRB->DIF_UNID,"@E 999,999,999")),oFont12,iif(TRB->DIF_UNID < 0 ,CLR_HRED,)) // unid
            oPrinter:Say(nLin-5,765,Alltrim(transform(TRB->DIF_PERCENT,"@E 9999"))+'%',oFont12,,iif(TRB->DIF_PERCENT < 0 ,CLR_HRED,)) // %
        oPrinter:Line(nLin,5,nLin,830) // Linha orizontal conjunto de fechamento
        endif
        TRB->(dbSkip())
    EndDo 
oPrinter:cPathPDF := cCaminho
oPrinter:EndPage()
oPrinter:print()
if oPrinter:nModalResult == PD_OK
oPrinter:GetViewPDF()
EndIf
FreeObj(oPrinter)
oPrinter := Nil
Return .T.
