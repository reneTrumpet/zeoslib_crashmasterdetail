object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 
    'ZEOS master detail server filtering onscroll gives access violat' +
    'ion'
  ClientHeight = 828
  ClientWidth = 1018
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lblActiveDetailRecord: TLabel
    Left = 829
    Top = 416
    Width = 113
    Height = 15
    Caption = 'Active DETAIL Record'
  end
  object lblActiveDetailRecordInfo: TLabel
    Left = 648
    Top = 416
    Width = 113
    Height = 15
    Caption = 'Active DETAIL Record'
  end
  object lblMaster: TLabel
    Left = 253
    Top = 238
    Width = 60
    Height = 28
    Caption = 'Master'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object lblDetail: TLabel
    Left = 648
    Top = 238
    Width = 51
    Height = 28
    Caption = 'Detail'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object btnConnect: TButton
    Left = 253
    Top = 176
    Width = 75
    Height = 25
    Caption = 'CONNECT'
    TabOrder = 0
    OnClick = btnConnectClick
  end
  object btnDetailSetLast: TButton
    Left = 893
    Top = 216
    Width = 75
    Height = 25
    Caption = 'LAST'
    TabOrder = 1
    OnClick = btnDetailSetLastClick
  end
  object dgbMaster: TDBGrid
    Left = 253
    Top = 272
    Width = 320
    Height = 120
    DataSource = dsMaster
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object dgbDetail: TDBGrid
    Left = 648
    Top = 272
    Width = 320
    Height = 120
    DataSource = dsDetail
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object zqDetail: TZQuery
    SQL.Strings = (
      'select * from DETAIL where MASTERID = :ID')
    Params = <
      item
        Name = 'ID'
      end>
    DataSource = dsMaster
    Left = 744
    Top = 56
    ParamData = <
      item
        Name = 'ID'
      end>
  end
  object dsDetail: TDataSource
    DataSet = zqDetail
    Left = 744
    Top = 120
  end
  object zqMaster: TZQuery
    SQL.Strings = (
      'select * from MASTER'
      '')
    Params = <>
    Left = 352
    Top = 48
  end
  object dsMaster: TDataSource
    DataSet = zqMaster
    Left = 352
    Top = 112
  end
  object ZSQLMonitor1: TZSQLMonitor
    Active = True
    AutoSave = True
    FileName = 'd:\crashmelog.txt'
    MaxTraceCount = 100
    Left = 88
    Top = 56
  end
end
