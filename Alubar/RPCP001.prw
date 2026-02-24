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
±±ºPrograma  ³ RPCP001    ºAutor ³Ismael Junior     º Data ³  21/02/2026  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RELATORIO BALANÇO DE MASSA                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RPCP001()
// Local   nLin        := 190
// Local   nItem       := 0
Local 	_cSql		:= ''
Local 	cFileLogo	:= ''
Local   cStartPath := ""
Local 	cCaminho := ""
Local 	cFile := 'relbmassa'
Local aPergs   := {}
Local dDataDe  := FirstDate(Date())
Local dDataAt  := LastDate(Date())
Local lServer := .T.
local lTReport := .F.
Local lViewPDF := .T.
Private _cAlias := ""
Private dData := DATE()
//Private	oPrinter	:= fwMSPrinter():New(cFile,6 , .F. ,cCaminho, .T. )
Private oPrinter := FWMSPrinter():New(cFile ,IMP_PDF, .F., cCaminho, .T. , lTReport, /*@oPrintSetup*/, /*cPrinter*/, lServer, /*descontinuado*/, /*lRaw*/, lViewPDF, /*nQtdCopy*/ )  
Private oBrushBlue := TBrush():New(,CLR_HBLUE)
Private oBrushCian := TBrush():New(,CLR_HCYAN)
Private oBrush1     := TBrush():New( , CLR_HGRAY),;
oFont06		:= TFont():New('Courier New',06,06,,.F.,,,,.T.,.F.),;
oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
oFont08		:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
oFont09		:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
oFont10		:= TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
oFont11		:= TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
oFont11n	:= TFont():New('Tahoma',11,11,,.T.,,,,.T.,.F.),;
oFont12		:= TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),;
oFont14		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
oFont15		:= TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
oFont18		:= TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
oFont16	    := TFont():New('Arial',16,16,,.F.,,,,.T.,.F.),;
oFont16n	:= TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),; 
oFont16s	:= TFont():New('Stencil',16,16,,.T.,,,,.T.,.F.),;
oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.),;
oFont24n	:= TFont():New('Courier New',24,24,,.T.,,,,.T.,.F.)
SET CENTURY ON
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
cStartPath := GetSrvProfString('Startpath','')
cCaminho := 'C:\atualizacao\'//GetTempPath()
FErase( cCaminho+cFile+'.pdf' )
_cSql		:= ''
    aAdd(aPergs, {1, "Data De",  dDataDe,  "", ".T.", "", ".T.", 80,  .T.})
    aAdd(aPergs, {1, "Data Até", dDataAt,  "", ".T.", "", ".T.", 80,  .T.})
    // aAdd(aPergs, {1, "Cliente De",  cCliDe,  "", ".T.", "SA1", ".T.", 80,  .F.})
    // aAdd(aPergs, {1, "Loja De",  cLojDe,  "", ".T.", "", ".T.", 40,  .F.})
    // aAdd(aPergs, {1, "Cliente Até", cCliAte,  "", ".T.", "SA1", ".T.", 80,  .T.})
    // aAdd(aPergs, {1, "Loja Até", cLojAte,  "", ".T.", "", ".T.", 40,  .T.}) 
    // aAdd(aPergs, {1, "Vendedor De",  cVendDe,  "", ".T.", "SA3", ".T.", 60,  .F.})
    // aAdd(aPergs, {1, "Vendedor Ate", cVendAte, "", ".T.", "SA3", ".T.", 60,  .T.})  
    // aAdd(aPergs, {2, "Tipo Envio",   nTpenv, {"1=Abertos", "2=Baixados", "3=Ambos"},090, ".T.", .F.})       
    //ParamBox(aPergs, "Informe os parâmetros") 
    /*        
    If !ParamBox(aPergs, "Informe os parâmetros")
        return nil    
    EndIf 

_cSql := "SELECT  "
    _cSql += "GRUPO, TIPO, SALDO "
_cSql += "FROM ( "
    _cSql += "SELECT '1001' AS GRUPO,'SALDO INICIAL' AS TIPO, ROUND(SUM(B9_QINI),2) AS SALDO "
    _cSql += "FROM " + RetSqlName("SB1") + " SB1 "
    _cSql += "INNER JOIN SB9100 SB9 ON B9_COD = B1_COD AND B9_QINI > 0AND SB9.D_E_L_E_T_ != '*' "
    _cSql += "WHERE B1_CDINTEL <> '' AND B1_GRUPO = '0111' AND SB1.D_E_L_E_T_ != '*' "
    _cSql += "GROUP BY B1_GRUPO "
    _cSql += "UNION ALL "
    _cSql += "SELECT '1002' AS GRUPO, 'RECEBIMENTO' AS TIPO, ROUND(SUM(D1_QUANT),2) AS SALDO "
    _cSql += "FROM " + RetSqlName("SB1") + " SB1 "
    _cSql += "INNER JOIN " + RetSqlName("SD1") + " SD1 ON D1_COD = B1_COD AND D1_DTDIGIT BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"' AND D1_TIPO = 'N' AND D1_FILIAL = '"+xFilial("SD1")+"' AND SD1.D_E_L_E_T_ != '*' "
    _cSql += "WHERE B1_CDINTEL <> '' AND B1_GRUPO = '0111' AND SB1.D_E_L_E_T_ != '*' "
    _cSql += "GROUP BY B1_GRUPO "
	_cSql += "UNION ALL "
    _cSql += "SELECT '1003', 'PRODUZIDO' AS TIPO,ROUND(SUM(SALDO),2) AS SALDO FROM ( "
	_cSql += "SELECT SUM(C2_QTSEGUM) AS SALDO "
    _cSql += "FROM " + RetSqlName("SB1") + " SB1 "
    _cSql += "INNER JOIN " + RetSqlName("SC2") + " SC2 ON C2_PRODUTO = B1_COD AND C2_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"' AND C2_QTSEGUM > 0 AND C2_FILIAL = '"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_ != '*' "
    _cSql += "WHERE B1_CDINTEL <> '' AND SB1.D_E_L_E_T_ != '*' "
_cSql += "UNION ALL  "
	_cSql += "SELECT SUM(C2_QUANT) AS SALDO "
    _cSql += "FROM " + RetSqlName("SB1") + " SB1 "
    _cSql += "INNER JOIN " + RetSqlName("SC2") + " SC2 ON C2_PRODUTO = B1_COD AND C2_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"' AND C2_QTSEGUM = 0 AND C2_FILIAL = '"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_ != '*' "
    _cSql += "WHERE B1_CDINTEL <> '' AND SB1.D_E_L_E_T_ != '*' ) X  "
_cSql += "UNION ALL "
	_cSql += "SELECT B1_GRUPO, TIPO, SALDO FROM ( "
		_cSql += "SELECT '2002' AS B1_GRUPO,'RIPAS DE NUCLEO' AS TIPO, SUM(C2_QTSEGUM) SALDO "
		_cSql += "FROM " + RetSqlName("SB1") + " SB1 "
		_cSql += "INNER JOIN " + RetSqlName("SC2") + " SC2 ON C2_PRODUTO = B1_COD AND C2_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"' AND C2_QTSEGUM > 0 AND C2_FILIAL = '"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_ != '*' "
		_cSql += "WHERE B1_CDINTEL <> '' AND SB1.D_E_L_E_T_ != '*' AND B1_DESC LIKE '%NUCLEO%' "
		_cSql += "UNION ALL  "
		_cSql += "SELECT '2001' AS B1_GRUPO,'RIPAS DE FLANGE'AS TIPO, SUM(C2_QTSEGUM) SALDO "
		_cSql += "FROM " + RetSqlName("SB1") + " SB1 "
		_cSql += "INNER JOIN " + RetSqlName("SC2") + " SC2 ON C2_PRODUTO = B1_COD AND C2_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"' AND C2_QTSEGUM > 0 AND C2_FILIAL = '"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_ != '*' "
		_cSql += "WHERE B1_CDINTEL <> '' AND SB1.D_E_L_E_T_ != '*' AND B1_DESC LIKE '%FLANGE%' "
		_cSql += "UNION ALL "
		_cSql += "SELECT '2003' AS B1_GRUPO,'RIPAS DE FECHAMENTO'AS TIPO, SUM(C2_QTSEGUM) SALDO "
		_cSql += "FROM " + RetSqlName("SB1") + " SB1 "
		_cSql += "INNER JOIN " + RetSqlName("SC2") + " SC2 ON C2_PRODUTO = B1_COD AND C2_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"' AND C2_QTSEGUM > 0 AND C2_FILIAL = '"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_ != '*' "
		_cSql += "WHERE B1_CDINTEL <> '' AND SB1.D_E_L_E_T_ != '*' AND B1_DESC LIKE '%FECHAMENTO%'  "
		_cSql += "UNION ALL "
		_cSql += "SELECT '2004' AS B1_GRUPO,'RIPA LATERAL'AS TIPO, SUM(C2_QTSEGUM) SALDO "
		_cSql += "FROM " + RetSqlName("SB1") + " SB1 "
		_cSql += "INNER JOIN " + RetSqlName("SC2") + " SC2 ON C2_PRODUTO = B1_COD AND C2_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"' AND C2_QTSEGUM > 0 AND C2_FILIAL = '"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_ != '*' "
		_cSql += "WHERE B1_CDINTEL <> '' AND SB1.D_E_L_E_T_ != '*' AND B1_DESC LIKE '%RIPA DE REFORCO TRAPEZOIDAL%') X	 "
_cSql += "UNION ALL "
	_cSql += "SELECT '3001' AS GRUPO, 'FLANGE MONTADA' AS TIPO, SUM(C2_QUANT) AS SALDO "
    _cSql += "FROM " + RetSqlName("SB1") + " SB1 "
    _cSql += "INNER JOIN " + RetSqlName("SC2") + " SC2 ON C2_PRODUTO = B1_COD AND C2_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"' AND C2_FILIAL = '"+xFilial("SC2")+"' AND SC2.D_E_L_E_T_ != '*' "
    _cSql += "WHERE B1_CDINTEL <> '' AND SB1.D_E_L_E_T_ != '*' AND B1_DESC LIKE '%FLANGE%MONTADA%' "
	_cSql += "GROUP BY B1_GRUPO "
_cSql += ") X "
_cSql += "ORDER BY GRUPO "

//Tratando a query para o AdvPL
//memowrite(funname()+".sql",_cSql)
TCQuery _cSql new Alias (_cAlias:=GetNextAlias()) */

