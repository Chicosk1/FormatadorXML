object DmOracle: TDmOracle
  OldCreateOrder = False
  Height = 61
  Width = 162
  object DmConexaoOracle: TSQLConnection
    DriverName = 'DevartOracleDirect'
    LoginPrompt = False
    Params.Strings = (
      'BlobSize=-1'
      'DataBase='
      'ErrorResourceFile='
      'HostName='
      'LocaleCode=0000'
      'Password='
      'Oracle TransIsolation=ReadCommitted'
      'User_Name='
      'UseQuoteChar=False'
      'UseUnicode=True'
      'GetDriverFunc=getSQLDriverORADirect'
      'LibraryName=dbexpoda40.dll'
      'VendorLib=dbexpoda40.dll'
      'ProductName=DevartOracle'
      'IPVersion=IPv4'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DBXCommonDriver240.' +
        'bpl'
      
        'MetaDataPackageLoader=TDBXDevartOracleMetaDataCommandFactory,Dbx' +
        'DevartOracleDriver240.bpl'
      'DriverUnit=DBXDevartOracle')
    Left = 56
    Top = 8
  end
end
