﻿// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Gloutlineshader.pas' rev: 36.00 (Windows)

#ifndef GloutlineshaderHPP
#define GloutlineshaderHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <Sysinit.hpp>
#include <System.Classes.hpp>
#include <Opengltokens.hpp>
#include <Glmaterial.hpp>
#include <Glcontext.hpp>
#include <Glcolor.hpp>
#include <Glstate.hpp>
#include <Glrendercontextinfo.hpp>
#include <Glbaseclasses.hpp>

//-- user supplied -----------------------------------------------------------

namespace Gloutlineshader
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGLOutlineShader;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TGLOutlineShader : public Glmaterial::TGLShader
{
	typedef Glmaterial::TGLShader inherited;
	
private:
	int FPassCount;
	Glcolor::TGLColor* FLineColor;
	bool FOutlineSmooth;
	float FOutlineWidth;
	void __fastcall SetOutlineWidth(float v);
	void __fastcall SetOutlineSmooth(bool v);
	
protected:
	virtual void __fastcall DoApply(Glrendercontextinfo::TGLRenderContextInfo &rci, System::TObject* Sender);
	virtual bool __fastcall DoUnApply(Glrendercontextinfo::TGLRenderContextInfo &rci);
	
public:
	__fastcall virtual TGLOutlineShader(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TGLOutlineShader();
	
__published:
	__property Glcolor::TGLColor* LineColor = {read=FLineColor, write=FLineColor};
	__property bool LineSmooth = {read=FOutlineSmooth, write=SetOutlineSmooth, default=0};
	__property float LineWidth = {read=FOutlineWidth, write=SetOutlineWidth};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Gloutlineshader */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_GLOUTLINESHADER)
using namespace Gloutlineshader;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// GloutlineshaderHPP
