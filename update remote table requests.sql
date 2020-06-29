-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE updateRemoteTableRequests
	-- Add the parameters for the stored procedure here
	@RequestID varchar(100),
	@OBRSetID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @DateTimeStamp datetime,
	@Versionstamp varchar(1000),
	@LIMSDateTimeStamp datetime,
	@LIMSVersionstamp varchar(1000),
	@LOINCPanelCode varchar(1000),
	@LIMSPanelCode varchar(1000),
	@LIMSPanelDesc varchar(1000),
	@HL7PriorityCode char,
	@SpecimenDateTime datetime,
	@RegisteredDateTime datetime,
	@ReceivedDateTime datetime,
	@AnalysisDateTime datetime,
	@AuthorisedDateTime datetime,
	@AdmitAttendDateTime datetime,
	@CollectionVolume float,
	@RequestingFacilityCode varchar(1000),
	@ReceivingFacilityCode varchar(1000),
	@LIMSPointOfCareDesc varchar(1000),
	@RequestTypeCode varchar(1000),
	@ICD10ClinicalInfoCodes varchar(1000),
	@ClinicalInfo varchar(1000),
	@HL7SpecimenSourceCode varchar(1000),
	@LIMSSpecimenSourceCode varchar(1000),
	@LIMSSpecimenSourceDesc varchar(1000),
	@HL7SpecimenSiteCode varchar(1000),
	@LIMSSpecimenSiteCode varchar(1000),
	@LIMSSpecimenSiteDesc varchar(1000),
	@WorkUnits float,
	@CostUnits float,
	@HL7SectionCode varchar(1000),
	@HL7ResultStatusCode char,
	@RegisteredBy varchar(1000),
	@TestedBy varchar(1000),
	@AuthorisedBy varchar(1000),
	@OrderingNotes varchar(1000),
	@EncryptedPatientID nvarchar(1000),
	@AgeInYears int,
	@AgeInDays int,
	@HL7SexCode char,
	@HL7EthnicGroupCode char,
	@Deceased bit,
	@Newborn bit,
	@HL7PatientClassCode char,
	@AttendingDoctor varchar(1000),
	@TestingFacilityCode varchar(1000),
	@ReferringRequestID varchar(1000),
	@Therapy varchar(1000),
	@LIMSAnalyzerCode varchar(1000),
	@TargetTimeDays int,
	@TargetTimeMins int,
	@LIMSRejectionCode varchar(1000),
	@LIMSRejectionDesc varchar(1000),
	@LIMSFacilityCode varchar(1000),
	@Repeated tinyint,
	@LIMSSpecimenID nvarchar(1000),
	@LIMSPreReg_RegistrationDateTime datetime,
	@LIMSPreReg_ReceivedDateTime datetime,
	@LIMSPreReg_RegistrationFacilityCode varchar(1000),
	@LIMSVendorCode varchar(1000),
	@RequestingFacilityNationalCode varchar(1000)


	SELECT [Versionstamp] = @Versionstamp
          ,[LIMSDateTimeStamp] = @LIMSDateTimeStamp
          ,[LIMSVersionstamp] = @LIMSVersionstamp
          ,[LOINCPanelCode] = @LOINCPanelCode
          ,[LIMSPanelCode] = @LIMSPanelCode
          ,[LIMSPanelDesc] = @LIMSPanelDesc
      ,[HL7PriorityCode] = @HL7PriorityCode
      ,[SpecimenDateTime] = @SpecimenDateTime
      ,[RegisteredDateTime] = @RegisteredDateTime
      ,[ReceivedDateTime] = @ReceivedDateTime
      ,[AnalysisDateTime] = @AnalysisDateTime
      ,[AuthorisedDateTime] = @AuthorisedDateTime
      ,[AdmitAttendDateTime] = @AdmitAttendDateTime
      ,[CollectionVolume] = @CollectionVolume
      ,[RequestingFacilityCode] = @RequestingFacilityCode
      ,[ReceivingFacilityCode] = @ReceivingFacilityCode
      ,[LIMSPointOfCareDesc] = @LIMSPointOfCareDesc
      ,[RequestTypeCode] = @RequestTypeCode
      ,[ICD10ClinicalInfoCodes] = @ICD10ClinicalInfoCodes
      ,[ClinicalInfo] = @ClinicalInfo
      ,[HL7SpecimenSourceCode] = @HL7SpecimenSourceCode
      ,[LIMSSpecimenSourceCode] = @LIMSSpecimenSourceCode
      ,[LIMSSpecimenSourceDesc] = @LIMSSpecimenSourceDesc
      ,[HL7SpecimenSiteCode] = @HL7SpecimenSiteCode
      ,[LIMSSpecimenSiteCode] = @LIMSSpecimenSiteCode
      ,[LIMSSpecimenSiteDesc] = @LIMSSpecimenSiteDesc
      ,[WorkUnits] = @WorkUnits
      ,[CostUnits] = @CostUnits
      ,[HL7SectionCode] = @HL7SectionCode
      ,[HL7ResultStatusCode] = @HL7ResultStatusCode
      ,[RegisteredBy] = @RegisteredBy
      ,[TestedBy] = @TestedBy
      ,[AuthorisedBy] = @AuthorisedBy
      ,[OrderingNotes] = @OrderingNotes
      ,[EncryptedPatientID] = @EncryptedPatientID
      ,[AgeInYears] = @AgeInYears
      ,[AgeInDays] = @AgeInDays
      ,[HL7SexCode] = @HL7SexCode
      ,[HL7EthnicGroupCode] = @HL7EthnicGroupCode
      ,[Deceased] = @Deceased
      ,[Newborn] = @Newborn
      ,[HL7PatientClassCode] = @HL7PatientClassCode
      ,[AttendingDoctor] = @AttendingDoctor
      ,[TestingFacilityCode] = @TestingFacilityCode
      ,[ReferringRequestID] = @ReferringRequestID
      ,[Therapy] = @Therapy
      ,[LIMSAnalyzerCode] = @LIMSAnalyzerCode
      ,[TargetTimeDays] = @TargetTimeDays
      ,[TargetTimeMins] = @TargetTimeMins
      ,[LIMSRejectionCode] = @LIMSRejectionCode
      ,[LIMSRejectionDesc] = @LIMSRejectionDesc
      ,[LIMSFacilityCode] = @LIMSFacilityCode
      ,[Repeated] = @Repeated
      ,[LIMSSpecimenID] = @LIMSSpecimenID
      ,[LIMSPreReg_RegistrationDateTime] = @LIMSPreReg_RegistrationDateTime
      ,[LIMSPreReg_ReceivedDateTime] = @LIMSPreReg_ReceivedDateTime
      ,[LIMSPreReg_RegistrationFacilityCode] = @LIMSPreReg_RegistrationFacilityCode
      ,[LIMSVendorCode] = @LIMSVendorCode
      ,[RequestingFacilityNationalCode] = @RequestingFacilityNationalCode
   FROM OpenLDRData.dbo.Requests WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID

   EXEC LDR.OpenLDRData.dbo.updateTableRequests 
        @RequestID, 
		@OBRSetID, 
		@DateTimeStamp,
		@Versionstamp,
		@LIMSDateTimeStamp,
		@LIMSVersionstamp,
		@LOINCPanelCode,
		@LIMSPanelCode,
		@LIMSPanelDesc,
		@HL7PriorityCode,
		@SpecimenDateTime,
		@RegisteredDateTime,
		@ReceivedDateTime,
		@AnalysisDateTime,
		@AuthorisedDateTime,
		@AdmitAttendDateTime,
		@CollectionVolume,
		@RequestingFacilityCode,
		@ReceivingFacilityCode,
		@LIMSPointOfCareDesc,
		@RequestTypeCode,
		@ICD10ClinicalInfoCodes,
		@ClinicalInfo,
		@HL7SpecimenSourceCode,
		@LIMSSpecimenSourceCode,
		@LIMSSpecimenSourceDesc,
		@HL7SpecimenSiteCode,
		@LIMSSpecimenSiteCode,
		@LIMSSpecimenSiteDesc,
		@WorkUnits,
		@CostUnits,
		@HL7SectionCode ,
		@HL7ResultStatusCode,
		@RegisteredBy,
		@TestedBy,
		@AuthorisedBy,
		@OrderingNotes,
		@EncryptedPatientID,
		@AgeInYears,
		@AgeInDays,
		@HL7SexCode,
		@HL7EthnicGroupCode,
		@Deceased,
		@Newborn,
		@HL7PatientClassCode,
		@AttendingDoctor,
		@TestingFacilityCode,
		@ReferringRequestID,
		@Therapy,
		@LIMSAnalyzerCode,
		@TargetTimeDays,
		@TargetTimeMins,
		@LIMSRejectionCode,
		@LIMSRejectionDesc,
		@LIMSFacilityCode,
		@Repeated,
		@LIMSSpecimenID,
		@LIMSPreReg_RegistrationDateTime,
		@LIMSPreReg_ReceivedDateTime,
		@LIMSPreReg_RegistrationFacilityCode ,
		@LIMSVendorCode ,
		@RequestingFacilityNationalCode 
	
END
GO
