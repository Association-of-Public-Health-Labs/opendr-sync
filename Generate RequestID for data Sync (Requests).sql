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
			@areTheRowsEquals AS varchar(10)
			
	DECLARE @requestsTable dbo.Requests
	DECLARE @insertedTable dbo.Requests


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
		INSERT INTO OpenLDRData.dbo.Sync_Requests SELECT @RequestID, 'INSERT', GETDATE()
	END
	ELSE IF @action = 'U'
	BEGIN
		SELECT @RequestID = RequestID FROM INSERTED
		INSERT INTO @insertedTable
		SELECT * FROM INSERTED

		INSERT INTO @requestsTable
		SELECT * FROM OpenLDRData.dbo.Requests WHERE RequestID = @RequestID

		EXEC @areTheRowsEquals = OpenLDRData.[dbo].[compareRequests] @insertedTable, @requestsTable
		IF @areTheRowsEquals = 'No' 
		BEGIN
		     INSERT INTO OpenLDRData.dbo.Sync_Requests SELECT @RequestID, 'UPDATE', GETDATE()
		END

	END
	ELSE IF @action = 'D'
	BEGIN
		SELECT @RequestID = RequestID FROM DELETED
		INSERT INTO OpenLDRData.dbo.Sync_Requests SELECT @RequestID, 'DELETE', GETDATE()
	END

END;

