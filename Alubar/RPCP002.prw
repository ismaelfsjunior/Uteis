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
oFont20n	:= TFont():New('Arial',20,20,,.T.,,,,.T.,.F.),;
oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.),;
oFont22n	:= TFont():New('Courier New',22,22,,.T.,,,,.T.,.F.)
oFont24n	:= TFont():New('Courier New',24,24,,.T.,,,,.T.,.F.)
SET CENTURY ON
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
cStartPath := GetSrvProfString('Startpath','')
cCaminho := 'C:\atualizacao\'//GetTempPath()
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
oPrinter:SetMargin(40,40,40,40) // nEsquerda, nSuperior, nDireita, nInferior
oPrinter:StartPage()

oPrinter:Box(0030,0005,0095,0810)  // QUADRO CABEÇALHO (L1, C1, L2, C2)
cFileLogo	:= cStartPath + 'LGRL.BMP' 
oPrinter:SayBitmap( 35, 9, cFileLogo, 60, 55)
oPrinter:Say(0055,0215,"STATUS DE PROGRAMAÇÃO | ALUBAR MONTENEGRO | AMN",oFont20n)
oPrinter:Say(0080,0260,"FABRICA DE CARRETEL | "+DTOC(MV_PAR01) + " - "+DTOC(MV_PAR02),oFont20n)

oPrinter:Box(0105,0005,0265,0810)  // QUADRO TIPO DE PRODUTO (L1, C1, L2, C2)
oPrinter:Line(0185,0005,0185,0810) // Linha orizontal tipo de produto
oPrinter:Line(0105,0450,0265,0450) // Linha Vertical tipo de produto

