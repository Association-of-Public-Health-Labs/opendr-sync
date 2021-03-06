USE [OpenLDRData]
GO
/****** Object:  Trigger [dbo].[generateXML]    Script Date: 11/21/2018 10:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[generateRequestIDForSync] ON [OpenLDRData].[dbo].[Requests] AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	Set NOCOUNT ON
	DECLARE @table AS VARCHAR(20) = 'Requests',
			@RequestID AS VARCHAR(50),
			@OBRSetID int,
			@areTheRowsEquals AS varchar(10)

	DECLARE @requestsTable dbo.Requests -- Antigo registo
	DECLARE @insertedTable dbo.Requests -- Novo registo


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
		SELECT @RequestID = RequestID, @OBRSetID = OBRSetID FROM INSERTED
		INSERT INTO OpenLDRData.dbo.SyncTable SELECT @RequestID, @OBRSetID, 'INSERT', GETDATE(), @table
	END
	ELSE IF @action = 'U'
	BEGIN
		SELECT @RequestID = RequestID, @OBRSetID = OBRSetID FROM INSERTED
		INSERT INTO @insertedTable -- Novo Registo
		SELECT * FROM INSERTED

		INSERT INTO @requestsTable -- Antigo Registo
		SELECT * FROM OpenLDRData.dbo.Requests WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID

		SELECT @areTheRowsEquals = OpenLDRData.[dbo].[compareRequests](@insertedTable, @requestsTable)
		IF @areTheRowsEquals = 'No' 
		BEGIN
		     INSERT INTO OpenLDRData.dbo.SyncTable SELECT @RequestID, @OBRSetID, 'UPDATE', GETDATE(), @table
		END

	END
	ELSE IF @action = 'D'
	BEGIN
		SELECT @RequestID = RequestID, @OBRSetID = OBRSetID  FROM DELETED
		INSERT INTO OpenLDRData.dbo.SyncTable SELECT @RequestID, @OBRSetID, 'DELETE', GETDATE(), @table
	END





END;