oPrinter:SetPortrait() //SetLandscape()
oPrinter:SetResolution(72)
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetMargin(40,40,40,40) // nEsquerda, nSuperior, nDireita, nInferior
oPrinter:StartPage()


//oPrinter:Box(0005,0005,0830,0585)    // Moldura do Relatório
cFileLogo	:= cStartPath + 'LGRL.BMP' 
oPrinter:Say(0045,0155,"RELATÓRIO BALANÇO DE MASSA",oFont24n)


oPrinter:Box(0060,0005,0425,0280)  // QUADRO PLAINA (L1, C1, L2, C2)
oPrinter:Fillrect( {0060,0005,0085,0280}, oBrushBlue, "-2")
oPrinter:Line(0085,0005,0085,0280) // Linha orizontal plaina e balanço de madeira
oPrinter:Line(0060,0155,0085,0155) // Linha Vertical plaina e balanço de madeira
oPrinter:Say(0075,0050,"PLAINA",oFont11,,CLR_WHITE,) 
oPrinter:Say(0075,0160,"BALANÇO DE MADEIRA",oFont11,,CLR_WHITE,) 

oPrinter:Fillrect( {085,0005,0105,0280}, oBrush1, "-2")
oPrinter:Line(0105,0006,0105,0280) // Linha orizontal Entradas
oPrinter:Say(0098,120,"ENTRADAS",oFont11,,,) 

