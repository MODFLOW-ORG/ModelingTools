﻿// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'GLTextureImageEditors.pas' rev: 36.00 (Windows)

#ifndef GLTextureImageEditorsHPP
#define GLTextureImageEditorsHPP

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
#include <System.SysUtils.hpp>
#include <GLTexture.hpp>
#include <GLProcTextures.hpp>

//-- user supplied -----------------------------------------------------------

namespace Gltextureimageeditors
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGLTextureImageEditor;
class DELPHICLASS TGLBlankTIE;
class DELPHICLASS TGLPersistentTIE;
class DELPHICLASS TGLPicFileTIE;
class DELPHICLASS TGLProcTextureNoiseTIE;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLTextureImageEditor : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod virtual bool __fastcall Edit(Gltexture::TGLTextureImage* aTexImage);
public:
	/* TObject.Create */ inline __fastcall TGLTextureImageEditor() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGLTextureImageEditor() { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TGLTextureImageEditorClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLBlankTIE : public TGLTextureImageEditor
{
	typedef TGLTextureImageEditor inherited;
	
public:
	__classmethod virtual bool __fastcall Edit(Gltexture::TGLTextureImage* aTexImage);
public:
	/* TObject.Create */ inline __fastcall TGLBlankTIE() : TGLTextureImageEditor() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGLBlankTIE() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLPersistentTIE : public TGLTextureImageEditor
{
	typedef TGLTextureImageEditor inherited;
	
public:
	__classmethod virtual bool __fastcall Edit(Gltexture::TGLTextureImage* aTexImage);
public:
	/* TObject.Create */ inline __fastcall TGLPersistentTIE() : TGLTextureImageEditor() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGLPersistentTIE() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLPicFileTIE : public TGLTextureImageEditor
{
	typedef TGLTextureImageEditor inherited;
	
public:
	__classmethod virtual bool __fastcall Edit(Gltexture::TGLTextureImage* aTexImage);
public:
	/* TObject.Create */ inline __fastcall TGLPicFileTIE() : TGLTextureImageEditor() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGLPicFileTIE() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLProcTextureNoiseTIE : public TGLTextureImageEditor
{
	typedef TGLTextureImageEditor inherited;
	
public:
	__classmethod virtual bool __fastcall Edit(Gltexture::TGLTextureImage* aTexImage);
public:
	/* TObject.Create */ inline __fastcall TGLProcTextureNoiseTIE() : TGLTextureImageEditor() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGLProcTextureNoiseTIE() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall EditGLTextureImage(Gltexture::TGLTextureImage* aTexImage);
extern DELPHI_PACKAGE void __fastcall RegisterGLTextureImageEditor(Gltexture::TGLTextureImageClass aTexImageClass, TGLTextureImageEditorClass texImageEditor);
extern DELPHI_PACKAGE void __fastcall UnRegisterGLTextureImageEditor(TGLTextureImageEditorClass texImageEditor);
}	/* namespace Gltextureimageeditors */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_GLTEXTUREIMAGEEDITORS)
using namespace Gltextureimageeditors;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// GLTextureImageEditorsHPP
