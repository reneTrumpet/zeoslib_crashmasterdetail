# Zeoslib Access violation using master detail and server side filtering
This repository contains instructions to setup and reproduce the access violation.




# Situation:
- Zeos 8.0.0
- ODBC driver
- Delphi 12.
- MSSQL server

An access violation is raised when having a master <-> detail relationship setup with __server side filtering__ and when using datascroll event on detail dataset.\
!!Note: when the application is setup for client side filtering, it works as expected.

The database will be setup as shown in below table.

|MASTER.ID     | DETAIL.ID | DETAIL.MASTERID |
|--------------|-----------|-----------------|  
| 1            | 1         | 1               |
| 2            | 2         | 2               |
| 2            | 3         | 2               |

# Reproduce:

1. From within the  DatabaseScripts folder (which contains the script to fill the database)
   - from within SSMS: (login as sa user)
     - Create a new database called 'ZEOSAV'
     - Open the file 'FillDataBase.sql'
     - run the query
     - check the database contains the tables:
        - MASTER (this is the master table)
        - DETAIL (this is the details table)
3. Application: this contains the code to reproduce.
   - From within delphi open the file 'CrashMe.dproj'
   - Build and debug the project.

0. Press the 'Connect' button (observe the both dbgrids are filled)
1. Select  master.Id=2\
2. Press the 'Last' button (observe in detail dbgrid the cursor moves to DETAIL.Id=3)
3. Select master.Id=1\
--> Access violation when accessing the detail field in the details.AfterScroll coupled method 'onqrDetailsAfterscroll'  (since this SUBJECT.id=1 has only one detail record, and the previous master had 2 detail records with the record pointer at the last record, it gives an access violation during the scroll when accessing a DETAIL field).\
!!Note if the SUBJECT.id=1 had 2 detail records, everything works as expected).


# Workarround:
using the datachange (instead of the datascroll event).