oPrinter:Say(0120,0010,"SALDO INICIAL",oFont11,,,) 
oPrinter:Say(0120,0165,"0,00",oFont11,,,) 
oPrinter:Line(0125,0005,0125,0280) // Linha orizontal SALDO INICIAL
oPrinter:Line(0105,0155,0145,0155) // Linha Vertical entrada

oPrinter:Say(0140,0010,"RECEBIMENTO",oFont11,,,) 
oPrinter:Say(0140,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0145,0005,0165,0280}, oBrushCian, "-2")
oPrinter:Line(0145,0005,0145,0280) // Linha orizontal RECEBIMENTO

oPrinter:Say(0160,0010,"TOTAL",oFont11,,,) 
oPrinter:Say(0160,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0165,0005,0185,0280}, oBrush1, "-2")
oPrinter:Line(0165,0005,0165,0280) // Linha orizontal TOTAL

oPrinter:Say(0180,120,"SAIDAS",oFont11,,,) 
oPrinter:Line(0185,0005,0185,0280) // Linha orizontal SAIDAS
oPrinter:Line(0185,0155,0425,0155) // Linha Vertical entrada

oPrinter:Say(0200,0010,"PRODUÇÃO",oFont11,,,) 
oPrinter:Say(0200,0165,"0,00",oFont11,,,) 
oPrinter:Line(0205,0005,0205,0280) // Linha orizontal PRODUÇÃO

