inherited frameScreenObjectPrp: TframeScreenObjectPrp
  Width = 547
  Height = 435
  ExplicitWidth = 547
  ExplicitHeight = 435
  object lblPackage: TLabel
    Left = 3
    Top = 40
    Width = 68
    Height = 15
    Caption = 'PRP Package'
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 547
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object pnlCaption: TPanel
      Left = 0
      Top = 0
      Width = 547
      Height = 25
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
    end
  end
  object rstcPrpPackage: TRbwStringTreeCombo
    Left = 3
    Top = 61
    Width = 398
    Height = 23
    Tree.Left = 0
    Tree.Top = 0
    Tree.Width = 624
    Tree.Height = 441
    Tree.Align = alClient
    Tree.Colors.BorderColor = 15987699
    Tree.Colors.DisabledColor = clGray
    Tree.Colors.DropMarkColor = 15385233
    Tree.Colors.DropTargetColor = 15385233
    Tree.Colors.DropTargetBorderColor = 15385233
    Tree.Colors.FocusedSelectionColor = 15385233
    Tree.Colors.FocusedSelectionBorderColor = 15385233
    Tree.Colors.GridLineColor = 15987699
    Tree.Colors.HeaderHotColor = clBlack
    Tree.Colors.HotColor = clBlack
    Tree.Colors.SelectionRectangleBlendColor = 15385233
    Tree.Colors.SelectionRectangleBorderColor = 15385233
    Tree.Colors.SelectionTextColor = clBlack
    Tree.Colors.TreeLineColor = 9471874
    Tree.Colors.UnfocusedColor = clGray
    Tree.Colors.UnfocusedSelectionColor = clWhite
    Tree.Colors.UnfocusedSelectionBorderColor = clWhite
    Tree.DefaultNodeHeight = 19
    Tree.Header.AutoSizeIndex = 0
    Tree.Header.Height = 15
    Tree.Header.MainColumn = -1
    Tree.TabOrder = 0
    Tree.OnFreeNode = rstcPrpPackageTreeFreeNode
    Tree.OnGetText = rstcPrpPackageTreeGetText
    Tree.OnGetNodeDataSize = rstcPrpPackageTreeGetNodeDataSize
    Tree.OnInitNode = rstcPrpPackageTreeInitNode
    Tree.Touch.InteractiveGestures = [igPan, igPressAndTap]
    Tree.Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Tree.ExplicitWidth = 200
    Tree.ExplicitHeight = 100
    Tree.Columns = <>
    Enabled = True
    Glyph.Data = {
      36020000424D3602000000000000360000002800000010000000080000000100
      2000000000000002000000000000000000000000000000000000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F00000000000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000C0C0C000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000000000000000000000000000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000C0C0C000C0C0C000C0C0C000F0F0F000F0F0F000F0F0F000F0F0F0000000
      000000000000000000000000000000000000F0F0F000F0F0F000F0F0F000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000F0F0F000F0F0F000000000000000
      00000000000000000000000000000000000000000000F0F0F000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0
      F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000F0F0F000}
    NumGlyphs = 2
    TabOrder = 1
    OnChange = rstcPrpPackageChange
  end
  inline frameModpathParticles: TframeModpathParticles
    Left = 0
    Top = 124
    Width = 547
    Height = 311
    Align = alBottom
    TabOrder = 2
    TabStop = True
    ExplicitTop = 124
    ExplicitWidth = 547
    inherited gbParticles: TJvGroupBox
      Width = 547
      OnCheckBoxClick = frameModpathParticlesgbParticlesCheckBoxClick
      ExplicitWidth = 547
      inherited lblTimeCount: TLabel
        Visible = False
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited sbAddTime: TSpeedButton
        Left = 402
        Visible = False
        ExplicitLeft = 402
      end
      inherited sbInsertTime: TSpeedButton
        Left = 435
        Visible = False
        ExplicitLeft = 435
      end
      inherited sbDeleteTime: TSpeedButton
        Left = 468
        Visible = False
        ExplicitLeft = 468
      end
      inherited lblMessage: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited rgChoice: TRadioGroup
        TabOrder = 0
        OnClick = frameModpathParticlesrgChoiceClick
      end
      inherited GLSceneViewer1: TGLSceneViewer
        TabOrder = 3
      end
      inherited plParticlePlacement: TJvPageList
        inherited jvspGrid: TJvStandardPage
          inherited lblX: TLabel
            Width = 159
            Height = 15
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 159
            ExplicitHeight = 15
          end
          inherited lblY: TLabel
            Width = 159
            Height = 15
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 159
            ExplicitHeight = 15
          end
          inherited lblZ: TLabel
            Width = 159
            Height = 15
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 159
            ExplicitHeight = 15
          end
          inherited cbLeftFace: TCheckBox
            OnClick = frameModpathParticlescbLeftFaceClick
          end
          inherited cbRightFace: TCheckBox
            OnClick = frameModpathParticlescbLeftFaceClick
          end
          inherited cbFrontFace: TCheckBox
            OnClick = frameModpathParticlescbLeftFaceClick
          end
          inherited cbBackFace: TCheckBox
            OnClick = frameModpathParticlescbLeftFaceClick
          end
          inherited cbBottomFace: TCheckBox
            OnClick = frameModpathParticlescbLeftFaceClick
          end
          inherited cbTopFace: TCheckBox
            OnClick = frameModpathParticlescbLeftFaceClick
          end
          inherited cbInternal: TCheckBox
            OnClick = frameModpathParticlescbLeftFaceClick
          end
          inherited seX: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameModpathParticlesseXChange
          end
          inherited seY: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameModpathParticlesseXChange
          end
          inherited seZ: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameModpathParticlesseXChange
          end
        end
        inherited jvspCylinder: TJvStandardPage
          inherited lblCylParticleCount: TLabel
            Width = 149
            Height = 30
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 149
            ExplicitHeight = 30
          end
          inherited lblClylLayerCount: TLabel
            Width = 152
            Height = 15
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 152
            ExplicitHeight = 15
          end
          inherited lblCylRadius: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited rgCylinderOrientation: TRadioGroup
            OnClick = frameModpathParticlesrgCylinderOrientationClick
          end
          inherited seCylParticleCount: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameModpathParticlesseXChange
          end
          inherited seCylLayerCount: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameModpathParticlesseXChange
          end
          inherited seCylRadius: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameModpathParticlesseCylRadiusChange
          end
        end
        inherited jvspSphere: TJvStandardPage
          inherited lblSpherParticleCount: TLabel
            Width = 149
            Height = 30
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 149
            ExplicitHeight = 30
          end
          inherited lblSpherelLayerCount: TLabel
            Width = 152
            Height = 15
            StyleElements = [seFont, seClient, seBorder]
            ExplicitWidth = 152
            ExplicitHeight = 15
          end
          inherited lblSphereRadius: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited rgSphereOrientation: TRadioGroup
            OnClick = frameModpathParticlesrgCylinderOrientationClick
          end
          inherited seSphereParticleCount: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameModpathParticlesseXChange
          end
          inherited seSphereLayerCount: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameModpathParticlesseXChange
          end
          inherited seSphereRadius: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
            OnChange = frameModpathParticlesseCylRadiusChange
          end
        end
        inherited jvspIndividual: TJvStandardPage
          inherited rdgSpecific: TRbwDataGrid4
            FixedCols = 0
            OnSetEditText = frameModpathParticlesrdgSpecificSetEditText
          end
          inherited pnlBottom: TPanel
            StyleElements = [seFont, seClient, seBorder]
            inherited lblCount: TLabel
              StyleElements = [seFont, seClient, seBorder]
            end
            inherited seSpecificParticleCount: TJvSpinEdit
              StyleElements = [seFont, seClient, seBorder]
              OnChange = frameModpathParticlesseSpecificParticleCountChange
            end
          end
        end
      end
      inherited seTimeCount: TJvSpinEdit
        StyleElements = [seFont, seClient, seBorder]
        TabOrder = 4
        Visible = False
      end
      inherited rdgReleaseTimes: TRbwDataGrid4
        FixedCols = 0
        TabOrder = 1
        Visible = False
      end
    end
    inherited GLScene1: TGLScene
      inherited GLDummyCube: TGLDummyCube
        Direction.Coordinates = {D36D79B2D7B35DBF010000BF00000000}
        Scale.Coordinates = {00000040000000400000004000000000}
        Up.Coordinates = {1C1DAFBEBC8FF0BE1155503F00000000}
        inherited GLLightSource1: TGLLightSource
          Position.Coordinates = {0000204100002041000020410000803F}
        end
        inherited BottomPlane: TGLPlane
          Material.BackProperties.Diffuse.Color = {0AD7633FD7A3F03ECDCC4C3E0000803F}
          Material.FrontProperties.Diffuse.Color = {00000000000000000000803F0000803F}
          Direction.Coordinates = {000000002EBDBBB3000080BF00000000}
          Position.Coordinates = {00000000000000000000003F0000803F}
          Up.Coordinates = {00000000000080BF2EBDBB3300000000}
        end
        inherited LeftPlane: TGLPlane
          Material.FrontProperties.Diffuse.Color = {8FC2753FCDCC4C3FD7A3303F0000803F}
          Direction.Coordinates = {0000803F000000002EBD3BB300000000}
          Position.Coordinates = {000000BF00000000000000000000803F}
        end
        inherited BackPlane: TGLPlane
          Material.FrontProperties.Diffuse.Color = {EBE0E03EE4DB5B3FE4DB5B3F0000803F}
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          Position.Coordinates = {00000000000000BF000000000000803F}
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
        end
        inherited GLCylinder1: TGLCylinder
          Position.Coordinates = {0000003F00000000000000BF0000803F}
        end
        inherited GLCylinder2: TGLCylinder
          Direction.Coordinates = {000000000000803F2EBD3BB300000000}
          Position.Coordinates = {0000003F0000003F000000000000803F}
          Up.Coordinates = {000000002EBD3BB3000080BF00000000}
        end
        inherited GLCylinder3: TGLCylinder
          Position.Coordinates = {000000000000003F000000BF0000803F}
          Up.Coordinates = {000080BF2EBD3BB30000000000000000}
        end
      end
      inherited GLLightSource2: TGLLightSource
        Position.Coordinates = {0000803F00000000000040400000803F}
        SpotDirection.Coordinates = {00000000000000000000803F00000000}
      end
      inherited GLCamera: TGLCamera
        Position.Coordinates = {0000000000000000000020410000803F}
      end
    end
  end
end
