/*create public database link oranTosba connect to u_sba identified by "aaa" using 'localhost:1521/departSba';*/
/*select sysdate from dual@oranToSba;*/
/*create table DepartementOran(
  idDe number(10) NOT NULL,
  nom varchar2(50) NOT NULL,
  ville varchar2(50),
  CONSTRAINT departementOran_pk PRIMARY KEY (idDe),
  CONSTRAINT ville_ct CHECK (ville in ('oran'))
);*/
/*CREATE TABLE EmployeOran
  (
    idEmp    NUMBER(10) NOT NULL,
    nom      VARCHAR2(50) NOT NULL,
    fonction VARCHAR2(50) NOT NULL,
    idDe     NUMBER(10),
    CONSTRAINT EmployeOran_pk PRIMARY KEY (idEmp),
    CONSTRAINT fk_Dep FOREIGN KEY (idDe) REFERENCES DepartementOran(idDe)
  );*/
/*CREATE SEQUENCE DepOran_seq
  MINVALUE 1
  MAXVALUE 1000
  START WITH 1
  INCREMENT BY 1
  CACHE 20;
CREATE SEQUENCE EmpOran_seq
  MINVALUE 1
  MAXVALUE 1000
  START WITH 1
  INCREMENT BY 1
  CACHE 20;  */
  /*insert into DepartementOran values(DepOran_seq.nextval,'depOran01','oran');
  insert into DepartementOran values(DepOran_seq.nextval,'depOran02','oran');*/
/*    insert into EmployeOran values(EmpOran_seq.nextval,'MohamedDjamell','Superviseur',2);
    insert into EmployeOran values(EmpOran_seq.nextval,'BoudabouzKhaled','Directeur',2);
    insert into EmployeOran values(EmpOran_seq.nextval,'DjabouAzziz','Chercheur',2);
    insert into EmployeOran values(EmpOran_seq.nextval,'MalikAbderahmen','Assistant',2);
        insert into EmployeOran values(EmpOran_seq.nextval,'FatehNoureddine','Superviseur',3);
    insert into EmployeOran values(EmpOran_seq.nextval,'KamiFoad','Directeur',3);
    insert into EmployeOran values(EmpOran_seq.nextval,'TakiAbdorahmen','Chercheur',3);
    insert into EmployeOran values(EmpOran_seq.nextval,'AttaqIslem','Assistant',3);
*/
/*create or replace PUBLIC SYNONYM EmployeSba For EmployeSba@oranTosba;
create or replace PUBLIC SYNONYM DepartementSba For DepartementSba@oranTosba;*/
/*create or replace view Departement as (Select * from departementoran 
                                              union 
                                      Select * from departementsba);
                                      
create or replace view Employe as (Select * from employeoran 
                                              union 
                                      Select * from employesba);*/
