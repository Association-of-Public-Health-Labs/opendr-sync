USE [OpenLDRData]
GO
/****** Object:  Trigger [dbo].[generateXML]    Script Date: 11/21/2018 10:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[generateRequestIDForSyncPatients] ON [OpenLDRData].[dbo].[Patients] AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	Set NOCOUNT ON
	DECLARE @table AS VARCHAR(20) = 'Patients',
			@RequestID AS VARCHAR(50),
			@OBRSetID int,
			@areTheRowsEquals AS varchar(10)

	DECLARE @requestsTable dbo.Patients -- Antigo registo
	DECLARE @insertedTable dbo.Patients -- Novo registo


	DECLARE @action AS CHAR(1)
		SET @action = (CASE WHEN EXISTS(SELECT * FROM INSERTED) AND EXISTS(SELECT * FROM DELETED)
							THEN 'U'  -- Set Action to Updated.
							WHEN EXISTS(SELECT * FROM INSERTED)
							THEN 'I'  -- Set Action to Insert.
							WHEN EXISTS(SELECT * FROM DELETED)
							THEN 'D'  -- Set Action to Deleted.
							ELSE NULL -- Skip.
						END)

	IF @action = 'I'
	BEGIN
		SELECT @RequestID = RequestID FROM INSERTED
		INSERT INTO OpenLDRData.dbo.SyncTable SELECT @RequestID, 0, 'INSERT', GETDATE(), @table
	END
	ELSE IF @action = 'U'
	BEGIN
		SELECT @RequestID = RequestID FROM INSERTED
		INSERT INTO @insertedTable -- Novo Registo
		SELECT * FROM INSERTED

		INSERT INTO @requestsTable -- Antigo Registo
		SELECT * FROM OpenLDRData.dbo.Patients WHERE RequestID = @RequestID

		SELECT @areTheRowsEquals = OpenLDRData.[dbo].[comparePatients](@insertedTable, @requestsTable)
		IF @areTheRowsEquals = 'No' 
		BEGIN
		     INSERT INTO OpenLDRData.dbo.SyncTable SELECT @RequestID, 0, 'UPDATE', GETDATE(), @table
		END

	END
	ELSE IF @action = 'D'
	BEGIN
		SELECT @RequestID = RequestID  FROM DELETED
		INSERT INTO OpenLDRData.dbo.SyncTable SELECT @RequestID, 0, 'DELETE', GETDATE(), @table
	END





END;

