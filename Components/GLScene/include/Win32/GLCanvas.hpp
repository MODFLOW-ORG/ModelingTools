﻿// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'GLCanvas.pas' rev: 36.00 (Windows)

#ifndef GLCanvasHPP
#define GLCanvasHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Types.hpp>
#include <System.Classes.hpp>
#include <System.Math.hpp>
#include <Vcl.Graphics.hpp>
#include <OpenGLTokens.hpp>
#include <GLVectorGeometry.hpp>
#include <GLColor.hpp>
#include <GLCrossPlatform.hpp>
#include <GLContext.hpp>
#include <GLVectorTypes.hpp>
#include <GLState.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Glcanvas
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGLCanvas;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TArcDirection : unsigned char { adCounterClockWise, adClockWise };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLCanvas : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	int FBufferSizeX;
	int FBufferSizeY;
	int FLastPrimitive;
	Glvectorgeometry::TAffineVector FCurrentPos;
	System::Uitypes::TColor FPenColor;
	int FPenWidth;
	Glvectorgeometry::TVector FCurrentPenColorVector;
	TArcDirection FArcDirection;
	
protected:
	void __fastcall BackupOpenGLStates();
	void __fastcall StartPrimitive(const int primitiveType);
	void __fastcall EllipseVertices(float x, float y, float xRadius, float yRadius);
	void __fastcall SetPenColor(const System::Uitypes::TColor val);
	float __fastcall GetPenAlpha();
	void __fastcall SetPenAlpha(const float val);
	void __fastcall SetPenWidth(const int val);
	void __fastcall SwapSingle(System::PSingle pX, System::PSingle pY);
	void __fastcall NormalizePoint(const float x1, const float y1, const float x2, const float y2, const float x, const float y, System::PSingle pX, System::PSingle pY);
	void __fastcall DrawArc(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, bool UpdateCurrentPos)/* overload */;
	void __fastcall DrawArc(float x1, float y1, float x2, float y2, float AngleBegin, float AngleEnd, bool UpdateCurrentPos)/* overload */;
	
public:
	__fastcall TGLCanvas(int bufferSizeX, int bufferSizeY, const Glvectorgeometry::TMatrix &baseTransform)/* overload */;
	__fastcall TGLCanvas(int bufferSizeX, int bufferSizeY)/* overload */;
	__fastcall virtual ~TGLCanvas();
	void __fastcall StopPrimitive();
	void __fastcall InvertYAxis();
	__property int CanvasSizeX = {read=FBufferSizeX, nodefault};
	__property int CanvasSizeY = {read=FBufferSizeY, nodefault};
	__property System::Uitypes::TColor PenColor = {read=FPenColor, write=SetPenColor, nodefault};
	__property float PenAlpha = {read=GetPenAlpha, write=SetPenAlpha};
	__property int PenWidth = {read=FPenWidth, write=SetPenWidth, nodefault};
	void __fastcall MoveTo(const int x, const int y)/* overload */;
	void __fastcall MoveTo(const float x, const float y)/* overload */;
	void __fastcall MoveToRel(const int x, const int y)/* overload */;
	void __fastcall MoveToRel(const float x, const float y)/* overload */;
	void __fastcall LineTo(const int x, const int y)/* overload */;
	void __fastcall LineTo(const float x, const float y)/* overload */;
	void __fastcall LineToRel(const int x, const int y)/* overload */;
	void __fastcall LineToRel(const float x, const float y)/* overload */;
	void __fastcall Line(const int x1, const int y1, const int x2, const int y2)/* overload */;
	void __fastcall Line(const float x1, const float y1, const float x2, const float y2)/* overload */;
	void __fastcall Polyline(const System::Types::TPoint *points, const System::NativeInt points_High);
	void __fastcall Polygon(const System::Types::TPoint *points, const System::NativeInt points_High);
	void __fastcall PlotPixel(const int x, const int y)/* overload */;
	void __fastcall PlotPixel(const float x, const float y)/* overload */;
	void __fastcall FrameRect(const int x1, const int y1, const int x2, const int y2)/* overload */;
	void __fastcall FrameRect(const float x1, const float y1, const float x2, const float y2)/* overload */;
	void __fastcall FillRect(const int x1, const int y1, const int x2, const int y2)/* overload */;
	void __fastcall FillRect(const float x1, const float y1, const float x2, const float y2)/* overload */;
	void __fastcall FillRectGradient(const float x1, const float y1, const float x2, const float y2, const Glcolor::TColorVector &x1y1Color, const Glcolor::TColorVector &x2y1Color, const Glcolor::TColorVector &x2y2Color, const Glcolor::TColorVector &x1y2Color)/* overload */;
	void __fastcall FillRectGradient(const int x1, const int y1, const int x2, const int y2, const Glcolor::TColorVector &x1y1Color, const Glcolor::TColorVector &x2y1Color, const Glcolor::TColorVector &x2y2Color, const Glcolor::TColorVector &x1y2Color)/* overload */;
	void __fastcall EllipseBB(const int x1, const int y1, const int x2, const int y2)/* overload */;
	void __fastcall EllipseBB(const float x1, const float y1, const float x2, const float y2)/* overload */;
	void __fastcall Ellipse(const int x, const int y, const float xRadius, const float yRadius)/* overload */;
	void __fastcall Ellipse(const float x, const float y, const float xRadius, const float yRadius)/* overload */;
	void __fastcall Ellipse(const float x, const float y, const float Radius)/* overload */;
	void __fastcall FillEllipse(const int x, const int y, const float xRadius, const float yRadius)/* overload */;
	void __fastcall FillEllipse(const float x, const float y, const float xRadius, const float yRadius)/* overload */;
	void __fastcall FillEllipse(const float x, const float y, const float Radius)/* overload */;
	void __fastcall FillEllipseGradient(const float x, const float y, const float xRadius, const float yRadius, const Glcolor::TColorVector &edgeColor)/* overload */;
	void __fastcall FillEllipseGradient(const int x, const int y, const int xRadius, const int yRadius, const Glcolor::TColorVector &edgeColor)/* overload */;
	void __fastcall FillEllipseGradient(const float x, const float y, const float Radius, const Glcolor::TColorVector &edgeColor)/* overload */;
	void __fastcall Arc(const int x1, const int y1, const int x2, const int y2, const int x3, const int y3, const int x4, const int y4)/* overload */;
	void __fastcall Arc(const float x1, const float y1, const float x2, const float y2, const float x3, const float y3, const float x4, const float y4)/* overload */;
	void __fastcall Arc(const float x1, const float y1, const float x2, const float y2, float AngleBegin, float AngleEnd)/* overload */;
	void __fastcall ArcTo(const int x1, const int y1, const int x2, const int y2, const int x3, const int y3, const int x4, const int y4)/* overload */;
	void __fastcall ArcTo(const float x1, const float y1, const float x2, const float y2, const float x3, const float y3, const float x4, const float y4)/* overload */;
	void __fastcall ArcTo(const float x1, const float y1, const float x2, const float y2, float AngleBegin, float AngleEnd)/* overload */;
	void __fastcall RoundRect(const int x1, const int y1, const int x2, const int y2, const int xr, const int yr)/* overload */;
	void __fastcall RoundRect(const float x1, const float y1, const float x2, const float y2, const float xr, const float yr)/* overload */;
	__property TArcDirection ArcDirection = {read=FArcDirection, write=FArcDirection, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Glcanvas */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_GLCANVAS)
using namespace Glcanvas;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// GLCanvasHPP