/*
        Les traigger de Vue De departement 
        
        Insert Trigger 
        
CREATE OR REPLACE TRIGGER TrigInseDepartement
      INSTEAD OF INSERT ON  Departement
      FOR EACH ROW
DECLARE    
v_depSba NUMBER := 0; 
v_depOran NUMBER := 0;
v_depSba1 NUMBER := 0; 
v_depOran1 NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_depSba FROM DepartementSba WHERE idDe=:NEW.idDe;
    SELECT COUNT(*) INTO v_depOran FROM DepartementOran WHERE idDe=:NEW.idDe;
        SELECT COUNT(*) INTO v_depSba1 FROM DepartementSba WHERE ville=:NEW.ville;
    SELECT COUNT(*) INTO v_depOran1 FROM DepartementOran WHERE ville=:NEW.ville;
        IF v_depSba > 0 AND v_depOran > 0 THEN 
                 RAISE_APPLICATION_ERROR(-20102, 'Les departements existent déjà!');
        ELSE
                 IF v_depOran=0 and v_depOran1 > 0 THEN INSERT INTO DepartementOran VALUES(:NEW.idDe,:NEW.nom,:NEW.ville);
                 END IF;
        IF v_depSba = 0 and v_depSba1 > 0 THEN INSERT INTO DepartementSba VALUES(:NEW.idDe,:NEW.nom,:NEW.ville);
        END IF;
        END IF;
END;        
        Delete Trigger
        
        CREATE OR REPLACE TRIGGER TrigDeleDepartement
      INSTEAD OF DELETE ON  Departement
      FOR EACH ROW
DECLARE    
v_depSba NUMBER := 0; 
v_depOran NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_depSba FROM DepartementSba WHERE idDe=:old.idDe;
    SELECT COUNT(*) INTO v_depOran FROM DepartementOran WHERE idDe=:old.idDe;
        IF v_depSba = 0 AND v_depOran = 0 THEN 
                 RAISE_APPLICATION_ERROR(-20102, 'Les departements étaient deja supprimer');
        ELSE
                 IF v_depSba=0 and :old.ville='oran' THEN 
                 Delete from DepartementOran where idDe=:old.idDe;
                 END IF;
        IF v_depOran = 0 and :old.ville='sba' THEN
        Delete from DepartementSba where idDe=:old.idDe;
        END IF;
        END IF;
END;

        Update Trigger
        
        CREATE OR REPLACE TRIGGER TrigUpdateDepartement
      INSTEAD OF INSERT ON  Departement
      FOR EACH ROW
DECLARE    
v_depSba NUMBER := 0; 
v_depOran NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_depSba FROM DepartementSba WHERE idDe=:old.idDe;
    SELECT COUNT(*) INTO v_depOran FROM DepartementOran WHERE idDe=:old.idDe;
        IF v_depSba = 0 AND v_depOran = 0 THEN 
                 RAISE_APPLICATION_ERROR(-20102, 'Les departements n"existent pas');
        ELSE
                 IF v_depOran=0 and :old.ville='oran' 
                 THEN 
                  UPDATE DepartementSba SET IDDE=:NEW.idDe,nom=:NEW.nom,ville=:NEW.ville where  IDDE=:old.idDe;
                 END IF;
                 IF v_depSba = 0 and :new.ville='sba' THEN 
                  UPDATE DepartementOran SET IDDE=:NEW.idDe,nom=:NEW.nom,ville=:NEW.ville where  IDDE=:old.idDe;
        END IF;
        END IF;
END;
        
        
                Les traigger de Vue De employe 
                
                
        Insert Trigger 


CREATE OR REPLACE TRIGGER TrigInseEmp
      INSTEAD OF INSERT ON  EMPLOYE
      FOR EACH ROW
DECLARE    
v_empSba NUMBER := 0; 
v_empOran NUMBER := 0;
v_depSba NUMBER := 0; 
v_depOran NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_empSba FROM employeSba WHERE IDEMP=:NEW.IDEMP;
    SELECT COUNT(*) INTO v_empOran FROM employeOran WHERE IDEMP=:NEW.IDEMP;
    SELECT COUNT(*) INTO v_depSba FROM departementsba WHERE IDDE=:NEW.IDDE;
    SELECT COUNT(*) INTO v_depOran FROM departementOran WHERE IDDE=:NEW.IDDE;
    
    
        IF v_empSba > 0 AND v_empOran > 0 THEN 
                 RAISE_APPLICATION_ERROR(-20102, 'Les employes existent déjà!');
        ELSE
                 IF v_empOran=0 and v_depSba>0 THEN INSERT INTO employeOran VALUES(:NEW.IDEMP,:NEW.nom,:NEW.FONCTION,:NEW.IDDE);
                 END IF;
                   IF v_empSba = 0 and v_depOran>0  THEN INSERT INTO employeSba VALUES(:NEW.IDEMP,:NEW.nom,:NEW.FONCTION,:NEW.IDDE);
        END IF;
        END IF;
END;


        Delete Trigger
        
        CREATE OR REPLACE TRIGGER TrigDeleEmploye
      INSTEAD OF DELETE ON  EMPLOYE
      FOR EACH ROW
DECLARE    
v_empSba NUMBER := 0; 
v_empOran NUMBER := 0;
v_depSba NUMBER := 0; 
v_depOran NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_empSba FROM employeSba WHERE IDEMP=:old.IDEMP;
    SELECT COUNT(*) INTO v_empOran FROM employeOran WHERE IDEMP=:old.IDEMP;
    SELECT COUNT(*) INTO v_depSba FROM departementsba WHERE IDDE=:NEW.IDDE;
    SELECT COUNT(*) INTO v_depOran FROM departementOran WHERE IDDE=:NEW.IDDE;
        IF v_empSba = 0 AND v_empOran = 0 THEN 
                 RAISE_APPLICATION_ERROR(-20102, 'Les employes étaient deja supprimer');
        ELSE
                 IF v_empSba  > 0 and v_depSba > 0 THEN 
                 Delete from employeOran where IDEMP=:old.IDEMP;
                 END IF;
        IF v_empSba  > 0 and v_depOran > 0 THEN
        Delete from employeSba where IDEMP=:old.IDEMP;
        END IF;
        END IF;
END;



      Update Trigger
      
              CREATE OR REPLACE TRIGGER TrigUpdateEmploye
      INSTEAD OF INSERT ON  Employe
      FOR EACH ROW
DECLARE    
v_empSba NUMBER := 0; 
v_empOran NUMBER := 0;
v_depSba NUMBER := 0; 
v_depOran NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_empSba FROM employeSba WHERE IDEMP=:old.IDEMP;
    SELECT COUNT(*) INTO v_empOran FROM employeOran WHERE IDEMP=:old.IDEMP;
        SELECT COUNT(*) INTO v_depSba FROM departementsba WHERE IDDE=:NEW.IDDE;
    SELECT COUNT(*) INTO v_depOran FROM departementOran WHERE IDDE=:NEW.IDDE;
        IF v_empSba = 0 AND v_empOran = 0 THEN 
                 RAISE_APPLICATION_ERROR(-20102, 'Les employes n"existent pas');
        ELSE
                 IF v_empSba > 0
                 THEN 
                  UPDATE employeSba SET IDEMP=:NEW.IDEMP,nom=:NEW.nom,FONCTION=:NEW.FONCTION,IDDE=:NEW.IDDE where  IDEMP=:old.IDEMP;
                 END IF;
                 IF v_empOran > 0
                 THEN 
                 UPDATE employeOran SET IDEMP=:NEW.IDEMP,nom=:NEW.nom,FONCTION=:NEW.FONCTION,IDDE=:NEW.IDDE where  IDEMP=:old.IDEMP;
        END IF;
        END IF;
END;


        
*/