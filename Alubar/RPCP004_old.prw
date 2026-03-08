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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออัอออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RPCP004    บAutor ณIsmael Junior     บ Data ณ  02/03/2026  บฑฑ
ฑฑฬออออออออออุออออออออออสออออออฯอออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ STATUS DE PROGRAMAวรO                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
cStartPath := GetSrvProfString('Startpath','')
cCaminho := 'C:\atualizacao\'//GetTempPath()
FErase( cCaminho+cFile+'.pdf' )
_cSql		:= ''
aAdd(aPergs, {1, "Data De",  dDataDe,  "", ".T.", "", ".T.", 80,  .T.})
aAdd(aPergs, {1, "Data At้", dDataAt,  "", ".T.", "", ".T.", 80,  .T.})
// If !ParamBox(aPergs, "Informe os parโmetros")
//     return nil    
// EndIf 
MV_PAR01 := dDataDe
MV_PAR02 := dDataAt
oPrinter:SetLandscape() // SetPortrait()
oPrinter:SetResolution(72)
oPrinter:SetPaperSize(DMPAPER_A4)
//oPrinter:SetMargin(5,5,5,5) // nEsquerda, nSuperior, nDireita, nInferior
oPrinter:StartPage()

oPrinter:Box(15,2,95,840)  // QUADRO CABEวALHO (L1, C1, L2, C2)
cFileLogo	:= cStartPath + 'LGRL.BMP' 
oPrinter:SayBitmap( 25, 8, cFileLogo, 70, 65)
oPrinter:Say(55,215,"STATUS DE PROGRAMAวรO | ALUBAR MONTENEGRO | AMN",oFont20n)
oPrinter:Say(80,260,"FABRICA DE CARRETEL | "+DTOC(MV_PAR01) + " - "+DTOC(MV_PAR02),oFont20n)

oPrinter:Box(105,2,230,840)  // QUADRO TIPO DE PRODUTO (L1, C1, L2, C2)
oPrinter:Fillrect( {105,2,155,420}, oBrushBlue, "-2")
oPrinter:Fillrect( {105,420,155,840}, oBrushGray, "-2")
oPrinter:Fillrect( {205,2,230,840}, oBrushGray, "-2") 
oPrinter:Say(136,150,"TIPO DE PRODUTO",oFont16n,,CLR_WHITE)
oPrinter:Say(125,450,"PROGRAMADO",oFont16n)
oPrinter:Say(125,730,"DIFERENวA",oFont16n)
oPrinter:Say(150,445,"MสS",oFont16n)
oPrinter:Say(150,513,"PERIODO",oFont16n) 
oPrinter:Say(135,592,"REALIZADO",oFont16n)
oPrinter:Say(150,700,"(UNID)",oFont16n)
oPrinter:Say(150,790,"(%)",oFont16n)

oPrinter:Line(105,420,230,420) // Linha Vertical tipo de produto
oPrinter:Line(130,420,130,580) // Linha orizontal Programado
oPrinter:Line(130,680,130,840) // Linha orizontal Diferen็a 
oPrinter:Line(155,2,155,840) // Linha orizontal tipo de produto

oPrinter:Line(130,500,230,500) // Linha Vertical mes
oPrinter:Line(105,580,230,580) // Linha Vertical periodo
oPrinter:Line(105,680,230,680) // Linha Vertical realizado --
oPrinter:Line(130,760,230,760) // Linha Vertical (unid)
nValor := 1574
nVlneg := -1919
nPerce := -50
oPrinter:Say(175,190,"CARRETEL",oFont16n)
oPrinter:Say(175,425,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) //mes
oPrinter:Say(175,505,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) // periodo
oPrinter:Say(175,590,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) // realizado
oPrinter:Say(175,685,Alltrim(transform(nVlneg,"@E 999,999,999")),oFont14,iif(nVlneg < 0 ,CLR_HRED,)) // unid
oPrinter:Say(175,765,Alltrim(transform(nPerce,"@E 999"))+'%',oFont14,,iif(nPerce < 0 ,CLR_HRED,)) // %
oPrinter:Line(180,2,180,840) // Linha orizontal carretel