oPrinter:Line(0211,0005,0211,0810) // Linha orizontal tipo de produto
oPrinter:Line(0237,0005,0237,0810) // Linha orizontal tipo de produto
/*
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

oPrinter:Box(0430,0005,0775,0280)  // QUADRO COLAGEM ******************************************
oPrinter:Fillrect( {0430,0005,0450,0280}, oBrushBlue, "-2")
oPrinter:Line(0450,0005,0450,0280) // Linha orizontal plaina e balanço de madeira
oPrinter:Line(0430,0155,0450,0155) // Linha Vertical plaina e balanço de madeira
oPrinter:Say(0445,0050,"COLAGEM",oFont11,,CLR_WHITE,) 
oPrinter:Say(0445,0160,"BALANÇO DE RIPAS",oFont11,,CLR_WHITE,) 

oPrinter:Fillrect( {0450,0005,0470,0280}, oBrush1, "-2")
oPrinter:Say(0465,130,"ENTRADAS",oFont11,,,) 
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
oPrinter:Fillrect( {0530,0005,0550,0280}, oBrush1, "-2")
oPrinter:Line(0530,0005,0530,0280) // Linha orizontal TOTAL

oPrinter:Say(0545,130,"SAIDAS",oFont11,,,) 
oPrinter:Line(0550,0005,0550,0280) // Linha orizontal SAIDAS
oPrinter:Line(0550,0155,0775,0155) // Linha Vertical entrada

oPrinter:Say(0565,0010,"PRODUÇÃO",oFont11,,,) 
oPrinter:Say(0565,0165,"0,00",oFont11,,,) 
oPrinter:Line(0570,0005,0570,0280) // Linha orizontal PRODUÇÃO

oPrinter:Say(0585,0010,"PERDAS",oFont11,,,) 
oPrinter:Say(0585,0165,"0,00",oFont11,,,) 
oPrinter:Line(0590,0005,0590,0280) // Linha orizontal PERDAS

oPrinter:Say(0605,0010,"DEVOLUÇÃO (NÃO CONFORMIDADE)",oFont11,,,) 
oPrinter:Say(0605,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0610,0005,0630,0280}, oBrushCian, "-2")
oPrinter:Line(0610,0005,0610,0280) // Linha orizontal DEVOLIÇÃO

oPrinter:Say(0625,0010,"TOTAL",oFont11,,,) 
oPrinter:Say(0625,0165,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0630,0005,0650,0280}, oBrush1, "-2")
oPrinter:Line(0630,0005,0630,0280) // Linha orizontal TOTAL

oPrinter:Say(0645,130,"BALANÇO",oFont11,,,) 
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

oPrinter:Box(0430,0285,0775,0575) // QUADRO PREGADEIRA ****************************************

oPrinter:Fillrect( {0430,0285,0450,0575}, oBrushBlue, "-2")
oPrinter:Line(0450,0285,0450,0575) // Linha orizontal corte e balanço de madeira
oPrinter:Line(0430,0430,0450,0430) // Linha Vertical cortee balanço de madeira
oPrinter:Say(0445,0320,"PREGADEIRA",oFont11,,CLR_WHITE,) 
oPrinter:Say(0445,0440,"BALANÇO DE FLANGES M",oFont11,,CLR_WHITE,) 

oPrinter:Fillrect( {0450,0285,0470,0575}, oBrush1, "-2")
oPrinter:Say(0465,0410,"ENTRADAS",oFont11,,,) 
oPrinter:Line(0470,0285,0470,0575) // Linha orizontal Entradas

oPrinter:Say(0485,0290,"SALDO INICIAL",oFont11,,,) 
oPrinter:Say(0485,0445,"0,00",oFont11,,,) 
oPrinter:Line(0490,0285,0490,0575) // Linha orizontal SALDO INICIAL
oPrinter:Line(0470,0430,0530,0430) // Linha Vertical entrada

oPrinter:Say(0505,0290,"RECEBIMENTO DA FLANGE M",oFont11,,,) 
oPrinter:Say(0505,0445,"0,00",oFont11,,,) 
oPrinter:Line(0510,0285,0510,0575) // Linha orizontal RECEBIMENTO

oPrinter:Say(0525,0290,"RECEBIMENTO REF. LATERAL",oFont11,,,) 
oPrinter:Say(0525,0445,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0530,0285,0550,0575}, oBrushCian, "-2")
oPrinter:Line(0530,0285,0530,0575) // Linha orizontal RECEBIMENTO

oPrinter:Say(0545,0290,"TOTAL",oFont11,,,) 
oPrinter:Say(0545,0445,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0550,0285,0570,0575}, oBrush1, "-2")
oPrinter:Line(0550,0285,0550,0575) // Linha orizontal TOTAL

oPrinter:Say(0565,0410,"SAIDAS",oFont11,,,) 
oPrinter:Line(0570,0285,0570,0575) // Linha orizontal SAIDAS
oPrinter:Line(0570,0430,0775,0430) // Linha Vertical entrada

oPrinter:Say(0585,0290,"FLANGE PREGADA",oFont11,,,) 
oPrinter:Say(0585,0445,"0,00",oFont11,,,) 
oPrinter:Line(0590,0285,0590,0575) // Linha orizontal - RIPAS DE FALNGES

oPrinter:Say(0605,0290,"PERDAS",oFont11,,,) 
oPrinter:Say(0605,0445,"0,00",oFont11,,,) 
oPrinter:Line(0610,0285,0610,0575) // Linha orizontal - RIPAS DE FALNGES

oPrinter:Say(0625,0290,"DEVOLUÇÃO(NÃO CONFORMIDADE)",oFont11,,,) 
oPrinter:Say(0625,0445,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0630,0285,0650,0575}, oBrushCian, "-2")
oPrinter:Line(0630,0285,0630,0575) // Linha orizontal DEVOLIÇÃO

oPrinter:Say(0645,0290,"TOTAL",oFont11,,,) 
oPrinter:Say(0645,0445,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0650,0285,0670,0575}, oBrush1, "-2")
oPrinter:Line(0650,0285,0650,0575) // Linha orizontal TOTAL

oPrinter:Say(0665,0410,"BALANÇO",oFont11,,,) 
oPrinter:Line(0670,0285,0670,0575) // Linha orizontal BALANÇO

oPrinter:Say(0685,0290,"SALDO FINAL",oFont11,,,) 
oPrinter:Say(0685,0445,"0,00",oFont11,,,) 
oPrinter:Line(0690,0285,0690,0575) // Linha orizontal SALDO FINAL

oPrinter:Say(0705,0290,"INVENTÁRIO",oFont11,,,) 
oPrinter:Say(0705,0445,"0,00",oFont11,,,) 
oPrinter:Fillrect( {0710,0285,0730,0575}, oBrushCian, "-2")
oPrinter:Line(0710,0285,0710,0575) // Linha orizontal INVENTÁRIO

oPrinter:Say(0725,0290,"DIFERENÇA DE SALDOS",oFont11,,,) 
oPrinter:Say(0725,0445,"0,00",oFont11,,,) 
oPrinter:Line(0730,0285,0730,0575) // Linha orizontal INVENTÁRIO
*/

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