oPrinter:Say(0220,0010,"PERDAS",oFont11,,,) 
oPrinter:Say(0220,0165,"0,00",oFont11,,,) 
oPrinter:Line(0225,0005,0225,0280) // Linha orizontal PERDAS

oPrinter:Say(0240,0010,"DEVOLIÇÃO (NÃO CONFORMIDADE)",oFont11,,,) 
oPrinter:Say(0240,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0245,0005,0265,0280}, oBrushCian, "-2")
oPrinter:Line(0245,0005,0245,0280) // Linha orizontal DEVOLIÇÃO

oPrinter:Say(0260,0010,"TOTAL",oFont11,,,) 
oPrinter:Say(0260,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0265,0005,0285,0280}, oBrush1, "-2")
oPrinter:Line(0265,0005,0265,0280) // Linha orizontal TOTAL

oPrinter:Say(0280,120,"BALANÇO",oFont11,,,) 
oPrinter:Line(0285,0005,0285,0280) // Linha orizontal BALANÇO

oPrinter:Say(0300,0010,"SALDO FINAL",oFont11,,,) 
oPrinter:Say(0300,0165,"0,00",oFont11,,,) 
oPrinter:Line(0305,0005,0305,0280) // Linha orizontal SALDO FINAL

oPrinter:Say(0320,0010,"INVENTÁRIO",oFont11,,,) 
oPrinter:Say(0320,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0325,0005,0345,0280}, oBrushCian, "-2")
oPrinter:Line(0325,0005,0325,0280) // Linha orizontal INVENTÁRIO

oPrinter:Say(0340,0010,"DIFERENÇA DE SALDOS",oFont11,,,) 
oPrinter:Say(0340,0165,"0,00",oFont11,,,) 
oPrinter:Line(0345,0005,0345,0280) // Linha orizontal INVENTÁRIO

oPrinter:Box(0060,0285,0425,0575) // QUADRO CORTE ****************************************

oPrinter:Fillrect( {0060,0285,0085,0575}, oBrushBlue, "-2")
oPrinter:Line(0085,0285,0085,0575) // Linha orizontal corte e balanço de madeira
oPrinter:Line(0060,0430,0085,0430) // Linha Vertical cortee balanço de madeira
oPrinter:Say(0075,0320,"CORTE",oFont11,,CLR_WHITE,) 
oPrinter:Say(0075,0465,"BALANÇO DE TABUAS",oFont11,,CLR_WHITE,) 

oPrinter:Fillrect( {085,0285,0105,0575}, oBrush1, "-2")
oPrinter:Line(0105,0285,0105,0575) // Linha orizontal Entradas
oPrinter:Say(0098,0410,"ENTRADAS",oFont11,,,) 

oPrinter:Say(0120,0290,"SALDO INICIAL",oFont11,,,) 
oPrinter:Say(0120,0445,"0,00",oFont11,,,) 
oPrinter:Line(0125,0285,0125,0575) // Linha orizontal SALDO INICIAL
oPrinter:Line(0105,0430,0145,0430) // Linha Vertical entrada

oPrinter:Say(0140,0290,"RECEBIMENTO DA PLAINA",oFont11,,,) 
oPrinter:Say(0140,0445,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0145,0285,0165,0575}, oBrushCian, "-2")
oPrinter:Line(0145,0285,0145,0575) // Linha orizontal RECEBIMENTO

oPrinter:Say(0160,0290,"TOTAL",oFont11,,,) 
oPrinter:Say(0160,0445,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0165,0285,0185,0575}, oBrush1, "-2")
oPrinter:Line(0165,0285,0165,0575) // Linha orizontal TOTAL

oPrinter:Say(0180,0410,"SAIDAS",oFont11,,,) 
oPrinter:Line(0185,0285,0185,0575) // Linha orizontal SAIDAS
oPrinter:Line(0185,0430,0425,0430) // Linha Vertical entrada

oPrinter:Say(0200,0290,"RIPAS DE FALNGES",oFont11,,,) 
oPrinter:Say(0200,0445,"0,00",oFont11,,,) 
oPrinter:Line(0205,0285,0205,0575) // Linha orizontal - RIPAS DE FALNGES

oPrinter:Say(0220,0290,"RIPAS DE NÚCLEOS",oFont11,,,) 
oPrinter:Say(0220,0445,"0,00",oFont11,,,) 
oPrinter:Line(0225,0285,0225,0575) // Linha orizontal - RIPAS DE FALNGES

