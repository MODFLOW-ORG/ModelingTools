﻿// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'GLSLanguage.pas' rev: 36.00 (Windows)

#ifndef GLSLanguageHPP
#define GLSLanguageHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.IniFiles.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Glslanguage
{
//-- forward type declarations -----------------------------------------------
struct TGLLanguageEntry;
class DELPHICLASS TGLLanguage;
class DELPHICLASS TGLLanguageExt;
class DELPHICLASS TGLSLanguage;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TGLLanguageEntry
{
public:
	System::UnicodeString ID;
	System::UnicodeString Text;
};


typedef System::DynamicArray<TGLLanguageEntry> TGLLanguageEntryArray;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLLanguage : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::UnicodeString FCurrentLanguageFile;
	TGLLanguageEntryArray Entry;
	
public:
	int __fastcall FindID(const System::UnicodeString ID);
	System::UnicodeString __fastcall Translate(const System::UnicodeString ID);
	void __fastcall LoadLanguageFromFile(const System::UnicodeString Language);
	__property System::UnicodeString CurrentLanguageFile = {read=FCurrentLanguageFile};
public:
	/* TObject.Create */ inline __fastcall TGLLanguage() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGLLanguage() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLLanguageExt : public TGLLanguage
{
	typedef TGLLanguage inherited;
	
private:
	TGLLanguageEntry __fastcall GetEntry(int Index);
	void __fastcall SetEntry(int Index, const TGLLanguageEntry &aValue);
	int __fastcall GetCount();
	
public:
	void __fastcall AddConst(const System::UnicodeString ID, const System::UnicodeString Text);
	void __fastcall AddConsts(System::Classes::TStrings* aValues);
	void __fastcall ChangeConst(const System::UnicodeString ID, const System::UnicodeString Text);
	__property TGLLanguageEntry Items[int Index] = {read=GetEntry, write=SetEntry};
	__property int Count = {read=GetCount, nodefault};
	void __fastcall SaveLanguageFromFile(const System::UnicodeString Language)/* overload */;
	void __fastcall SaveLanguageFromFile()/* overload */;
public:
	/* TObject.Create */ inline __fastcall TGLLanguageExt() : TGLLanguage() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGLLanguageExt() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TGLSLanguage : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	TGLLanguageExt* FLanguage;
	System::Classes::TStrings* FLanguageList;
	void __fastcall SetLanguage(TGLLanguageExt* aValue);
	
public:
	__fastcall virtual TGLSLanguage(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TGLSLanguage();
	void __fastcall LoadLanguageFromFile(const System::UnicodeString Language);
	void __fastcall SaveLanguageFromFile(const System::UnicodeString Language)/* overload */;
	void __fastcall SaveLanguageFromFile()/* overload */;
	System::UnicodeString __fastcall Translate(const System::UnicodeString ID);
	__property TGLLanguageExt* Language = {read=FLanguage, write=SetLanguage};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Glslanguage */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_GLSLANGUAGE)
using namespace Glslanguage;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// GLSLanguageHPP
