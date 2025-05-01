# Zeoslib Access violation using master detail and server side filtering
This repository contains instructions to setup and reproduce the access violation.




# Situation:
- Zeos 8.0.0
- ODBC driver
- Delphi 12.
- MSSQL server

An access violation is raised when having a master <-> detail relationship setup with  server side filtering and when using  datascroll event on master.

|MASTER.ID     | DETAIL.ID | DETAIL.MASTERID |
|--------------|-----------|-----------------|  
| 1            | 1         | 1               |
| 2            | 2         | 2               |
| 2            | 3         | 2               |

# Reproduce:

1. From within the  DatabaseScripts folder (which contains the script to fill the database)
   - from within SSMS:
     - Create a new database called 'ZEOSAV' with user='zeosuser' and password='zeosuser'
     - open the FillDataBase.sql file
     - run the query
     - check the database contains the tables:
        - SUBJECT (this is the master table)
        - EXAMSESSION (this is the details table)
3. Application: this contains the code to reproduce.
   - From within delphi open the file 'CrashMe.dproj'
   - Run the project.

1. Start with master.Id=1\
2. Go to SUBJECT.Id=2.\
3. Move the EXAMSESSION to the last record.\
4. Go to SUBJECT.Id=1\
--> Access violation when accessing the detail field in the SUBJECTS.onDataScroll event (since this SUBJECT.id=1 has only one detail record, it gives an access violation during the scroll when accessing a EXAMSESSION field).\
!!Note if the SUBJECT.id=1 had 2 detail records, everything works as expected).


# Workarround:
using the datachange (instead of the datascroll event).

