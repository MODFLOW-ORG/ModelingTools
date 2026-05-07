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
    ExplicitWidth = 541
    object pnlCaption: TPanel
      Left = 0
      Top = 0
      Width = 547
      Height = 25
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 541
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
    Tree.DefaultNodeHeight = 19
    Tree.Header.AutoSizeIndex = 0
    Tree.Header.Height = 15
    Tree.Header.MainColumn = -1
    Tree.TabOrder = 0
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
  end
  inline frameModpathParticles: TframeModpathParticles
    Left = -4
    Top = 120
    Width = 545
    Height = 311
    TabOrder = 2
    TabStop = True
    ExplicitLeft = -4
    ExplicitTop = 120
    inherited gbParticles: TJvGroupBox
      OnCheckBoxClick = frameModpathParticlesgbParticlesCheckBoxClick
      ExplicitLeft = 4
      ExplicitTop = -30
      inherited lblTimeCount: TLabel
        Visible = False
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited sbAddTime: TSpeedButton
        Visible = False
      end
      inherited sbInsertTime: TSpeedButton
        Visible = False
      end
      inherited sbDeleteTime: TSpeedButton
        Visible = False
      end
      inherited lblMessage: TLabel
        StyleElements = [seFont, seClient, seBorder]
      end
      inherited rgChoice: TRadioGroup
        TabOrder = 0
      end
      inherited GLSceneViewer1: TGLSceneViewer
        TabOrder = 3
      end
      inherited plParticlePlacement: TJvPageList
        ActivePage = frameModpathParticles.jvspIndividual
        inherited jvspGrid: TJvStandardPage
          inherited lblX: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited lblY: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited lblZ: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited seX: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited seY: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited seZ: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited jvspCylinder: TJvStandardPage
          inherited lblCylParticleCount: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited lblClylLayerCount: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited lblCylRadius: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited seCylParticleCount: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited seCylLayerCount: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited seCylRadius: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited jvspSphere: TJvStandardPage
          inherited lblSpherParticleCount: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited lblSpherelLayerCount: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited lblSphereRadius: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited seSphereParticleCount: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited seSphereLayerCount: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited seSphereRadius: TJvSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited jvspIndividual: TJvStandardPage
          inherited rdgSpecific: TRbwDataGrid4
            FixedCols = 0
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