oPrinter:Say(0240,0290,"RIPAS DE FECHAMENTO",oFont11,,,) 
oPrinter:Say(0240,0445,"0,00",oFont11,,,) 
oPrinter:Line(0245,0285,0245,0575) // Linha orizontal - RIPAS DE FALNGES

oPrinter:Say(0260,0290,"RIPAS DE REF. LATERAL",oFont11,,,) 
oPrinter:Say(0260,0445,"0,00",oFont11,,,) 
oPrinter:Line(0265,0285,0265,0575) // Linha orizontal - RIPAS DE FALNGES

oPrinter:Say(0280,0290,"RIPAS DE REF. CENTRAL",oFont11,,,) 
oPrinter:Say(0280,0445,"0,00",oFont11,,,) 
oPrinter:Line(0285,0285,0285,0575) // Linha orizontal - RIPAS DE FALNGES

oPrinter:Say(0300,0290,"PERDAS",oFont11,,,) 
oPrinter:Say(0300,0445,"0,00",oFont11,,,) 
oPrinter:Line(0305,0285,0305,0575) // Linha orizontal - RIPAS DE FALNGES

oPrinter:Say(0320,0290,"DEVOLUÇÃO(NÃO CONFORMIDADE)",oFont11,,,) 
oPrinter:Say(0320,0445,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0325,0285,0345,0575}, oBrushCian, "-2")
oPrinter:Line(0325,0285,0325,0575) // Linha orizontal DEVOLIÇÃO

oPrinter:Say(0340,0290,"TOTAL",oFont11,,,) 
oPrinter:Say(0340,0445,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0345,0285,0365,0575}, oBrush1, "-2")
oPrinter:Line(0345,0285,0345,0575) // Linha orizontal TOTAL

oPrinter:Say(0360,0410,"BALANÇO",oFont11,,,) 
oPrinter:Line(0365,0285,0365,0575) // Linha orizontal BALANÇO

oPrinter:Say(0380,0290,"SALDO FINAL",oFont11,,,) 
oPrinter:Say(0380,0445,"0,00",oFont11,,,) 
oPrinter:Line(0385,0285,0385,0575) // Linha orizontal SALDO FINAL

oPrinter:Say(0400,0290,"INVENTÁRIO",oFont11,,,) 
oPrinter:Say(0400,0445,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0405,0285,0425,0575}, oBrushCian, "-2")
oPrinter:Line(0405,0285,0405,0575) // Linha orizontal INVENTÁRIO

oPrinter:Say(0420,0290,"DIFERENÇA DE SALDOS",oFont11,,,) 
oPrinter:Say(0420,0445,"0,00",oFont11,,,) 
oPrinter:Line(0425,0340,0425,0575) // Linha orizontal INVENTÁRIO

oPrinter:Box(0430,0005,775,0280)  // QUADRO COLAGEM ******************************************
oPrinter:Fillrect( {0430,0005,0450,0280}, oBrushBlue, "-2")
oPrinter:Line(0450,0005,0450,0280) // Linha orizontal plaina e balanço de madeira
oPrinter:Line(0430,0155,0450,0155) // Linha Vertical plaina e balanço de madeira
oPrinter:Say(0445,0050,"COLAGEM",oFont11,,CLR_WHITE,) 
oPrinter:Say(0445,0160,"BALANÇO DE RIPAS",oFont11,,CLR_WHITE,) 

oPrinter:Fillrect( {0450,0005,0470,0280}, oBrush1, "-2")
oPrinter:Say(0465,120,"ENTRADAS",oFont11,,,) 
oPrinter:Line(0470,0006,0470,0280) // Linha orizontal Entradas

oPrinter:Say(0485,0010,"SALDO INICIAL",oFont11,,,) 
oPrinter:Say(0485,0165,"0,00",oFont11,,,) 
oPrinter:Line(0490,0005,0490,0280) // Linha orizontal SALDO INICIAL
oPrinter:Line(0470,0155,0510,0155) // Linha Vertical entrada

oPrinter:Say(0505,0010,"RECEBIMENTO",oFont11,,,) 
oPrinter:Say(0505,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0510,0005,0530,0280}, oBrushCian, "-2")
oPrinter:Line(0510,0005,0510,0280) // Linha orizontal RECEBIMENTO

oPrinter:Say(0525,0010,"TOTAL",oFont11,,,) 
oPrinter:Say(0525,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0520,0005,0540,0280}, oBrush1, "-2")
oPrinter:Line(0530,0005,0530,0280) // Linha orizontal TOTAL

