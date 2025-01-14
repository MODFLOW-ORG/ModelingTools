﻿// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'GLRagdoll.pas' rev: 36.00 (Windows)

#ifndef GlragdollHPP
#define GlragdollHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <GLScene.hpp>
#include <GLPersistentClasses.hpp>
#include <GLVectorGeometry.hpp>
#include <GLVectorFileObjects.hpp>
#include <GLVectorLists.hpp>
#include <GLObjects.hpp>
#include <System.Classes.hpp>
#include <GLVectorTypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Glragdoll
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGLRagdolJoint;
class DELPHICLASS TGLRagdolBoneList;
class DELPHICLASS TGLRagdolBone;
class DELPHICLASS TGLRagdoll;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLRagdolJoint : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	/* TObject.Create */ inline __fastcall TGLRagdolJoint() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TGLRagdolJoint() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLRagdolBoneList : public Glpersistentclasses::TPersistentObjectList
{
	typedef Glpersistentclasses::TPersistentObjectList inherited;
	
public:
	TGLRagdolBone* operator[](int Index) { return this->Items[Index]; }
	
private:
	TGLRagdoll* FRagdoll;
	
protected:
	TGLRagdolBone* __fastcall GetRagdollBone(int Index);
	
public:
	__fastcall TGLRagdolBoneList(TGLRagdoll* Ragdoll);
	__fastcall virtual ~TGLRagdolBoneList();
	DYNAMIC void __fastcall WriteToFiler(Glpersistentclasses::TVirtualWriter* writer);
	DYNAMIC void __fastcall ReadFromFiler(Glpersistentclasses::TVirtualReader* reader);
	__property TGLRagdoll* Ragdoll = {read=FRagdoll};
	__property TGLRagdolBone* Items[int Index] = {read=GetRagdollBone/*, default*/};
public:
	/* TPersistentObject.CreateFromFiler */ inline __fastcall TGLRagdolBoneList(Glpersistentclasses::TVirtualReader* reader) : Glpersistentclasses::TPersistentObjectList(reader) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLRagdolBone : public TGLRagdolBoneList
{
	typedef TGLRagdolBoneList inherited;
	
public:
	TGLRagdolBone* operator[](int Index) { return this->Items[Index]; }
	
private:
	TGLRagdolBoneList* FOwner;
	System::UnicodeString FName;
	int FBoneID;
	Glvectorgeometry::TAffineVector FBoundMax;
	Glvectorgeometry::TAffineVector FBoundMin;
	Glvectorgeometry::TAffineVector FBoundBoneDelta;
	Glvectorgeometry::TAffineVector FOrigin;
	Glvectorgeometry::TAffineVector FSize;
	Glvectorgeometry::TMatrix FBoneMatrix;
	TGLRagdolJoint* FJoint;
	Glvectorgeometry::TMatrix FOriginalMatrix;
	Glvectorgeometry::TMatrix FReferenceMatrix;
	Glvectorgeometry::TAffineVector FAnchor;
	void __fastcall CreateBoundingBox();
	void __fastcall SetAnchor(const Glvectorgeometry::TAffineVector &Anchor);
	void __fastcall AlignToSkeleton();
	void __fastcall CreateBoundsChild();
	void __fastcall StartChild();
	void __fastcall AlignChild();
	void __fastcall UpdateChild();
	void __fastcall StopChild();
	
protected:
	HIDESBASE TGLRagdolBone* __fastcall GetRagdollBone(int Index);
	virtual void __fastcall Start() = 0 ;
	virtual void __fastcall Align() = 0 ;
	virtual void __fastcall Update() = 0 ;
	virtual void __fastcall Stop() = 0 ;
	
public:
	__fastcall TGLRagdolBone(TGLRagdolBoneList* aOwner);
	__fastcall TGLRagdolBone(TGLRagdoll* Ragdoll);
	__fastcall virtual ~TGLRagdolBone();
	DYNAMIC void __fastcall WriteToFiler(Glpersistentclasses::TVirtualWriter* writer);
	DYNAMIC void __fastcall ReadFromFiler(Glpersistentclasses::TVirtualReader* reader);
	__property TGLRagdolBoneList* Owner = {read=FOwner};
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property int BoneID = {read=FBoneID, write=FBoneID, nodefault};
	__property Glvectorgeometry::TAffineVector Origin = {read=FOrigin};
	__property Glvectorgeometry::TAffineVector Size = {read=FSize};
	__property Glvectorgeometry::TMatrix BoneMatrix = {read=FBoneMatrix};
	__property Glvectorgeometry::TMatrix ReferenceMatrix = {read=FReferenceMatrix};
	__property Glvectorgeometry::TAffineVector Anchor = {read=FAnchor};
	__property TGLRagdolJoint* Joint = {read=FJoint, write=FJoint};
	__property TGLRagdolBone* Items[int Index] = {read=GetRagdollBone/*, default*/};
public:
	/* TPersistentObject.CreateFromFiler */ inline __fastcall TGLRagdolBone(Glpersistentclasses::TVirtualReader* reader) : TGLRagdolBoneList(reader) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGLRagdoll : public Glpersistentclasses::TPersistentObject
{
	typedef Glpersistentclasses::TPersistentObject inherited;
	
private:
	Glvectorfileobjects::TGLBaseMesh* FOwner;
	TGLRagdolBone* FRootBone;
	bool FEnabled;
	bool FBuilt;
	
public:
	__fastcall TGLRagdoll(Glvectorfileobjects::TGLBaseMesh* AOwner);
	__fastcall virtual ~TGLRagdoll();
	DYNAMIC void __fastcall WriteToFiler(Glpersistentclasses::TVirtualWriter* writer);
	DYNAMIC void __fastcall ReadFromFiler(Glpersistentclasses::TVirtualReader* reader);
	void __fastcall SetRootBone(TGLRagdolBone* RootBone);
	void __fastcall BuildRagdoll();
	void __fastcall Start();
	void __fastcall Update();
	void __fastcall Stop();
	__property Glvectorfileobjects::TGLBaseMesh* Owner = {read=FOwner};
	__property TGLRagdolBone* RootBone = {read=FRootBone};
	__property bool Enabled = {read=FEnabled, nodefault};
public:
	/* TPersistentObject.CreateFromFiler */ inline __fastcall TGLRagdoll(Glpersistentclasses::TVirtualReader* reader) : Glpersistentclasses::TPersistentObject(reader) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Glragdoll */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_GLRAGDOLL)
using namespace Glragdoll;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// GlragdollHPP
