﻿// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'DDSImage.pas' rev: 36.00 (Windows)

#ifndef DDSImageHPP
#define DDSImageHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Graphics.hpp>
#include <GLVectorGeometry.hpp>
#include <GLGraphics.hpp>
#include <OpenGLTokens.hpp>
#include <GLContext.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ddsimage
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TDDSImage;
class DELPHICLASS EDDSException;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TDDSImage : public Vcl::Graphics::TBitmap
{
	typedef Vcl::Graphics::TBitmap inherited;
	
public:
	virtual void __fastcall LoadFromStream(System::Classes::TStream* stream);
	virtual void __fastcall SaveToStream(System::Classes::TStream* stream);
public:
	/* TBitmap.Create */ inline __fastcall virtual TDDSImage()/* overload */ : Vcl::Graphics::TBitmap() { }
	/* TBitmap.Create */ inline __fastcall TDDSImage(int AWidth, int AHeight)/* overload */ : Vcl::Graphics::TBitmap(AWidth, AHeight) { }
	/* TBitmap.Destroy */ inline __fastcall virtual ~TDDSImage() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION EDDSException : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EDDSException(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EDDSException(const System::UnicodeString Msg, const System::TVarRec *Args, const System::NativeInt Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EDDSException(System::NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EDDSException(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EDDSException(System::NativeUInt Ident, const System::TVarRec *Args, const System::NativeInt Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EDDSException(System::PResStringRec ResStringRec, const System::TVarRec *Args, const System::NativeInt Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EDDSException(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EDDSException(const System::UnicodeString Msg, const System::TVarRec *Args, const System::NativeInt Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDDSException(System::NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EDDSException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDDSException(System::PResStringRec ResStringRec, const System::TVarRec *Args, const System::NativeInt Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EDDSException(System::NativeUInt Ident, const System::TVarRec *Args, const System::NativeInt Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EDDSException() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Ddsimage */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_DDSIMAGE)
using namespace Ddsimage;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DDSImageHPP