oPrinter:Say(0535,120,"SAIDAS",oFont11,,,) 
oPrinter:Line(0540,0005,0540,0280) // Linha orizontal SAIDAS
oPrinter:Line(0540,0155,0775,0155) // Linha Vertical entrada

oPrinter:Say(0555,0010,"PRODUÇÃO",oFont11,,,) 
oPrinter:Say(0555,0165,"0,00",oFont11,,,) 
oPrinter:Line(0570,0005,0570,0280) // Linha orizontal PRODUÇÃO

oPrinter:Say(0575,0010,"PERDAS",oFont11,,,) 
oPrinter:Say(0575,0165,"0,00",oFont11,,,) 
oPrinter:Line(0590,0005,0590,0280) // Linha orizontal PERDAS

oPrinter:Say(0605,0010,"DEVOLIÇÃO (NÃO CONFORMIDADE)",oFont11,,,) 
oPrinter:Say(0605,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0610,0005,0630,0280}, oBrushCian, "-2")
oPrinter:Line(0610,0005,0610,0280) // Linha orizontal DEVOLIÇÃO

oPrinter:Say(0625,0010,"TOTAL",oFont11,,,) 
oPrinter:Say(0625,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0630,0005,0650,0280}, oBrush1, "-2")
oPrinter:Line(0630,0005,0630,0280) // Linha orizontal TOTAL

oPrinter:Say(0645,120,"BALANÇO",oFont11,,,) 
oPrinter:Line(0650,0005,0650,0280) // Linha orizontal BALANÇO

oPrinter:Say(0665,0010,"SALDO FINAL",oFont11,,,) 
oPrinter:Say(0665,0165,"0,00",oFont11,,,) 
oPrinter:Line(0670,0005,0670,0280) // Linha orizontal SALDO FINAL

oPrinter:Say(0685,0010,"INVENTÁRIO",oFont11,,,) 
oPrinter:Say(0685,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0690,0005,0710,0280}, oBrushCian, "-2")
oPrinter:Line(0690,0005,0690,0280) // Linha orizontal INVENTÁRIO

oPrinter:Say(0705,0010,"DIFERENÇA DE SALDOS",oFont11,,,) 
oPrinter:Say(0705,0165,"0,00",oFont11,,,) 
oPrinter:Line(0710,0005,0710,0280) // Linha orizontal INVENTÁRIO

// oPrinter:Box(0170,0265,0194,0360)  // ATENDIMENTO
// oPrinter:Fillrect( {0171,0266,0182,0359}, oBrush1, "-2")
// oPrinter:Line(0182,0265,0182,0360) 
// oPrinter:Say(0180,0275,"ATENDIMENTO",oFont11n)   
// oPrinter:Say(0192,0275,cAtend,oFont11n)

//oPrinter:Box(0170,0365,0194,0510)  // CLIENTE
//oPrinter:Fillrect( {0171,0366,0182,0509}, oBrush1, "-2")



//(_cAlias)->(DbGotop())
// While !(_cAlias)->(EOF())
// 	oPrinter:Box(nLin,0040,nLin+24,0510)  // CLIENTE
// 	oPrinter:Fillrect( {nLin+1,0041,nLin+11,0509}, oBrush1, "-2")
// 	oPrinter:Line(nLin+11,0040,nLin+11,0510) 
// 	oPrinter:Say(nLin+10,0240,"TRECHO "+STRzero(nTrecho,2),oFont11n) 
// 	oPrinter:Say(nLin+22,0045,"ORIGEM: "+Alltrim(SubStr((_cAlias)->Z2_MUNORIG,1,30))+" / DESTINO: "+Alltrim(SubStr((_cAlias)->Z2_MUNDEST,1,30)),oFont11n)
// 	oPrinter:Say(nLin+22,0415,STRzero((_cAlias)->Z2_QTPASSG,2)+" PASSAGEIROS",oFont11n)
// 	nTrecho := nTrecho + 1 
// 	nLin := nLin + 32
// 	nItem := nItem + 1
// 	(_cAlias)->(DbSkip())
// 	If nLin >= 0750
// 		oPrinter:EndPage()
// 		oPrinter:StartPage()
// 		nLin := 0070
// 	Endif		
// EndDo


oPrinter:cPathPDF := cCaminho
oPrinter:EndPage()
oPrinter:print()
if oPrinter:nModalResult == PD_OK
oPrinter:GetViewPDF()
EndIf


FreeObj(oPrinter)
oPrinter := Nil
RESET ENVIRONMENT
Return .T.
