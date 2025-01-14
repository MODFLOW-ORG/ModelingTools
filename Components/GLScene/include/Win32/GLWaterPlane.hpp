﻿// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'GLWaterPlane.pas' rev: 36.00 (Windows)

#ifndef GlwaterplaneHPP
#define GlwaterplaneHPP

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
#include <Vcl.Graphics.hpp>
#include <OpenGLTokens.hpp>
#include <GLVectorGeometry.hpp>
#include <GLScene.hpp>
#include <GLVectorLists.hpp>
#include <GLCrossPlatform.hpp>
#include <GLPersistentClasses.hpp>
#include <GLBaseClasses.hpp>
#include <GLContext.hpp>
#include <GLRenderContextInfo.hpp>
#include <GLVectorTypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Glwaterplane
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGLWaterPlane;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TGLWaterPlaneOption : unsigned char { wpoTextured };

typedef System::Set<TGLWaterPlaneOption, TGLWaterPlaneOption::wpoTextured, TGLWaterPlaneOption::wpoTextured> TGLWaterPlaneOptions;

class PASCALIMPLEMENTATION TGLWaterPlane : public Glscene::TGLSceneObject
{
	typedef Glscene::TGLSceneObject inherited;
	
	
private:
	typedef System::DynamicArray<System::ByteBool> _TGLWaterPlane__1;
	
	typedef System::DynamicArray<float> _TGLWaterPlane__2;
	
	
private:
	_TGLWaterPlane__1 FLocks;
	_TGLWaterPlane__2 FPositions;
	_TGLWaterPlane__2 FVelocity;
	Glpersistentclasses::TPersistentObjectList* FPlaneQuadIndices;
	Glvectorlists::TTexPointList* FPlaneQuadTexCoords;
	Glvectorlists::TAffineVectorList* FPlaneQuadVertices;
	Glvectorlists::TAffineVectorList* FPlaneQuadNormals;
	bool FActive;
	int FRainTimeInterval;
	float FRainForce;
	float FViscosity;
	float FElastic;
	int FResolution;
	float FSimulationFrequency;
	float FTimeToNextUpdate;
	float FTimeToNextRainDrop;
	int FMaximumCatchupIterations;
	float FLastIterationStepTime;
	Vcl::Graphics::TPicture* FMask;
	TGLWaterPlaneOptions FOptions;
	
protected:
	void __fastcall SetElastic(const float value);
	void __fastcall SetResolution(const int value);
	void __fastcall SetRainTimeInterval(const int val);
	void __fastcall SetViscosity(const float val);
	void __fastcall SetRainForce(const float val);
	void __fastcall SetSimulationFrequency(const float val);
	void __fastcall SetMask(Vcl::Graphics::TPicture* val);
	void __fastcall SetOptions(const TGLWaterPlaneOptions val);
	void __fastcall DoMaskChanged(System::TObject* Sender);
	void __fastcall InitResolution();
	void __fastcall IterComputeVelocity();
	void __fastcall IterComputePositions();
	void __fastcall IterComputeNormals();
	void __fastcall Iterate();
	
public:
	__fastcall virtual TGLWaterPlane(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TGLWaterPlane();
	virtual void __fastcall DoProgress(const Glbaseclasses::TGLProgressTimes &progressTime);
	virtual void __fastcall BuildList(Glrendercontextinfo::TGLRenderContextInfo &rci);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual Glvectorgeometry::TVector __fastcall AxisAlignedDimensionsUnscaled();
	void __fastcall CreateRippleAtGridPos(int X, int Y);
	void __fastcall CreateRippleAtWorldPos(const float x, const float y, const float z)/* overload */;
	void __fastcall CreateRippleAtWorldPos(const Glvectorgeometry::TVector &pos)/* overload */;
	void __fastcall CreateRippleRandom();
	void __fastcall Reset();
	__property float LastIterationStepTime = {read=FLastIterationStepTime};
	
__published:
	__property bool Active = {read=FActive, write=FActive, default=1};
	__property int RainTimeInterval = {read=FRainTimeInterval, write=SetRainTimeInterval, default=500};
	__property float RainForce = {read=FRainForce, write=SetRainForce};
	__property float Viscosity = {read=FViscosity, write=SetViscosity};
	__property float Elastic = {read=FElastic, write=SetElastic};
	__property int Resolution = {read=FResolution, write=SetResolution, default=64};
	__property TGLWaterPlaneOptions Options = {read=FOptions, write=SetOptions, default=1};
	__property Vcl::Graphics::TPicture* Mask = {read=FMask, write=SetMask};
	__property float SimulationFrequency = {read=FSimulationFrequency, write=SetSimulationFrequency};
	__property int MaximumCatchupIterations = {read=FMaximumCatchupIterations, write=FMaximumCatchupIterations, default=1};
public:
	/* TGLBaseSceneObject.CreateAsChild */ inline __fastcall TGLWaterPlane(Glscene::TGLBaseSceneObject* aParentOwner) : Glscene::TGLSceneObject(aParentOwner) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define cDefaultWaterPlaneOptions (System::Set<TGLWaterPlaneOption, TGLWaterPlaneOption::wpoTextured, TGLWaterPlaneOption::wpoTextured>() << TGLWaterPlaneOption::wpoTextured )
}	/* namespace Glwaterplane */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_GLWATERPLANE)
using namespace Glwaterplane;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// GlwaterplaneHPP
