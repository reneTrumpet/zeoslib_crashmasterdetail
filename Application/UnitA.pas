unit UnitA;

interface

uses
     Data.DB,
     System.Classes,
     Vcl.Forms,
     Vcl.StdCtrls,
     Vcl.Controls,
     Vcl.Grids,
     Vcl.DBGrids,
     ZConnection,
     ZSqlMonitor,
     ZAbstractRODataset,
     ZAbstractDataset,
     ZDataset;

type
  TForm3 = class(TForm)
    zqDetail: TZQuery;
    dsDetail: TDataSource;
    zqMaster: TZQuery;
    dsMaster: TDataSource;
    ZSQLMonitor1: TZSQLMonitor;
    btnConnect: TButton;
    btnDetailSetLast: TButton;
    lblActiveDetailRecord: TLabel;
    lblActiveDetailRecordInfo: TLabel;
    dgbMaster: TDBGrid;
    dgbDetail: TDBGrid;
    lblMaster: TLabel;
    lblDetail: TLabel;
    procedure dsDetailsDataChange(Sender: TObject; Field: TField);
    procedure qrDetailsAfterscroll(Sender: TDataset);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDetailSetLastClick(Sender: TObject);
  private
    { Private declarations }
    FConnection : TZConnection;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
     System.SysUtils,
     System.UITYpes,
     VCL.Dialogs;


{$R *.dfm}
const
   // STEP0.1
   DB_SERVER = '127.0.0.1\sqlexpress';
   DB_DATABASENAME = 'ZEOSAV';
   DB_USER = 'zeosuser';
   DB_PASSWORD = 'zeosuser';

procedure TForm3.btnConnectClick(Sender: TObject);
begin

  FConnection := TZConnection.create(self);
  with FConnection do
  begin
    user := DB_USER;
    password := DB_PASSWORD;
    database := Format('Driver=ODBC Driver 17 for SQL Server;'
                       +'SERVER=%s;'
                       +'DATABASE=%s;'
                       +'Trusted_Connection=No;'
                       +'TrustServerCertificate=No;'
                       +'MARS_Connection=yes',
                       [DB_SERVER,
                        DB_DATABASENAME]);
    protocol := 'odbc_w';
    connected := true;
  end;

  with zqMaster do
  begin
    Active := false;
    connection := FConnection;
    Sql.clear();
    Sql.Add('SELECT * FROM MASTER');
    Active := true;
  end;
  dsMaster.dataset := zqMaster;

  try
    with zqDetail do
    begin
      Active := false;
      connection := FConnection;
      Datasource := dsMaster; // <<--------------------------
      Sql.clear();
      Sql.Add('SELECT * FROM DETAIL WHERE MASTERID = :ID');
      Active := true;
    end;
    dsDetail.dataset := zqDetail;
    zqDetail.AfterScroll := qrDetailsAfterscroll;

  except
    on E: EDatabaseError do
    begin
      MessageDlg('DatabaseError : ' + E.Message, mtError, [mbOk], 0);
    end;
  end;

end;

procedure TForm3.btnDetailSetLastClick(Sender: TObject);
begin
  zqDetail.Last;
end;

// STEP 1.0 THIS FAILS under condition: master scroll and new details from new master have less elements then previous master
procedure TForm3.qrDetailsAfterscroll(Sender: TDataset);
var
  id: integer;
begin
  id := zqDetail.FieldByName('id').AsInteger;
  lblActiveDetailRecord.caption := inttostr(id);
end;

// STEP 2.0 THIS is a possible solution, so react on the datachange instead of the on scroll of the detail
procedure TForm3.dsDetailsDataChange(Sender: TObject; Field: TField);
var
  id: integer;
begin

  if (Field = nil) then
  begin
    id := zqDetail.FieldByName('id').AsInteger;
    lblActiveDetailRecord.caption := inttostr(id);
  end;
end;

end.
