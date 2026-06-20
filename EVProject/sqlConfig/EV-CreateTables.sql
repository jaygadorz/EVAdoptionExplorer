
CREATE TABLE refCAFVInfo
(
  CAFVID          INT          NOT NULL,
  CAFVEligibility VARCHAR(100) NULL    ,
  PRIMARY KEY (CAFVID)
);

CREATE TABLE refDistrictInfo
(
  DistrictID             INT NOT NULL,
  LegislativeDistricts   INT NULL    ,
  CongressionalDistricts INT NULL    ,
  PRIMARY KEY (DistrictID)
);

CREATE TABLE refEVTypeInfo
(
  EVID   INT          NOT NULL,
  EVType VARCHAR(100) NULL    ,
  PRIMARY KEY (EVID)
);

CREATE TABLE refGeographyInfo
(
  LocationID  INT          NOT NULL,
  City        VARCHAR(50)  NULL    ,
  State       VARCHAR(50)  NULL    ,
  PostalCode  VARCHAR(50)  NULL    ,
  County      VARCHAR(50)  NULL    ,
  CountyCode  VARCHAR(50)  NULL    ,
  CensusTract VARCHAR(250) NULL    ,
  PRIMARY KEY (LocationID)
);

CREATE TABLE refUtilityInfo
(
  UtilityID       INT          NOT NULL,
  ElectricUtility VARCHAR(100) NULL    ,
  PRIMARY KEY (UtilityID)
);

CREATE TABLE refVehicleinfo
(
  VID       INT         NOT NULL,
  Make      VARCHAR(50) NULL    ,
  ModelYear INT         NULL    ,
  ModelName VARCHAR(50) NULL    ,
  PRIMARY KEY (VID)
);

CREATE TABLE tblRegistrationInfo
(
  RegistrationID  INT          NOT NULL,
  VINPrefix       VARCHAR(100) NOT NULL,
  DOLVehicleID    VARCHAR(100) NULL    ,
  VehicleLocation VARCHAR(100) NULL    ,
  ElectricRange   FLOAT        NULL    ,
  CreatedAt       DATETIME     NULL    ,
  UpdatedAt       DATETIME     NULL    ,
  LocationID      INT          NOT NULL,
  VID             INT          NOT NULL,
  UtilityID       INT          NOT NULL,
  DistrictID      INT          NOT NULL,
  EVID            INT          NOT NULL,
  CAFVID          INT          NOT NULL,
  PRIMARY KEY (RegistrationID)
);

ALTER TABLE tblRegistrationInfo
  ADD CONSTRAINT FK_refGeographyInfo_TO_tblRegistrationInfo
    FOREIGN KEY (LocationID)
    REFERENCES refGeographyInfo (LocationID);

ALTER TABLE tblRegistrationInfo
  ADD CONSTRAINT FK_refVehicleinfo_TO_tblRegistrationInfo
    FOREIGN KEY (VID)
    REFERENCES refVehicleinfo (VID);

ALTER TABLE tblRegistrationInfo
  ADD CONSTRAINT FK_refUtilityInfo_TO_tblRegistrationInfo
    FOREIGN KEY (UtilityID)
    REFERENCES refUtilityInfo (UtilityID);

ALTER TABLE tblRegistrationInfo
  ADD CONSTRAINT FK_refDistrictInfo_TO_tblRegistrationInfo
    FOREIGN KEY (DistrictID)
    REFERENCES refDistrictInfo (DistrictID);

ALTER TABLE tblRegistrationInfo
  ADD CONSTRAINT FK_refEVTypeInfo_TO_tblRegistrationInfo
    FOREIGN KEY (EVID)
    REFERENCES refEVTypeInfo (EVID);

ALTER TABLE tblRegistrationInfo
  ADD CONSTRAINT FK_refCAFVInfo_TO_tblRegistrationInfo
    FOREIGN KEY (CAFVID)
    REFERENCES refCAFVInfo (CAFVID);