oPrinter:Say(200,130,"CONJUNTO DE FECHAMENTO",oFont16n)
oPrinter:Say(200,425,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) //mes
oPrinter:Say(200,505,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) // periodo
oPrinter:Say(200,590,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) // realizado
oPrinter:Say(200,685,Alltrim(transform(nVlneg,"@E 999,999,999")),oFont14,iif(nVlneg < 0 ,CLR_HRED,)) // unid
oPrinter:Say(200,765,Alltrim(transform(nPerce,"@E 999"))+'%',oFont16n,,iif(nPerce < 0 ,CLR_HRED,)) // %
oPrinter:Line(205,2,205,840) // Linha orizontal conjunto de fechamento
oPrinter:Say(225,185,"TOTAL (UND)",oFont16n)
oPrinter:Say(225,425,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) //mes
oPrinter:Say(225,505,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) // periodo
oPrinter:Say(225,590,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) // realizado
oPrinter:Say(225,685,Alltrim(transform(nVlneg,"@E 999,999,999")),oFont14,iif(nVlneg < 0 ,CLR_HRED,)) // unid
oPrinter:Say(225,765,Alltrim(transform(nPerce,"@E 999"))+'%',oFont14,,CLR_BLUE) // %

// ************ DETALHAMENTO POR PRODUTO ********************
oPrinter:Box(235,2,590,840)  // DETALHAMENTO POR PRODUTO (L1, C1, L2, C2)
oPrinter:Fillrect( {235,2,310,420}, oBrushCyan, "-2")
oPrinter:Fillrect( {235,420,310,840}, oBrushGray, "-2")
//oPrinter:Fillrect( {205,2,575,840}, oBrushGray, "-2")

oPrinter:Line(235,420,590,420) // Linha Vertical detalhamento de produto
nLin := 260
oPrinter:Say(nLin-5,125,"DETALHAMENTO POR PRODUTO",oFont16n)
oPrinter:Say(nLin-5,450,"PROGRAMADO",oFont16n)
oPrinter:Line(nLin,2,nLin,580) // Linha orizontal detalhamento de produto e Programado
nLin := nLin + 25
oPrinter:Say(nLin+5,10,"CLIENTE",oFont16n)
oPrinter:Say(nLin-5,210,"TIPO DE PRODUTO",oFont16n)
oPrinter:Say(nLin-5,445,"MสS",oFont16n)
oPrinter:Say(nLin-5,513,"PERIODO",oFont16n)
oPrinter:Say(nLin-15,592,"REALIZADO",oFont16n) 
oPrinter:Say(nLin-15,700,"(UNID)",oFont16n)
oPrinter:Say(nLin-15,790,"(%)",oFont16n)
oPrinter:Line(nLin,100,nLin,840) // Linha orizontal tipo de produto
nLin := nLin + 25
oPrinter:Say(nLin-5,240,"CARRETEL",oFont16n)
oPrinter:Say(nLin-5,425,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) //mes
oPrinter:Say(nLin-5,505,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) // periodo
oPrinter:Say(nLin-5,590,Alltrim(transform(nValor,"@E 999,999,999")),oFont14) // realizado
oPrinter:Say(nLin-5,685,Alltrim(transform(nVlneg,"@E 999,999,999")),oFont14,iif(nVlneg < 0 ,CLR_HRED,)) // unid
oPrinter:Say(nLin-5,765,Alltrim(transform(nPerce,"@E 999"))+'%',oFont14,,iif(nPerce < 0 ,CLR_HRED,)) // %
oPrinter:Line(nLin,100,nLin,840) // Linha orizontal Carretel

oPrinter:Line(260,100,590,100) // Linha Vertical cliente
oPrinter:Line(260,500,590,500) // Linha Vertical mes
oPrinter:Line(235,580,590,580) // Linha Vertical periodo
oPrinter:Line(235,680,590,680) // Linha Vertical realizado --
oPrinter:Line(235,760,590,760) // Linha Vertical (unid)

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
