unit DataBaseHelper;

interface

uses
  System.Classes,
  VCL.DBGrids,
  Data.DB,
  System.Types,
  ZDataSet;

type

TDMHelper = class(TObject)
public
  class procedure SaveMemoryStream(ms:TMemoryStream; query: TZQuery; fieldName: String);
  class function ReadMemoryStream(dataSet: TZQuery; fieldName: String): TMemoryStream;
  class function GetIDsFromBookmarkList(oBookmarkList: TBookmarkList; dataSource: TDataSource; fieldName: string) : TIntegerDynArray;
  class function HasTextInStream(textToSearch: string; stream: TStream): Boolean;
end;


implementation

uses
  System.SysUtils;

{TDMHelper}
//
// ---------------------------------------------------------------------------------------------------------------------
class procedure TDMHelper.SaveMemoryStream(ms:TMemoryStream; query: TZQuery; fieldName: String);
var
  bs: TStream;
begin
  with query do
  begin
    bs := createBlobStream(fieldByName(fieldName), bmWrite);
    try
      ms.Position := 0;
      bs.copyFrom(ms, 0);
    finally
      bs.Free;
    end;
  end;
end;

//
// ---------------------------------------------------------------------------------------------------------------------
class function TDMHelper.ReadMemoryStream(dataSet: TZQuery; fieldName: String): TMemoryStream;
var
  bs: TStream;
  ms: TMemoryStream;
begin
  ms:= TMemoryStream.Create();
  with dataSet do
  begin
    bs:= CreateBlobStream(fieldByName(fieldName), bmRead);
    try
     ms.copyFrom(bs, 0);
     ms.Position := 0;
    finally
      bs.Free;
    end;
  end;
  result:= ms;
end;

// @Brief returns an array of record id's for the belonging selected bookmarks.
// ---------------------------------------------------------------------------------------------------------------------
class function TDMHelper.GetIDsFromBookmarkList(oBookmarkList: TBookmarkList; dataSource: TDataSource;
  fieldName: string): TIntegerDynArray;
var
  nCnt: Integer;
begin
  If Assigned(dataSource.DataSet) then
  begin
    try
      dataSource.DataSet.disableControls;

      //Copy the Record IDs into the result list
      SetLength(Result, oBookmarkList.Count);
      for nCnt := 0 to oBookmarkList.Count - 1 do
      begin
        dataSource.DataSet.GotoBookmark(oBookmarkList.Items[nCnt]);
        Result[nCnt] := dataSource.DataSet.FieldByName(fieldName).asInteger;
      end;
    finally
      dataSource.DataSet.enableControls;
    end;
  end;
end;

//
// ---------------------------------------------------------------------------------------------------------------------
class function TDMHelper.HasTextInStream(textToSearch: string; stream: TStream): Boolean;
var
  stringList: TStringList;
begin
  stringList := TStringList.Create();
  try
    stringList.loadFromStream(stream);
    Result := AnsiPos(UpperCase(textToSearch), UpperCase(stringList.GetText())) > 0;
  finally
    freeAndNil(stringList);
  end;
end;


end.
