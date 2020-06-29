
DECLARE @SyncTable TABLE(Ord int IDENTITY(1,1), Id int, RequestID varchar(50), OBRSetID int, SyncStatus varchar(10), DatetimeStamp datetime)
DECLARE @i int = 1,
		@id int,
        @RequestID varchar(50),
		@OBRSetID int,
		@SyncStatus varchar(50)

INSERT INTO @SyncTable(Id, RequestID, OBRSetID, SyncStatus, DatetimeStamp)
SELECT TOP 1000 Id, RequestID, OBRSetID, SyncStatus, DatetimeStamp FROM OpenLDRData.dbo.SyncTable WHERE TableSync = 'Requests' ORDER BY DatetimeStamp

WHILE (SELECT COUNT(1) FROM @SyncTable) >= @i 
BEGIN
   SELECT @id = Id, @RequestID = RequestID, @OBRSetID = OBRSetID, @SyncStatus = SyncStatus FROM @SyncTable WHERE Ord = @i

   IF @SyncStatus = 'INSERT'
   BEGIN
       -- Data insertion
	   EXEC OpenLDRData.dbo.insertAndUpdateIntoRequests @RequestID, @OBRSetID, 'INSERT'
	   DELETE FROM OpenLDRData.dbo.SyncTable WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID AND SyncStatus = 'INSERT' AND Id = @id AND TableSync = 'Requests'
   END
   ELSE IF @SyncStatus = 'UPDATE'
   BEGIN
	   EXEC OpenLDRData.dbo.insertAndUpdateIntoRequests @RequestID, @OBRSetID, 'UPDATE'
       DELETE FROM OpenLDRData.dbo.SyncTable WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID AND SyncStatus = 'UPDATE' AND Id = @id AND TableSync = 'Requests'
   END 
   ELSE
   BEGIN
       -- Delete records
	   EXEC LDR.OpenLDRData.dbo.deleteIntoTableRequests @RequestID, @OBRSetID
	   DELETE FROM OpenLDRData.dbo.SyncTable WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID AND SyncStatus = 'DELETE' AND Id = @id AND TableSync = 'Requests'
   END

   SET @i = @i + 1 
END



